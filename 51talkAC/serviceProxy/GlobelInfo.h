//
//  GlobelInfo.h
//  AC_project
//
//  Created by guominglong on 15-1-10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISocketData.h"
#import <Acua/ACNotifyCenter.h>
#import <Acua/ACUserAgent_proxy.h>
#import <Acua/ACNotifyCenter.h>
#import <Acua/UserAgentCallbackMac.h>
@interface GlobelInfo : NSObject

/**
 当前的课程信息
 */
@property Course * currentCourse;

/**
 与ACuasdk进行通讯时的sessionID
 */
@property UInt32 sessionID;

/**
 程序版本
 */
@property NSString * appVersion;

/**
 应用程序名称
 */
@property NSString * appName;

/**
 图片加载地址
 */
@property NSString * imageLoadPath;

/**
 登陆名
 */
@property NSString * loginName;

/**
 未经过md5的用户密码
 */
@property NSString * loginPWD;

/**
 授权文件存储路径
 */
@property NSString * successFilePath;

/**
 用户头像地址
 */
@property NSString * userHeadImgPath;

/**
 用户中心地址
 */
@property NSString * yonghuzhongxin;

/**
 日志路径
 */
@property NSString * logpath;

/**
 媒体日志路径
 */
@property NSString * medialogpath;

/**
 所有日志的目录地址
 */
@property NSString * logsDic;

@property NSMutableArray * crashLogs;

/**
 录音文件路径
 */
@property NSString * recodeDic;

/**
 用户自定义的app设置
 */
@property NSDictionary * CustomAppConfigDic;
+(GlobelInfo *)getInstance;
@end
