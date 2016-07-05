//  Ac自主研发的sdk
//  AcuaSDK.h
//  AC for swift
//
//  Created by guominglong on 15/12/8.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Acua/ACNotifyCenter.h>
#import <Acua/UserAgentCallbackMac.h>

#define COURSE_PIC_FIELD @"coursePic"
@interface AcuaSDK:NSObject

+(BOOL)isLogined;
+(void)setIsLogined:(BOOL)b;
/**
 初始化
 */
+(void)InitUA;

/**
 用户信息管理
 */
+(UserAgent*) UserAgent;

/**
 配置文件管理
 */
+(ConfigService*) ConfigService;

/**
 课程信息管理
 */
+(CourseService*) CourseService;

/**
 AC webService 管理
 */
+(ACService*)     ACService;

/**
 日志管理
 */
+(LogService*)    LogService;

+(StatisticService *)StatsService;

+(ServiceManager *)SM;
@end
