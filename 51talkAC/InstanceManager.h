//  单例管理类
//  InstanceManager.h
//  AC for mac OS
//
//  Created by guominglong on 15/4/1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GLogger.h"

@interface InstanceManager : NSObject
{
    NSMutableDictionary * instanceDic;
}

/**
 单例
 */
+(InstanceManager *)instance;

/**
 根据唯一的namekey绑定单例
 */
-(void)addModuleInstance:(id)_instance nameKey:(NSString *)_nameKey;

/**
 根据唯一的namekey获得单例
 */
-(id)getModuleInstaceByName:(NSString *)_namekey;
@end
