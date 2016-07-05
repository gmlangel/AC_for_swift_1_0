//  课程列表页面
//  NavigateMenuPage.swift
//  AC for swift
//
//  Created by guominglong on 15/4/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
public class ClassListPage: BaseController {

    
    private var btn_refresh:FrameBtn!;
    
    override public func viewDidLoad() {
        // Do view setup here.
        if(!isInited)
        {
            //添加课程列表监听回调
            ACNotifyCenter.Instace().addObserver(self, selector: Selector("onCourseCallback:"), name: CourseUpdatedEventArgs.TypeName(), object: nil);
            AcuaSDK.CourseService().Start();//启动课程管理
            (self.view as! ClassListView).showOrHideLoading(true);
        }
        ginit();
        
    }
    
    /**
    课程列表消息回调
    */
    func onCourseCallback(notify:NSNotification){

        //一下逻辑只适合老师和学生的1v1教室课表
        if(AcuaSDK.ACService().RoleType() == "stu")
        {
            (self.view as! ClassListView).fillInfo(AcuaSDK.CourseService().StuReservedCourses(), needRefrush: true);
        }else{
            (self.view as! ClassListView).fillInfo(AcuaSDK.CourseService().TeaPrivateCourses(), needRefrush: true);
        }
        (self.view as! ClassListView).showOrHideLoading(false);
        if(HeartbeatManager.instance.hasTask("updateCourseInfo") == false)
        {
            HeartbeatManager.instance.addTask(Selector("updateCourseInfo"), ti: 1, tg: self, taskName: "updateCourseInfo", repeats: true);
        }
    }
    
    /**
    根据课程的开始时间更新课程的显示状态
    */
    public func updateCourseInfo()
    {
        (self.view as! ClassListView).updateCourseList();//刷新课程列表状态
        
    }
    
    
    public override func ginit()
    {
        super.ginit();
        btn_refresh = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("refrushClassList"), _type: 3);
        btn_refresh.action = Selector("onbtn_refreshClick:");
        btn_refresh.target = self;
        InstanceManager.instance().addModuleInstance(self, nameKey: "stroyClassList");//
    }
    
    public func onbtn_refreshClick(sender:AnyObject)
    {
        self.autoRefresh();
    }
    
    public func goOneToOneClassRoom(sender:AnyObject)
    {
        HeartbeatManager.instance.removeTask("uploadLog");
        //换页
        func gComplete()->Void{
            //去上课页
            var classRoomPage:NSViewController;
            if(InstanceManager.instance().getModuleInstaceByName("stroyOneToOne") == nil)
            {
                classRoomPage = self.storyboard?.instantiateControllerWithIdentifier("stroyOneToOne") as! NSViewController;
                
            }else
            {
                classRoomPage = InstanceManager.instance().getModuleInstaceByName("stroyOneToOne") as! NSViewController;
            }
            self.view.window?.contentViewController = classRoomPage;
            showPage(classRoomPage);
            (classRoomPage as! OneToOneClassRoom).start();//开始上课
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
    
    public override func viewWillAppear() {
        var tsize:CGFloat = (NSScreen.mainScreen()?.visibleFrame.size.height)!
        if((NSScreen.mainScreen()?.visibleFrame.size.height)! > 720)
        {
            tsize = 720;
        }
        self.view.frame.size = NSSize(width: 800, height: tsize);
        self.view.needsDisplay = true;
        AcuaSDK.CourseService().Subscribe()//订阅一次课程列表信息的访问
        (self.view as! ClassListView).showOrHideLoading(true);
        if(HeartbeatManager.instance.hasTask("autoRefresh") == false)
        {
            //每10分钟刷新一次
            HeartbeatManager.instance.addTask(Selector("autoRefresh"), ti: 60*10, tg: self, taskName: "autoRefresh", repeats: true);
            
        }
    }
    public func autoRefresh(){
        (self.view as! ClassListView).showOrHideLoading(true);
        AcuaSDK.CourseService().Subscribe()//订阅一次课程列表信息的访问
    }
    
    public override func viewDidDisappear() {
        HeartbeatManager.instance.removeTask("autoRefresh");
        HeartbeatManager.instance.removeTask("updateCourseInfo");
        btn_refresh.removeFromSuperview();
        
    }
    

    //当视图被添加到window后
    override public func viewDidAppear() {
        //设置最大化最小化尺寸
        self.view.window?.maxSize = self.view.frame.size;
        self.view.window?.minSize = self.view.frame.size;
        //设置屏幕居中显示
       let tx:CGFloat = ((NSScreen.mainScreen()?.visibleFrame.width)!-(self.view.frame.width))/2.0;
        let ty:CGFloat = ((NSScreen.mainScreen()?.visibleFrame.height)!-(self.view.frame.height))/2.0 + (NSScreen.mainScreen()?.visibleFrame.origin.y)!;
        
        self.view.window?.setFrame(NSMakeRect(tx, ty, self.view.frame.size.width, self.view.frame.size.height), display: true);
        let win:MainWindow = self.view.window! as! MainWindow;
        win.titlebar.alphaValue = 1;
        win.titlebar.setFrameSize(NSSize(width: self.view.frame.size.width, height: 36));
        win.titlebar.setFrameOrigin(NSPoint(x: 0, y: self.view.frame.size.height - 36));
        win.contentView?.superview?.addSubview(win.titlebar);
        //隐藏resizebtn
        let closeBtn:NSButton = win.standardWindowButton(NSWindowButton.CloseButton)!;
        win.titlebar.addSubview(closeBtn);
        let closebtnY:CGFloat = (win.titlebar.frame.height - closeBtn.frame.height)/2;
        closeBtn.setFrameOrigin(NSPoint(x: closeBtn.frame.origin.x, y: closebtnY));
        let minBtn:NSButton = win.standardWindowButton(NSWindowButton.MiniaturizeButton)!;
        minBtn.hidden = false;
        minBtn.setFrameOrigin(NSPoint(x: minBtn.frame.origin.x, y: closebtnY));
        win.titlebar.addSubview(minBtn);
        let resizeBtn:NSButton = win.standardWindowButton(NSWindowButton.ZoomButton)!;
        resizeBtn.hidden = true;
        win.titlebar.layer?.backgroundColor = CGColorCreateGenericRGB(0xe7/255.0, 0xe7/255.0, 0xe7/255.0, 1);
        win.setGTitle(GlobelInfo.getInstance().appName);
        
        //添加刷新按钮
        win.titlebar.addSubview(btn_refresh);
        btn_refresh.setFrameOrigin(NSPoint(x: self.view.frame.width-25, y: 10));
    }
    
    
    
    override public func goprePage(){
        
        //换页
        func gComplete()->Void{
            //登陆页
            var loginControl:NSViewController;
            if(InstanceManager.instance().getModuleInstaceByName("stroyLogin") == nil)
            {
                loginControl = self.storyboard?.instantiateControllerWithIdentifier("stroyLogin") as! NSViewController;
                
            }else
            {
                loginControl = InstanceManager.instance().getModuleInstaceByName("stroyLogin") as! NSViewController;
            }
            self.view.window?.contentViewController = loginControl;
            showPage(loginControl);
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
    
    
}
