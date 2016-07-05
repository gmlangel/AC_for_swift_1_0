//
//  NSObject+AcuaSDK.m
//  AC for swift
//
//  Created by guominglong on 15/12/8.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "AcuaSDK.h"
#import "GlobelInfo.h"
#import "LanguageManager.h"
@implementation AcuaSDK

bool _isLogined;
UserAgent* _ua = nil;
ConfigService* _configService = nil;
CourseService* _courseService = nil;
ACService* _acService = nil;
LogService* _logService = nil;
ServiceManager* _serviceManager = nil;
StatisticService * _statisticService = nil;

+(BOOL)isLogined{
    return _isLogined;
}
+(void)setIsLogined:(BOOL)b{
    _isLogined = b;
}

+(ServiceManager *)SM{
    return _serviceManager;
}

+(UserAgent *)UserAgent
{
    return _ua;
}
+ (ConfigService *)ConfigService
{
    return _configService;
}
+ (CourseService *)CourseService
{
    return _courseService;
}
+ (LogService *)LogService
{
    return _logService;
}
+ (ACService *)ACService
{
    return _acService;
}

+(StatisticService *)StatsService
{
    return _statisticService;
}


+ (void)InitUA
{
    _isLogined = false;
    if (_ua == nil) {
        UserAgentConfig* config = [[UserAgentConfig alloc]init];
        [config setXmlConfigPath:@""];
        [config setCallback:[UserAgentCallbackMac Instance]];
        _ua = [UserAgent CreateUserAgent:config];
        _serviceManager = [_ua ServiceManager];
        _configService = [_serviceManager UAConfigService];
        _courseService = [_serviceManager CourseService];
        _acService = [_serviceManager ACService];
        _logService = [_serviceManager LogService];
        _statisticService = [_serviceManager StatisticService];
        //线下测试环境
        //[[self ConfigService] SetString:[ACService getCKEY_LOGIN_LBS_IP] value:@"172.16.0.23"];//@"121.40.96.226"  @"" @"112.74.130.170"
        
        //线上测试环境
        //[[self ConfigService] SetString:[ACService getCKEY_LOGIN_LBS_IP] value:@"112.74.130.170"];//@"121.40.96.226"  @"" @"112.74.130.170"
        //线上正式环境

        [[self ConfigService] SetString:[ACService getCKEY_LOGIN_LBS_IP] value:@"svc.51talk.com|121.40.96.226|116.213.69.212|svc.51actalk.com"];//@"121.40.96.226"  @"" @"112.74.130.170"

        [[self ConfigService] SetString:[LogService getCKEY_LOG_PATH] value:[GlobelInfo getInstance].logpath];
        //[[self ConfigService] SetString:[ACService getCKEY_LOGIN_HOST] value:@"www.51talk.com|www.51actalk.com|www.italkenglish.cn|www.ifreetalk.net"];
        [[self ConfigService] SetString:[ACService getCKEY_LOGIN_HOST] value:@"172.16.0.23"];
        
        //正式的时候应该用/Ac/Login/login  /Ac/MacLogin/login
        [[self ConfigService] SetString:[ACService getCKEY_LOGIN_URI] value:@"/Ac/MacLogin/login"];
        //[[self ConfigService] SetString:[CourseService getCKEY_COURSE_HOST] value:@"www.51talk.com"];
        [[self ConfigService] SetString:[CourseService getCKEY_COURSE_HOST] value:@"172.16.0.23"];
        [[self ConfigService] SetString:[CourseService getCKEY_COURSE_URI] value:@"/Ac/Lesson/LessonList"];
        [[self ConfigService] SetString:[ACService getCKEY_LOGIN_CLIENT_VERSION] value:[GlobelInfo getInstance].appVersion];
        [[self ConfigService] SetString:[ACService getCKEY_LOGIN_CLIENT_FLAG] value:@"Mac"];
        [[self ConfigService] SetUInt:[ACService getCKEY_LOGIN_CLIENT_OSFLAG] value:0];
        [[self ConfigService] SetUInt:[ACService getCKEY_LOGIN_CLIENT_TYPE] value:7];
        if([[[LanguageManager instance] currentLanguage] isEqual: @"en"])
        {
            [[self ConfigService] SetString:[ACService getCKEY_LOGIN_LANG] value:@"En"];
        }else{
            [[self ConfigService] SetString:[ACService getCKEY_LOGIN_LANG] value:@"Cn"];
        }
        
        [[self LogService] SetLogLevel:LOG_LEVEL_INFO];
        [[self LogService] AddLogType:LOG_TYPE_DEBUG];
        [[self LogService] AddLogType:LOG_TYPE_FILE];
        
    }
}


@end
