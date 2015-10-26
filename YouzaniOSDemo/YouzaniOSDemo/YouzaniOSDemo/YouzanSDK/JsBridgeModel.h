//
//  JsBridgeModel.h
//  YouzanIOSSDK
//
//  Copyright (c) 2012-2015 © youzan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 请求回调的block
 * response: 返回值，成功获取：(response , NO , nil)
 * 取出成功返回value: response[@"response"]
 * 失败获取：(nil, YES , errorMsg) 直接输出errorMsg
 */
typedef void (^RequestReturnDetail)(NSDictionary *response , BOOL error ,NSString *errorMsg);


@interface JsBridgeModel : NSObject

@property (copy, nonatomic) RequestReturnDetail block;

+ (instancetype) sharedManage;

/*
 * 页面加载完毕后，对js函数进行初始化
 */
- (NSString *) JsBridgeWhenWebDidLoad;

/*
 * 点击分享按钮，触发web分享数据回调
 */
- (NSString *) JsBridgeWhenShareBtnClick;

/*
 * 解析url的参数
 * 返回值:
 * 1. CHECK_LOGIN 验证是否登录  没有登录，跳转到登录页面；如果已经登录，直接调用webUserInfoLogin方法写入用户信息
 * 2. SHARE_DATA 数据分享
 * 3. WEB_READY 页面资源是否加载完毕
 * 4. WX_PAY 微信支付
 *
 */
- (NSString *) parseYOUZANScheme:(NSURL *) url;

/*将客户端获取的用户信息同步到web端
 * params: 字典
 * gender 性别
 * user_name
 * user_id
 * telephone
 * nick_name
 * avatar
 */
- (NSString *) webUserInfoLogin:(NSDictionary *) userInfo;

/*
 * 分享的数据获取
 * title  标题
 * desc 商品的描述
 * link 商品的链接
 * img_url 商品的图片的url
 */
- (NSDictionary *) ShareDataInfo:(NSURL *) url;

@end
