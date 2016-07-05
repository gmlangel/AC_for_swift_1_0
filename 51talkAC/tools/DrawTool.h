//  绘画工具
//  DrawTool.h
//  AC for mac OS
//
//  Created by guominglong on 15/4/1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ByteArray.h"
#import <Cocoa/Cocoa.h>
#import "InstanceManager.h"

@interface DrawTool : NSObject
{
    CGContextRef _currentCanvas;
    NSMutableArray * drawCmdArr;
    NSMutableArray * freePoints;//一条完整线条的集合
    uint16_t drawId;//图形ID
}
/**
 是否启用
 */
@property bool isEnabled;
/**
 笔触颜色
 */
@property UInt32 LineColor;

/**
 笔触宽度
 */
@property CGFloat LineWidth;
@property CGFloat goffset;
@property NSMutableArray * wantdrawCmdArr;
@property uint16_t wantDrawId;

/**
 单例
 */
+(DrawTool *)getInstance;

/**
 绑定画板
 */
-(void)bindCGContextRef:(CGContextRef)_canvas;

/**
 添加一个矩形
 @param _rect 要绘制的矩形
 @param _frameSize 绘制矩形时的画布尺寸
 */
-(void)addRect:(CGRect)_rect frameSize:(NSSize)_frameSize;

/**
 添加一个圆
 @param _rect 要绘制的圆形
 @param _frameSize 绘制园形时的画布尺寸
 */
-(void)addCirc:(CGRect)_rect  frameSize:(NSSize)_frameSize;

/**
 添加一个椭圆
 @param _rect 要绘制的椭圆形
 @param _frameSize 绘制椭圆形时的画布尺寸
 */
-(void)addEllipse:(CGRect)_rect  frameSize:(NSSize)_frameSize;




/**
 创建一个任意线
 @param _point
 @param _frameSize 绘制线条时的画布尺寸
 */
-(void)createFreeLine:(CGPoint)_point;

/**
 向线条中添加一个画点
 */
-(void)addFreePoint:(CGPoint)_point;

/**
 结束线段的点记录，等待drawRect时绘制成完整的一条线或者按轨迹擦除
 @param _frameSize 绘制线条时的画布尺寸
 @param _type （gFreeLine或者gEraser）
 */
-(void)endRecodFreePointAndWaitDraw:(CGSize)_frameSize drawType:(uint8_t)_type;

/**
 添加一个文本行
 */
-(void)addTextField:(NSString *)text point:(CGPoint)_point franmesize:(CGSize)_frameSize;

/**
 根据画布尺寸重绘
 */
-(void)reDraw:(NSSize)_size;


/**
 清除绘画数据
 */
-(void)clearGraphics;

/**
 后退一步
 */
-(void)undo;


@end

enum DrawType{

    gRect=1,/*矩形*/
    gFreeLine=4,/*线条*/
    gText=5,/*文本*/
    gEraser=6,/*笔擦*/
    gUndo=7,/*后退一步*/
    gClear=8/*清除所有*/
};
