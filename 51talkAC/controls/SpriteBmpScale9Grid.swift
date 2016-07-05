//  9切片图层
//  SpriteBmpScale9Grid.swift
//  AC for swift
//
//  Created by guominglong on 15/4/9.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
public class SpriteBmpScale9Grid:NSView
{
    var imgskin:NSImage?;
    var scale9Rects:Array<CGRect>?;//9切片区域范围
    var sourceRect:CGRect?;
    var wantDrawRect:CGRect?;
    var tw:CGFloat = 0;
    var th:CGFloat = 0;
    
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    /**
    根据皮肤初始化
    @param _imgskin 背景图
    @param _type 1状态按钮，两状态按钮，3状态按钮，还是4状态按钮
    */
    public init(_imgskin:NSImage,_rect:CGRect) {
        
        imgskin = _imgskin;
        self.scale9Rects = [];
        self.scale9Rects?.append(CGRectMake(0, 0, _rect.origin.x,_rect.origin.y));
        self.scale9Rects?.append(CGRectMake(_rect.origin.x, 0, _rect.width,_rect.origin.y));
        self.scale9Rects?.append(CGRectMake(
            _rect.origin.x+_rect.width,
            0,
            CGFloat((imgskin?.size.width)!)-CGFloat(_rect.origin.x+_rect.width),
            _rect.origin.y
            ));
        
        
        self.scale9Rects?.append(CGRectMake(0, _rect.origin.y, _rect.origin.x,_rect.height));
        self.scale9Rects?.append(CGRectMake(_rect.origin.x,_rect.origin.y, _rect.width,_rect.height));
        self.scale9Rects?.append(CGRectMake(_rect.origin.x+_rect.width, _rect.origin.y,
            CGFloat((imgskin?.size.width)!)-CGFloat(_rect.origin.x+_rect.width),_rect.height));
        
        self.scale9Rects?.append(CGRectMake(0, _rect.origin.y+_rect.height, _rect.origin.x,
            CGFloat((imgskin?.size.height)!)-CGFloat(_rect.origin.y+_rect.height)));
        self.scale9Rects?.append(CGRectMake(_rect.origin.x,_rect.origin.y+_rect.height, _rect.width,
            CGFloat((imgskin?.size.height)!)-CGFloat(_rect.origin.y+_rect.height)));
        self.scale9Rects?.append(CGRectMake(_rect.origin.x+_rect.width, _rect.origin.y+_rect.height,
            CGFloat((imgskin?.size.width)!)-CGFloat(_rect.origin.x+_rect.width),
            CGFloat((imgskin?.size.height)!)-CGFloat(_rect.origin.y+_rect.height)));
        
        
//        for(var i:Int=0 ;i<9;i++)
//        {
//            println(scale9Rects?[i]);
//        }
        sourceRect = CGRectMake(
            0,
            0,
            _imgskin.size.width,
            _imgskin.size.height
        );
        
        super.init(frame:sourceRect!);
       
    }
    public override func drawRect(dirtyRect: NSRect) {
        
        
        if imgskin == nil{
            return;
        }
        if wantDrawRect == nil{
            wantDrawRect = CGRectMake(0, 0, 1, 1);
        }
        
        
        tw = self.bounds.width - (self.scale9Rects?[0].width)! - (self.scale9Rects?[2].width)!;
        th = self.bounds.height - (self.scale9Rects?[0].height)! - (self.scale9Rects?[6].height)!;
        if tw < 0 || th < 0{
            return;
        }
            
        //第一区域
        wantDrawRect?.origin.x = 0;
        wantDrawRect?.origin.y = 0;
        wantDrawRect?.size.width = (self.scale9Rects?[0].width)!;
        wantDrawRect?.size.height = (self.scale9Rects?[0].height)!;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[0])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //第二区域
        wantDrawRect?.origin.x = (self.scale9Rects?[1].origin.x)!;
        wantDrawRect?.origin.y = (self.scale9Rects?[1].origin.y)!;
        wantDrawRect?.size.width = tw;
        wantDrawRect?.size.height = (self.scale9Rects?[1].height)!;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[1])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //第三区域
        wantDrawRect?.origin.x = (self.scale9Rects?[1].origin.x)!+tw;
        wantDrawRect?.origin.y = (self.scale9Rects?[2].origin.y)!;
        wantDrawRect?.size.width = (self.scale9Rects?[2].width)!;
        wantDrawRect?.size.height = (self.scale9Rects?[2].height)!;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[2])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //第四区域
        wantDrawRect?.origin.x = (self.scale9Rects?[3].origin.x)!;
        wantDrawRect?.origin.y = (self.scale9Rects?[3].origin.y)!;
        wantDrawRect?.size.width = (self.scale9Rects?[3].width)!;
        wantDrawRect?.size.height = th;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[3])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        
        //第五区域
        wantDrawRect?.origin.x = (self.scale9Rects?[4].origin.x)!;
        wantDrawRect?.origin.y = (self.scale9Rects?[4].origin.y)!;
        wantDrawRect?.size.width = tw;
        wantDrawRect?.size.height = th;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[4])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //第6区域
        wantDrawRect?.origin.x = (self.scale9Rects?[4].origin.x)!+tw;
        wantDrawRect?.origin.y = (self.scale9Rects?[5].origin.y)!;
        wantDrawRect?.size.width = (self.scale9Rects?[5].width)!;
        wantDrawRect?.size.height = th;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[5])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //第7区域
        wantDrawRect?.origin.x = (self.scale9Rects?[6].origin.x)!;
        wantDrawRect?.origin.y = (self.scale9Rects?[3].origin.y)!+th;
        wantDrawRect?.size.width = (self.scale9Rects?[6].width)!;
        wantDrawRect?.size.height = (self.scale9Rects?[6].height)!;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[6])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        
        //第8区域
        wantDrawRect?.origin.x = (self.scale9Rects?[7].origin.x)!;
        wantDrawRect?.origin.y = (self.scale9Rects?[3].origin.y)!+th;
        wantDrawRect?.size.width = tw;
        wantDrawRect?.size.height = (self.scale9Rects?[7].height)!;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[7])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //第9区域
        wantDrawRect?.origin.x = (self.scale9Rects?[7].origin.x)!+tw;
        wantDrawRect?.origin.y = (self.scale9Rects?[3].origin.y)!+th;
        wantDrawRect?.size.width = (self.scale9Rects?[8].width)!;
        wantDrawRect?.size.height = (self.scale9Rects?[8].height)!;
        imgskin?.drawInRect(wantDrawRect!, fromRect: (self.scale9Rects?[8])!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        //super.drawRect(dirtyRect);
        
        
    }
    
    public override func mouseMoved(theEvent: NSEvent) {
        
    }
    
    public override func mouseEntered(theEvent: NSEvent) {
        
    }
    
    public override func mouseExited(theEvent: NSEvent) {
       
    }
    
}