//
//  httpUtil.m
//  LunDeng
//
//  Created by zhenfu zhou on 14/11/17.
//  Copyright (c) 2014年 majun. All rights reserved.
//

#import "httpUtil.h"

@implementation AFManager


/**
 *  返回一个单例对象
 */
+ (instancetype)shareMangager
{
    static AFManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 创建会话配置对象
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // 设置请求时长
        config.timeoutIntervalForRequest = 15.0;
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:config];
        //设置缓存策略(有缓存就用缓存，没有缓存就重新请求)
//        [instance.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        // 设置响应解析数据的类型
        //        instance.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/javascript",@"text/html", nil];
        
        ((AFJSONResponseSerializer *)instance.responseSerializer).readingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers;
        
    });
    return instance;
}


@end

@implementation ResponseModel

-(id)initWithDic:(NSDictionary *)dic
{
    
    self = [super init];
    if(self){
        
        if(dic){
            
            //            self = [ResponseModel mj_objectWithKeyValues:dic];
            self.msg =[dic objectForKey:@"msg"];
            self.code =[dic objectForKey:@"code"];
            self.response =[dic objectForKey:@"data"];
            
            if ([self.code intValue] == 0) {
                
                self.backCode = kSuccess_Code;
                _isResultOk = YES;
            }
            else{
                self.backCode = kError_Code;
            }
            
        }else{
            self.msg = @"网络异常，连接超时！";
            self.code = @"100000";
            self.response =nil;
            self.backCode = kFailure_Code;
        }
    }
    return self;
    
}

#pragma mark - 字典序列化成字符串
+ (NSString *)SerializationJson:(NSDictionary *)dictionary
{
    if([NSJSONSerialization isValidJSONObject:dictionary]){
        NSError *error;
        NSData *dictionaryData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"SerialixationJson>>%@",error);
        return [[NSString alloc] initWithData:dictionaryData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (ResponseModel *)responseModelFailureStaue
{
    ResponseModel *model = [[ResponseModel alloc]init];
    model.response = nil;
    model.backCode = kFailure_Code;
    
    if ([Tools getNetworkStatus]) {
        model.msg = @"网络异常，连接超时！";
    }
    else{
        model.msg = @"请检查您的网络连接！";
    }
    return model;
}

@end

@interface httpUtil()

@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;

@end

@implementation httpUtil


- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkStatus = AFNetworkReachabilityStatusNotReachable;
    }
    return self;
}

- (NSError *)formatWithResponseObject:(id)response error:(NSError *)error {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[error userInfo]];
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [userInfo setObject:@"网络中断" forKey:NSLocalizedFailureReasonErrorKey];
    } else if (error.code == kCFURLErrorTimedOut) {
        [userInfo setObject:@"请求超时" forKey:NSLocalizedFailureReasonErrorKey];
    } else if (error.code == kCFURLErrorCannotConnectToHost || error.code == kCFURLErrorCannotFindHost || error.code == kCFURLErrorBadURL || error.code == kCFURLErrorNetworkConnectionLost) {
        [userInfo setObject:@"无法连接服务器" forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:error.code userInfo:userInfo];
    return formattedError;
}

//网络请求
+ (void)doRequest:(NSString *)url ServerceHost:(NSString *)host args:(NSDictionary *)args requestType:(requestType)type isShowHUD:(BOOL)isShowHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (isShowHUD) {
        [SVProgressHUD show];
    }
    
    url = [NSString stringWithFormat:@"%@%@",host,url];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", url];
    
    
    if (args) {
        [urlStr appendString:@"?"];
        NSMutableArray *pairs = [NSMutableArray array];
        [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [pairs addObject:pair];
        }];
        [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
    }
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"请求url:-->>%@",urlStr);
    
    if (type == GET) {
        [[AFManager shareMangager] GET:url parameters:args progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [SVProgressHUD dismiss];
//            NSLog(@"返回json-->>%@",[ResponseModel SerializationJson:responseObject]);
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [SVProgressHUD dismiss];
            NSLog(@"error ----> %@",[error localizedDescription]);
            failure(error);
        }];
        
    } else if (type == POST) {
        
        [[AFManager shareMangager] POST:url parameters:args progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [SVProgressHUD dismiss];
//            NSLog(@"返回json-->>%@",[ResponseModel SerializationJson:responseObject]);
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [SVProgressHUD dismiss];
            NSLog(@"error ----> %@",[error localizedDescription]);
//            failure([wself formatWithResponseObject:nil error:error]);
            failure(error);
        }];
        
        [SVProgressHUD dismiss];
        
    } else {
        NSLog(@"请选择请求方式");
    }
}

