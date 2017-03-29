//
//  AppDelegate.m
//  APNsDemo
//
//  Created by Avidly on 2017/2/28.
//  Copyright © 2017年 Avidly. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#define IOS_VERSION ([[UIDevice currentDevice].systemVersion doubleValue])
#define IOS_VERSIONIsIOS10 (IOS_VERSION>=10.0f)

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 在iOS8之前注册远程通知的方法，如果项目要支持iOS8以前的版本，必须要写此方法
//    UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
//    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
//    
    
    
    //iOS10 注册APNS
    if (IOS_VERSIONIsIOS10)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
    else
    {
        //iOS8 注册APNS
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    //  userInfo为收到远程通知的内容
//    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        // 有推送的消息，处理推送的消息
//        NSLog(@"%@", userInfo);
//    }
    
    return YES;
}

// 注册成功回调方法，其中deviceToken即为APNs返回的token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self sendProviderDeviceToken:deviceToken]; // 将此deviceToken发送给Provider
}

// 注册失败回调方法，处理失败情况
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error:%@", error);
}

- (void)sendProviderDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken:%s", deviceToken.bytes);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 在此方法中一定要调用completionHandler这个回调，告诉系统是否处理成功
    NSLog(@"1111%@", userInfo);
    if (userInfo) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}


@end
