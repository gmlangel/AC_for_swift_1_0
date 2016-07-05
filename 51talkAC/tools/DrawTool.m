//
//  DrawTool.m
//  AC for mac OS
//
//  Created by guominglong on 15/4/1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "DrawTool.h"



@implementation DrawTool

static DrawTool * _instace;

@synthesize wantdrawCmdArr = drawCmdArr;
@synthesize wantDrawId = drawId;
+(DrawTool *)getInstance
{
    if(nil == _instace)
    {
        _instace = [[DrawTool alloc] init];
        _instace.LineColor = 0xffff0000;
        _instace.LineWidth = 2;
        _instace.isEnabled = false;
    }
    return _instace;
}

-(void)bindCGContextRef:(CGContextRef)_canvas
{
    _currentCanvas = _canvas;
}


-(void)createFreeLine:(CGPoint)_point
{
    if(_isEnabled == false)
    {
        return ;
    }
    [freePoints removeAllObjects];
    NSValue * _val = [[NSValue alloc] initWithBytes:&_point objCType:@encode(CGPoint)];
    [freePoints addObject:_val];
}

-(void)addFreePoint:(CGPoint)_point
{
    if(_isEnabled == false)
    {
        return ;
    }
    if(_point.x<0)
        _point.x = 0;
    if(_point.y<0)
        _point.y = 0;
    NSValue * _val = [[NSValue alloc] initWithBytes:&_point objCType:@encode(CGPoint)];
    [freePoints addObject:_val];
}

-(void)endRecodFreePointAndWaitDraw:(CGSize)_frameSize drawType:(uint8_t)_type
{
    if(_isEnabled == false)
    {
        return ;
    }
    
    if([freePoints count]==0)
        return;
    //存储绘图命令
    ByteArray * cmdbys = [[ByteArray alloc] init];
    [cmdbys writeByte:_type];
    [cmdbys writeShort:drawId];
    [cmdbys writeUnsignedInt64:0];
    [cmdbys writeShort:_frameSize.width];
    [cmdbys writeShort:_frameSize.height];
    [cmdbys writeByte:self.LineWidth];
    [cmdbys writeUnsignedInt:self.LineColor];
    [cmdbys writeUnsignedInt64:0];//无用的4个short
    NSInteger j = [freePoints count];
    [cmdbys writeUnsignedInt:(uint32_t)j];//点数
    NSValue * nv;
    CGPoint p;
    for (int i =0; i<j; i++) {
        nv = freePoints[i];
        [nv getValue:&p];
        [cmdbys writeShort:p.x];
        [cmdbys writeShort:_frameSize.height - p.y];
    }
    //更新图形ID
    drawId++;
    [drawCmdArr addObject:cmdbys];
}

