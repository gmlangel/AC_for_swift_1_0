//
//  DrawView.swift
//  AC for swift
//
//  Created by guominglong on 15/4/13.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
@available(OSX 10.10, *)
public class DrawView:NSView
{
    var drawType:Int?;
    var canvas:CGContextRef?;
    var beginX:CGFloat?;
    var beginY:CGFloat?;
    var endX:CGFloat?;
    var endY:CGFloat?;
    
    /**
    是否开启图形绘制工具
    */
    private var _isEnabled:Bool!;
    public var isEnabled:Bool{
        get{
            return _isEnabled;
        }
        set{
            _isEnabled = newValue;
            DrawTool.getInstance().isEnabled = _isEnabled;
        }
    }
    
    /**
    允许点击屏幕绘制图形
    */
    public var cantoDraw:Bool!;
    
    
    var gsize:NSSize{
        get{
            //return (InstanceManager.instance().getModuleInstaceByName("pdfReader") as PdfView).gSize;
            return self.frame.size;
        }
    }
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        isEnabled = false;
        cantoDraw = true;

    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public func setgDrawType(value:String)
    {
        self.drawType = Int(value);
        if drawType == 8
        {
            self.clearDrawData();
        }else if(self.drawType == 7)
        {
            self.goback();
        }
    }
    public override func drawRect(dirtyRect: NSRect) {

        
        if(InstanceManager.instance().getModuleInstaceByName("pdfReader") == nil)
        {
            DrawTool.getInstance().goffset = 0;
        }else
        {
            DrawTool.getInstance().goffset = 0;//(InstanceManager.instance().getModuleInstaceByName("pdfReader") as PdfView).h;
            
            canvas = NSGraphicsContext.currentContext()?.CGContext;
            DrawTool.getInstance().bindCGContextRef(canvas);
            DrawTool.getInstance().reDraw(self.bounds.size);
        }
        
        
    }
   
    public func ginit()
    {
        self.drawType = 4;
        
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        
        if(cantoDraw == false)
        {
            return;
        }
        
        beginX = theEvent.locationInWindow.x-self.frame.origin.x;
        beginY = theEvent.locationInWindow.y-self.frame.origin.y;
        //println("x=\(beginX),y=\(beginY)");
        
        let i:Int = drawType!;
        switch i {
        case 1:
            break;
        case 6:
            DrawTool.getInstance().createFreeLine(CGPointMake(beginX!, beginY!));
            break;
        case 4:
            DrawTool.getInstance().createFreeLine(CGPointMake(beginX!, beginY!));
            break;
        case 5:
            
            break;
            
        default:
            break;
        }
    }
    
    public override func mouseDragged(theEvent: NSEvent) {
        
        if(cantoDraw == false)
        {
            return;
        }
        
        endX = theEvent.locationInWindow.x-self.frame.origin.x;
        endY = theEvent.locationInWindow.y-self.frame.origin.y;
        let i:Int = drawType!;
        switch (i) {
        case 6:
            DrawTool.getInstance().addFreePoint(CGPointMake(endX!, endY!));
            break;
        case 4:
            DrawTool.getInstance().addFreePoint(CGPointMake(endX!, endY!));
            break;
        default:
            break;
        }
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        
        if(cantoDraw == false)
        {
            return;
        }
        endX = theEvent.locationInWindow.x-self.frame.origin.x;
        endY = theEvent.locationInWindow.y-self.frame.origin.y;
        let i:Int = drawType!;
        switch (i) {
        case 1:
            //向工具中添加一个矩形，准备在drawRect：的时候重绘
            DrawTool.getInstance().addRect(CGRectMake(beginX!, beginY!, endX!-beginX!, endY!-beginY!), frameSize: gsize)
            break;
        case 4:
            DrawTool.getInstance().endRecodFreePointAndWaitDraw(gsize, drawType: 4);
            break;
        case 6:
            DrawTool.getInstance().endRecodFreePointAndWaitDraw(gsize, drawType: 6);
            break;
        case 5:
            DrawTool.getInstance().addTextField("我是中国人", point: CGPointMake(beginX!, beginY!), franmesize: gsize)
            
            break;
        default:
            break;
        }
        self.setNeedsDisplayInRect(self.bounds);
    }
    
    /**
    清除绘画笔记
    */
    public func clearDrawData()
    {
        if(DrawTool.getInstance().wantdrawCmdArr.count == 0)
        {
            return;
        }
        //清空画板数据
        DrawTool.getInstance().clearGraphics();
        self.setNeedsDisplayInRect(self.bounds);
    }
    
    /**
    后退操作
    */
    public func goback()
    {
        if(DrawTool.getInstance().wantdrawCmdArr.count == 0)
        {
            return;
        }
        //后退一步操作
        DrawTool.getInstance().undo();
        self.setNeedsDisplayInRect(self.bounds);
    }
    
    /**
    同步绘画数据
    */
    public func syncDraw(data:ByteArray,cmdType:Int)
    {
        //解析绘画数据
        WhiteBoardProxy.instance.decodeData(data, cmdType: cmdType, _isClient: true);
    }
    
    /**
    执行绘画动作
    */
    private func execCMD(isNeedAni:Bool=false)
    {
        
    }
    
}


