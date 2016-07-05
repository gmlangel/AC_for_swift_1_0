//  1态，2态，3态，4态按钮
//  FrameBtn.swift
//  AC for swift
//
//  Created by guominglong on 15/4/9.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
public class FrameBtn:NSButton{

    var imgskin:NSImage?;
    var type:Int?;
    var sourceRect:CGRect?;
    var wantDrawRect:CGRect?;
    var displayType:Int?;
    var isDowned:Bool = false;
    var hitTextArea:NSTrackingRectTag?;
    public var downfunc:((sender:NSButton)->Void)?;
    public var upfunc:(()->Void)!;
    public var dragfunc:(()->Void)!;
    public var isSelected:Bool = false;
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    /**
    根据皮肤初始化按钮
    @param _imgskin 背景图
    @param _type 1状态按钮，两状态按钮，3状态按钮，还是4状态按钮
    */
    public init(_imgskin:NSImage,_type:Int) {
    
        imgskin = _imgskin;
        type = _type;
        sourceRect = CGRectMake(
            0,
            0,
            CGFloat(_imgskin.size.width/CGFloat(_type)),
            _imgskin.size.height
        );
        
        
        wantDrawRect = CGRectMake(
            0,
            0,
            CGFloat(_imgskin.size.width/CGFloat(_type)),
            _imgskin.size.height
        );
        super.init(frame:sourceRect!);
    }

    public override func drawRect(dirtyRect: NSRect) {

       // super.drawRect(dirtyRect);
        if nil == imgskin
        {
            return;
        }
        imgskin?.drawInRect(self.bounds, fromRect: wantDrawRect!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1, respectFlipped: true, hints: nil);
        
        if nil != hitTextArea
        {
            self.removeTrackingRect(hitTextArea!);
            hitTextArea = nil;
        }
        hitTextArea =  self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false);
        
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        if type >= 3
        {
            self.wantDrawRect?.origin.x = (wantDrawRect?.size.width)!*2;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        isDowned = true;
        if(downfunc != nil)
        {
            downfunc!(sender: self);
        }
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        if(isSelected == false)
        {
            wantDrawRect?.origin.x = 0;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        if(upfunc != nil)
        {
            upfunc();
        }
        if isDowned{
            self.performClick(self);
        }
        isDowned = false;
    }
    
    public override func mouseEntered(theEvent: NSEvent) {
        if type >= 2 && self.wantDrawRect?.origin.x != (wantDrawRect?.size.width)! && isDowned == false && isSelected == false
        {
            self.wantDrawRect?.origin.x = (wantDrawRect?.size.width)!;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        
        superview?.mouseEntered(theEvent);
    }
    
    public override func mouseExited(theEvent: NSEvent) {
        if(isSelected == false)
        {
            wantDrawRect?.origin.x = 0;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        isDowned = false;
        
    }
   
}