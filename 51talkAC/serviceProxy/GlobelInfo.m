//
//  GlobelInfo.m
//  AC_project
//
//  Created by guominglong on 15-1-10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "GlobelInfo.h"
#import <Foundation/Foundation.h>
@implementation GlobelInfo

static GlobelInfo * _instance;
@synthesize currentCourse;
@synthesize sessionID;
@synthesize appVersion;
@synthesize appName;
@synthesize successFilePath;
@synthesize loginName;
@synthesize loginPWD;
@synthesize userHeadImgPath;
@synthesize yonghuzhongxin;
@synthesize logpath;
@synthesize medialogpath;

@synthesize logsDic;
@synthesize crashLogs;
@synthesize recodeDic;
@synthesize CustomAppConfigDic;
NSDateFormatter * nf;
+(GlobelInfo *)getInstance
{
    if(_instance == nil)
        _instance = [[GlobelInfo alloc] init];
    return  _instance;
}

-(id)init
{
    nf = [[NSDateFormatter alloc] init];
    [nf setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//大版本号.小版本号.编译次数
    self.appName = @"51talk AC";
    self.imageLoadPath = @"http://www.51talk.com/upload/talk_pic/";
    
    self.yonghuzhongxin = @"http://www.51talk.com/admin/user/login_to_stu.php?user_id=%d&target=personal_center&token=%@&time=%d&nick_name=%@";
    //获取document文件夹的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    logsDic = [paths objectAtIndex:0];
    logsDic = [logsDic stringByAppendingString:@"/logs/"];
    
    recodeDic = [[paths objectAtIndex:0] stringByAppendingString:@"/51talkAudioRecode/"];
    //创建日志目录
    
    if([[NSFileManager defaultManager] fileExistsAtPath:logsDic] == FALSE)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:logsDic withIntermediateDirectories:FALSE attributes:nil error:nil];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:recodeDic] == FALSE)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:recodeDic withIntermediateDirectories:FALSE attributes:nil error:nil];
    }
    self.logpath = [NSString stringWithFormat:@"%@%@acua.log",logsDic,[nf stringFromDate:[[NSDate alloc] init]]];
    self.medialogpath = [NSString stringWithFormat:@"%@%@acme.log",logsDic,[nf stringFromDate:[[NSDate alloc] init]]];
    self.successFilePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],@"success.gml"];
    
    self.CustomAppConfigDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"/localSuport/meishenmeyong" ofType:@"plist"]];
    return self;
}
@end
