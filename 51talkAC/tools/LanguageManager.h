//
//  LanguageManager.h
//  51talkAC
//
//  Created by guominglong on 16/5/13.
//  Copyright © 2016年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject
{
    NSMutableDictionary * languageDic;
    NSString * _currentLanguage;
}

/**
 当前系统语言
 */
@property (readonly)NSString * currentLanguage;

/**
 单例
 */
+(LanguageManager * )instance;

-(NSString *)getLanguageStr:(NSString *)key;
@end
