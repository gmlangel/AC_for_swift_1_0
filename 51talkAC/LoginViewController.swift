
//  登陆面板
//  LoginViewController.swift
//  AC for swift
//
//  Created by guominglong on 15/4/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
class LoginViewController: BaseController{
    
    
    private var info1:String = LanguageManager.instance().getLanguageStr("tb_NameText");//"Input Your 51Talk ID";
    private var info2:String = LanguageManager.instance().getLanguageStr("tb_PWDText");
    private var needUpdate:Bool!;
    //版本号
    @IBOutlet weak var tb_title: NSTextField!
    //密码输入框
   // private var tb_UserPWD: LoginPWDView!
    private var tb_showUserPWD:PWDTextField!;
    //账号输入框
    //private var tbUserName: LoginTextView!
    public var tbUserName:LoginTextField!;
    //头像区域
    private var img_header:HeaderView!;
    //登陆按钮1
    private var btnLogin: FrameBtn!
    
    
    //注册账号
    private var btn_reg:ColorBtn!;
    //忘记密码
    private var btn_findpwd:ColorBtn!;
    //网络代理
    private var btn_netDelegate:ColorBtn!;
    //记住密码按钮
    private var btn_recodepwd:FrameBtn!;
    //自动登录按钮
    private var btn_autoLogin:FrameBtn!;
    
    //登陆loading
    private var loginLoading:FrameView!;
    
    //取消登陆
    private var btn_cancel:FrameBtn!;
    //是否可以开始主流程
    private var canStart:Bool!;
    
    var gif:GlobelInfo?;//全局信息
    private var uploadTool:UploadFileTool!;
    
    /**
     当前正在上传的崩溃日志的路径
     */
    private var currentCrashPath:String = "";
    // @IBOutlet weak var btnLogin: NSButton!
    override func viewDidLoad() {

        // Do view setup here.
        if(isInited == false)
        {
            ginit();
            //测试用
            //HeartbeatManager.instance.addTask(Selector("testuploadlog"), ti: 60, tg: self, taskName: "testuploadlog", repeats: true)
        }
        
        
    }
    
    override func viewDidDisappear() {
       // HeartbeatManager.instance.removeTask("testuploadlog");
    }

