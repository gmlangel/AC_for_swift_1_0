//
//  ChangyongyuView.swift
//  51talkAC
//
//  Created by guominglong on 16/3/9.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
class ChangyongyuView:NSView{
    var dataSource:[[String:String]]!;
    var canvas:CGContextRef!;
    var drawFrame:NSRect!;
    var plength:Int = 0;
    var p1:NSPoint!,p2:NSPoint!,p3:NSPoint!;
    var container:NSView!;
    var notifationName:String!;
    init(frame frameRect:NSRect,jiantouPoint:NSPoint,_dataSource:[[String:String]],jiantouFangXiang:String = "bottom"){
        super.init(frame: frameRect);
        self.shadow = NSShadow();
        self.shadow?.shadowBlurRadius = 20;
        self.shadow?.shadowColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.6);
        
        
        
        plength = sizeof(NSPoint);

        

        
        
        dataSource = _dataSource;
        container = NSView(frame: NSRect(x: 5, y: 15, width: self.bounds.size.width - 10, height: self.bounds.size.height - 25));
        var th:CGFloat = 0;
        self.addSubview(container);
        for da in dataSource
        {
            let tv:NSView = getTextFieldView(da);
            tv.frame.origin.y = th;
            container.addSubview(tv);
            th += tv.frame.size.height;
        }
        
        self.frame.size.height = th + 20;
        p1 = jiantouPoint;
        drawFrame = CGRectZero;
        if(jiantouFangXiang == "bottom")
        {
            drawFrame.origin.y = 10;
            p2 = NSPoint(x:jiantouPoint.x - 8,y:10);
            p3 = NSPoint(x:jiantouPoint.x + 8,y:10);
        }else if(jiantouFangXiang == "top")
        {
            drawFrame.origin.y = 0;
            p1.y = self.frame.size.height;
            p2 = NSPoint(x:jiantouPoint.x - 8,y:self.frame.size.height-10);
            p3 = NSPoint(x:jiantouPoint.x + 8,y:self.frame.size.height-10);
            container.frame.origin.y = 5;
        }
        
        drawFrame.size.height = self.frame.size.height - 10;
        drawFrame.origin.x = 0;
        drawFrame.size.width = self.frame.size.width;
        self.setNeedsDisplayInRect(self.bounds);
    }
    private func getTextFieldView(data:[String:String]) ->NSView{
    
        let tb:NSTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        let ce:NSTextFieldCell = NSTextFieldCell(textCell: data.keys.first!);
        ce.selectable = false;
        ce.drawsBackground = true;
        ce.backgroundColor = NSColor.clearColor();
        let size:NSSize = ce.cellSizeForBounds(tb.bounds);
        tb.cell = ce;
        tb.frame.size.height = size.height;
        
        let view:ListView = ListView(frame: tb.frame,delegate: self);
        view.wantsLayer = true;

        view.addSubview(tb);
        return view;
    }
    
    func onSelectItem(item:ListView)
    {
        //当选中view
        let idx:Int = container.subviews.indexOf(item)!;
        if(idx > -1)
        {
            NSNotificationCenter.defaultCenter().postNotificationName(notifationName, object: dataSource[idx].values.first);
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
        canvas = NSGraphicsContext.currentContext()?.CGContext;
        CGContextSaveGState(canvas);
        let be:NSBezierPath = NSBezierPath(roundedRect: drawFrame, xRadius: 5, yRadius: 5);
        be.addClip();
        be.stroke();
        CGContextSetRGBFillColor(canvas, 1, 1,1,1);
        CGContextSetLineWidth(canvas, 1);
        CGContextSetRGBStrokeColor(canvas, 0.8, 0.8, 0.8, 1);
        CGContextFillRect(canvas, self.bounds);
        CGContextStrokeRect(canvas,self.bounds);
        CGContextRestoreGState(canvas);
        
        
        
        CGContextSaveGState(canvas);
        CGContextSetRGBFillColor(canvas, 1, 1, 1, 1);
        CGContextBeginPath(canvas);
        CGContextMoveToPoint(canvas, p1.x, p1.y);
        CGContextAddLineToPoint(canvas, p2.x, p2.y);
        CGContextAddLineToPoint(canvas, p3.x, p3.y);
        CGContextAddLineToPoint(canvas, p1.x, p1.y);
        CGContextFillPath(canvas);
        CGContextRestoreGState(canvas);
        
    }
}

class ListView:NSView{
    private var delegate:ChangyongyuView!;
    private var selectedColor:CGColor!;
    init(frame frameRect: NSRect, delegate:ChangyongyuView) {
        super.init(frame: frameRect);
        self.delegate = delegate;
        self.wantsLayer = true;
        selectedColor = NSColor(red: 1, green: 0.4, blue: 0, alpha: 0.5).CGColor;
        self.layer?.backgroundColor = NSColor.clearColor().CGColor;
    }
    
    override func drawRect(dirtyRect: NSRect) {
        self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false);
    }
    override func mouseEntered(theEvent: NSEvent) {
        self.layer?.backgroundColor = selectedColor;
    }
    
    override func mouseExited(theEvent: NSEvent) {
        self.layer?.backgroundColor = NSColor.clearColor().CGColor;
        
    }

    override func mouseDown(theEvent: NSEvent) {
        delegate.onSelectItem(self);
        self.layer?.backgroundColor = NSColor.clearColor().CGColor;
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
}
