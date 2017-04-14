//
//  httpUtil.h
//  Novel
//
//  Created by zhenfu zhou on 17/03/04.
//  Copyright (c) 2017年 xth. All rights reserved.
//  这里不用了

#import <Foundation/Foundation.h>
#import "ReachabilityTool.h"

@class ResponseModel;

/** 网络请求方式GET和POST */
typedef NS_ENUM(NSInteger,requestType) {
    GET = 999,
    POST
};

//网络请求
@interface httpUtil : NSObject

/**
 *  AFN网络请求
 */
+ (void)doRequest:(NSString *)url ServerceHost:(NSString *)host args:(NSDictionary *)args requestType:(requestType)type isShowHUD:(BOOL)isShowHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


/**
 NSURLSession同步请求
 */
+ (void)doRequestWithSync:(NSString *)url ServerceHost:(NSString *)host args:(NSDictionary *)args requestType:(requestType)type isCache:(BOOL)isCache isShowHUD:(BOOL)isShowHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


/**
 NSURLSession异步请求
 */
+ (void)doRequestWithAsync:(NSString *)url ServerceHost:(NSString *)host args:(NSDictionary *)args requestType:(requestType)type isCache:(BOOL)isCache isShowHUD:(BOOL)isShowHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 *  单张图片上传
 *
 *  param url           url 请求的地址 不用服务器地址,统一拼接
 *  param image         图片
 *  param name          图片对应的关键字
 *  param args          args    请求参数
 *  param responseBlock
 */
+ (void)doUpImageRequest:(NSString *)url Image:(UIImage *)image
                    name:(NSString *)name args:(NSDictionary *)args
               isShowHUD:(BOOL)isShowHUD
                response:(void (^)(ResponseModel *responseMd))responseBlock;

/**
 *  多张图片上传
 */
+ (void)doUpImageRequest:(NSString *)url images:(NSArray *)images
                    name:(NSString *)name args:(NSDictionary *)args
               isShowHUD:(BOOL)isShowHUD
                response:(void (^)(ResponseModel *responseMd))responseBlock;


@end

#pragma mark - AFManager

@interface AFManager : AFHTTPSessionManager

+ (instancetype)shareMangager;

@end


typedef NS_ENUM(int)
{
    /** 没和服务器交换的失败*/
    kFailure_Code = 10086,
    /** 返回错误*/
    kError_Code,
    /** 返回成功*/
    kSuccess_Code
}BackCode;

#pragma mark - ResponseModel

@interface ResponseModel : NSObject

/**
 *	@brief	字典序列化成字符串
 */
+(NSString *)SerializationJson:(NSDictionary *)dictionary;

@property(nonatomic,copy) NSString *msg;

@property(nonatomic,copy) NSString *code;

@property(nonatomic,retain) id response;
/** 返回状态 */
@property(nonatomic,assign) BackCode backCode;
/** 判断是否请求成功 */
@property (nonatomic, assign) BOOL isResultOk;

-(id)initWithDic:(NSDictionary *)dic;

+ (ResponseModel *)responseModelFailureStaue;

@end