//NSURLSession同步请求
+ (void)doRequestWithSync:(NSString *)url ServerceHost:(NSString *)host args:(NSDictionary *)args requestType:(requestType)type isCache:(BOOL)isCache isShowHUD:(BOOL)isShowHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (isShowHUD) {
        [SVProgressHUD show];
    }
    
//    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    defaultConfig.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    
//    defaultConfig.timeoutIntervalForRequest = 15.0;
    
    //一个NSOperation对象可以通过调用start方法来执行任务，默认是同步执行的。也可以将NSOperation添加到一个NSOperationQueue(操作队列)中去执行，而且是异步执行的。
    
    //    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //添加一个Operation
    //    [queue addOperation:[NSOperation new]];
    
    //添加一组Operation
    //    [queue addOperations:@[[NSOperation new]] waitUntilFinished:NO];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建信号量，可以设置信号量的资源数。0表示没有资源，调用dispatch_semaphore_wait会立即等待。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    url = [NSString stringWithFormat:@"%@%@",host,url];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", url];
    
    if (type == GET) {
        request.HTTPMethod = @"GET";
        
        if (args) {
            [urlStr appendString:@"?"];
            NSMutableArray *pairs = [NSMutableArray array];
            [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [pairs addObject:pair];
            }];
            [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        }
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSLog(@"请求url:-->>%@",urlStr);
        
        request.URL = [NSURL URLWithString:urlStr];
        
    } else if (type == POST) {
        request.HTTPMethod = @"POST";
        
        if (args) {
            
            NSMutableString *dicStr = [NSMutableString new];
            
            NSMutableArray *pairs = [NSMutableArray array];
            [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [pairs addObject:pair];
            }];
            [dicStr appendString:[pairs componentsJoinedByString:@"&"]];
            
            request.HTTPBody = [[NSString stringWithFormat:@"%@",dicStr] dataUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        request.URL = [NSURL URLWithString:urlStr];
    }
    
    
    //
    
    request.timeoutInterval = 15.0;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (isCache) {
        //设置缓存策略(有缓存就用缓存，没有缓存就重新请求)
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    //获取全局的缓存对象
//    NSURLCache *cache = [NSURLCache sharedURLCache];
//    
//    [cache removeAllCachedResponses];
//    [cache removeCachedResponseForRequest:request];
    
    //价值：判断是否存在缓存
//    NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
//    if (response)
//    {
//        NSLog(@"---这个请求已经存在缓存");
//    }
//    else
//    {
//        NSLog(@"---这个请求没有缓存");
//    }

    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            success (response);
        } else {
            
            failure (error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
        
        // 通知信号，如果等待线程被唤醒则返回非0，否则返回0。
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    [task resume];
    
    // 等待信号，可以设置超时参数。该函数返回0表示得到通知，非0表示超时。
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

//NSURLSession异步请求
+ (void)doRequestWithAsync:(NSString *)url ServerceHost:(NSString *)host args:(NSDictionary *)args requestType:(requestType)type isCache:(BOOL)isCache isShowHUD:(BOOL)isShowHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (isShowHUD) {
        [SVProgressHUD show];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    url = [NSString stringWithFormat:@"%@%@",host,url];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", url];
    
    if (type == GET) {
        request.HTTPMethod = @"GET";
        
        if (args) {
            [urlStr appendString:@"?"];
            NSMutableArray *pairs = [NSMutableArray array];
            [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [pairs addObject:pair];
            }];
            [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        }
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSLog(@"请求url:-->>%@",urlStr);
        
        request.URL = [NSURL URLWithString:urlStr];
        
    } else if (type == POST) {
        request.HTTPMethod = @"POST";
        
        if (args) {
            
            NSMutableString *dicStr = [NSMutableString new];
            
            NSMutableArray *pairs = [NSMutableArray array];
            [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [pairs addObject:pair];
            }];
            [dicStr appendString:[pairs componentsJoinedByString:@"&"]];
            
            request.HTTPBody = [[NSString stringWithFormat:@"%@",dicStr] dataUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        request.URL = [NSURL URLWithString:urlStr];
    }
    
    
    //
    
    request.timeoutInterval = 15.0;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (isCache) {
        //设置缓存策略(有缓存就用缓存，没有缓存就重新请求)
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    //获取全局的缓存对象
    //    NSURLCache *cache = [NSURLCache sharedURLCache];
    //
    //    [cache removeAllCachedResponses];
    //    [cache removeCachedResponseForRequest:request];
    
    //价值：判断是否存在缓存
    //    NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
    //    if (response)
    //    {
    //        NSLog(@"---这个请求已经存在缓存");
    //    }
    //    else
    //    {
    //        NSLog(@"---这个请求没有缓存");
    //    }
//    dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
//        failure(nil, serializationError);
//    });
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{//其实这个也是在子线程中执行的，只是把它放到了主线程的队列中
            Boolean isMain = [NSThread isMainThread];
            if (isMain) {
                
                if (!error) {
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    success (response);
                } else {
                    
                    failure (error);
                }
                
                //取消单个操作
//                [opration cancel];
                
                //取消所有操作
//                [queue cancelAllOperations];
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [SVProgressHUD dismiss];
                
            }
        });
        
    }];
    
    [task resume];
}


//单张图片上传
+ (void)doUpImageRequest:(NSString *)url Image:(UIImage *)image name:(NSString *)name args:(NSDictionary *)args isShowHUD:(BOOL)isShowHUD response:(void (^)(ResponseModel *))responseBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (isShowHUD) {
        [SVProgressHUD show];
    }
    
    NSData *imageData = nil;
    NSString *type = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = nil;
    
    if (UIImagePNGRepresentation(image) == nil) {
        
        imageData = UIImageJPEGRepresentation(image, 1);
        type = @"image/jpeg";
        fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
    } else {
        
        imageData = UIImagePNGRepresentation(image);
        type = @"image/png";
        fileName = [NSString stringWithFormat:@"%@.png", str];
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    session.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSString  * path =[NSString stringWithFormat:@"%@%@",SERVERCE_HOST,url];
    //打印url
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", path];
    
    if (args) {
        [urlStr appendString:@"?"];
        NSMutableArray *pairs = [NSMutableArray array];
        [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [pairs addObject:pair];
        }];
        
        [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        NSLog(@"请求url:-->>%@",urlStr);
    }
    [session POST:path parameters:args constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:type];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回Json-->>%@",[Tools SerializationJson:responseObject]);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
        
        @try {
            responseBlock([[ResponseModel alloc]initWithDic:responseObject]);
        }
        @catch (NSException *exception) {
            NSLog(@"NSException:-->%@:\r reason%@ \r  userinfo:%@",exception.name,exception.reason,exception.userInfo);
            //            [HUD showAlertMsg:@"数据解析出错!"];
            //            NSError * error=[NSError errorWithDomain:@"数据解析出错!" code:0 userInfo:nil];
            
            ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
            model.msg =@"数据解析出错!";
            
            responseBlock(model);
        }
        @finally {
            
        };
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
        NSLog(@"error ----> %@",error);
        ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
        model.msg =@"网络异常!";
        responseBlock(model);
        
    }];
}


