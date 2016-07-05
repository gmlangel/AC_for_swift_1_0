//
//  DrawViewToolBar.swift
//  AC for swift
//
//  Created by guominglong on 15/4/13.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
public class DrawViewToolBar:NSView
{
    var becontrolled:NSControl?;
    public var position:NSPoint?;
    public var setDefaultType:((String)->Void)?;
    private var preState:Int = 4;
    required public init!(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public override func viewDidMoveToWindow() {
        if(self.window != nil)
        {
            //设置默认属性
            (self.subviews[0] as! NSButton).mouseDown(NSEvent());
        }
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
    }
    
    public func ginit()
    {
        
        
        
        position = NSMakePoint(0, 0);
        var frb:FrameBtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("pencil_btn"), _type: 4);
        frb.target = self;
        frb.downfunc = onbtnDown;
        frb.setFrameOrigin(position!);
        self.addSubview(frb);
        position!.x+=frb.bounds.width;
        
        frb = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("rectangle_btn"), _type: 4);
        frb.target = self;
        frb.downfunc = onbtnDown;
        frb.setFrameOrigin(position!);
        self.addSubview(frb);
        position!.x+=frb.bounds.width;
        
        frb = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("text_btn"), _type: 4);
        frb.target = self;
        frb.downfunc = onbtnDown;
        frb.setFrameOrigin(position!);
        self.addSubview(frb);
        position!.x+=frb.bounds.width;
        
        frb = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("eraser_btn"), _type: 4);
        frb.target = self;
        frb.downfunc = onbtnDown;
        frb.setFrameOrigin(position!);
        self.addSubview(frb);
        position!.x+=frb.bounds.width;
        
        
        frb = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("undo_btn"), _type: 4);
        frb.target = self;
        frb.downfunc = onbtnDown;
        frb.setFrameOrigin(position!);
        self.addSubview(frb);
        position!.x+=frb.bounds.width;
        
        
        frb = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("clear_btn"), _type: 4);
        frb.target = self;
        frb.downfunc = onbtnDown;
        frb.setFrameOrigin(position!);
        self.addSubview(frb);
        position!.x+=frb.bounds.width;
        
        
    }
    
    
    
    func onbtnDown(_sender:NSButton)->Void
    {
        var arr:Array = self.subviews;
        for(var i:Int = 0 ;i<arr.count;i++)
        {
            if arr[i] as! FrameBtn  == _sender as! FrameBtn
            {
                func1(i);
                (arr[i] as! FrameBtn).isSelected = true;
            
            }else{
                (arr[i] as! FrameBtn).isSelected = false;
                (arr[i] as! FrameBtn).mouseUp(NSEvent());
            }
        }
       NSNotificationCenter.defaultCenter().postNotificationName("resignTextField", object: nil);
    }
    
    
    private func func1(idx:Int)
    {
        let idxType:Int = idx;
        var result:Int?;
        switch idxType{
        case 1:
            result = 1;
            break;
        case 0:
            result = 4;
            break;
        case 2:
            result = 5;
            break;
        case 3:
            result = 6;
            break;
        case 4:
            result = 7;
            break;
        case 5:
            result = 8;
            break;
        default:
            break;
        }
        
        setDefaultType!(String(result!));
        if(result == 8 || result == 7)
        {
            //在执行完清空或者回退操作后，设置默认笔触为铅笔
            result = preState;
            setDefaultType!(String(result!));
        }else{
            preState = result!;
        }
    }
    
}