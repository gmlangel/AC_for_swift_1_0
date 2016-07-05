//
//  SoundAndMicToolBar.swift
//  AC for swift
//
//  Created by guominglong on 15/12/17.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation

public class SoundAndMicToolBar:NSView{
    private var bgbar:NSImageView!;
    private var jindubar:NSImageView!;
    private var btn:NSImageView!;
    
    private var sourceJinduHeight:CGFloat!;
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        var img:NSImage = ResourceManager.instance.getResourceByName("soundtoolbar_bg");
        bgbar = NSImageView(frame: NSMakeRect(0, 0, img.size.width, img.size.height));
        addSubview(bgbar);
        bgbar.image = img;
        
        img = ResourceManager.instance.getResourceByName("soundtoolbar_jindu");
        sourceJinduHeight = 70;
        jindubar = NSImageView(frame: NSMakeRect(11, 31, img.size.width, img.size.height));
        jindubar.image = img;
        jindubar.imageScaling = NSImageScaling.ScaleAxesIndependently;
        addSubview(jindubar);
        jindubar.frame.size.height = 0;
        
        img = ResourceManager.instance.getResourceByName("soundtoolbar_btn");
        btn = NSImageView(frame: NSMakeRect(6, jindubar.frame.origin.y + jindubar.frame.size.height - 7, img.size.width, img.size.height));
        btn.image = img;
        addSubview(btn);
        self.frame.size = bgbar.frame.size;
        self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false);
    }
    public override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
    }
    
    private var offsetY:CGFloat! = 0;
    public override func mouseDown(theEvent: NSEvent) {
        setJindu(theEvent);
    }
    
    public override func mouseDragged(theEvent: NSEvent) {
        setJindu(theEvent);
        
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        setJindu(theEvent);
    }
    
    private func setJindu(theEvent:NSEvent)
    {
        offsetY = theEvent.locationInWindow.y - self.frame.origin.y;
        
        if(offsetY > jindubar.frame.origin.y + sourceJinduHeight)
        {
            offsetY = jindubar.frame.origin.y + sourceJinduHeight
        }
        if(offsetY < jindubar.frame.origin.y)
        {
            offsetY = jindubar.frame.origin.y;
        }
        
        jindubar.frame.size.height = offsetY - jindubar.frame.origin.y;
        btn.frame.origin.y = jindubar.frame.origin.y + jindubar.frame.size.height - 7;
        NSNotificationCenter.defaultCenter().postNotificationName("setVolum", object: CGFloat(jindubar.frame.size.height/sourceJinduHeight));
    }
    
    required public init!(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    public override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent);
        
    }
    
    
    public func setJinDuPosition(f:CGFloat)
    {
        jindubar.frame.size.height = sourceJinduHeight * f;
        btn.frame.origin.y = jindubar.frame.origin.y + jindubar.frame.size.height - 7;
    }
}