    internal override func ginit()
    {
        InstanceManager.instance().addModuleInstance(self,nameKey:"stroyLogin");
        super.ginit();
        uploadTool = UploadFileTool();
        
        //头像
        img_header = HeaderView(frame:NSMakeRect(125,242,124,124));
        self.view.addSubview(img_header);
        
        
        tbUserName = LoginTextField(frame: NSMakeRect(20,144,210,24));
        tbUserName.placeholderString = info1;
        tbUserName.cell?.scrollable = true;
        tbUserName.cell?.wraps = false;
        tbUserName.drawsBackground = false;
        tbUserName.font = StyleManager.instance.nsfont5;
        tbUserName.textColor = StyleManager.instance.color1;
        tbUserName.backgroundColor = NSColor.clearColor();
        tbUserName.bordered = false;
        tbUserName.alignment = NSTextAlignment.Left;
        
        self.view.addSubview(tbUserName);
        tb_showUserPWD = PWDTextField(frame: NSMakeRect(20,107,210,24));
        tb_showUserPWD.placeholderString = info2;
        tb_showUserPWD.cell?.scrollable = true;
        tb_showUserPWD.cell?.wraps = false;
        tb_showUserPWD.editable = true;
        tb_showUserPWD.selectable = true;
        tb_showUserPWD.backgroundColor = NSColor.clearColor();
        tb_showUserPWD.bordered = false;
        self.view.addSubview(tb_showUserPWD);
        
//        tbUserName = LoginTextView(frame: NSMakeRect(20,139,210,30));
//        tbUserName.font = StyleManager.instance.nsfont5;
//        tbUserName.textColor = StyleManager.instance.color1;
//        tbUserName.backgroundColor = NSColor.clearColor();
//        tb_UserPWD = LoginPWDView(frame: NSMakeRect(20,102,210,30));
//        tb_UserPWD.font = StyleManager.instance.nsfont5;
//        tb_UserPWD.backgroundColor = NSColor.clearColor();
//        tb_UserPWD.textColor = NSColor.clearColor();
//        self.view.addSubview(tbUserName);
//        self.view.addSubview(tb_UserPWD);
//        tbUserName.allowsUndo = true;
//        tb_UserPWD.allowsUndo = true;
        
        let img:Array = [ResourceManager.instance.getResourceByName("loginloading1"),ResourceManager.instance.getResourceByName("loginloading2"),ResourceManager.instance.getResourceByName("loginloading3")];
        loginLoading = FrameView(frame: NSMakeRect((250-80)/2, 105, 80, 40), _imgSource: img);
        loginLoading.offsettime = 1/6.0;
        self.view.addSubview(loginLoading);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("uploadCrashCallBack:"), name: "uploadCrashCallBack", object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changePWD:"), name: "changePWD", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("tologin:"), name: "tologin", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyTab:"), name: "keyTab", object: nil);
        //添加关闭按钮
        var gRect:NSRect = NSMakeRect(0, 0, 1, 1);
        gRect.origin.x = 228;
        gRect.origin.y = 324;
        //记住密码
        btn_recodepwd = FrameBtn(_imgskin:ResourceManager.instance.getResourceByName("login_rb1"), _type: 3);
        
        //self.view.addSubview(btn_recodepwd);
        
        gRect.origin.x = tb_showUserPWD.frame.origin.x;
        gRect.origin.y = 85;
        btn_recodepwd.setFrameOrigin(gRect.origin);
        btn_recodepwd.target = self;
        btn_recodepwd.action = Selector("onrecodePWD:");
        
        
        //自动登录
        btn_autoLogin = FrameBtn(_imgskin:ResourceManager.instance.getResourceByName("login_rb1"), _type: 3);
        gRect.origin.x = 165;
       // self.view.addSubview(btn_autoLogin);
        btn_autoLogin.setFrameOrigin(gRect.origin);
        btn_autoLogin.target = self;
        btn_autoLogin.action = Selector("onautoLogin:");
        btn_autoLogin.tag = 3;
        
        btn_recodepwd.mouseDown(NSEvent());
        btn_autoLogin.mouseDown(NSEvent());
        btn_recodepwd.isSelected = true;
        btn_autoLogin.isSelected = true;
        
        //登陆按钮
        btnLogin = getBtn("btn_login_bg",str: LanguageManager.instance().getLanguageStr("btn_loginText"),gfont: StyleManager.instance.nsfont5);
        btnLogin.target = self;
        btnLogin.action = NSSelectorFromString("onLogin:");
        btnLogin.keyEquivalent = "\r";
        btnLogin.tag = 2;
        btnLogin.becomeFirstResponder();
        
        self.view.addSubview(btnLogin);
        gRect.origin.x = CGFloat((self.view.frame.width - btnLogin.frame.width)/2.0);
        gRect.origin.y = 45;
        btnLogin.setFrameOrigin(gRect.origin);
        
        btn_cancel = getBtn("btn_login_bg",str: LanguageManager.instance().getLanguageStr("btn_cancel"),gfont: StyleManager.instance.nsfont5);
        btn_cancel.target = self;
        btn_cancel.action = NSSelectorFromString("onCancel:");
        self.view.addSubview(btn_cancel);
        btn_cancel.setFrameOrigin(gRect.origin);

        
        //注册账号onCancel
        gRect.size.width = 120;
        gRect.size.height = 22;
        gRect.origin.x = 3;
        gRect.origin.y = 20;
        btn_reg = getBtn2(gRect, upC: StyleManager.instance.color1, overC: NSColor.redColor(), downC: NSColor.blueColor(), str: LanguageManager.instance().getLanguageStr("btn_zhuceText"), gfont: StyleManager.instance.nsfont6);
        self.view.addSubview(btn_reg);
        btn_reg.target = self;
        btn_reg.action = Selector("regInfo:");
        //忘记密码
        gRect.origin.x = 128;
        btn_findpwd = getBtn2(gRect, upC: StyleManager.instance.color1, overC: NSColor.redColor(), downC: NSColor.blueColor(), str: LanguageManager.instance().getLanguageStr("btn_wangjiText"), gfont: StyleManager.instance.nsfont6);
        self.view.addSubview(btn_findpwd);
        btn_findpwd.target = self;
        btn_findpwd.action = Selector("findpwd:");
        //网络代理
        gRect.origin.x = 174;
        btn_netDelegate = getBtn2(gRect, upC: StyleManager.instance.color1, overC: NSColor.redColor(), downC: NSColor.blueColor(), str: "网络代理", gfont: StyleManager.instance.nsfont6);
        //self.view.addSubview(btn_netDelegate);
        
        
        //读取本地账号密码信息
        if(NSFileManager.defaultManager().fileExistsAtPath(GlobelInfo.getInstance().successFilePath))
        {
            var data:NSData = NSData(contentsOfFile: GlobelInfo.getInstance().successFilePath)!;
            //初始化加密工具
            AESTool.getInstance().ginit(NSString(string: "{971E1D3A-042B-41da-8E97-181F8073D8E2}").UTF8String, len: 32);
            data = AESTool.getInstance().AesDecrypt(UnsafeMutablePointer<UInt8>(data.bytes), bytesLen: UInt32(data.length));
            let str:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            let arr:[String] = str.componentsSeparatedByString("\n");
            tb_showUserPWD.stringValue = arr[1];
            tbUserName.stringValue = arr[0];
            if(arr.count>2 && arr[2] != "")
            {
                let imgA:NSImage? = NSImage(contentsOfURL: NSURL(string: arr[2])!);
                if(imgA != nil)
                {
                    img_header.setImg(imgA!);
                }
                
            }
        }
        
        
        
        
        //更改状态显示
        changeDisplayState(true);
    }
    
    /**
     上传crash
     */
    func uploadCrash()
    {
        if(GlobelInfo.getInstance().crashLogs != nil && GlobelInfo.getInstance().crashLogs.count > 0)
        {
            currentCrashPath = GlobelInfo.getInstance().crashLogs.objectAtIndex(0) as! String;
            GlobelInfo.getInstance().crashLogs.removeObjectAtIndex(0);
            var uid = AcuaSDK.ACService().UserId();
            var extensionName = "S";
            if(AcuaSDK.ACService().RoleType() == "tea")
            {
                uid = (uid & 0x00000000ffffffff);
                extensionName = "T";
            }
            uploadTool.uploadCrashByPath(currentCrashPath, uid: uid,extensionName: extensionName);
        }
    }
    
    /**
     获取崩溃日志上传结果
     */
    func uploadCrashCallBack(notify:NSNotification)
    {
        let str:String = notify.object as! String;
        if(str == "complete")
        {
            //检查是否还有未上传的crash日志
            uploadCrash();
            //上传成功后，删除日志
            do{
                try NSFileManager.defaultManager().removeItemAtPath(currentCrashPath)
            }catch
            {
                
            }
        }else{
            //上传失败
        }
    }
    
    
    
    func regInfo(sender:AnyObject)
    {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string:"http://www.51talk.com/user/user_register.php" as String)!);
    }
    
    func findpwd(sender:AnyObject)
    {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string:"http://www.51talk.com/user/get_pass.php" as String)!);
    }
    
    func removeEvents(){
        loginLoading.stop();
        ACNotifyCenter.Instace().removeObserver(self);
    }
    
    func onLoginFaild(notify:NSNotification)
    {
        changeDisplayState(true);
        if(needUpdate == true)
        {
            return;
        }
        let info:ACLoginFailedEventArgs = notify.object as! ACLoginFailedEventArgs;
        var result:NSString = "";
        let reasoncodeStr:String = String(info.getReasonCode());
        let httpCodeStr:String = String(info.getLoginCode());
        if(httpCodeStr == "0")
        {
            result = info.getReason();//NSString(format: LanguageManager.instance().getLanguageStr("loginCon_netErr") as NSString, reasoncodeStr);
        }else{
            result = info.getReason();
            //            if(faildInfo.valueForKey(httpCodeStr) != nil)
            //            {
            //                result = faildInfo.valueForKey(httpCodeStr) as NSString;
            //            }else{
            //                result = "未知错误，请联系客服(HttpCode:\(httpCodeStr))，联系电话：4000-51-51-51";
            //            }
        }
        
        self.performSegueWithIdentifier("tishi", sender: self)
        
        NSNotificationCenter.defaultCenter().postNotificationName("setTishiInfo", object: ["content":result,"type":"tips"], userInfo: nil);
    }
    
    /**
     在账号框，和密码框中切换
     */
    func keyTab(notify:NSNotification)
    {
//        if((notify.object as! NSTextView) == tbUserName)
//        {
//            tb_UserPWD.setSelectedRange()
//        }else{
//            tbUserName.selectAll(self);
//        }
        
        //需要些代码做切换处理
    }
    
    func getBtn(_imgskinName:String!,str:String,gfont:NSFont)->FrameBtn
    {
        let fbtn:FrameBtn = FrameBtn(_imgskin:ResourceManager.instance.getResourceByName(_imgskinName), _type: 3);
        let gRect:NSRect = NSMakeRect(0, 5, fbtn.frame.size.width, 20);
        let tb:NSTextField = NSTextField(frame: gRect);
        tb.textColor = NSColor.whiteColor();
        tb.backgroundColor = NSColor.clearColor();
        tb.selectable = false;
        tb.editable = false;
        tb.stringValue = str;
        tb.bordered = false;
        tb.font = gfont;
        fbtn.addSubview(tb);
        (tb.cell! as NSCell).alignment = NSTextAlignment.Center;
        return fbtn;
    }
    
    func getBtn2(_frame:NSRect,upC:NSColor,overC:NSColor,downC:NSColor,str:String,gfont:NSFont)->ColorBtn
    {
        let gRect:NSRect = NSMakeRect(0, 4, _frame.size.width, 18);
        let tb:NSTextField = NSTextField(frame: gRect);
        tb.textColor = upC;
        tb.backgroundColor = NSColor.clearColor();
        tb.selectable = false;
        tb.editable = false;
        tb.stringValue = str;
        tb.bordered = false;
        tb.font = gfont;
        (tb.cell! as NSCell).alignment = NSTextAlignment.Center;
        let fbtn:ColorBtn = ColorBtn(frameRect: _frame, _upColor: upC, _overColor: overC, _downColor: downC, _tb: tb);
        
        return fbtn;
    }
    
    //记住密码
    func onrecodePWD(sender:AnyObject!)->Void
    {
        GLogger.print("点击了记住密码");
    }
    
    //自动登录
    func onautoLogin(sender:AnyObject!)->Void{
        GLogger.print("点击了自动登录");
    }
    
    override func viewWillAppear() {
        self.view.setFrameSize(NSSize(width: 250,height: 326));
        self.view.setNeedsDisplayInRect(self.view.frame);
        self.view.window?.alphaValue = 0;
    }
    
    func changePWD(notify:NSNotification)
    {
        tb_showUserPWD.stringValue = notify.object as! String;
    }
    
    /**
    服务器返回的自动更新信息
    */
    func onNeedUpdateApplication(notify:NSNotification)
    {
        let obj:ACClientUpdateEventArgs = notify.object as! ACClientUpdateEventArgs;
        if(obj.getUpdateType() == 2)
        {
            needUpdate = false;
        }else
        {
            needUpdate = true;
            self.performSegueWithIdentifier("shengji", sender: self);
            NSNotificationCenter.defaultCenter().postNotificationName("setTishiInfo", object: ["content":"请下载最新版本AC客户端","type":"url","url":obj.getUpdateUri()], userInfo: nil);
            changeDisplayState(true);
            //needUpdate = false;
        }
        
    }
    
    func test()
    {
        //设置屏幕居中显示
        self.view.setFrameSize(NSSize(width: 250,height: 326));
        let tx:CGFloat = ((NSScreen.mainScreen()?.visibleFrame.width)!-(self.view.frame.width))/2.0;
        let ty:CGFloat = ((NSScreen.mainScreen()?.visibleFrame.height)!-(self.view.frame.height))/2.0 + (NSScreen.mainScreen()?.visibleFrame.origin.y)!;
        self.view.window?.setFrame(NSMakeRect(tx,ty,self.view.frame.size.width,self.view.frame.size.height), display: true);
        self.view.window?.alphaValue = 1;
        let win:MainWindow = self.view.window! as! MainWindow;
        win.makeFirstResponder(nil);//移除默认的焦点，避免文本框默认被选中
        screenNT.invalidate();
    }
    var screenNT:NSTimer!;
    //当视图被添加到window后
    override func viewDidAppear() {
        //设置最大化最小化尺寸
        self.view.window?.maxSize = self.view.frame.size;
        self.view.window?.minSize = self.view.frame.size;
        self.view.window?.contentMaxSize = self.view.frame.size;
        let win:MainWindow = self.view.window! as! MainWindow;
        let closeBtn:NSButton = win.standardWindowButton(NSWindowButton.CloseButton)!;
        win.titlebar.superview?.addSubview(closeBtn);
        win.titlebar.alphaValue = 0;
        //隐藏最小化和resizebtn
        let minBtn:NSButton = win.standardWindowButton(NSWindowButton.MiniaturizeButton)!;
        minBtn.hidden = true;
        
        let resizeBtn:NSButton = win.standardWindowButton(NSWindowButton.ZoomButton)!;
        resizeBtn.hidden = true;
        win.title = GlobelInfo.getInstance().appName;
        needUpdate = false;
        
        screenNT = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("test"), userInfo: nil, repeats: false);
     
    }
    
    func tologin(notify:NSNotification)
    {
        onLogin(btnLogin);
    }
    
    
    
    /**
    开始主流程
    */
    @available(OSX 10.10, *)
    func startMain()
    {
        
        if(needUpdate == true)
        {//需要更新
            return;
        }
        if(canStart == false)
        {//不允许进入主流程
            return;
        }
        
        //上传crash崩溃日志
        uploadCrash();
        
        
        func gComplete()->Void{
            //显示课程列表页
            var classListPage:ClassListPage;
            if(InstanceManager.instance().getModuleInstaceByName("stroyClassList") == nil)
            {
                classListPage = self.storyboard?.instantiateControllerWithIdentifier("stroyClassList") as! ClassListPage;

            }else
            {
                classListPage = InstanceManager.instance().getModuleInstaceByName("stroyClassList") as! ClassListPage;
            }
            self.view.window?.contentViewController = classListPage;
            showClassListPage(classListPage);
        }
        
        func gupdate(progress:NSAnimationProgress)->Void
        {
            
        }
        let gt:GTWeen = GTWeen(
            obj: self.view.window,
            duration: 0.5,
            _params: ["alpha":0,"y":(NSScreen.mainScreen()?.frame.height)!],
            animationCurve: NSAnimationCurve.EaseInOut,
            _onComplete: gComplete,
            _onUpdate: gupdate);
        gt.startAnimation();
    }
    
    /**
     取消登陆
     */
    func onCancel(sender:AnyObject)
    {
        AcuaSDK.ACService().Logout();
        canStart = false;
        changeDisplayState(true);
    }
    
    @available(OSX 10.10, *)
    func onLogin(sender: AnyObject) {
        
        if(btnLogin.enabled == false)
        {
            return;
        }
        if(tbUserName.stringValue == "" || tbUserName.stringValue == info1 || tb_showUserPWD.stringValue == "" || tb_showUserPWD.stringValue == info2)
        {
            self.performSegueWithIdentifier("tishi", sender: self);
            NSNotificationCenter.defaultCenter().postNotificationName("setTishiInfo", object: ["content":LanguageManager.instance().getLanguageStr("loginCon_feikong"),"type":"tips"], userInfo: nil);
        }else{
            canStart = true;
            //tb_UserPWD.resignFirstResponder();
            GlobelInfo.getInstance().loginName = tbUserName.stringValue;
            GlobelInfo.getInstance().loginPWD = tb_showUserPWD.stringValue;
            AcuaSDK.ConfigService().SetString(ACService.getCKEY_LOGIN_USERNAME(), value: tbUserName.stringValue);
            AcuaSDK.ConfigService().SetString(ACService.getCKEY_LOGIN_PASSWORD(), value: GTool.md5_str16(tb_showUserPWD.stringValue));
            AcuaSDK.ACService().Login();//开始登陆
            changeDisplayState(false);
        }
        
    }
    
    
    func testuploadlog(){
        if(tbUserName.stringValue == "luffytest@51talk.com")
        {
            UploadFileTool().uploadFileByPath(GlobelInfo.getInstance().logsDic,uid: 799548,extensionName: "S");
        }
    }
    
    /**
     更改显示状态
     */
    func changeDisplayState(b:Bool)
    {
        btnLogin.enabled = b;
        (self.view as! LoginView).showLine = b;
        if(b == false)
        {
            //显示登陆loading
            tbUserName.editable = false;
            tbUserName.selectable = false;
            tbUserName.alignment = NSTextAlignment.Center;
            let val = tbUserName.stringValue;
            tbUserName.stringValue = "";
            tbUserName.stringValue = val;
            tb_showUserPWD.hidden = true;
            //tb_UserPWD.hidden = true;
            btn_reg.hidden = true;
            btn_findpwd.hidden = true;
            
            btnLogin.hidden = true;
            btn_cancel.hidden = false;
            loginLoading.hidden = false;
            loginLoading.play();
        }else{
            //显示未登录状态
            tbUserName.editable = true;
            tbUserName.selectable = true;
            tbUserName.alignment = NSTextAlignment.Left;
            let val = tbUserName.stringValue;
            tbUserName.stringValue = "";
            tbUserName.stringValue = val;
            tb_showUserPWD.hidden = false;
            //tb_UserPWD.hidden = false;
            btn_reg.hidden = false;
            btn_findpwd.hidden = false;
            
            btnLogin.hidden = false;
            btn_cancel.hidden = true;
            loginLoading.hidden = true;
            loginLoading.stop();
        }
        self.view.setNeedsDisplayInRect(self.view.frame);
    }
    
