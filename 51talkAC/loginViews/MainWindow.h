//
//  NSWindow+MainWindow.h
//  AC for swift
//
//  Created by guominglong on 15/11/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/NSMenuItem.h>
@interface MainWindow:NSWindow

@property NSView * titlebar;


-(void)setGTitle:(NSString *)_title;
@end
