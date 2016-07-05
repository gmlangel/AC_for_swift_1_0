//
//  ClassListView.swift
//  AC for swift
//
//  Created by guominglong on 15/5/20.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
public class ClassListView: NSView {
    
    
    private var headerIMG:MaskImageView?;
    private var tb_NickName:NSTextField?;
    
    /**
    显示 我已经预约的课程 的按钮
    */
    private var btn_myClass:FrameBtn?;
    
    /**
    显示 预约公开课 的按钮
    */
    private var btn_openClass:FrameBtn?;
    
    private var btn_classbackplay:FrameBtn?;
    private var btnarr:NSMutableArray!;
    
    
    private var btn_lianxikefu:FrameBtn?;
    private var btn_shebeiceshi:FrameBtn?;
    private var currentMenuBtnName:String = "";
    
    private var contentScroll:NSScrollView?;
    private var contentView:NSView?;
    private var classPage_qiangdan:ClassList_qingdan?;
    private var classPage_openClass:ClassList_openclass?;
    private var canvas:CGContextRef!;
    private var isInted:Bool!;
    private var classlistInfo:CourseVector!;
    private var bannerContainer:NSView!;
    private var banner:ButtonImageView!;
    private var bannerAni:NSImageView!;
    private var bannerURLS:[NSURL]!;
    private var binnerPaths:[String]!;
    private var currentbinnerIdx:Int = 0;
    private var loading:LoadingView!;
    
    private var noLessonImg:NSImageView!;
    private var noLessonTb:NSTextField!;
    
    override public func drawRect(dirtyRect: NSRect) {
        canvas = NSGraphicsContext.currentContext()?.CGContext
        CGContextSaveGState(canvas);
        let be:NSBezierPath = NSBezierPath(roundedRect: NSMakeRect(0, 0, self.frame.width, self.frame.height), xRadius: 5, yRadius: 5);
        be.addClip();
        CGContextSetRGBFillColor(canvas, 0xf7/255.0, 0xf7/255.0, 0xf7/255.0, 1);
        CGContextFillRect(canvas, self.frame);
        
        
        CGContextSaveGState(canvas);
        let trect:NSRect = NSMakeRect(110, self.frame.height-125, self.frame.width - 110, self.frame.height - (self.frame.height-125));
        CGContextSetRGBFillColor(canvas, 1, 1, 1, 1);
        CGContextFillRect(canvas, trect);
        CGContextRestoreGState(canvas);
        if(!isInted)
        {
            isInted = true;
            ginit();
        }
        super.drawRect(dirtyRect);
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
        isInted = false;
        if(self.frame.size.height > (NSScreen.mainScreen()?.visibleFrame.height)!)
        {
            self.setFrameSize(NSSize(width: self.frame.size.width, height: (NSScreen.mainScreen()?.visibleFrame.height)!));
            self.needsDisplay = true;
        }
    }
    
    private func recodePWDtoLocal()
    {
        //本地记录账号密码
        var successStr:String = "";
        successStr += GlobelInfo.getInstance().loginName;//账号
        successStr += "\n";
        successStr += GlobelInfo.getInstance().loginPWD;//密码
        successStr += "\n";
        successStr += GlobelInfo.getInstance().userHeadImgPath;//用户头像
        var nd:NSData = NSString(string: successStr).dataUsingEncoding(NSUTF8StringEncoding)!
        //初始化加密工具
        AESTool.getInstance().ginit(NSString(string: "{971E1D3A-042B-41da-8E97-181F8073D8E2}").UTF8String, len: 32);
        nd = AESTool.getInstance().AesEncrypt(UnsafeMutablePointer<UInt8>(nd.bytes), bytesLen: UInt32(nd.length));
        nd.writeToFile(GlobelInfo.getInstance().successFilePath, atomically: false);
    }
    
    public func ginit()
    {
        var positionRect:NSRect = NSRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height);
        bannerURLS = [];
        //头像
        positionRect.size.width = 64;
        positionRect.size.height = 64;
        positionRect.origin.x = 24;
        positionRect.origin.y = self.bounds.height - 120;
        headerIMG = MaskImageView(frame: positionRect);
        addSubview(headerIMG!);
        
        var headim:NSImage?;
        if(AcuaSDK.ACService().UserImg() != "")
        {
            headim = ResourceManager.instance.getResourceByURL("userheader", sourcePath: AcuaSDK.ACService().UserImg());
            GlobelInfo.getInstance().userHeadImgPath = AcuaSDK.ACService().UserImg();
        }else{
            headim = ResourceManager.instance.getResourceByName("defaultheader")
            GlobelInfo.getInstance().userHeadImgPath = "";
        }