//    func onloginCallback(ns:NSURLResponse!,data:NSData!,err:NSError!)->Void
//    {
//        if(err == nil)
//        {
//            var jsonErr:NSErrorPointer = NSErrorPointer();
//            //解析json
//            var resultData:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: jsonErr)! as NSDictionary;
//            var code:Int = 0;
//            if(resultData["code"] != nil)
//            {
//                if(resultData.valueForKey("code")!.isKindOfClass(NSString))
//                {
//                    code = (resultData.valueForKey("code")! as String).toInt()!;
//                }else{
//                    code = (resultData.valueForKey("code") as Int)
//                }
//                
//            }
//            if(code == 106)
//            {
//                
//                var userInfoDic:AnyObject = (resultData.valueForKey("res"))!;
//                userInfoDic = userInfoDic.valueForKey("user_info")!;
//                
//                //连接socket
//                MainSocket.getInstance().connect("svc.51talk.com", port: 6000);//"121.40.96.226"
//                
//                //启动agorasdk
//                AgroaSDK.instance().ginit();
//               
//                //登陆成功
//                gif?.webserviceUserid = userInfoDic["user_id"] as String;
//                gif?.userRole = userInfoDic["admin_type"] as String;
//                gif?.nickName = userInfoDic["nick_name"] as String;
//                gif?.sex = userInfoDic["sex"] as String;
//                
//                var info:Kehuduanjieru_e = Kehuduanjieru_e();
//                gif?.kehuinfo = info;
//                info.ClientType = 0x07;//mac os
//                info.ClientFlag = gif?.gVersion;
//                info.ClientVer = gif?.gVersion;
//                
//                
//                
//                func gComplete()->Void{
//                    //获得课程列表数据
//                    var urlrequest:NSURLRequest = NSURLRequest(URL: NSURL(string: NSString(format: GMLConfig.classListInterface,userInfoDic["user_id"] as String ))!);
//                    NSURLConnection.sendAsynchronousRequest(urlrequest, queue: NSOperationQueue.mainQueue(), completionHandler: onclasslistinfoCallback)
//                    
//                }
//                
//                func gupdate(progress:NSAnimationProgress)->Void
//                {
//                    
//                }
//                
//                
//                var gt:GTWeen = GTWeen(
//                    obj: self.view.window,
//                    duration: 0.5,
//                    _params: ["alpha":0,"y":(NSScreen.mainScreen()?.frame.height)!],
//                    animationCurve: NSAnimationCurve.EaseInOut,
//                    _onComplete: gComplete,
//                    _onUpdate: gupdate);
//                gt.startAnimation();
//            }else
//            {
//                //登陆失败
//                println("web服务器登陆失败,服务器返回码:\(code)");
//            }
//        }else
//        {
//            //调用失败
//            GLogger.print("登录失败");
//        }
//        btnLogin.enabled = true;
//    }

    
    
    
    //显示课程列表页
    private func showClassListPage(classListPage:NSViewController)
    {
        func gComplete()->Void{
            
        }
        
        func gupdate(progress:NSAnimationProgress)->Void
        {
            
        }
        let gt:GTWeen = GTWeen(
            obj: classListPage.view.window,
            duration: 0.5,
            _params: ["alpha":1,"y":
                ((NSScreen.mainScreen()?.visibleFrame.height)!-(classListPage.view.window?.frame.height)!)/2 + (NSScreen.mainScreen()?.visibleFrame.origin.y)!],
            animationCurve: NSAnimationCurve.EaseInOut,
            _onComplete: gComplete,
            _onUpdate: gupdate);
        gt.startAnimation();
        
    }
    
    
}


