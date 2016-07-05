//  1对1教室
//  OneToOneClassRoom.swift
//  AC for swift
//
//  Created by guominglong on 15/4/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa
@available(OSX 10.10, *)
public class OneToOneClassRoom: BaseController {

    var mainView:OneToOneRoomView!;
    var classID:UInt64 = 0;
    override public func viewDidLoad() {
        // Do view setup here.
        if(isInited == false){
            ginit();
        }
        
        
    }
    
    
    public override func ginit()
    {
        super.ginit();
        //加载视图
        mainView = OneToOneRoomView(frame: self.view.frame);
        self.view.addSubview(mainView);
        mainView.ginit();
        //绑定教室单例
        InstanceManager.instance().addModuleInstance(mainView, nameKey: "mainView");
        InstanceManager.instance().addModuleInstance(self,nameKey:"stroyOneToOne");
    }
    
    override public func viewWillAppear() {
        self.view.frame.size = (NSScreen.mainScreen()?.visibleFrame)!.size;
        self.view.needsDisplay = true;
        minSize = NSMakeSize(800, self.view.frame.size.height);
        
    }
    
    public func start()
    {
        classID = GlobelInfo.getInstance().currentCourse.getClassId();
        mainView.fillInfo(GlobelInfo.getInstance().currentCourse);//"http://www.51talk.com/upload/open_pdf/2015/12/02/2015120216483656266.pdf"
    }
    var minSize:NSSize!;
    
    //当视图被添加到window后
    override public func viewDidAppear() {
        //设置最大化最小化尺寸
        self.view.window?.minSize = minSize;
        self.view.window?.maxSize = (NSScreen.mainScreen()?.visibleFrame)!.size;//(NSScreen.mainScreen()?.frame)!.size;切换到全屏模式
        
        //设置屏幕居中显示
        let tx:CGFloat = ((NSScreen.mainScreen()?.visibleFrame.width)!-(self.view.frame.width))/2.0;
        let ty:CGFloat = ((NSScreen.mainScreen()?.visibleFrame.height)!-(self.view.frame.height))/2.0 + (NSScreen.mainScreen()?.visibleFrame.origin.y)!;
        self.view.window?.setFrame(NSMakeRect(tx, ty, self.view.frame.size.width, self.view.frame.size.height), display: true);
        
        let win:MainWindow = self.view.window as! MainWindow;
        win.titlebar.setFrameSize(NSSize(width: self.view.frame.size.width, height: 36));
        win.titlebar.setFrameOrigin(NSPoint(x: 0, y: self.view.frame.size.height - 36));
        win.contentView?.superview?.addSubview(win.titlebar);
        let closeBtn:NSButton = win.standardWindowButton(NSWindowButton.CloseButton)!;
        win.titlebar.addSubview(closeBtn);
        let closebtnY:CGFloat = (win.titlebar.frame.height - closeBtn.frame.height)/2;
        closeBtn.setFrameOrigin(NSPoint(x: closeBtn.frame.origin.x, y: closebtnY));
        let minBtn:NSButton = win.standardWindowButton(NSWindowButton.MiniaturizeButton)!;
        minBtn.hidden = false;
        minBtn.setFrameOrigin(NSPoint(x: minBtn.frame.origin.x, y: closebtnY));
        win.titlebar.addSubview(minBtn);
        let resizeBtn:NSButton = win.standardWindowButton(NSWindowButton.ZoomButton)!;
        resizeBtn.hidden = false;
        win.titlebar.addSubview(resizeBtn);
        resizeBtn.setFrameOrigin(NSPoint(x: resizeBtn.frame.origin.x, y: closebtnY));
        win.titlebar.addSubview(mainView.channelView);
        win.titlebar.layer?.backgroundColor = NSColor.clearColor().CGColor;
        mainView.cameraContainer?.startMedia(GlobelInfo.getInstance().currentCourse);//调用sdk,开始进入教室流程
        mainView.fillMediaInfo();//填充媒体相关的数据
    }
    
    /**
    从主屏幕移除
    */
    override public func viewDidDisappear(){
        
        if(mainView != nil)
        {
            mainView.cameraContainer?.removeAllEvents();
            mainView.cameraContainer?.stopMedia();
            mainView.channelView.removeFromSuperview();
        }
    }
    
    /**
     上传退出教室的日志
     */
    func uploadExitRoomLog()
    {
        if(classID == 0)
        {
            return;
        }
        func onComplete(ns:NSURLResponse?,nd:NSData?,err:NSError?)->Void{
            if(err == nil)
            {
                do{
                    let resultData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(nd!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary;
                    
                    NSLog("%d", (resultData.valueForKey("code")?.integerValue)!);
                    
                }catch{
                    NSLog("bannerComplete发生错误");
                }
                
            }
        }
        let urlrequest:NSURLRequest = NSURLRequest(URL: NSURL(string: NSString(format: GMLConfig.inOutRoomInterface,"mout",AcuaSDK.ACService().UserId(),"private",classID,classID,AcuaSDK.ACService().RoleType()) as String)!);
        NSURLConnection.sendAsynchronousRequest(urlrequest, queue: NSOperationQueue.mainQueue(), completionHandler: onComplete)
    }
    
    override public func goprePage(){
        //调用网站的退出教室接口
        uploadExitRoomLog();
        GlobelInfo.getInstance().currentCourse = nil;
        classID = 0;
        mainView.userInfoBar.stop();
        //换页
        func gComplete()->Void{
            //去课程列表页
            var classListPage:NSViewController;
            if(InstanceManager.instance().getModuleInstaceByName("stroyClassList") == nil)
            {
                classListPage = self.storyboard?.instantiateControllerWithIdentifier("stroyClassList") as! NSViewController;
                
            }else
            {
                classListPage = InstanceManager.instance().getModuleInstaceByName("stroyClassList") as! NSViewController;
            }
            
            self.view.window?.contentViewController = classListPage;
            classListPage.view.window?.setFrameOrigin(
                NSMakePoint(
                    ((NSScreen.mainScreen()?.visibleFrame.width)!-(classListPage.view.window?.frame.width)!)/2, (classListPage.view.window?.frame.origin.y)!));
            showPage(classListPage);
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
