//
//  InstanceManager.m
//  AC for mac OS
//
//  Created by guominglong on 15/4/1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "InstanceManager.h"
@implementation InstanceManager

static InstanceManager * _ins;

+(InstanceManager *)instance
{
    if(nil == _ins)
    {
        _ins = [[InstanceManager alloc] init];
    }
    return _ins;
}

-(id)init
{
    self = [super init];
    if(nil != self)
    {
        instanceDic = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

-(void)addModuleInstance:(id)_instance nameKey:(NSString *)_nameKey
{
    
    if(nil == _instance)
    {
//        NSException * ne=[[NSException alloc] initWithName:@"InstanceManagerERR"
//                                                    reason:[NSString stringWithFormat:@"[getModuleInstaceByName]无法获得%@绑定的单例",_nameKey]
//                                                  userInfo:nil];
//        @throw ne;
        [GLogger print:[NSString stringWithFormat:@"[addModuleInstance]无法绑定空对象by%@",_nameKey]];
    }else
        [instanceDic setValue:_instance forKey:_nameKey];
        
}

-(id)getModuleInstaceByName:(NSString *)_namekey
{
    
    id ins = [instanceDic valueForKey:_namekey];
    if(nil == ins)
    {
//        NSException * ne=[[NSException alloc] initWithName:@"InstanceManagerERR"
//                                                    reason:[NSString stringWithFormat:@"[getModuleInstaceByName]无法获得%@绑定的单例",_namekey]
//                                                  userInfo:nil];
       // @throw ne;
    //[GLogger print:[NSString stringWithFormat:@"[getModuleInstaceByName]无法获得%@绑定的单例",_namekey]];
    }
    
    return ins;
}

@end