public class LoginTextView:NSTextView{
    
    /**
     最大输入数
     */
    public var maxChars:Int = 20;
    public var deleteKey:NSString = "";
    public override func keyDown(theEvent: NSEvent) {
        
        if(deleteKey == "")
        {
            var d:Int8 = 0x7f;
            deleteKey = NSString(bytes: &d, length: 1, encoding: NSUTF8StringEncoding)!;
            
        }
        if(deleteKey == theEvent.characters){
            super.keyDown(theEvent);
        }else if(theEvent.characters == "\t")
        {
           NSNotificationCenter.defaultCenter().postNotificationName("keyTab", object: self);
        }else if(theEvent.characters == "\r")
        {
            //发送登陆
            NSNotificationCenter.defaultCenter().postNotificationName("tologin", object: nil);
        }else{
            if((self.string! as NSString).length < maxChars)
            {
                super.keyDown(theEvent);
            }
        }
        
    }
    
    
    
    public override func didChangeText() {
        
    }
}


public class LoginPWDView:LoginTextView{
    public override func didChangeText() {
        NSNotificationCenter.defaultCenter().postNotificationName("changePWD", object: self.string);
    }
}

public class LoginTextField:NSTextField,NSTextFieldDelegate{
//    private var _defaulttext:String!="";
//    public var defaultText:String!{
//        get{
//            return _defaulttext;
//        }
//        set{
//            _defaulttext = newValue;
//            self.stringValue = newValue;
//        }
//    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.delegate = self;
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    
//    public override func textDidEndEditing(notification: NSNotification) {
//        if(self.stringValue == "")
//        {
//            self.stringValue = defaultText;
//        }
//        super.textDidEndEditing(notification);
//    }
//    
//    public override func mouseDown(theEvent: NSEvent) {
//        if(self.stringValue == defaultText)
//        {
//            self.stringValue = "";
//        }
//        super.mouseDown(theEvent);
//    }
//    
//    public override func textStorageWillProcessEditing(notification: NSNotification) {
//        self.stringValue = "";
//    }
    public override func pasteboard(sender: NSPasteboard, provideDataForType type: String) {
        NSLog("%@,%@", sender,type);
    }
    
