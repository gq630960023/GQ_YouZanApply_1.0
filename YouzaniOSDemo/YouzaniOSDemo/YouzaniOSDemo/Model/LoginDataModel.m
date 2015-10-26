//
//  LoginDataModel.m
//  ChiHuoApp
//
//  Copyright (c) 2012-2015 © youzan.com. All rights reserved.
//

#import "LoginDataModel.h"

@implementation LoginDataModel


+ (instancetype)sharedManage {
    static LoginDataModel *shareManage = nil;
    dispatch_once_t once;
    dispatch_once(&once,^{
        shareManage = [[LoginDataModel alloc] init];
    });
    return shareManage;
}

@end


@implementation UserInfoDataModel

+ (instancetype)sharedManage {
    static UserInfoDataModel *shareManage = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        shareManage = [[UserInfoDataModel alloc] init];
    });
    return shareManage;
}

- (id) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)setGender:(NSString *)gender {
    [self setProperty:@"gender" Value:gender];
}
- (void)setBid:(NSString *)bid {
    [self setProperty:@"bid" Value:bid];
}
- (void)setName:(NSString *)name {
    [self setProperty:@"name" Value:name];
}
- (void)setTelephone:(NSString *)telephone {
    [self setProperty:@"telephone" Value:telephone];
}
- (void)setAvatar:(NSString *)avatar {
    [self setProperty:@"avatar" Value:avatar];
}

- (void)setProperty:(NSString *)key Value:(NSString *)value {
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [NSUserDefaults standardUserDefaults];
}

- (void)setIpAddress:(NSString *)ipAddress {
    [self setProperty:@"ipaddress" Value:ipAddress];
}

- (NSString *)gender {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
}

- (NSString *)bid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bid"];
}

- (NSString *)name {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (NSString *)telephone {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"telephone"];
}

- (NSString *)avatar {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
}

- (NSString *)ipAddress {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ipaddress"];
}
@end
