//  视频窗口上面的那个在线状态工具条
//  UserInfoBar.swift
//  AC for swift
//
//  Created by guominglong on 15/12/15.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
@available(OSX 10.10, *)
public class UserInfoBar:NSView{
    var canvas:CGContextRef!;
    
    //private var otherUserIco:NSImageView!;
    private var tb_userName:NSTextField!;
    private var tb_jishi:NSTextField!;
    private var isBegin:Bool!=false;
    public var count:NSTimeInterval!;
    private var f1:NSDateFormatter!;
    private var f2:NSDateFormatter!;
   // private var frameAni:FrameView!;
    //private var onlineState:NSImageView!;
    //private var offlineState:NSImageView!;
    
    private var defaultStr:String! = LanguageManager.instance().getLanguageStr("userInfoBarLabel1");
    public override func drawRect(dirtyRect: NSRect) {
        canvas = NSGraphicsContext.currentContext()?.CGContext;
        CGContextSaveGState(canvas);
//        let be:NSBezierPath = NSBezierPath(roundedRect: NSMakeRect(0, -5, self.frame.width, self.frame.height+5), xRadius: 5, yRadius: 5);
//        be.addClip();
        CGContextSetRGBFillColor(canvas, 0,0,0,0.5);
        CGContextFillRect(canvas, self.bounds);
        CGContextSaveGState(canvas);
        super.drawRect(dirtyRect);
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        
//        var img:NSImage = ResourceManager.instance.getResourceByName("classroom_teacherico");
//        otherUserIco = NSImageView(frame: NSMakeRect(5, 4, img.size.width, img.size.height));
//        addSubview(otherUserIco);
//        otherUserIco.image = img;
        tb_userName = NSTextField(frame: NSMakeRect(5, 2, 250, 22));
        tb_userName.selectable = false;
        tb_userName.editable = false;
        tb_userName.textColor = NSColor.whiteColor();
        tb_userName.font = StyleManager.instance.nsfont7;
        tb_userName.bordered = false;
        tb_userName.stringValue = defaultStr;
        tb_userName.backgroundColor = NSColor.clearColor();
        addSubview(tb_userName);
        
        tb_jishi = NSTextField(frame: NSMakeRect(frameRect.width - 120, 2, 120, 22));
        tb_jishi.selectable = false;
        tb_jishi.editable = false;
        tb_jishi.textColor = NSColor.whiteColor();
        tb_jishi.font = StyleManager.instance.nsfont7;
        tb_jishi.bordered = false;
        tb_jishi.stringValue = "00:00";
        tb_jishi.backgroundColor = NSColor.clearColor();
        tb_jishi.alignment = NSTextAlignment.Right;
        addSubview(tb_jishi);
        
        f1 = NSDateFormatter();
        f1.dateFormat = "HH:mm:ss";
        f2 = NSDateFormatter();
        f2.dateFormat = "mm:ss";
        //img = ResourceManager.instance.getResourceByName("mc_pinpu0004");
        
//        frameAni = FrameView(frame: NSMakeRect(frameRect.size.width-img.size.width-5, 4, img.size.width, img.size.height), _imgSource: [img,ResourceManager.instance.getResourceByName("mc_pinpu0006"),ResourceManager.instance.getResourceByName("mc_pinpu0014"),ResourceManager.instance.getResourceByName("mc_pinpu0015"),ResourceManager.instance.getResourceByName("mc_pinpu0016")]);
//        addSubview(frameAni);
        
//        img = ResourceManager.instance.getResourceByName("onlineStateBig_0");
//        onlineState = NSImageView(frame: NSMakeRect(otherUserIco.frame.origin.x+5, 0, img.size.width, img.size.height));
//        onlineState.image = img;
//        
//        img = ResourceManager.instance.getResourceByName("onlineStateBig_1");
//        offlineState = NSImageView(frame: NSMakeRect(otherUserIco.frame.origin.x+5, 0, img.size.width, img.size.height));
//        offlineState.image = img;
//        addSubview(onlineState);
//        addSubview(offlineState);
//        onlineState.hidden = true;
        
    }
    
    public override func viewDidMoveToWindow() {
        if(window == nil)
        {
            //移除计时器
            HeartbeatManager.instance.removeTask("UserinfoBarjishi");
        }
    }
    
    
    
    private func getHour(i:Int)->String
    {
        if(i>9)
        {
            return "\(i)";
        }else
        {
            return "0\(i)";
        }
    }
    
    public func jishi()
    {
        if(isBegin == true)
        {
            count = count + 1;
            if(count>=3600)
            {
                //显示00:00:00
                tb_jishi.stringValue = getHour(Int(count/3600)) + ":" + f2.stringFromDate(NSDate(timeIntervalSince1970: count));
            }else{
                //显示00:00
                tb_jishi.stringValue = f2.stringFromDate(NSDate(timeIntervalSince1970: count));
            }
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public func start(otherName:String)
    {
        tb_userName.stringValue = otherName;
        isBegin = true;
        tb_jishi.stringValue = "00:00";
        HeartbeatManager.instance.removeTask("UserinfoBarjishi");
        //添加计时器
        HeartbeatManager.instance.addTask(Selector("jishi"), ti: 1, tg: self, taskName: "UserinfoBarjishi")
        
//        onlineState.hidden = false;
//        offlineState.hidden = true;
    }
    
    public func stop()
    {
        tb_userName.stringValue = defaultStr;
        isBegin = false;
        tb_jishi.stringValue = "00:00";
//        frameAni.stop();
//        onlineState.hidden = true;
//        offlineState.hidden = false;
    }
}