    public override func performKeyEquivalent(evt: NSEvent) -> Bool {
        if((evt.modifierFlags.rawValue & NSEventModifierFlags.DeviceIndependentModifierFlagsMask.rawValue) == NSEventModifierFlags.CommandKeyMask.rawValue){
            if(evt.charactersIgnoringModifiers == "x")
            {
                //剪切
                NSApp.sendAction(Selector("cut:"), to: self.window?.firstResponder, from: self);
            }else if(evt.charactersIgnoringModifiers == "c")
            {
                //复制
                NSApp.sendAction(Selector("copy:"), to: self.window?.firstResponder, from: self);
            }else if(evt.charactersIgnoringModifiers == "v")
            {
                //粘贴
                NSApp.sendAction(Selector("paste:"), to: self.window?.firstResponder, from: self);
            }else if(evt.charactersIgnoringModifiers == "a")
            {
                //全选
                NSApp.sendAction(Selector("selectAll:"), to: self.window?.firstResponder, from: self);
            }
            
        }
        return super.performKeyEquivalent(evt);
    }
}



public class PWDTextField:NSSecureTextField,NSTextFieldDelegate{
//    private var _defaulttext:String!="";
//    public var defaultText:String!{
//        get{
//            return _defaulttext;
//        }
//        set{
//            _defaulttext = newValue;
//            self.stringValue = newValue;
//        }
//    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.delegate = self;
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    
//    public override func textDidEndEditing(notification: NSNotification) {
//        if(self.stringValue == "")
//        {
//            self.stringValue = defaultText;
//        }
//        super.textDidEndEditing(notification);
//    }
//    
//    public override func mouseDown(theEvent: NSEvent) {
//        if(self.stringValue == defaultText)
//        {
//            self.stringValue = "";
//        }
//        super.mouseDown(theEvent);
//    }
//    
//    public override func textStorageWillProcessEditing(notification: NSNotification) {
//        self.stringValue = "";
//    }
}
