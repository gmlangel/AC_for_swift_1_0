//
//  BaseWhiteBoardLayer.swift
//  51talkAC
//
//  Created by guominglong on 16/3/22.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
public class AniWhiteBoardLayer:CALayer{
   var _tempDrawInfo:DrawInfo?;//用于记录自己绘制轨迹的笔触对象
    public override func drawInContext(ctx: CGContext) {
        //清除上一次绘制的内容
        CGContextClearRect(ctx, self.bounds);
        if(_tempDrawInfo != nil)
        {
            let di = _tempDrawInfo!;
            var point:[CGPoint];
            CGContextSaveGState(ctx);
            if(di.Type == DrawType.Line)
            {
                point = di.Point;
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                
                CGContextAddLines(ctx,point,point.count);
                
                CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
                CGContextSetLineWidth(ctx, 2);
                CGContextDrawPath(ctx,CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
                point.removeAll(keepCapacity: false);
            }
            else if di.Type == DrawType.Erase
            {
                point = di.Point;
                CGContextSetBlendMode(ctx, CGBlendMode.Clear);
                CGContextAddLines(ctx,point,point.count);
                CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
                CGContextSetLineWidth(ctx, 20);
                CGContextDrawPath(ctx,CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
                point.removeAll(keepCapacity: false);
            }
            else if di.Type == DrawType.Rect
            {
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                let rect = CGRect(x: di.Left, y: di.Top, width: (di.Right-di.Left), height: (di.Bottom-di.Top));
                CGContextAddRect(ctx, rect);
                CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
                CGContextSetLineWidth(ctx, 2);
                CGContextDrawPath(ctx,CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
                
                
            }
            else if di.Type == DrawType.Ellipse
            {
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                let rect = CGRect(x: di.Left, y: di.Top, width: (di.Right-di.Left), height: (di.Bottom-di.Top));
                CGContextAddEllipseInRect(ctx, rect);
                CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
                CGContextSetLineWidth(ctx, 2);
                CGContextDrawPath(ctx, CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
            }else if di.Type == DrawType.Text
            {
//                let currentCTX = NSGraphicsContext.currentContext();
//                NSGraphicsContext.setCurrentContext(NSGraphicsContext(CGContext: ctx, flipped: false));
//                font = NSFont(name: "Helvetica Neue", size: CGFloat(NSNumber(char: di.Pen).integerValue) * xScale);
//                CGContextSetRGBStrokeColor (ctx, 1, 0, 0, 1); // 7
//                CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
//                di.text.drawAtPoint(NSPoint(x: di.Left * xScale, y: di.Top * yScale - font.pointSize), withAttributes: [NSFontAttributeName: font,NSForegroundColorAttributeName:NSColor.redColor()]);
//                NSGraphicsContext.setCurrentContext(currentCTX);
            }
            CGContextRestoreGState(ctx);
        }
        
    }
    
    //图形ID加时间组成的token
    func getToken64(tuxingID:Int32)->UInt64
    {
       return (UInt64(tuxingID)&0xffffffff)|((UInt64(NSDate().timeIntervalSince1970)<<32)&0xffffffff00000000)
    }
    
    /**
     创建一条临时线条，供老师使用
     */
    func createFreeLine(cp:CGPoint,drawType:DrawType,penWidth:Int8 = 1)-> DrawInfo?
    {
        _tempDrawInfo = DrawInfo();
        _tempDrawInfo!.Type = drawType;
        _tempDrawInfo!.Cx = Int16(self.bounds.width);
        _tempDrawInfo!.Cy = Int16(self.bounds.height);
        _tempDrawInfo!.Color = 0x0000ff;
        _tempDrawInfo!.Pen = penWidth;
        _tempDrawInfo!.Point = [cp];
        _tempDrawInfo!.Left = 0;
        _tempDrawInfo!.Top = 0;
        _tempDrawInfo!.Right = self.bounds.width;
        _tempDrawInfo!.Bottom = self.bounds.height;
        self.setNeedsDisplay();
        if(_tempDrawInfo?.Type == .Erase)
        {
            //如果当前正在执行的操作是擦出，则交由上层去处理
            return _tempDrawInfo;
        }else{
            return nil;
        }
    }
    
    /**
     向临时线条中添加点
     */
    func addFreePoint(cp:CGPoint)-> DrawInfo?
    {
        if(_tempDrawInfo != nil)
        {
            _tempDrawInfo!.Point.append(cp);
        }
        self.setNeedsDisplay();
        if(_tempDrawInfo?.Type == .Erase)
        {
            //如果当前正在执行的操作是擦出，则交由上层去处理
            return _tempDrawInfo;
        }else{
            return nil;
        }
    }
    
    /**
     结束临时线条的绘制，并隐藏临时线条。将绘制数据反馈给上一层，去处理
     */
    func endAndWaitDraw(tuxingID:Int32)-> DrawInfo?
    {
        var result:DrawInfo?;
        if((_tempDrawInfo?.Type == .Erase || _tempDrawInfo?.Type == .Line) && _tempDrawInfo?.Point.count < 2)
        {
            result = nil;
        }else{
            result = _tempDrawInfo;
            _tempDrawInfo!.UToken = tuxingID;
            _tempDrawInfo!.Token = getToken64(tuxingID);
            _tempDrawInfo = nil;
            self.setNeedsDisplay();
            
        }
        return result;
    }
    
    /**
     创建一个临时矩形图形，供老师观看
     */
    func createRect(cr:CGRect,tuxingID:Int32)
    {
        _tempDrawInfo = DrawInfo();
        _tempDrawInfo!.Type = .Rect;
        _tempDrawInfo!.UToken = tuxingID;
        _tempDrawInfo!.Cx = Int16(self.bounds.width);
        _tempDrawInfo!.Cy = Int16(self.bounds.height);
        _tempDrawInfo!.Token = getToken64(tuxingID);
        _tempDrawInfo!.Color = 0x0000ff;
        _tempDrawInfo!.Pen = 1;
        _tempDrawInfo!.Left = cr.origin.x;
        _tempDrawInfo!.Top = cr.origin.y;
        _tempDrawInfo!.Right = cr.origin.x + cr.size.width;
        _tempDrawInfo!.Bottom = cr.origin.y + cr.size.height;
        self.setNeedsDisplay();
    }
    
    /**
     改变临时矩形图形的尺寸，供老师观看
     */
    func changeRect(cr:CGRect)
    {
        if(_tempDrawInfo != nil)
        {
            _tempDrawInfo!.Left = cr.origin.x;
            _tempDrawInfo!.Top = cr.origin.y;
            _tempDrawInfo!.Right = cr.origin.x + cr.size.width;
            _tempDrawInfo!.Bottom = cr.origin.y + cr.size.height;
        }
        self.setNeedsDisplay();
    }
    
    
}

