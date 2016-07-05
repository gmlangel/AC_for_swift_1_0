//
//  LoginView.swift
//  AC for swift
//
//  Created by guominglong on 15/11/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa

@available(OSX 10.10, *)
public class LoginView:NSView{
    
    private var canvas:CGContextRef?;
    
    private var isInited:Bool = false;
    public var showLine:Bool! = true;
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public override func menuForEvent(event: NSEvent) -> NSMenu? {
        return nil;
    }
    
    
    public override func drawRect(dirtyRect: NSRect) {
        
            canvas = NSGraphicsContext.currentContext()?.CGContext;
            CGContextSaveGState(canvas);
            let be:NSBezierPath = NSBezierPath(roundedRect: NSMakeRect(0, 0, self.frame.width, self.frame.height), xRadius: 5, yRadius: 5);
            be.addClip();
            CGContextSetRGBFillColor(canvas, 1, 1, 1, 1);
            CGContextFillRect(canvas, self.frame);
        if(showLine == true)
        {
            CGContextSetLineWidth(canvas, 1);
            CGContextSetRGBStrokeColor(canvas, 0xaa/255.0,0xaa/255.0,0xaa/255.0, 1);
            CGContextBeginPath(canvas);
            CGContextMoveToPoint(canvas, 20, 144);
            CGContextAddLineToPoint(canvas, 230, 144);
            
            
            CGContextMoveToPoint(canvas, 20, 107);
            CGContextAddLineToPoint(canvas, 230, 107);
            
            CGContextMoveToPoint(canvas, 125, 20);
            CGContextAddLineToPoint(canvas, 125, 35);
            
            
            CGContextStrokePath(canvas);
            CGContextRestoreGState(canvas);
        }
        super.drawRect(dirtyRect);
        if(!isInited)
        {
            isInited = true;
            //设置Title
            //lab_title.textColor = StyleManager.instance.color1;
            //lab_title.backgroundColor = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0);
        }
        
    }
}