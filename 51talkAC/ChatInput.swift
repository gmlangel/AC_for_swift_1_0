//
//  ChatInput.swift
//  AC for swift
//
//  Created by guominglong on 15/5/12.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

public class ChatInput: NSScrollView {
    
    private var tb:MyTextView?;
    public var text:String{
        get{
            return (tb?.string)!;
        }
        set{
            tb?.string = newValue;
        }
    }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        tb = MyTextView(frame: frameRect);
        tb?.allowsImageEditing = true;//允许接受位图
        tb?.allowsUndo = true;//允许会删
        tb?.importsGraphics = true;
        tb?.editable = true;
        tb?.selectable = true;
        self.documentView = tb;
        self.hasHorizontalScroller = false;
        self.hasVerticalScroller = true;
        
        
        
        self.layer = CALayer();
        //self.layer?.backgroundColor = NSColor.whiteColor().CGColor;
        self.layer?.borderColor = NSColor(red: 0xcd/255.0, green: 0xcd/255.0, blue: 0xcd/255.0, alpha: 1).CGColor;
        self.layer?.borderWidth = 1;
    }
  
    /**
    清除文本
    */
    public func clearText()
    {
        if(tb?.string == nil)
        {
            return;
        }
        tb?.replaceCharactersInRange(NSMakeRange(0, NSString(string: (tb?.string)!).length), withString: "");
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
}

public class MyTextView:NSTextView{

    
    public override func keyDown(theEvent: NSEvent) {
        if(theEvent.modifierFlags.rawValue == 262401 && theEvent.characters == "\r"){
        
            //换行
            super.keyDown(theEvent);
        }else if(theEvent.characters == "\r")
        {
            //发送文本
            NSNotificationCenter.defaultCenter().postNotificationName("sendMSG", object: nil);
        }else{
            super.keyDown(theEvent);
        }
        
    }
}


