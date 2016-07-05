//
//  WhiteBoardTextField.swift
//  51talkAC
//
//  Created by guominglong on 16/3/23.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
class WhiteBoardTextFieldView:NSControl
{
    //var offsetX:CGFloat = 0;//父级窗口相对于主窗口window的偏移
    //var offsetY:CGFloat = 0;//父级窗口相对于主窗口window的偏移
    var tb:WhiteBoardTextField!;
    
    //获取文本内容
    var value:String{
        get{
            return tb.stringValue;
        }
    }
    override func drawRect(dirtyRect: NSRect) {
        let canvas = NSGraphicsContext.currentContext()?.CGContext;
        let bp:NSBezierPath = NSBezierPath(roundedRect: self.bounds, xRadius: 5, yRadius: 5);
        bp.addClip();
        CGContextSetRGBFillColor(canvas, 1,0,0,0.5);
        CGContextFillRect(canvas, self.bounds);
    }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        
        tb = WhiteBoardTextField(frame: NSRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20));
        tb.bordered = false;
        tb.textColor = NSColor.redColor();
        tb.backgroundColor = NSColor.whiteColor();
        tb.alignment = NSTextAlignment.Left;
        
        self.frame.size.width = tb.frame.width + 20;
        self.frame.size.height = tb.frame.height + 20;
        self.frame.origin.y = self.frame.origin.y - self.frame.size.height - 10;
        self.frame.origin.x = self.frame.origin.x + 10;
        self.addSubview(tb);
    }
    
    func greset(){
        tb.greset();
        self.frame.size.width = tb.frame.width + 20;
        self.frame.size.height = tb.frame.height + 20;
        self.frame.origin.y = self.frame.origin.y - self.frame.size.height + 10;
        self.frame.origin.x = self.frame.origin.x - 10;
    }
    
    var tempH:CGFloat=0;
    override func resizeWithOldSuperviewSize(oldSize: NSSize) {
        
        tempH = oldSize.height + 20;
        if(tempH != self.frame.height)
        {
            self.frame.origin.y = self.frame.origin.y + (self.frame.height - tempH);
        }
        self.frame.size.width = oldSize.width + 20;
        self.frame.size.height = tempH;
        self.setNeedsDisplay();
    }

    required init?(coder: NSCoder) {
        super.init(coder:coder);
    }

    override func mouseDragged(e: NSEvent) {
        self.frame.origin.x += e.deltaX;
        self.frame.origin.y -= e.deltaY;
    }
    
    
    override func mouseDown(theEvent: NSEvent) {
        //有了这个函数，事件就不会向上派发造成误操作了
    }
    
    override func mouseUp(theEvent: NSEvent) {
        //有了这个函数，事件就不会向上派发造成误操作了
    }
}

class WhiteBoardTextField:NSTextField{
    var maxWidth:CGFloat = 150;
    var minWidth:CGFloat = 50;
    var sourceHeight:CGFloat = 30;
    var bs:CGSize = CGSizeZero;
    private var tc:NSTextFieldCell!;
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.font = NSFont(name: "Helvetica Neue", size: 26);
        greset();
    }
    
    
    //还原
    func greset()
    {
        self.frame.size.width = minWidth;
        self.bounds.size.width = minWidth;
        self.frame.size.height = sourceHeight;
        self.bounds.size.height = sourceHeight;
        self.cell?.wraps = false;
        self.cell?.scrollable = true;
        self.stringValue = "";
    }
    
    override func viewDidMoveToSuperview() {
        if(superview != nil)
        {
            superview?.resizeWithOldSuperviewSize(self.bounds.size);
        }
    }
    
    override func viewDidMoveToWindow() {
        if(self.window == nil)
        {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "resignTextField", object: nil);
        }else{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resignTextField:"), name: "resignTextField", object: nil);
        }
    }
    
    func resignTextField(notify:NSNotification)
    {
        self.resignFirstResponder();
        NSNotificationCenter.defaultCenter().postNotificationName("drawWhiteBoardText", object: nil);
    }

    required init?(coder: NSCoder) {
        super.init(coder:coder);
    }

    
    override func textDidChange(notification: NSNotification) {
        super.textDidChange(notification);
        self.cell?.stringValue = (self.cell?.stringValue)!;
        self.frame.size = (self.cell?.cellSize)!;
        self.bounds.size = (self.cell?.cellSize)!;
//        bs = (self.cell?.cellSizeForBounds(self.bounds))!;
//        if(bs.width > maxWidth + 10)
//        {
//            self.cell?.wraps = true;//超出最大宽度后，变成多方文本框
//            self.cell?.stringValue = (self.cell?.stringValue)! + "\n";
//            self.frame.size.width = maxWidth;
//            self.bounds.size.width = maxWidth;
//            self.frame.size.height  = (self.cell?.cellSize.height)!;
//            self.bounds.size.height = (self.cell?.cellSize.height)!;
//        }else{
//            self.cell?.wraps = false;
//            self.frame.size.width = (self.cell?.cellSize.width)!;
//            self.frame.size.width = self.frame.size.width < minWidth ? minWidth : self.frame.size.width;
//            self.bounds.size.width = (self.cell?.cellSize.width)!;
//            self.bounds.size.width = self.bounds.size.width < minWidth ? minWidth : self.bounds.size.width;
//            self.frame.size.height = (self.cell?.cellSize.height)!;
//            self.bounds.size.height = (self.cell?.cellSize.height)!;
//        }
        superview?.resizeWithOldSuperviewSize(self.bounds.size);
    }
    

    
}