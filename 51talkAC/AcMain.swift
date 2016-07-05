//
//  AcMain.swift
//  AC for swift
//
//  Created by guominglong on 15/4/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
public class AcMain: NSWindowController,NSWindowDelegate,NSApplicationDelegate {

    internal var mainView:NSView?;//主窗口
    
   // var st:SocketTool?;//socket链接工具
    var isYuanduan:Bool! = false;
    override public func windowDidLoad() {
        super.windowDidLoad();
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        //设置背景
        //self.window?.backgroundColor = NSColor(SRGBRed: 1, green: 1, blue: 1, alpha: 1);
        
        //启动多语言支持
        LanguageManager.instance();
        //设置回调函数代理
        self.window?.delegate = self;
        
        //读取上一次未上传的crash日志，并进行上传
        checkCrash();
        
        //初始化ACSDK
        AcuaSDK.InitUA();
        NSApplication.sharedApplication().delegate = self;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("toClose:"), name: "toCloseApp", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("uploadCallBack:"), name: "uploadCallBack", object: nil);
        
        ACNotifyCenter.Instace().addObserver(self, selector: Selector("onYuanDuanClose:"), name: ACForceLogoutEventArgs.TypeName(), object: nil);
        ACNotifyCenter.Instace().addObserver(self, selector: Selector("onLoginState:"), name: ACLoginStateEventArgs.TypeName(), object: nil);
        ACNotifyCenter.Instace().addObserver(self, selector: Selector("onLoginFaild:"), name: ACLoginFailedEventArgs.TypeName(), object: nil);
        ACNotifyCenter.Instace().addObserver(self, selector: Selector("onNeedUpdateApplication:"), name: ACClientUpdateEventArgs.TypeName(), object: nil);
        
    }
    
    private func checkCrash()
    {
        
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        var crashDictionaryPath:NSString? = paths[0] as? NSString;
        if(crashDictionaryPath != nil)
        {
            crashDictionaryPath = crashDictionaryPath?.stringByAppendingString("/Logs/DiagnosticReports/");
            let fi:NSFileManager = NSFileManager.defaultManager();
            var isDic:ObjCBool = ObjCBool(true);
            if(fi.fileExistsAtPath(crashDictionaryPath as! String, isDirectory: &isDic))
            {
                do{
                    let filePaths:[String] = try fi.contentsOfDirectoryAtPath(crashDictionaryPath as! String);
                    let j:Int = filePaths.count;
                    var resultPaths:[String] = [];
                    for(var i:Int = 0;i<j;i++)
                    {
                        
                        if(NSString(string: filePaths[i]).rangeOfString("51talkAC").location == 0)
                        {
                            resultPaths.append((crashDictionaryPath?.stringByAppendingString(filePaths[i]))!);
                        }
                    }
                    if(resultPaths.count > 0)
                    {
                        //保存崩溃日志路径，等待上传
                        GlobelInfo.getInstance().crashLogs = NSMutableArray(array: resultPaths);
                    }
                }catch{
                    NSLog("日志路径出错");
                }
                
            }
        }
    }
    

    
    
    /**
     被踢下线
     */
    public func onYuanDuanClose(notify:NSNotification)
    {
        isYuanduan = true;
        let controller:NSViewController = (self.window?.contentViewController)!;
        if(controller.isKindOfClass(ClassListPage))
        {
            controller.performSegueWithIdentifier("listofflineTishi", sender: controller);
        }else if(controller.isKindOfClass(OneToOneClassRoom)){
            controller.performSegueWithIdentifier("roomofflineTishi", sender: controller);
        }
        NSNotificationCenter.defaultCenter().postNotificationName("setLostTishiInfo", object: ["type":1]);
        
    }
    
    func onLoginState(notify:NSNotification)
    {
        
        let args:ACLoginStateEventArgs = notify.object as! ACLoginStateEventArgs;
        let gstate:ACServiceState = args.getNewState() ;
        let oldState:ACServiceState = args.getOldState();
        let vc:NSViewController = (self.window?.contentViewController)!;
        
        switch (gstate.rawValue) {
        case STATE_LOGIN_LOGOUTING.rawValue:
            GLogger.print("正在登录...");
            break;
        case STATE_LOGIN_LOGINED.rawValue:
            GLogger.print("登录成功");
            AcuaSDK.setIsLogined(true);
            //changeDisplayState(true);
            if(vc.isKindOfClass(LoginViewController)){
                //如果当前在登陆页面，则执行登录主流程
               (vc as! LoginViewController).startMain();
            }else if(vc.isKindOfClass(OneToOneClassRoom))
            {
                //如果当前在上课页面，则重新启动sdk
                (vc as! OneToOneClassRoom).mainView.cameraContainer?.startMedia(GlobelInfo.getInstance().currentCourse);
                    //调用sdk,开始进入教室流程
                    (vc as! OneToOneClassRoom).mainView.fillMediaInfo();//填充媒体相关的数据
            }
            break;
        case STATE_LOING_LOGOUTED.rawValue:
            if(isYuanduan == true)
            {
                return;
            }
            if(oldState.rawValue == STATE_LOGIN_LOGINED.rawValue)
            {
                AcuaSDK.setIsLogined(false);
                //掉线了，需要重连
                if(vc.isKindOfClass(ClassListPage))
                {
                    vc.performSegueWithIdentifier("listofflineTishi", sender: vc);
                }else if(vc.isKindOfClass(OneToOneClassRoom)){
                    vc.performSegueWithIdentifier("roomofflineTishi", sender: vc);
                }
            NSNotificationCenter.defaultCenter().postNotificationName("setLostTishiInfo", object: ["type":0]);
                
                toReLogin();//断线连的流程
            }
            break;
        default:
            //self.performSegueWithIdentifier("登录失败", sender: self);
            break;
        }
    }
    
    func onLoginFaild(notify:NSNotification)
    {
        let vc:NSViewController = (self.window?.contentViewController)!;
        if(vc.isKindOfClass(LoginViewController)){
            (vc as! LoginViewController).onLoginFaild(notify);
        }
        
    }
    
    /**
     服务器返回的自动更新信息
     */
    func onNeedUpdateApplication(notify:NSNotification)
    {
        let vc:NSViewController = (self.window?.contentViewController)!;
        if(vc.isKindOfClass(LoginViewController)){
            (vc as! LoginViewController).onNeedUpdateApplication(notify);
        }
    }
    
    
    public func toClose(notify:NSNotification)
    {
        closeApp();
    }
    
    //断线重连
    public func toReLogin()
    {
        
        //停止所有的SDK工作
        let vc:NSViewController = (self.window?.contentViewController)!;
        if(vc.isKindOfClass(OneToOneClassRoom)){
            mainView = (vc as! OneToOneClassRoom).mainView;
            if(mainView != nil)
            {
                (vc as! OneToOneClassRoom).mainView.cameraContainer?.removeAllEvents();
                (vc as! OneToOneClassRoom).mainView.cameraContainer?.stopMedia();
            }
        }
        //重新登录
        HeartbeatManager.instance.addTask(Selector("autoRelogin"), ti: 20, tg: self, taskName: "autoRelogin");
    }
    
    //自动重连
    public func autoRelogin()
    {
        if(AcuaSDK.isLogined() == false)
        {
            AcuaSDK.ACService().Login();
        }else{
            HeartbeatManager.instance.removeTask("autoRelogin");
        }
        
    }
    
    public func windowDidResize(notification: NSNotification) {
        
        if(InstanceManager.instance().getModuleInstaceByName("mainView") != nil)
        {
            mainView = InstanceManager.instance().getModuleInstaceByName("mainView") as? NSView;
            mainView?.resizeWithOldSuperviewSize(window!.contentView!.bounds.size);
        }
        let win:MainWindow = window as! MainWindow;
        let closeBtn:NSButton = win.standardWindowButton(NSWindowButton.CloseButton)!;
        let minBtn:NSButton = win.standardWindowButton(NSWindowButton.MiniaturizeButton)!;
        let resizeBtn:NSButton = win.standardWindowButton(NSWindowButton.ZoomButton)!;
        
        var p:NSPoint = NSPoint(x: closeBtn.frame.origin.x, y: (win.titlebar.frame.height - closeBtn.frame.height)/2);
        closeBtn.setFrameOrigin(p);
        p.x = minBtn.frame.origin.x;
        minBtn.setFrameOrigin(p);
        
        p.x = resizeBtn.frame.origin.x;
        resizeBtn.setFrameOrigin(p);
    }
    
    
    public func windowShouldClose(sender: AnyObject) -> Bool {
        
        let vc:NSViewController = (self.window?.contentViewController)!;
        if(vc.isKindOfClass(LoginViewController)){
            ACNotifyCenter.Instace().removeObserver(self);
            ((self.window?.contentViewController)! as! LoginViewController).removeEvents();
            //上传日志
//            if((vc as! LoginViewController).tbUserName.stringValue == "luffytest@51talk.com")
//            {
//                UploadFileTool().uploadFileByPath(GlobelInfo.getInstance().logsDic,uid: 799548,extensionName: "S");
//            }
            //关闭程序
            closeApp();
            return true;
        }else if(vc.isKindOfClass(BaseController))
        {
            //当前在课程列表页,或者教室页，则返回上一页
            huanye();
            return false;
        }else
        {
            NSApp.stopModalWithCode(0);
            return false;
        }
    }
    
    /**
     上传APP运行日志
     */
    public func uploadLog()
    {
        var uid = AcuaSDK.ACService().UserId();
        var extensionName = "S";
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            uid = (uid & 0x00000000ffffffff);
            extensionName = "T";
        }
        UploadFileTool().uploadFileByPath(GlobelInfo.getInstance().logsDic,uid: uid,extensionName: extensionName);
    }
    
    public func uploadCallBack(notify:NSNotification)
    {
        let obj:[String:String] = notify.object as! [String:String];
        if(obj["state"] == "complete")
        {
            //上传成功后，清空日志
            do{
                try "".writeToFile(obj["path"]!, atomically: false, encoding: NSUTF8StringEncoding);
            }catch
            {
                
            }
        }else{
            //上传失败
        }
    }
    
    public func closeApp(){
        NSApp.stopModalWithCode(1);
        NSApplication.sharedApplication().terminate(nil);//关闭程序
    }
    
    public func huanye(needHide:Bool = true){
        let vc:NSViewController = (self.window?.contentViewController)!;
        if(vc.isKindOfClass(ClassListPage))
        {
            //如果当前在课程列表页
            if(needHide == true)
            {
                NSApplication.sharedApplication().hide(self.window);//隐藏
            }
        }else{
            //如果当前在教室页,返回上一页
            (vc as! BaseController).goprePage();
            NSApp.stopModalWithCode(0);
        }
    }
    
    //点击托盘时显示当前的窗口
    public func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag){
            //主窗口显示
            NSApplication.sharedApplication().activateIgnoringOtherApps(false);
            self.window?.makeKeyAndOrderFront(self);
        } 
        return true;
    }
    
    public func windowDidEnterFullScreen(notification: NSNotification) {
        let win:MainWindow = window as! MainWindow;
        let closeBtn:NSButton = win.standardWindowButton(NSWindowButton.CloseButton)!;
        let minBtn:NSButton = win.standardWindowButton(NSWindowButton.MiniaturizeButton)!;
        let resizeBtn:NSButton = win.standardWindowButton(NSWindowButton.ZoomButton)!;
        win.titlebar.addSubview(closeBtn);
        win.titlebar.addSubview(minBtn);
        win.titlebar.addSubview(resizeBtn);
    }
    
    public func applicationWillTerminate(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "toCloseApp", object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "uploadCallBack", object: nil);
        ACNotifyCenter.Instace().removeObserver(self);
        if(AcuaSDK.isLogined() == true)
        {
            uploadLog();//上传日志
            AcuaSDK.ACService().Logout();//退出登陆
        }
        
        if (AcuaSDK.UserAgent() != nil) {
            ClassSession.ReleaseAll();
            UserAgent.ReleaseUserAgent(AcuaSDK.UserAgent());
            
        }
        
        //停止任务管理器
        HeartbeatManager.instance.removeAllTask();
    }
   
    
}