//多张图片上传
+ (void)doUpImageRequest:(NSString *)url images:(NSArray *)images name:(NSString *)name args:(NSDictionary *)args isShowHUD:(BOOL)isShowHUD response:(void (^)(ResponseModel *))responseBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (isShowHUD) {
        [SVProgressHUD show];
    }
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  session.requestSerializer = [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    session.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSString  * path =[NSString stringWithFormat:@"%@%@",SERVERCE_HOST,url];
    //打印url
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", path];
    
    if (args) {
        [urlStr appendString:@"?"];
        NSMutableArray *pairs = [NSMutableArray array];
        [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [pairs addObject:pair];
        }];
        [urlStr appendString:[pairs componentsJoinedByString:@"&"]];
        NSLog(@"请求url:-->>%@",urlStr);
    }
    
    [session POST:path parameters:args constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //要提交的图片信息
        for (int i = 0; i < images.count; i++) {
            
            NSData *imageData = nil;
            NSString *type = nil;
            
            NSString *str = [DateTools getDateTimeNow:DateTypeYAll];
            NSString *fileName = nil;
            UIImage *image = [images objectAtIndex:i];
            if (UIImagePNGRepresentation(image) == nil) {
                
                imageData = UIImageJPEGRepresentation(image, 1);
                type = @"image/jpeg";
                fileName = [NSString stringWithFormat:@"%@_%d.jpg",str,i];
                
            } else {
                
                imageData = UIImagePNGRepresentation(image);
                type = @"image/png";
                fileName = [NSString stringWithFormat:@"%@_%d.png",str,i];
            }
            
            //            NSString *imageName = [NSString stringWithFormat:@"%@%d",name,i + 1];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:type];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回Json-->>%@",[Tools SerializationJson:responseObject]);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
        
        @try {
            responseBlock([[ResponseModel alloc]initWithDic:responseObject]);
        }
        @catch (NSException *exception) {
            NSLog(@"NSException:-->%@:\r reason%@ \r  userinfo:%@",exception.name,exception.reason,exception.userInfo);
            //            [HUD showAlertMsg:@"数据解析出错!"];
            //            NSError * error=[NSError errorWithDomain:@"数据解析出错!" code:0 userInfo:nil];
            
            ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
            model.msg =@"数据解析出错!";
            
            responseBlock(model);
        }
        @finally {
            
        };
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
        NSLog(@"error ----> %@",error);
        ResponseModel *model =[[ResponseModel alloc]initWithDic:nil];
        model.msg =@"网络异常!";
        responseBlock(model);
        
    }];
}


@end
