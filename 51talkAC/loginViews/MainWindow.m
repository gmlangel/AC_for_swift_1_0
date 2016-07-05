//
//  NSWindow+MainWindow.m
//  AC for swift
//
//  Created by guominglong on 15/11/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow
bool isinited= NO;
NSTextField * gt;
@synthesize titlebar;
-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
   // [self setAcceptsMouseMovedEvents:YES];
//    //便于窗口形状重绘的操作
    [self setOpaque:NO];//是否为不透明  YES为不透明 NO为透明
    [self setBackgroundColor:[NSColor clearColor]];//清空颜色
//    //隐藏titlebar的操作
    [self setStyleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask|NSFullSizeContentViewWindowMask|NSTexturedBackgroundWindowMask];

    
    gt = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
    [gt setEditable:NO];
    [gt setSelectable:NO];
    [gt setBackgroundColor:[NSColor clearColor]];
    [gt setBordered:NO];
    [gt setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    [gt setAlignment:NSTextAlignmentCenter];
    [gt setTextColor:[NSColor colorWithCalibratedRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1]];
    return self;
}

-(NSRect)frameRectForContentRect:(NSRect)contentRect
{
    if(!isinited)
    {
        isinited = YES;
        NSButton * closebtn = [self standardWindowButton:NSWindowCloseButton];
        NSButton * minbtn = [self standardWindowButton:NSWindowMiniaturizeButton];
        NSButton * resizebtn = [self standardWindowButton:NSWindowZoomButton];
        titlebar = [closebtn superview];//获取titlebar
        [titlebar setHidden:YES];
        
        
        //重绘titlebar
        NSView * tempbar = [[NSView alloc] initWithFrame:titlebar.frame];
        [titlebar.superview addSubview:tempbar];
        tempbar.layer = [[CALayer alloc] init];
        tempbar.layer.backgroundColor = CGColorCreateGenericRGB(0xe7/255.0, 0xe7/255.0, 0xe7/255.0, 1);
        titlebar = tempbar;
        [titlebar addSubview:closebtn];
        [titlebar addSubview:minbtn];
        [titlebar addSubview:resizebtn];
        [titlebar addSubview:gt];
    }
    return [super frameRectForContentRect:contentRect];
}

-(void)setGTitle:(NSString *)_title
{
    [gt setStringValue:_title];
    [gt setFrameOrigin:NSMakePoint((titlebar.frame.size.width - gt.frame.size.width)/2.0, (titlebar.frame.size.height - gt.frame.size.height)/2.0)];
}


-(void)performClose:(id)sender{
    BOOL b = NO;
    if([sender isKindOfClass:[NSMenuItem class]])
    {
        NSMenuItem * item = (NSMenuItem *)sender;
        if([[item keyEquivalent]  isEqual: @"q"])
        {
            b = YES;
        }
       // if((NSMenuItem)sender)
    }
    if(!b)
    {
        [super performClose:sender];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toCloseApp" object:Nil];
    }
}




@end
