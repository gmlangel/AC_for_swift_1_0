//  3态可变颜色按钮
//  FrameColorBtn.swift
//  AC for swift
//
//  Created by guominglong on 15/12/2.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class FrameColorBtn:NSButton{

    private var enabledImage:NSImage!;//可用状态
    private var disabledImage:NSImage!;//不可用状态
    private var enabledThirdColorArr:NSArray!;//可用状态的颜色数组
    private var disabledThirdColorArr:NSArray!;//不可用状态的颜色数组
    public var tb:NSTextField!;
    
    private var isEnabled:Bool!;//是否启用
    var thirdColorArr:NSArray!;//颜色数组
    var imgskin:NSImage!;
    var type:Int?;
    var sourceRect:CGRect?;
    var wantDrawRect:CGRect?;
    var displayType:Int?;
    var isDowned:Bool = false;
    var hitTextArea:NSTrackingRectTag?;
    public var downfunc:((sender:NSButton)->Void)!;
    public var upfunc:(()->Void)!;
    public var dragfunc:(()->Void)!;
    public var isSelected:Bool = false;
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public init(_enabledImgskin:NSImage,_disabledImgskin:NSImage,_enabledThirdColorArr:NSArray,_disabledThirdColorArr:NSArray) {
        isEnabled = true;
        enabledImage = _enabledImgskin;
        disabledImage = _disabledImgskin;
        enabledThirdColorArr = _enabledThirdColorArr;
        disabledThirdColorArr = _disabledThirdColorArr;
        
        thirdColorArr = enabledThirdColorArr;
        imgskin = _enabledImgskin;
        type = 3;
        
        sourceRect = CGRectMake(
            0,
            0,
            CGFloat(imgskin.size.width/CGFloat(type!)),
            imgskin.size.height
        );
        
        
        wantDrawRect = CGRectMake(
            0,
            0,
            CGFloat(imgskin.size.width/CGFloat(type!)),
            imgskin.size.height
        );
        super.init(frame:sourceRect!);
        tb = NSTextField(frame: sourceRect!);
        tb.selectable = false;
        tb.editable = false;
        tb.alignment = NSTextAlignment.Center;
        tb.backgroundColor = NSColor.clearColor();
        tb.bordered = false;
        tb.textColor = enabledThirdColorArr[0] as? NSColor;
        tb.target = self;
        addSubview(tb);
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
    
    /**
    设置是否可用
    */
    public func setGEnable(b:Bool)
    {
        isEnabled = b;
        if(isEnabled == true)
        {
            thirdColorArr = enabledThirdColorArr;
            imgskin = enabledImage;
        }else
        {
            thirdColorArr = disabledThirdColorArr;
            imgskin = disabledImage;
        }
        mouseUp(NSEvent());
    }
    
    /**
    设置显示文字
    */
    public func setText(textValue:String,tfont:NSFont)
    {
        tb.stringValue = textValue;
        tb.alignment = NSTextAlignment.Center;
        tb.font = tfont;
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        if type >= 3
        {
            self.wantDrawRect?.origin.x = (wantDrawRect?.size.width)!*2;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        tb.textColor = thirdColorArr[1] as? NSColor;
        isDowned = true;
        if(downfunc != nil && isEnabled == true)
        {
            downfunc(sender: self);
        }
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        if(isSelected == false)
        {
            tb.textColor = thirdColorArr[0] as? NSColor;
            wantDrawRect?.origin.x = 0;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        if(upfunc != nil)
        {
            upfunc();
        }
        if isDowned == true && isEnabled == true{
            self.performClick(self);
        }
        isDowned = false;
    }
    
    public override func mouseEntered(theEvent: NSEvent) {
        if type >= 2 && self.wantDrawRect?.origin.x != (wantDrawRect?.size.width)! && isDowned == false && isSelected == false
        {
            tb.textColor = thirdColorArr[2] as? NSColor;
            self.wantDrawRect?.origin.x = (wantDrawRect?.size.width)!;
            self.setNeedsDisplayInRect(sourceRect!);
        }
    }
    
    public override func mouseExited(theEvent: NSEvent) {
        if(isSelected == false)
        {
            tb.textColor = thirdColorArr[0] as? NSColor;
            wantDrawRect?.origin.x = 0;
            self.setNeedsDisplayInRect(sourceRect!);
        }
        isDowned = false;
        
    }
}