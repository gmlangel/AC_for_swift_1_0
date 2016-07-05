//
//  IView.h
//  AC for mac OS
//
//  Created by guominglong on 15/3/27.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IView <NSObject>

@property BOOL isInited;
-(void)ginit;
-(void)fillInfo:(id)_obj;
-(void)reset;
-(void)clearInfo;
@end
