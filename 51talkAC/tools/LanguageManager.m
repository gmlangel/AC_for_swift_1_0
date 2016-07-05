//
//  LanguageManager.m
//  51talkAC
//
//  Created by guominglong on 16/5/13.
//  Copyright © 2016年 guominglong. All rights reserved.
//

#import "LanguageManager.h"

static LanguageManager * LanguageManagerins;
@implementation LanguageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentLanguage = @"zh";
        //确定系统语言
        NSArray * dic = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] valueForKey:@"NSLanguages"];
        _currentLanguage = (NSString *)dic[0];

        
        //加载语言本地化文件
        languageDic = [[NSMutableDictionary alloc] init];
        NSDictionary * currentDic = nil;
        NSString * temppath = @"";
        if([_currentLanguage isEqualToString:@"en"])
        {
            temppath = [[NSBundle mainBundle] pathForResource:@"localSuport/en_language" ofType:@"plist"];
        }else{
            temppath = [[NSBundle mainBundle] pathForResource:@"localSuport/zh_language" ofType:@"plist"];
        }
        currentDic = [[NSDictionary alloc] initWithContentsOfFile:temppath];
        if(currentDic != nil)
        {
            NSString * tempkey = @"";
            NSArray * lanallkeys = [currentDic allKeys];
            for (NSString * key in lanallkeys) {
                NSDictionary * obj = [currentDic valueForKey:key];
                NSArray * temparr = [obj allKeys];
                NSArray * tempvaluearr = [obj allValues];
                for (NSInteger i = 0; i<temparr.count; i++) {
                    tempkey = temparr[i];
                    [languageDic setObject:tempvaluearr[i] forKey:tempkey];
                }
            }
        }
    }
    return self;
}

+(LanguageManager * )instance{
    if(LanguageManagerins == nil)
    {
        LanguageManagerins = [[LanguageManager alloc] init];
    }
    return LanguageManagerins;
}

-(NSString *)currentLanguage{
    return _currentLanguage;
}


-(NSString *)getLanguageStr:(NSString *)key{
    return [languageDic valueForKey:key];
}
@end
