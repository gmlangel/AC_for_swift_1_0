//
//  OffLineViewController.swift
//  AC for swift
//
//  Created by guominglong on 16/1/12.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
public class OffLineViewController:NSViewController{
    
    @IBOutlet public weak var btn_commit: NSButton!

    @IBOutlet public weak var tb_tishi: NSTextField!

    private var tishitype:Int!;//0为断线重连提示   1为被强制线下提示
    private var tishiArr:NSArray = [LanguageManager.instance().getLanguageStr("label_offline"),LanguageManager.instance().getLanguageStr("label_huti")];
    public override func viewDidLoad() {
        btn_commit.target = self;
        btn_commit.action = Selector("onCommit:");
        btn_commit.title = LanguageManager.instance().getLanguageStr("btn_commit");
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLostTishi:", name: "setLostTishiInfo", object: nil);
    }
    
    public override func viewDidDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    public override func viewDidAppear() {
        let resizeBtn:NSButton = (self.view.window?.standardWindowButton(NSWindowButton.ZoomButton))!;
        resizeBtn.hidden = true;
        
        let closeBtn:NSButton = (self.view.window?.standardWindowButton(NSWindowButton.CloseButton))!;
        closeBtn.hidden = true;
        
        let minBtn:NSButton = (self.view.window?.standardWindowButton(NSWindowButton.MiniaturizeButton))!;
        minBtn.hidden = true;
        
        self.view.window?.maxSize = (self.view.window?.frame.size)!;
        self.view.window?.minSize = (self.view.window?.frame.size)!;
    }
    
    public func setLostTishi(notify:NSNotification)
    {
        let args:[String:Int] = notify.object as! [String:Int];
        tishitype = args["type"]!;
        tb_tishi.stringValue = tishiArr[tishitype] as! String;
    }
    
    public func onCommit(sender:AnyObject)
    {
        if #available(OSX 10.10, *) {
            self.dismissController(self)
        } else {
            // Fallback on earlier versions
        };
        if(tishitype == 0)
        {
            reLogin();
        }else{
            closeApp();
        }
    }
    
    /**
     重新登录
     */
    private func reLogin()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("toReLogin", object: nil);
    }
    
    /**
     关闭App
     */
    public func closeApp()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("toCloseApp", object: nil);
    }
}