        if(headim == nil)
        {
            headim = ResourceManager.instance.getResourceByName("defaultheader")
            GlobelInfo.getInstance().userHeadImgPath = "";
        }
        //本地记录账号密码
        recodePWDtoLocal();
        headerIMG?.setImage(headim!);
        headerIMG?.setMaskImage(ResourceManager.instance.getResourceByName("headmask"));
        
        
        
        
        //昵称
        positionRect.size.width = 110;
        positionRect.size.height = 30;
        positionRect.origin.x = 0;
        positionRect.origin.y -= 35;
        tb_NickName = NSTextField(frame: positionRect);
        tb_NickName?.font = StyleManager.instance.nsfont5;
        tb_NickName?.alignment = NSTextAlignment.Center;
        tb_NickName?.stringValue = AcuaSDK.ACService().NickName()!;
        tb_NickName?.selectable = false;
        tb_NickName?.editable = false;
        tb_NickName?.textColor = StyleManager.init().color2;
        tb_NickName?.bordered = false;
        tb_NickName?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0);
        addSubview(tb_NickName!);
        
        positionRect.size.width = 80;
        positionRect.size.height = 80;
        positionRect.origin.x = 0;
        positionRect.origin.y -= 85;
        btnarr = [];
        btn_myClass = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("classList_myClass"), _type: 3);
        btn_myClass?.setFrameOrigin(positionRect.origin);
        addSubview(btn_myClass!);
        btn_myClass?.mouseDown(NSEvent());
        btn_myClass?.downfunc = onMenuBtnClick;
        btn_myClass?.identifier = "btn_myClass";
        var temptb:NSTextField = gettb(LanguageManager.instance().getLanguageStr("btn_wodekebiaoText"));
        btn_myClass?.addSubview(temptb);
        
        positionRect.size.width = 80;
        positionRect.size.height = 80;
        positionRect.origin.x = 0;
        positionRect.origin.y -= (btn_myClass?.frame.size.height)!;
        btn_openClass = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("classList_openClass"), _type: 3);
        btn_openClass?.setFrameOrigin(positionRect.origin);
        addSubview(btn_openClass!);
        btn_openClass?.downfunc = onMenuBtnClick;
        btn_openClass?.identifier = "btn_openClass";
        temptb = gettb("公开课");
        btn_openClass?.addSubview(temptb);
        btn_openClass?.hidden = true;
        
        positionRect.size.width = 80;
        positionRect.size.height = 80;
        positionRect.origin.x = 0;
        positionRect.origin.y -= (btn_myClass?.frame.size.height)!;
        btn_classbackplay = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("classList_classbackplay"), _type: 3);
        btn_classbackplay?.setFrameOrigin(positionRect.origin);
        addSubview(btn_classbackplay!);
        btn_classbackplay?.hidden = true;
        
        temptb = gettb("课程回放");
        btn_classbackplay?.addSubview(temptb);
        
        btn_classbackplay?.downfunc = onMenuBtnClick;
        btn_classbackplay?.identifier = "btn_classbackplay";
        btnarr.addObject(btn_myClass!);
        btnarr.addObject(btn_openClass!);
        btnarr.addObject(btn_classbackplay!);
        //联系客服
        btn_lianxikefu = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("lianxikefuSkin"), _type: 3);
        if(AcuaSDK.ACService().RoleType() == "stu")
        {
            addSubview(btn_lianxikefu!);
        }
        positionRect.origin.x = (110 - (btn_lianxikefu?.frame.size.width)!) / 2;
        positionRect.origin.y = 15;//49;
        btn_lianxikefu?.setFrameOrigin(positionRect.origin);
        var lixanxikefucontent:ColorBtn = getBtn2(NSMakeRect(20, 1, 74, 25), upC: StyleManager.instance.color1, overC: StyleManager.instance.color4, downC: StyleManager.instance.color4, str: LanguageManager.instance().getLanguageStr("btn_huiyuanzhognxinText"), gfont: StyleManager.instance.nsfont5!);
        btn_lianxikefu?.addSubview(lixanxikefucontent);
        btn_lianxikefu?.target = self;
        btn_lianxikefu?.action = Selector("huiyuanzhongxin:");
        lixanxikefucontent.target = self;
        lixanxikefucontent.action = Selector("huiyuanzhongxin:");
        //设备检测
        btn_shebeiceshi = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("shebeijianceSkin"), _type: 3);
       // addSubview(btn_shebeiceshi!);
        positionRect.origin.x = (110 - (btn_shebeiceshi?.frame.size.width)!) / 2;
        positionRect.origin.y = 15;
        btn_shebeiceshi?.setFrameOrigin(positionRect.origin);
        var shibeiceshicontent:ColorBtn = getBtn2(NSMakeRect(20, 1, 74, 25), upC: StyleManager.instance.color1, overC: StyleManager.instance.color4, downC: StyleManager.instance.color4, str: "设备检测", gfont: StyleManager.instance.nsfont5!);
        btn_shebeiceshi?.addSubview(shibeiceshicontent);
        
        //右侧内容滚动条
        positionRect.size.width = self.frame.width - 110;
        positionRect.size.height = (tb_NickName?.frame.origin.y)!+38;
        positionRect.origin.x = 110;
        positionRect.origin.y = 0;
        contentScroll = NSScrollView(frame: positionRect);
        addSubview(contentScroll!);
        contentScroll?.hasVerticalScroller = true;
        contentScroll?.hasHorizontalScroller = false;
        
        
        //右侧内容容器
        positionRect.origin.x = 0;
        positionRect.origin.y = 0;
        positionRect.size.height = self.frame.height - 80;
        classPage_qiangdan = ClassList_qingdan(frame: positionRect);
        classPage_openClass = ClassList_openclass(frame: positionRect);
        
        
        
        
        //右上角banner
        positionRect.size.width = self.frame.width - 120;
        positionRect.origin.x = 115;
        positionRect.size.height = 74;
        positionRect.origin.y = (tb_NickName?.frame.origin.y)!+44;
        bannerContainer = NSView(frame: positionRect);
        
        positionRect.origin.x = 0;
        positionRect.origin.y = 0;
        banner = ButtonImageView(frame: positionRect);
        banner.clickFunc = onbannerClick;
        positionRect.origin.x += positionRect.size.width;
        
        bannerAni = NSImageView(frame: positionRect);
        bannerContainer.addSubview(banner);
        bannerContainer.addSubview(bannerAni);
        addSubview(bannerContainer);
        bannerAni.hidden = true;
        //加载banner
        func bannerComplete(ns:NSURLResponse?,nd:NSData?,err:NSError?)->Void{
            if(err == nil)
            {
                do{
                    var bannerData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(nd!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary;
                    bannerData = bannerData.valueForKey("res") as! NSDictionary;
                    let pathArr:NSArray = (bannerData.valueForKey("AcBanner") as! NSArray);
                    let j:Int = pathArr.count;
                    var ps:[String] = [];
                    bannerURLS.removeAll();
                    for(var i:Int = 0;i<j;i++)
                    {
                        bannerURLS.append(NSURL(string: pathArr[i].valueForKey("pic_url") as! String)!);
                        ps.append(pathArr[i].valueForKey("pic") as! String);
                    }
                    if(ps.count > 0)
                    {
                        lunboBinner(ps);//轮播binner
                    }
                }catch{
                    NSLog("bannerComplete发生错误");
                }
                
            }
        }
        
        let bannerStr:String = NSString(format: GMLConfig.binnerPath,"1",AcuaSDK.ACService().RoleType() == "stu" ? 1:2,GlobelInfo.getInstance().appVersion) as String
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: bannerStr)!), queue: NSOperationQueue.mainQueue(), completionHandler: bannerComplete)

        
        let nolession:NSImage = NSImage(named: "noLesson")!;
        positionRect.size.width = nolession.size.width;
        positionRect.size.height = nolession.size.height;
        positionRect.origin.x = ((contentScroll?.frame.width)! - positionRect.size.width)/2.0 + (contentScroll?.frame.origin.x)!;
        positionRect.origin.y = ((contentScroll?.frame.height)! - positionRect.size.height)/2.0 + (contentScroll?.frame.origin.y)! + 50;
        noLessonImg = NSImageView(frame: positionRect);
        noLessonImg.image = nolession;
        addSubview(noLessonImg);
        noLessonImg.hidden = true;
        noLessonTb = gettb(LanguageManager.instance().getLanguageStr("label_nolesson"));
        noLessonTb.font = NSFont(name: "Helvetica Neue", size: 18);
        noLessonTb.textColor = StyleManager.instance.color1;
        noLessonTb.frame.size.width = 380;
        noLessonTb.frame.size.height = 30;
        noLessonTb.frame.origin.x = positionRect.origin.x - 150;
        noLessonTb.frame.origin.y = positionRect.origin.y - 40;
        addSubview(noLessonTb);
        noLessonTb.hidden = true;
        
        var imgSet:[NSImage]=[ResourceManager.instance.getResourceByName("p1"),ResourceManager.instance.getResourceByName("p2"),ResourceManager.instance.getResourceByName("p3"),ResourceManager.instance.getResourceByName("p4"),ResourceManager.instance.getResourceByName("p5"),ResourceManager.instance.getResourceByName("p6"),ResourceManager.instance.getResourceByName("p7"),ResourceManager.instance.getResourceByName("p8"),ResourceManager.instance.getResourceByName("p9"),ResourceManager.instance.getResourceByName("p10"),ResourceManager.instance.getResourceByName("p11"),ResourceManager.instance.getResourceByName("p12")];
        positionRect.size.width = imgSet[0].size.width;
        positionRect.size.height = imgSet[0].size.height;
        positionRect.origin.x = ((contentScroll?.frame.width)! - positionRect.size.width)/2.0 + (contentScroll?.frame.origin.x)!
        
        positionRect.origin.y = ((contentScroll?.frame.height)! - positionRect.size.height)/2.0 + (contentScroll?.frame.origin.y)!
        loading = LoadingView(frame: positionRect, _imgSource: imgSet);
        addSubview(loading);
        //loading.hidden = true;
        
        //刷新课程列表按钮