-(void)drawLineByPoints:(NSMutableArray *)_points
{
    if(_isEnabled == false)
    {
        return ;
    }
    //设置线条样式
    CGContextSetLineCap(_currentCanvas, kCGLineCapRound);
    //设置线条粗细宽度
    CGContextSetLineWidth(_currentCanvas, self.LineWidth);
    //设置颜色
    CGContextSetRGBStrokeColor(_currentCanvas, 1.0, 0.0, 0.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(_currentCanvas);
    CGPoint p;
    NSValue *nv;
    NSInteger _count = [_points count];
    for (int i =0; i<_count; i++) {
        nv =_points[i];
        [nv getValue:&p];
        if(i == 0)
          CGContextMoveToPoint(_currentCanvas, p.x, p.y);
        else
          CGContextAddLineToPoint(_currentCanvas, p.x, p.y);
    }
    CGContextStrokePath(_currentCanvas);

    
}
//
-(void)clearByLinePoints:(NSMutableArray *)_points
{
    if(_isEnabled == false)
    {
        return ;
    }

//    CGContextSetRGBFillColor(_currentCanvas, 0, 0, 0, 1);
//    CGPoint p;
//    NSValue *nv;
//    NSInteger _count = [_points count];
//    for (int i =0; i<_count; i++) {
//        nv =_points[i];
//        [nv getValue:&p];
//        CGContextFillRect(_currentCanvas, CGRectMake(p.x-10, p.y-10, 20, 20));
//    }
    CGContextSetBlendMode(_currentCanvas, kCGBlendModeClear);
    //设置线条样式
    CGContextSetLineCap(_currentCanvas, kCGLineCapRound);
    //设置线条粗细宽度
    CGContextSetLineWidth(_currentCanvas, 20.0);
    //设置颜色
    CGContextSetRGBStrokeColor(_currentCanvas, 1, 0,0, 1);
    //开始一个起始路径
    //CGContextBeginPath(_currentCanvas);
    CGPoint p;
    NSValue *nv;
    NSInteger _count = [_points count];
    CGPoint *ps = alloca(_count);
    for (int i =0; i<_count; i++) {
        nv =_points[i];
        [nv getValue:&p];
//        if(i == 0)
//            CGContextMoveToPoint(_currentCanvas, p.x, p.y);
//        else
//            CGContextAddLineToPoint(_currentCanvas, p.x, p.y);
        ps[i] = p;
    }
   // CGContextStrokePath(_currentCanvas);

    
    CGContextDrawPath(_currentCanvas, kCGPathStroke);
    CGContextFillPath(_currentCanvas);
    
}

-(void)addRect:(CGRect)_rect frameSize:(CGSize)_frameSize
{
    if(_isEnabled == false)
    {
        return ;
    }
    //存储绘图命令
    ByteArray * cmdbys = [[ByteArray alloc] init];
    [cmdbys writeByte:gRect];
    [cmdbys writeShort:drawId];
    [cmdbys writeUnsignedInt64:0];
    [cmdbys writeShort:_frameSize.width];
    [cmdbys writeShort:_frameSize.height];
    [cmdbys writeByte:self.LineWidth];
    [cmdbys writeUnsignedInt:self.LineColor];
    [cmdbys writeShort:_rect.origin.x];
    [cmdbys writeShort:_frameSize.height - _rect.origin.y];
    [cmdbys writeShort:_rect.origin.x + _rect.size.width];
    [cmdbys writeShort:_frameSize.height - (_rect.origin.y + _rect.size.height)];
    //更新图形ID
    drawId++;
    [drawCmdArr addObject:cmdbys];
}

-(void)addTextField:(NSString *)text point:(CGPoint)_point franmesize:(CGSize)_frameSize
{
    if(_isEnabled == false)
    {
        return ;
    }
    NSLog(@"text=%@",text);
    ByteArray * cmdbys = [[ByteArray alloc] init];
    [cmdbys writeByte:gText];
    [cmdbys writeShort:drawId];
    [cmdbys writeUnsignedInt64:0];
    [cmdbys writeShort:_frameSize.width];
    [cmdbys writeShort:_frameSize.height];
    [cmdbys writeByte:self.LineWidth];
    [cmdbys writeUnsignedInt:self.LineColor];
    [cmdbys writeShort:_point.x];
    [cmdbys writeShort:_frameSize.height - _point.y];
    [cmdbys writeUnsignedInt:0];//无用的2个short
    [cmdbys writeUnicodeString:text];
    
    //更新图形ID
    drawId++;
    [drawCmdArr addObject:cmdbys];
}

-(void)addCirc:(CGRect)_rect frameSize:(CGSize)_frameSize
{
    
}

-(void)addEllipse:(CGRect)_rect frameSize:(CGSize)_frameSize
{
    
}

-(void)reDraw:(CGSize)_size
{
    if(_isEnabled == false)
    {
        return ;
    }
    
    NSInteger i = [drawCmdArr count];
    while (i>0) {
        i--;
        CGContextSaveGState(_currentCanvas);
        [self analysisAndDraw:[drawCmdArr objectAtIndex:i] size:_size];
        CGContextRestoreGState(_currentCanvas);
    }
}

/**
 解析画笔命令
 */
-(void)analysisAndDraw:(ByteArray *)bys size:(CGSize)_size
{
    if(_isEnabled == false)
    {
        return ;
    }
    
    bys.gposition = 0;
    uint8_t drawType = [bys readByte];
    switch (drawType) {
        case gRect:
            [self func1:bys Size:_size];
            break;
        case gFreeLine:
            [self func2:bys Size:_size];
            break;
        case gEraser:
            [self func3:bys Size:_size];
            break;
        case gText:
            [self func4:bys Size:_size];
            break;
        default:
            break;
    }
}

-(void)func1:(ByteArray *)bys Size:(CGSize)_size
{
    bys.gposition +=10;//掠过无用的信息
    CGFloat scalex = _size.width/[bys readShort];

    bys.gposition +=2;//略过 高度信息的读取
    //设置线条粗细宽度
    CGContextSetLineWidth(_currentCanvas, [bys readUnsignedByte]);
    bys.gposition +=4;//略过颜色信息
    CGFloat bx = [bys readShort] * scalex;
    CGFloat by = [bys readShort] * scalex;
    by = _size.height - by;
    CGFloat ex = [bys readShort] * scalex;
    CGFloat ey = _size.height - [bys readShort] * scalex;
    //设置线条样式
    CGContextSetLineCap(_currentCanvas, kCGLineCapRound);
    
    //设置颜色
    CGContextSetRGBStrokeColor(_currentCanvas, 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(_currentCanvas);
    CGRect _rect = NSMakeRect(bx, by, ex-bx, ey-by);
    // NSLog(@"x=%f,y=%f,w=%f,h=%f",_rect.origin.x,_rect.origin.y,_rect.size.width,_rect.size.height);
    CGContextAddRect(_currentCanvas, _rect);
    CGContextStrokePath(_currentCanvas);
}

-(void)func2:(ByteArray *)bys Size:(CGSize)_size
{
    bys.gposition +=10;//掠过无用的信息
    CGFloat scalex2 = _size.width/[bys readShort];
    //CGFloat scaley = _size.height/[bys readShort];
    bys.gposition +=2;//略过 高度信息的读取
    //设置线条粗细宽度
    self.LineWidth = (CGFloat)[bys readUnsignedByte];
    bys.gposition +=4;//略过颜色信息
    bys.gposition +=8;//略过freeline特有的8个无用字节
    NSInteger j = [bys readUnsignedInt];//读取画点数
    [freePoints removeAllObjects];
    NSValue * nv;
    CGPoint p;
    for (int i = 0; i<j; i++) {
        p = CGPointMake(
                        [bys readUnsignedShort] * scalex2,
                        _size.height - [bys readUnsignedShort] * scalex2);
        nv = [[NSValue alloc] initWithBytes:&p objCType:@encode(CGPoint)];
        [freePoints addObject:nv];
    }
    [self drawLineByPoints:freePoints];
}

-(void)func3:(ByteArray *)bys Size:(CGSize)_size
{
    bys.gposition +=10;//掠过无用的信息
    CGFloat scalex2 = _size.width/[bys readShort];
    //CGFloat scaley = _size.height/[bys readShort];
    bys.gposition +=2;//略过 高度信息的读取
    //设置线条粗细宽度
    self.LineWidth = (CGFloat)[bys readUnsignedByte];
    bys.gposition +=4;//略过颜色信息
    bys.gposition +=8;//略过freeline特有的8个无用字节
    NSInteger j = [bys readUnsignedInt];//读取画点数
    [freePoints removeAllObjects];
    NSValue * nv;
    CGPoint p;
    for (int i = 0; i<j; i++) {
        p = CGPointMake(
                        [bys readUnsignedShort] * scalex2,
                        _size.height - [bys readUnsignedShort] * scalex2);
        nv = [[NSValue alloc] initWithBytes:&p objCType:@encode(CGPoint)];
        [freePoints addObject:nv];
    }
    [self clearByLinePoints:freePoints];
}

-(void)func4:(ByteArray *)bys Size:(CGSize)_size
{
    bys.gposition +=10;//掠过无用的信息
    CGFloat scalex2 = _size.width/[bys readShort];
    //CGFloat scaley = _size.height/[bys readShort];
    bys.gposition +=2;//
    CGFloat fontsize = [bys readByte];
    bys.gposition +=4;
    CGPoint p = CGPointMake([bys readShort]*scalex2, _size.height - [bys readShort]*scalex2);
    bys.gposition +=4;//略过freeline特有的4个无用字节
    NSString * _text = [bys readUnicodeString];
    NSFont * font = [NSFont systemFontOfSize:fontsize*scalex2];
    p.y -= font.pointSize;
    //NSLog(@"fontsize=%f",fontsize*scalex2);
    CGContextSetRGBStrokeColor(_currentCanvas, 1, 0, 0, 1);
    [_text drawAtPoint:p withAttributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName:[NSColor redColor]}];
}

-(void)clearGraphics
{
    [drawCmdArr removeAllObjects];//移除所有记录
}

-(void)undo
{
    if([drawCmdArr count]>0)
        [drawCmdArr removeLastObject];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        drawCmdArr = [[NSMutableArray alloc]init];
        drawId = 0;
        freePoints = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
