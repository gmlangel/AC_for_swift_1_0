//
//  TishiViewController.swift
//  AC for swift
//
//  Created by guominglong on 15/12/3.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class TishiViewController:BaseController{
    @IBOutlet weak var tb_info: NSTextField!
    required public init!(coder: NSCoder) {
        super.init(coder: coder);
        
    }
    override public func viewDidLoad() {
        if(isInited == false)
        {
            ginit();
        }
        
    }
    public override func viewDidDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override public func ginit() {
        super.ginit();
//        var btn_close:NSButton = NSButton(frame: NSMakeRect(0, 0, 100, 30));
//        btn_close.title = "关闭";
//        btn_close.target = self;
//        btn_close.action = Selector("onclose:");
//        self.view.addSubview(btn_close);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setTishi:", name: "setTishiInfo", object: nil);
        tb_info.stringValue = "";
        
//        urlBtn = NSButton(frame: tb_info.frame);
//        urlBtn.alignment = NSTextAlignment.Center;
//        urlBtn.target = self;
//        urlBtn.action = Selector("toURL:");
//        urlBtn.bordered = false;
//        self.view.addSubview(urlBtn);
        
//        let d:NSMutableParagraphStyle=NSMutableParagraphStyle();
//        d.alignment = NSTextAlignment.Center;
//        
//        attrs = [
//        NSFontAttributeName : NSFont.systemFontOfSize(14),
//        NSForegroundColorAttributeName : NSColor.blueColor(),
//        NSUnderlineStyleAttributeName : 1,
//            NSParagraphStyleAttributeName:d
//        ]
    }
    
//    public func toURL(sender:AnyObject)
//    {
//        NSWorkspace.sharedWorkspace().openURL(NSURL(string:currentURL as String)!);
//    }
    
    public override func viewDidAppear() {
        
        let resizeBtn:NSButton = (self.view.window?.standardWindowButton(NSWindowButton.ZoomButton))!;
        resizeBtn.hidden = true;
        
        self.view.window?.maxSize = (self.view.window?.frame.size)!;
        self.view.window?.minSize = (self.view.window?.frame.size)!;
    }
    
    
    public func setTishi(notify:NSNotification)
    {
        var info:[NSString:NSString] = notify.object as! [NSString:NSString];
        if(info["type"] == "tips")
        {
            tb_info.hidden = false;
            tb_info.stringValue = info["content"]! as String;
        }
//        else{
//            tb_info.hidden = true;
//            urlBtn.hidden = false;
//            
//            let attributedString:NSAttributedString = NSAttributedString(string: info[" as Stringcontent"]! as String, attributes: attrs);
//            urlBtn.attributedTitle = attributedString;
//            currentURL = info["url"]!;
//        }
    }
    
    
    public func onclose(sender:AnyObject)
    {
       // self.dismissController(self);
    }
}