//        let gRect:NSRect = NSMakeRect(0, 4, 80, 25);
//        let tb:NSTextField = NSTextField(frame: gRect);
//        tb.textColor = StyleManager.instance.color1;
//        tb.backgroundColor = NSColor.clearColor();
//        tb.selectable = false;
//        tb.editable = false;
//        tb.stringValue = "刷新";
//        tb.bordered = false;
//        tb.font = StyleManager.instance.nsfont5;
//        (tb.cell! as NSCell).alignment = NSTextAlignment.Center;
//        
        
        
        
        
        
    }
    
    func onbannerClick(sender:AnyObject)
    {
        if(currentbinnerIdx > -1 && currentbinnerIdx < bannerURLS.count)
        {
            NSWorkspace.sharedWorkspace().openURL(bannerURLS[currentbinnerIdx]);
        }
    }
    
    /**
     轮播binner
     */
    func lunboBinner(sourceNameArr:[String])
    {
        binnerPaths = sourceNameArr;
        currentbinnerIdx = 0;
        if(HeartbeatManager.instance.hasTask("lunbobinner_0") == false)
        {
            banner.image = ResourceManager.instance.getResourceByURL("binner\(currentbinnerIdx)", sourcePath: binnerPaths[currentbinnerIdx])
            HeartbeatManager.instance.addTask(Selector("lunbo"), ti: 4, tg: self, taskName: "lunbobinner_0",repeats: true);
        }
    }
    
    public func lunbo()
    {

        if(currentbinnerIdx < binnerPaths.count - 1)
        {
            currentbinnerIdx += 1;
        }else{
            currentbinnerIdx = 0;
        }
        huandongBinner();
        
    }
    
    func huandongBinner()
    {
        bannerAni.hidden = false;
        bannerAni.frame.origin.x = banner.frame.origin.x + banner.frame.size.width;
        bannerAni.image = ResourceManager.instance.getResourceByURL("binner\(currentbinnerIdx)", sourcePath: binnerPaths[currentbinnerIdx])
        //换页
        func gComplete()->Void{
            banner.image = bannerAni.image;
            banner.frame.origin.x = 0;
            bannerAni.hidden = true;
        }
        
        func gupdate(progress:NSAnimationProgress)->Void
        {
            banner.frame.origin.x = bannerAni.frame.origin.x - banner.frame.width;
        }
        
        let gt:GTWeen = GTWeen(
            obj: bannerAni,
            duration: 0.4,
            _params: ["x":banner.frame.origin.x],
            animationCurve: NSAnimationCurve.EaseInOut,
            _onComplete: gComplete,
            _onUpdate: gupdate);
        gt.startAnimation();
        
        
    }
    
    /**
     会员中心
     */
    public func huiyuanzhongxin(sender:AnyObject)
    {
        let timeUTC:UInt32 = UInt32(CGFloat(NSDate().timeIntervalSince1970));
        var token:String = GTool.md5_str32("\(AcuaSDK.ACService().UserId())\(AcuaSDK.ACService().NickName())\(timeUTC)");
        token = NSString(string: token).substringWithRange(NSMakeRange(0, 10)) as String;
        let str:String = NSString(format: GlobelInfo.getInstance().yonghuzhongxin, AcuaSDK.ACService().UserId(),token,timeUTC,AcuaSDK.ACService().NickName()).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String;
        NSWorkspace.sharedWorkspace().openURL(NSURL(string:str)!);
    }
    
    private var loadingTimer:NSTimer!;
    /**
    显示或者隐藏loading
    */
    public func showOrHideLoading(b:Bool)
    {
        if(loading != nil)
        {
            loading.hidden = !b;
            loadingTimer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("hideLoading"), userInfo: nil, repeats: false);
        }
    }
    
    func hideLoading()
    {
        if(loading != nil)
        {
            loading.hidden = true;
            loadingTimer.invalidate();
        }
    }
    
    func getBtn2(_frame:NSRect,upC:NSColor,overC:NSColor,downC:NSColor,str:String,gfont:NSFont)->ColorBtn
    {
        let gRect:NSRect = NSMakeRect(0, 4, _frame.size.width, 20);
        let tb:NSTextField = NSTextField(frame: gRect);
        tb.font = gfont;
        tb.textColor = upC;
        tb.backgroundColor = NSColor.clearColor();
        tb.selectable = false;
        tb.editable = false;
        tb.stringValue = str;
        tb.bordered = false;
        tb.alignment = NSTextAlignment.Center;
        let fbtn:ColorBtn = ColorBtn(frameRect: _frame, _upColor: upC, _overColor: overC, _downColor: downC, _tb: tb);
        
        return fbtn;
    }
    
    func onMenuBtnClick(sender:NSButton)->Void{
        
        //变更按钮的选中状态
        var btn:FrameBtn;
        for(var i:Int = 0 ;i<btnarr.count;i++)
        {
            btn = btnarr[i] as! FrameBtn;
            if(btn == sender)
            {
                btn.isSelected = true;
            }else
            {
                btn.isSelected = false;
                btn.mouseUp(NSEvent());
            }
        }
        
        if(classlistInfo == nil)
        {
            return;
        }
//        if(currentMenuBtnName != sender.identifier)
//        {
            currentMenuBtnName = sender.identifier!;
            //填充指定按钮对应的页面
            classPage_qiangdan?.fillInfo(classlistInfo,type: currentMenuBtnName);
            contentView = classPage_qiangdan;
            fillInfo(classlistInfo);
        //}
    }
    
    private func gettb(gtext:String)->NSTextField
    {
        let tb:NSTextField = NSTextField(frame: NSMakeRect(0,56,106, 25));
        tb.font = StyleManager.instance.nsfont5;
        tb.alignment = NSTextAlignment.Center;
        tb.stringValue = gtext;
        tb.selectable = false;
        tb.editable = false;
        tb.bordered = false;
        tb.textColor = StyleManager.instance.color2;
        tb.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0);
        return tb;
    }
    
    
    /**
    填充数据
    */
    public func fillInfo(arr:CourseVector,needRefrush:Bool = false)
    {
        self.classlistInfo = arr;
        if(classlistInfo.size() == 0)
        {
            //显示没有约课的图标
            noLessonImg.hidden = false;
            noLessonTb.hidden = false;
        }else{
            //隐藏没有约课的图标
            noLessonImg.hidden = true;
            noLessonTb.hidden = true;
        }
        //填充数据,默认显示我的课表的清单效果
        if(contentView == nil || needRefrush == true)
        {
            btn_myClass?.mouseDown(NSEvent());
        }else{
            contentScroll?.documentView = contentView;
            if(contentView?.frame.height > contentScroll?.frame.height)
            {
                contentScroll?.contentView.scrollToPoint(NSPoint(x: 0, y: (contentView?.frame.height)! - (contentScroll?.frame.height)!))
                contentScroll?.reflectScrolledClipView((contentScroll?.contentView)!);
            }
        }
        
    }
    
    /**
    刷新课程列表状态
    */
    public func updateCourseList()
    {
        if(contentView != nil)
        {
            var arr:Array = (contentView?.subviews)!;
            for(var i:Int = 0 ;i<arr.count;i++)
            {
                (arr[i] as! ClassListItem).updateCourse();
            }
        }
    }
    
    public override func viewWillMoveToWindow(newWindow: NSWindow?) {
        if(self.window == nil)
        {
            HeartbeatManager.instance.removeTask("lunbobinner");
        }else if(binnerPaths != nil)
        {
            lunboBinner(binnerPaths);
        }
        
    }
    
}


class ButtonImageView:NSImageView{
    var clickFunc:((AnyObject)->Void)?;

    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        if(clickFunc != nil)
        {
            clickFunc!(self);
        }
    }
}
