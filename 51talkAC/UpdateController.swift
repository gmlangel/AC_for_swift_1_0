//  更新版本提示
//  UpdateController.swift
//  AC for swift
//
//  Created by guominglong on 15/12/30.
//  Copyright © 2015年 guominglong. All rights reserved.
//

import Foundation
public class UpdateController:BaseController{
    
    @IBOutlet weak var tb_info: NSTextField!
    @IBOutlet weak var btn_update: NSButton!
    private var currentURL:String!;
    public override func viewDidLoad() {
        btn_update.target = self;
        btn_update.action = Selector("onUpdate:");
        btn_update.title = LanguageManager.instance().getLanguageStr("btn_update");
        tb_info.stringValue = LanguageManager.instance().getLanguageStr("tb_updateInfo");
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpdateTishi:", name: "setTishiInfo", object: nil);
    }
    
    public override func viewDidDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    public override func viewDidAppear() {
        let resizeBtn:NSButton = (self.view.window?.standardWindowButton(NSWindowButton.ZoomButton))!;
        resizeBtn.hidden = true;
        
        self.view.window?.maxSize = (self.view.window?.frame.size)!;
        self.view.window?.minSize = (self.view.window?.frame.size)!;
    }
    
    func onUpdate(sender:AnyObject)
    {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string:currentURL as String)!);
    }
    
    func setUpdateTishi(notify:NSNotification)
    {
        var info:[NSString:NSString] = notify.object as! [NSString:NSString];
        currentURL = "";
        if(info["type"] == "url")
        {
            currentURL = info["url"]! as String;
        }
    }
}