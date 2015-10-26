//
//  LoginDataModel.h
//  ChiHuoApp
//
//  Copyright (c) 2012-2015 © youzan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDataModel : NSObject

+ (instancetype)sharedManage;

@end


@interface UserInfoDataModel : NSObject
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *bid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *ipAddress;

+ (instancetype)sharedManage;
@end