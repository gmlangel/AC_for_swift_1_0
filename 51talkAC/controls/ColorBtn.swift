//
//  ColorBtn.swift
//  AC for swift
//
//  Created by guominglong on 15/11/25.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class ColorBtn:NSButton{

    var type:Int?;
    var displayType:Int?;
    var isDowned:Bool = false;
    var hitTextArea:NSTrackingRectTag?;
    public var downfunc:(()->Void)?;
    public var upfunc:(()->Void)?;
    public var dragfunc:(()->Void)?;
    public var isSelected:Bool = false;
    
    var upColor:NSColor!;
    var overColor:NSColor!;
    var downColor:NSColor!;
    var tb:NSTextField!;
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
    }
    
    public init(frameRect: NSRect,_upColor:NSColor,_overColor:NSColor,_downColor:NSColor,_tb:NSTextField)
    {
        self.upColor = _upColor;
        self.overColor = _overColor;
        self.downColor = _downColor;
        self.tb = _tb;
        super.init(frame: frameRect);
        addSubview(tb);
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        
        // super.drawRect(dirtyRect);
        if nil != hitTextArea
        {
            self.removeTrackingRect(hitTextArea!);
            hitTextArea = nil;
        }
        hitTextArea =  self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false);
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        if downColor != nil
        {
            tb.textColor = downColor;
        }
        isDowned = true;
        if(downfunc != nil)
        {
            downfunc!();
        }
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        
        if isDowned{
            if(isSelected == false)
            {
                tb.textColor = upColor;
            }
            if(upfunc != nil)
            {
                upfunc!();
            }
            self.performClick(self);
        }
        isDowned = false;
        
    }
    
    public override func mouseEntered(theEvent: NSEvent) {
        if overColor != nil && isDowned == false && isSelected == false
        {
            tb.textColor = overColor;
        }
    }
    
    public override func mouseExited(theEvent: NSEvent) {
        if(isSelected == false)
        {
            tb.textColor = upColor;
        }
        isDowned = false;
        
    }
}