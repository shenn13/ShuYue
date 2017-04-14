//
//  ReadingManager.m
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ReadingManager.h"

@interface ReadingManager()

@property (nonatomic, copy) void(^updateCompletion)();


@end

@implementation ReadingManager

+ (instancetype)shareReadingManager {
    
    static ReadingManager *readM = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        readM = [[self alloc] init];
    });
    
    return readM;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        //code
        
    }
    
    return self;
}
- (void)clear {
    self.chapter = 0;
    self.page = 0;
    self.chapters = nil;
    self.title = nil;
    self.summaryId = nil;
    self.isSave = nil;
    self.autoSummaryId = nil;
}

- (void)updateWithSummary:(NSString *)bookId completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    //请求源
    @weakify(self);
    
    [Http GET:NSStringFormat(@"%@/toc?book=%@&view=summary",SERVERCE_HOST,bookId) parameters:nil success:^(id responseObject) {
        
        NSArray *arr = [NSArray modelArrayWithClass:[SummaryModel class] json:responseObject];
        
        NSMutableArray *summarys = @[].mutableCopy;
        
        for (SummaryModel *model in arr) {
            //去掉追书的vip源，你懂得
            if (!model.starting) {
                [summarys addObject:model];
            }
        }
        
        if (summarys.count > 0) {
            weak_self.summaryId = ((SummaryModel *)summarys[0])._id;
            [SQLiteTool updateWithTableName:weak_self.bookId dict:@{@"autoSummaryId": weak_self.summaryId}];
        }
        
        completion ();

        
    } failure:^(NSError *error) {
        failure ([error localizedDescription]);
    }];
    
}

//请求章节数组
- (void)onloadChaptersWithId:(NSString *)summaryId completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    @weakify(self);
    
    void(^completionBlock)(id) = ^(id responseObject){
        NSArray *arr = [NSArray modelArrayWithClass:[BookChapterModel class] json:responseObject[@"chapters"]];
        
        weak_self.chapters = arr;
        
        completion ();
    };
    
    [Http GET:NSStringFormat(@"%@/atoc/%@?view=chapters",SERVERCE_HOST,summaryId) parameters:nil responseCache:^(id responseCache) {
        
        if (responseCache) {
            NSLog(@"有缓存");
            if (![Http isNetwork]) {//有网YES, 无网:NO
                //没有网络情况下直接返回缓存的
                completionBlock(responseCache);
            }
            
        } else {
            NSLog(@"没有缓存");
        }
        
    } success:^(id responseObject) {
        
        completionBlock(responseObject);
        
    } failure:^(NSError *error) {
        failure ([error localizedDescription]);
    }];
    
}


//预下载章节
- (void)downLoadChapterWithNumber:(NSInteger)number {
    
    @weakify(self);
    
    void(^downLownChapter)(NSInteger i) = ^(NSInteger i){
        
        BookChapterModel *model = self.chapters[_chapter+i];
        
        //查询章节
        [SQLiteTool getChapterTitle:model.title tableName:_bookId success:^(ResultModel *resultModel) {
            
            NSLog(@"%@已存在",resultModel.title);
            
        } failure:^{
            
            [Http GET:NSStringFormat(@"%@/chapter/%@",chapter_URL,[NSString encodeToPercentEscapeString:model.link]) parameters:nil success:^(id responseObject) {
                
                model.body = [model adjustParagraphFormat:responseObject[@"chapter"][@"body"]];
                
                //存储章节
                [SQLiteTool saveWithTitle:model.title body:model.body tableName:weak_self.bookId];
                
            } failure:^(NSError *error) {
                
            }];
        }];
        
    };
    
    
    if (_chapter + number <= _chapters.count - 1) {
        
        for (int i = 1; i <= number; i++) {
            
            downLownChapter(i);
        }
        
    } else {
        //超出了
        number = _chapters.count - 1 - _chapter;
        
        for (int i = 1; i <= number; i++) {
            
            downLownChapter(i);
        }
    }
}





//异步请求章节
- (void)updateWithChapterAsync:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    BookChapterModel *model = self.chapters[chapter];
    
    @weakify(self);
    //查询章节
    [SQLiteTool getChapterTitle:model.title tableName:_bookId success:^(ResultModel *resultModel) {
        
        model.body = resultModel.body;
        
        [model pagingWithBounds:kReadingFrame];
        
        weak_self.page = 0;
        
        if (ispreChapter) {
            weak_self.page = model.pageCount - 1;
        }
        
        completion();
        
    } failure:^{
        
        [Http GET:NSStringFormat(@"%@/chapter/%@",chapter_URL,[NSString encodeToPercentEscapeString:model.link]) parameters:nil success:^(id responseObject) {
            
            model.body = [model adjustParagraphFormat:responseObject[@"chapter"][@"body"]];
            
            //存储章节
            [SQLiteTool saveWithTitle:model.title body:model.body tableName:weak_self.bookId];
            
            [model pagingWithBounds:kReadingFrame];
            
            weak_self.page = 0;
            
            if (ispreChapter) {
                weak_self.page = model.pageCount - 1;
            }
            
            completion ();
            
        } failure:^(NSError *error) {
            failure ([error localizedDescription]);
        }];
        
    }];
        
}

//同步请求章节
- (void)updateWithChapterSync:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    BookChapterModel *model = self.chapters[chapter];
    
    @weakify(self);
    [Http doRequest:NSStringFormat(@"%@/chapter/%@",chapter_URL,[NSString encodeToPercentEscapeString:model.link]) parameters:nil requestType:GET_http isCache:NO success:^(id responseObject) {
        
        model.body = [model adjustParagraphFormat:responseObject[@"chapter"][@"body"]];
        
        [model pagingWithBounds:kReadingFrame];
        
        weak_self.page = 0;
        
        if (ispreChapter) {
            weak_self.page = model.pageCount - 1;
        }
        
        completion ();
        
    } failure:^(NSError *error) {
        failure ([error localizedDescription]);
    }];
}

@end
