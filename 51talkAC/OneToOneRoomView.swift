//
//  GMLMain.swift
//  AC for swift
//
//  Created by guominglong on 15/4/8.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
@available(OSX 10.10, *)
public class OneToOneRoomView:NSView,NSWindowDelegate {

    

    var whiteboardBg:NSView?;
    var whiteBoardToolBar:DrawViewToolBar?;
    var whiteBoardChangeToolBar:NSView?;
    var nextbtn:FrameBtn?;
    var prebtn:FrameBtn?;
    var tongbubtn:FrameBtn?;
    var yemaTextField:NSTextField?;
    var positionRect:NSRect = NSMakeRect(0, 0, 1, 1);
    
    //pdf加载器
    var pdfReader:PDFDocument?;//pdf阅读器
    var scrollContainer:ScrollContainer?;//滚动容器
    //bottombg
    var soundbtn:FrameBtn?;
    var soundMutebtn:FrameBtn?;
    var soundBar:SoundAndMicToolBar!;
    var micbtn:FrameBtn?;
    var micMutebtn:FrameBtn?;
    var micBar:SoundAndMicToolBar!;
    var savePDFbtn:FrameBtn?;
    
    //右侧的视频和聊天区域
    var rightPanelBg:NSView?;
    public var cameraContainer:MediaView?;
    public var userInfoBar:UserInfoBar!;
    var camerabg:NSImageView?;
    var translateBG:SpriteBmpScale9Grid?;
    var toTeacherSay:FrameBtn?;//想对老师说
    var tview:ChangyongyuView!;//常用语面板
    var sdkView:ChangyongyuView!;//sdk选择列表
    var chatSayBtn:FrameBtn?;
    //其它控件
    var lianxikefubtn:FrameBtn?;
    var shebeijiancebtn:FrameBtn?;
    
    //聊天输入框
    var chatInputTb:ChatInput?;
    
    //连天内容显示面板
    var chatMSGContainer:NSView?;
    var chatMSGScroll:NSScrollView?;
    //public var bottomBar:NSImageView!;
    
    var socketChatMsg:NSMutableDictionary?;
    var jsonErr:NSErrorPointer?;
    var be:NSBezierPath!;
    var canvas:CGContextRef!;
    var loading:LoadingView!;
    var guangbiao:NSImageView!;
    var win:MainWindow?;
    var gtitle:NSString!;
    var channelView:NSView!;
    var btn_changeChannel:FrameBtn!;
    var channelInfo:NSTextField!;
    var xinhao_pannel:FrameView2!;
    var userListPanel:UserListPanel!;
    var jishi:NSTimeInterval! = 0;//3分钟
    
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        _serverPageID = 0;
        gtitle = "";
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    func jianshijian()
    {
        if(jishi > 0)
        {
            jishi = jishi - 1;
        }
    }

    public override func drawRect(dirtyRect: NSRect) {
        
        canvas = NSGraphicsContext.currentContext()?.CGContext;
        CGContextSaveGState(canvas);
        be = NSBezierPath(roundedRect: NSMakeRect(0, 0, self.frame.width, self.frame.height), xRadius: 5, yRadius: 5);
        be.addClip();
        CGContextSetRGBFillColor(canvas, 0xf2/255.0, 0xf2/255.0, 0xf2/255.0, 1);
        CGContextFillRect(canvas, self.frame);
    }
    public override func viewDidMoveToWindow() {
        win = self.window as? MainWindow;
        if(window != nil)
        {
            //添加计时器
            HeartbeatManager.instance.addTask(Selector("jianshijian"), ti: 1, tg: self, taskName: "jianshijian");
        }else{
            //移除计时器
            HeartbeatManager.instance.removeTask("jianshijian");
            _serverPageID = 0;
        }
    }
    
    /**
    屏幕自适应
    */
    public override func resizeWithOldSuperviewSize(oldSize: NSSize) {
        self.setFrameSize(oldSize);
        win?.titlebar.setFrameSize(NSSize(width: self.frame.size.width, height: 36));
        win?.titlebar.setFrameOrigin(NSPoint(x: 0, y: self.frame.size.height - 36));
        if(gtitle != "")
        {
            win?.setGTitle(String(gtitle));
        }
        positionRect.origin.x = 0;
        positionRect.origin.y = 40;
        positionRect.size.width = self.frame.width-320;//self.frame.width-310-10;
        positionRect.size.height = self.frame.height-76;//self.frame.height-36-40
        whiteboardBg?.frame = positionRect;
        
        positionRect.origin.x = 0;
        positionRect.origin.y = 62;
        positionRect.size.width = (self.whiteboardBg?.frame.width)!;
        positionRect.size.height = self.frame.height-108;//self.frame.height-40-36;
        autosizipdfReader(positionRect);//自适应居中显示pdf
        
        whiteBoardToolBar?.frame.origin.x = positionRect.origin.x + (positionRect.width - (whiteBoardToolBar?.position)!.x)/2;
        whiteBoardChangeToolBar?.frame.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.width)! - (nextbtn?.bounds.size.width)!-(nextbtn?.frame.origin.x)!-25;
        
        positionRect.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.size.width)! ;
        positionRect.origin.x -= ((savePDFbtn?.bounds.width)! + 10);
        positionRect.origin.y = 10;
        savePDFbtn?.setFrameOrigin(positionRect.origin);
        
        //other控件
        positionRect.origin.x = oldSize.width - (shebeijiancebtn?.bounds.size.width)!-10;
        positionRect.origin.y = oldSize.height - (shebeijiancebtn?.bounds.size.height)! - 1;
        shebeijiancebtn?.setFrameOrigin(positionRect.origin);
        
        positionRect.origin.x = positionRect.origin.x - (lianxikefubtn?.bounds.size.width)!-5;
        positionRect.origin.y = oldSize.height - (lianxikefubtn?.bounds.size.height)! - 1;
        lianxikefubtn?.setFrameOrigin(positionRect.origin);
        
        //右侧面板
        positionRect.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.size.width)! + 10;
        positionRect.origin.y = 0;
        positionRect.size.width = 310;
        positionRect.size.height = self.frame.height - 36;
        rightPanelBg?.frame = positionRect;
        
        positionRect.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.size.width)! + 10;
        positionRect.origin.y = oldSize.height - (camerabg?.frame.height)! - 36;
        cameraContainer?.setFrameOrigin(positionRect.origin);
        
        positionRect.origin.x = (cameraContainer?.frame.origin.x)! - 1;
        positionRect.origin.y = (cameraContainer?.frame.origin.y)! - userListPanel.frame.height;
        userListPanel.setFrameOrigin(positionRect.origin);
        
        positionRect.origin.x = (cameraContainer?.frame.origin.x)!;
        positionRect.origin.y = (cameraContainer?.frame.origin.y)! + (cameraContainer?.frame.size.height)!-userInfoBar.frame.height;
        userInfoBar.setFrameOrigin(positionRect.origin);
        
        positionRect.origin.x = (rightPanelBg?.frame.origin.x)!;
        positionRect.origin.y = 70;
        positionRect.size.width = (rightPanelBg?.frame.width)!;
        positionRect.size.height = 30;
        translateBG?.frame = positionRect;
        
        positionRect.origin.x = oldSize.width-15-(toTeacherSay?.bounds.width)!;
        positionRect.origin.y += 7;
        toTeacherSay?.setFrameOrigin(positionRect.origin);
        
        tview.frame.origin.x = (toTeacherSay?.frame.origin.x)! - 60;
        tview.frame.origin.y = (toTeacherSay?.frame.origin.y)! + 20;
        
        
        positionRect.origin.x = (rightPanelBg?.frame.origin.x)! + 10;
        positionRect.origin.y = 10;
        chatInputTb?.setFrameOrigin(positionRect.origin);
        
        
        positionRect.origin.x = oldSize.width-10-(chatSayBtn?.bounds.width)!;
        positionRect.origin.y = 10;
        chatSayBtn?.setFrameOrigin(positionRect.origin);
        
        
        chatMSGScroll?.frame.origin.x = (rightPanelBg?.frame.origin.x)!-1;
        chatMSGScroll?.frame.size.height = (userListPanel.frame.origin.y) - 70 - (translateBG?.frame.height)!;
        autoSizeChatMSGContainer();
        
        positionRect.origin.x = ((scrollContainer?.frame.width)! - loading.frame.size.width)/2.0 + (scrollContainer?.frame.origin.x)!
        
        positionRect.origin.y = ((scrollContainer?.frame.height)! - loading.frame.size.height)/2.0 + (scrollContainer?.frame.origin.y)!
        loading.setFrameOrigin(positionRect.origin);
        guangbiao.setFrameOrigin(positionRect.origin);
        
        //频道显示区域
        positionRect.origin.x = self.frame.width - 125;
        positionRect.origin.y = 10;//self.frame.height - 27;
        channelView.setFrameOrigin(positionRect.origin);
        positionRect.origin.x = self.frame.width - 135;
        positionRect.origin.y = self.frame.height - sdkView.frame.height - 30;
        sdkView.setFrameOrigin(positionRect.origin);
    }
    
    /**
    自适应pdf的大小与位置
    */
    public func autosizipdfReader(_positionRect:NSRect)
    {
        if(_positionRect.size.width < 0 || _positionRect.size.height < 0)
        {
            return;
        }
        scrollContainer?.frame = _positionRect;
        //设置PDF阅读器的显示区域
        pdfReader?.setFrameSize(_positionRect.size);
        
        autoAlignpdfReader();

    }
    
    /**
     自适应pdf的滚动显示区域
     */
    private func autoAlignpdfReader()
    {
        var scrollPoint:NSPoint = NSZeroPoint;
        if(pdfReader?.frame.height >= scrollContainer?.frame.height)
        {
            scrollPoint.x = 0;
            scrollPoint.y = (pdfReader?.frame.height)! - (scrollContainer?.frame.height)!
            scrollContainer?.contentView.scrollToPoint(scrollPoint);
        }else{
            scrollPoint.x = 0;
            scrollPoint.y = 0;
            scrollContainer?.contentView.scrollToPoint(scrollPoint);
        }
        
        scrollContainer?.hasVerticalScroller = true;
        scrollContainer?.reflectScrolledClipView((scrollContainer?.contentView)!);
        //告知pdfReader，pdfReader相对于NSwindow的真实位置是多少
        updatePDFReaderTrueOffset();
        
    }
    
    /**
     告知pdfReader，pdfReader相对于NSwindow的真实位置是多少
     */
    public func updatePDFReaderTrueOffset()
    {
        var scrollPoint:NSPoint = NSZeroPoint;
        scrollPoint.x = (scrollContainer?.documentVisibleRect.origin.x)!;
        scrollPoint.y = (scrollContainer?.documentVisibleRect.origin.y)!;
        scrollPoint.x = (scrollContainer?.frame.origin.x)! + scrollPoint.x;
        scrollPoint.y = (scrollContainer?.frame.origin.y)! - scrollPoint.y;
        pdfReader?.setTrueOffset(scrollPoint);
    }
    
    
    
    public func ginit()->Void
    {
        jsonErr = NSErrorPointer();
        positionRect.origin.x = 10;
        positionRect.origin.y = self.frame.height-47;
        positionRect.size.width = self.frame.width-310-10-10-10;
        positionRect.size.height = 30;
        
        
        
        //白板背景
        positionRect.origin.x = 10;
        positionRect.origin.y = 10;
        positionRect.size.width = self.frame.width-310-10-10;
        positionRect.size.height = self.frame.height-40;
        whiteboardBg = NSView(frame: positionRect);
        whiteboardBg?.layer = CALayer();
        whiteboardBg?.layer?.backgroundColor = NSColor.whiteColor().CGColor;
        whiteboardBg?.frame = positionRect;
        whiteboardBg?.setNeedsDisplayInRect(positionRect);
        addSubview(whiteboardBg!);
        
        
        //加载pdf
        positionRect.origin.x = 11;
        positionRect.origin.y = 62;
        positionRect.size.width = self.frame.width-310-10-10-10-2;
        positionRect.size.height = self.frame.height-40-20-17;
        scrollContainer = ScrollContainer(frame: positionRect);
        scrollContainer?.hasHorizontalScroller = false;
        scrollContainer?.hasVerticalScroller = true;
        self.addSubview(scrollContainer!);
        //白板容器
        positionRect.origin.x = 0;
        positionRect.origin.y = 0;
        positionRect.size.width = self.frame.width-310-10-10-10-2;
        positionRect.size.height = self.frame.height-40-20-17;
        
        positionRect.origin.x = 0;
        positionRect.origin.y = 0;
        pdfReader = PDFDocument(frame: positionRect);
        scrollContainer?.documentView = pdfReader;
        scrollContainer!.scrolledFun = updatePDFReaderTrueOffset;
        
        positionRect.origin.x = 10;
        positionRect.origin.y = 42;
        positionRect.size.width = self.frame.width-310-10-10-10;
        positionRect.size.height = 40;
        whiteBoardToolBar = DrawViewToolBar(frame: positionRect);
        whiteBoardToolBar?.ginit();
        var t:CGFloat = positionRect.origin.x;
        t = t + (positionRect.width - (whiteBoardToolBar?.position)!.x)/2;
        whiteBoardToolBar?.frame.origin.x = t;
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            addSubview(whiteBoardToolBar!);
            whiteBoardToolBar?.setDefaultType = pdfReader?.whiteboardView.setgDrawType;
        }
        //翻页工具
        whiteBoardChangeToolBar = NSView(frame: positionRect);
        nextbtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("1v1_right"), _type: 3);
        nextbtn?.action = Selector("onNextpage:");
        nextbtn?.target = self;
        
        prebtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("btnpre"), _type: 3);
        prebtn?.action = Selector("onPrepage:");
        prebtn?.target = self;
        
        tongbubtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("tongbu"), _type: 3);
        tongbubtn?.action = Selector("ontongbu:");
        tongbubtn?.target = self;
        
        yemaTextField = NSTextField(frame: positionRect);
        yemaTextField?.textColor = StyleManager.instance.nscolor1;
        yemaTextField?.stringValue = "1/1";
        yemaTextField?.alignment = NSTextAlignment.Center;
        yemaTextField?.bordered = false;
        yemaTextField?.backgroundColor = NSColor(deviceRed: 0, green: 0, blue: 0, alpha: 0);
        yemaTextField?.font = StyleManager.instance.nsfont2;
        yemaTextField?.selectable = false;
        addSubview(yemaTextField!);
        
        
        whiteBoardChangeToolBar?.addSubview(nextbtn!);
        whiteBoardChangeToolBar?.addSubview(prebtn!);
        if(AcuaSDK.ACService().RoleType() != "tea")
        {
            whiteBoardChangeToolBar?.addSubview(tongbubtn!);
        }
        whiteBoardChangeToolBar?.addSubview(yemaTextField!);
        
        positionRect.origin.y = 2;
        positionRect.origin.x = 0;
        positionRect.size.width = 16;
        positionRect.size.height = 16;
        prebtn?.frame = positionRect;
        positionRect.origin.x = 70;
        nextbtn?.frame = positionRect;
        positionRect.origin.x = 93;
        tongbubtn?.setFrameOrigin(positionRect.origin);
        
        positionRect.size.width = 50;
        positionRect.origin.x = 20;
        yemaTextField?.frame = positionRect;
        
        addSubview(whiteBoardChangeToolBar!);
        whiteBoardChangeToolBar?.frame.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.width)! - (nextbtn?.bounds.size.width)!-(nextbtn?.frame.origin.x)!-25;
        
        //底部工具条
        soundbtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("soundSkin"), _type: 3);
        soundMutebtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("soundMuteSkin"), _type: 3);
        micbtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("micSkin"), _type: 3);
        micMutebtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("micMuteSkin"), _type: 3);
        positionRect.origin.y = 12;
        positionRect.origin.x = 10;
        soundbtn?.frame.origin = positionRect.origin;
        soundMutebtn?.frame.origin = positionRect.origin;
        soundMutebtn?.hidden = true;
        positionRect.origin.y = 8;
        positionRect.origin.x = 6;
        soundBar = SoundAndMicToolBar(frame: positionRect);
        addSubview(soundBar);
        addSubview(soundbtn!);
        addSubview(soundMutebtn!);
        
        
        positionRect.origin.y = 12;
        positionRect.origin.x = 40;
        micbtn?.frame.origin = positionRect.origin;
        micMutebtn?.frame.origin = positionRect.origin;
        positionRect.origin.y = 8;
        positionRect.origin.x = 34;
        micBar = SoundAndMicToolBar(frame: positionRect);
        addSubview(micBar);
        addSubview(micbtn!);
        addSubview(micMutebtn!);
        
        micMutebtn?.hidden = true;
        soundbtn?.target = self;
        soundMutebtn?.target = self;
        micbtn?.target = self;
        micMutebtn?.target = self;
        
        soundbtn?.action = Selector("onmuteSound:");
        soundMutebtn?.action = Selector("onresumeSound:");
        
        micbtn?.action = Selector("onmuteMic:");
        micMutebtn?.action = Selector("onresumeMic:");
        
        savePDFbtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("savePDFSkin"), _type: 3);
        savePDFbtn?.target = self;
       // addSubview(savePDFbtn!);
        positionRect.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.size.width)! ;
        positionRect.origin.x -= ((savePDFbtn?.bounds.width)! + 10);
        positionRect.origin.y = 10;
        savePDFbtn?.setFrameOrigin(positionRect.origin);
        //other控件
        lianxikefubtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("lianxikefuSkin"), _type: 3);
        shebeijiancebtn = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("shebeijianceSkin"), _type: 3);
        //addSubview(lianxikefubtn!);
        //addSubview(shebeijiancebtn!);
        positionRect.origin.x = 800 - (shebeijiancebtn?.bounds.size.width)!-10;
        positionRect.origin.y = 600 - (shebeijiancebtn?.bounds.size.height)! - 10;
        shebeijiancebtn?.setFrameOrigin(positionRect.origin);
        
        positionRect.origin.x = positionRect.origin.x - (lianxikefubtn?.bounds.size.width)!-10;
        positionRect.origin.y = 600 - (lianxikefubtn?.bounds.size.height)! - 10;
        lianxikefubtn?.setFrameOrigin(positionRect.origin);
        
        
        //右侧面板
        positionRect.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.size.width)! + 10;
        positionRect.origin.y = 0;
        positionRect.size.width = 310;
        positionRect.size.height = (self.frame.size.height) - 36;
        rightPanelBg = NSView(frame: positionRect);
        rightPanelBg?.layer = CALayer();
        rightPanelBg?.layer?.backgroundColor = NSColor(red: 0xf9/255.0, green: 0xf9/255.0, blue: 0xf9/255.0, alpha: 1).CGColor;
        addSubview(rightPanelBg!);
        rightPanelBg?.hidden = true;
        
        let cameraimg:NSImage = ResourceManager.instance.getResourceByName("cameraSkin") as NSImage;
        positionRect.origin.x = 0;
        positionRect.origin.y = 0;
        positionRect.size.width = cameraimg.size.width;
        positionRect.size.height = cameraimg.size.height;
        camerabg = NSImageView(frame: positionRect);
        camerabg?.image = cameraimg;
        
        
        positionRect.origin.x = (whiteboardBg?.frame.origin.x)! + (whiteboardBg?.frame.size.width)! + 10;
        positionRect.origin.y = 570 - (camerabg?.frame.height)!;
        cameraContainer = MediaView(frame: positionRect);
        cameraContainer?.addSubview(camerabg!);
        cameraContainer?.ginit((camerabg?.bounds)!, localBounds: NSMakeRect(0, 0, (camerabg?.bounds.size.width)!/3.0, (camerabg?.bounds.size.height)!/3.0));
       
        addSubview(cameraContainer!);
        
        
        positionRect.origin.x = (cameraContainer?.frame.origin.x)!;
        positionRect.origin.y = (cameraContainer?.frame.origin.y)! + (cameraContainer?.frame.size.height)!-28;
        positionRect.size.width = cameraimg.size.width;
        positionRect.size.height = 28;
        
        userInfoBar = UserInfoBar(frame: positionRect);
        addSubview(userInfoBar);
        
        //用户列表
        positionRect.origin.x = (cameraContainer?.frame.origin.x)!;
        positionRect.origin.y = (cameraContainer?.frame.origin.y)! - 30;
        positionRect.size.width = cameraimg.size.width;
        positionRect.size.height = 30;
        userListPanel = UserListPanel(frame: positionRect);
        addSubview(userListPanel);
        
        
        positionRect.origin.x = 0;
        positionRect.origin.y = 0;
        positionRect.size.width = 20;
        positionRect.size.height = 10;
        translateBG = SpriteBmpScale9Grid(_imgskin: ResourceManager.instance.getResourceByName("translateBG"), _rect: positionRect);
        addSubview(translateBG!);
        
        toTeacherSay = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("toTeacherSkin"), _type: 3);
        toTeacherSay?.target = self;
        toTeacherSay?.action = Selector("toTeacherSay:");
        if(AcuaSDK.ACService().RoleType() == "stu")
        {
            addSubview(toTeacherSay!);
        }
        
        var changyongyudataSource = [[String:String]]();
        changyongyudataSource.append(["你可以写下来吗？":"Could you write it down for me, please?"]);
        changyongyudataSource.append(["怎么拼写？":"How do you spell it?"]);
        changyongyudataSource.append(["你能再重复一遍吗？":"Can you repeat it, please?"]);
        changyongyudataSource.append(["你能帮我吗？":"Can you help me with it, please?"]);
        changyongyudataSource.append(["我不明白.":"I don't understand."]);
        changyongyudataSource.append(["这个什么意思？":"What does it mean?"]);
        changyongyudataSource.append(["这用英语怎么说？":"What do you call it in English?"]);
        changyongyudataSource.append(["你能给我举个例子吗？":"May I have an example?"]);
        changyongyudataSource.append(["你能帮我再解释一下吗？":"Could you explain this one more time, please?"]);
        
        tview = ChangyongyuView(frame: NSRect(x: 100, y: 50, width: 150, height: 300),jiantouPoint: NSPoint(x:120,y:0),_dataSource:changyongyudataSource);
        tview.setNeedsDisplayInRect(tview.frame);
        tview.notifationName = "changyongyuMSG";
        //聊天输入区域
        positionRect.origin.x = (rightPanelBg?.frame.origin.x)!;
        positionRect.origin.y = 32;
        positionRect.size.width = 246;
        positionRect.size.height = 50;
        
        chatInputTb = ChatInput(frame: positionRect);
        addSubview(chatInputTb!);
        
        chatSayBtn = getBtn("1v1_sendmsg", str: LanguageManager.instance().getLanguageStr("btn_sendMSG"), gfont: StyleManager.instance.nsfont5);
        addSubview(chatSayBtn!);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onEnterSnedChatInfo:"), name: "sendMSG", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changyongyuMSG:"), name: "changyongyuMSG", object: nil);
        chatSayBtn?.target = self;
        chatSayBtn?.action = Selector("sendChatInfo:");
        chatSayBtn?.keyEquivalent = "\r";
        
        positionRect.origin.x = (rightPanelBg?.frame.origin.x)!;
        positionRect.origin.y = 100;
        positionRect.size.width = (rightPanelBg?.frame.size.width)!+1;
        positionRect.size.height = (userListPanel?.frame.origin.y)! - 70 - (translateBG?.frame.height)!;
        chatMSGScroll = NSScrollView(frame: positionRect);
        chatMSGScroll?.hasHorizontalScroller = false;
        chatMSGScroll?.hasVerticalScroller = true;
        addSubview(chatMSGScroll!);
        
        chatMSGContainer = NSView(frame: positionRect);
        chatMSGScroll?.documentView = chatMSGContainer;
        chatMSGScroll?.backgroundColor = NSColor(red: 0xf9/255.0, green: 0xf9/255.0, blue: 0xf9/255.0, alpha: 1);
        chatMSGScroll?.layer = CALayer();
        chatMSGScroll?.layer?.backgroundColor = NSColor(red: 0xf9/255.0, green: 0xf9/255.0, blue: 0xf9/255.0, alpha: 1).CGColor;
        chatMSGScroll?.layer?.borderWidth = 1;
        chatMSGScroll?.layer?.borderColor = NSColor(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1).CGColor;

        
        //显示loading
        var imgSet:[NSImage]=[ResourceManager.instance.getResourceByName("p1"),ResourceManager.instance.getResourceByName("p2"),ResourceManager.instance.getResourceByName("p3"),ResourceManager.instance.getResourceByName("p4"),ResourceManager.instance.getResourceByName("p5"),ResourceManager.instance.getResourceByName("p6"),ResourceManager.instance.getResourceByName("p7"),ResourceManager.instance.getResourceByName("p8"),ResourceManager.instance.getResourceByName("p9"),ResourceManager.instance.getResourceByName("p10"),ResourceManager.instance.getResourceByName("p11"),ResourceManager.instance.getResourceByName("p12")];
        positionRect.size.width = imgSet[0].size.width;
        positionRect.size.height = imgSet[0].size.height;
        positionRect.origin.x = ((scrollContainer?.frame.width)! - positionRect.size.width)/2.0 + (scrollContainer?.frame.origin.x)!
        
        positionRect.origin.y = ((scrollContainer?.frame.height)! - positionRect.size.height)/2.0 + (scrollContainer?.frame.origin.y)!
        loading = LoadingView(frame: positionRect, _imgSource: imgSet);
        addSubview(loading);
        
        //channel显示却与
        //voice_channel
        positionRect.origin.x = self.frame.width - 120;
        positionRect.origin.y = self.frame.height - 36 - 25;
        positionRect.size.width = 120;
        positionRect.size.height = 25;
        channelView = NSView(frame: positionRect);
        btn_changeChannel = FrameBtn(_imgskin: ResourceManager.instance.getResourceByName("voice_channel"), _type: 3);
        btn_changeChannel.frame.origin.x = 0;
        btn_changeChannel.frame.origin.y = 0;
        btn_changeChannel.target = self;
        btn_changeChannel.action = Selector("onbtn_changeChannelClick:");
        
        var sdkList = [[String : String]]();
        sdkList.append(["\(LanguageManager.instance().getLanguageStr("channelInfo"))5":"5"]);
        sdkList.append(["\(LanguageManager.instance().getLanguageStr("channelInfo"))4":"4"]);
        
        sdkView = ChangyongyuView(frame: NSRect(x: 0, y: 0, width: 100, height: 100), jiantouPoint: NSPoint(x: 20, y: 0), _dataSource: sdkList,jiantouFangXiang:"top");
        sdkView.setNeedsDisplayInRect(sdkView.frame);
        sdkView.notifationName = "changesdk";
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changesdk:"), name: "changesdk", object: nil);
            
        positionRect.origin.x = 20;
        positionRect.origin.y = 0;
        positionRect.size.width = 120;
        positionRect.size.height = 20;
        channelInfo = NSTextField(frame: positionRect);
        channelInfo.textColor = NSColor.grayColor();
        channelInfo.stringValue = LanguageManager.instance().getLanguageStr("channelInfo");
        channelInfo.alignment = NSTextAlignment.Left;
        channelInfo.bordered = false;
        channelInfo.backgroundColor = NSColor.clearColor();
        channelInfo.font = StyleManager.instance.nsfont7;
        channelInfo.selectable = false;
        
        positionRect.origin.x = 95;
        positionRect.origin.y = 2;
        positionRect.size.width = 18;
        positionRect.size.height = 18;
        xinhao_pannel = FrameView2(_imgskin: ResourceManager.instance.getResourceByName("network"), _type: 5);
        xinhao_pannel.setFrameOrigin(positionRect.origin);
        channelView.addSubview(xinhao_pannel);
        channelView.addSubview(btn_changeChannel);
        channelView.addSubview(channelInfo);
        addSubview(channelView);
        //添加光标
        let guangbiaoImg:NSImage = ResourceManager.instance.getResourceByName("star_mc1");
        guangbiao = NSImageView(frame:NSMakeRect(0,0,guangbiaoImg.size.width,guangbiaoImg.size.height));
        guangbiao.image = guangbiaoImg;
        if(AcuaSDK.ACService().RoleType() != "tea")
        {
            addSubview(guangbiao);
        }
        guangbiao.setFrameOrigin(loading.frame.origin);
        guangbiao.hidden = true;
        //用户进入，用户离开消息监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userJoin:"), name: "userJoin", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userLeave:"), name: "userLeave", object: nil);
        
        if(AcuaSDK.ACService().RoleType() != "tea")
        {
            //光标同步监听
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeGuanBiao:"), name: "changeGuanBiao", object: nil);
        }else{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("sendPOS:"), name: "sendguangbiao", object: nil);
        }
        //聊天消息回调监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("msgCallBack:"), name: "msgCallBack", object: nil);
        
        //pdf换页监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changePDFPage:"), name: "changePDFPage", object: nil);
        
        //清除白板的监听
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("clearWhiteData:"), name: "clearWhiteData", object: nil);
        
        //设置音量的回调
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setVolum:"), name: "setVolum", object: nil);
        
        //白板数据监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onWhiteData:"), name: "onWhiteData", object: nil);
        
        //添加用户列表更新监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateUserList:"), name: "updateUserList", object: nil);
        
        //changSDK频道选择回调
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changSDK:"), name: "changSDK", object: nil);
        
        
        //网络延迟
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onJitter:"), name: "onJitter", object: nil);
        
        //麦克风震动
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("maizhenCallBack:"), name: "maizhenCallBack", object: nil);
        
        //添加白板数据发送的监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("sendWD:"), name: "sendWhiteBoardInfoToServer", object: nil)
        
        
    }
    
    func changesdk(notify:NSNotification)
    {
        cameraContainer?.changeSDK(UInt8(notify.object as! String)!)
        if(sdkView.superview != nil)
        {
            sdkView.removeFromSuperview();
        }
    }
    
    func getBtn(_imgskinName:String!,str:String,gfont:NSFont)->FrameBtn
    {
        let fbtn:FrameBtn = FrameBtn(_imgskin:ResourceManager.instance.getResourceByName(_imgskinName), _type: 3);
        let gRect:NSRect = NSMakeRect(0, (fbtn.frame.height - 18)/2 - 2, fbtn.frame.size.width, 18);
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
    
    /**
     收到常用语消息
     */
    public func changyongyuMSG(notify:NSNotification)
    {
        chatInputTb?.text = notify.object as! String;
        sendChatInfo(self);//显示消息
        //隐藏常用语面板
        if(tview.superview != nil)
        {
            tview.removeFromSuperview();
        }
    }
    
    /**
     sdk切换面板
     */
    public func onbtn_changeChannelClick(sender:AnyObject)
    {
        if(sdkView.superview == nil)
        {
            addSubview(sdkView);
        }else{
            sdkView.removeFromSuperview();
        }
    }
    
    public func maizhenCallBack(notify:NSNotification)
    {
        let args:EngineVLREvent = notify.object as! EngineVLREvent;
        let mediaID:Int32 = Int32(args.getUserId().getMediaId());
        //NSLog("mediaID:%d,麦克风yinliang:%d",mediaID,args.getLevel());
        userListPanel.setFrameIdx(mediaID,val: args.getLevel());
    }
    
    //网络延迟
    public func onJitter(notify:NSNotification)
    {//
        let rtt:Int32 = (notify.object as! ChannelAudioStatistics).getRtt();
        if(rtt <= 100)
        {
            xinhao_pannel.setFrameIdx(4);
        }else if(rtt <= 200)
        {
            xinhao_pannel.setFrameIdx(3);
        }else if(rtt <= 400)
        {
            xinhao_pannel.setFrameIdx(2);
        }else
        {
            xinhao_pannel.setFrameIdx(1);
        }
        //NSLog("网络延迟：%d,jitt:%d,PlayPacketLoss:%d",(,(notify.object as! ChannelAudioStatistics).getJitter(),(notify.object as! ChannelAudioStatistics).getPlayPacketLoss());
        
    }
    
    //sdk变更
    public func changSDK(notify:NSNotification)
    {
        if(notify.object == nil)
        {
            //停止信号
            
            //更新语音通道的显示
            channelInfo.stringValue = LanguageManager.instance().getLanguageStr("channelInfo");
        }else{
            //更新语音通道的显示
            channelInfo.stringValue = "\(LanguageManager.instance().getLanguageStr("channelInfo"))\(notify.object as! String)";
        }
    }
    
    /**
     用户列表更新
     */
    public func updateUserList(notify:NSNotification)
    {
        let ulist:ClassUserVector = notify.object as! ClassUserVector;
        userListPanel.fillList(ulist);
        userListPanel.frame.origin.y = (cameraContainer?.frame.origin.y)! - userListPanel.frame.height;
        chatMSGScroll?.frame.size.height = (userListPanel.frame.origin.y) - 70 - (translateBG?.frame.height)!;
        autoSizeChatMSGContainer();
    }
    
    /**
    获得了白板数据
    */
    public func onWhiteData(notify:NSNotification)
    {
        pdfReader?.onwhiteBoardData(notify.object as! WBOperationData);
    }
    
    
    /**
    清空白板数据并发送给对端(内部已经实现了老师权限判断)
    */
    public func clearWhiteData(notify:NSNotification)
    {
        pdfReader?.clearDrawDataAndSendToServer();
    }
    
    private var _serverPageID:UInt16!;
    public var serverPageID:UInt16{
        get{
            return _serverPageID;
        }
        set{
            if(newValue != _serverPageID)
            {
                //页面更新了,通知白板清空数据
                clearWhiteData(NSNotification(name: "clearWhiteData", object: nil));
                //NSNotificationCenter.defaultCenter().postNotificationName("clearWhiteData", object: nil);
            }
            _serverPageID = newValue;
            pdfReader?.currentPageId = Int(_serverPageID);
            autoAlignpdfReader();
            setPdfPagesInfo((self.pdfReader?.currentPageId)!,_totalPages: (self.pdfReader?.totalPages)!);
        }
    }
    
    /**
    响应服务器端发来的pdf翻页命令
    */
    public func changePDFPage(notify:NSNotification)
    {
        serverPageID = (notify.object as! NSNumber).unsignedShortValue;
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            //告诉对端和自身同步
            let d:WBDocumentData = WBDocumentData();
            d.setCurrentPage(serverPageID);
            d.setTotalPage(UInt16((self.pdfReader?.totalPages)!));
            cameraContainer?.sendFanye(d);
        }
    }
    
    /**
     向服务器发送pdf翻页同步命令
     */
    public func sendPDFPageSync()
    {
        let d:WBDocumentData = WBDocumentData();
        d.setCurrentPage(serverPageID);
        d.setTotalPage(UInt16((self.pdfReader?.totalPages)!));
        cameraContainer?.sendFanye(d);
        
        //页面更新了,通知白板清空数据
        clearWhiteData(NSNotification(name: "clearWhiteData", object: nil));
    }
    
    /**
     发送白斑数据
     */
    public func sendWD(notify:NSNotification)
    {
        let data:WBOperationData = notify.object as! WBOperationData;
        cameraContainer?.sendWD(data);
    }
    
    /**
     发送光标同步
     */
    public func sendPOS(notify:NSNotification)
    {
        let data:WBPencilPosData = notify.object as! WBPencilPosData;
        cameraContainer?.sendPOS(data);
    }
    
    
    /**
    远端发来消息
    */
    public func msgCallBack(notify:NSNotification)
    {
        let obj:ClassRecvImEventArgs = notify.object as! ClassRecvImEventArgs;
        socketCallBackMSG(obj.getMessage(),nickName: (cameraContainer?.getOtherUserName())! as String);
    }
    
    var tempscale:CGFloat!;
    var tempRect:NSRect! = NSMakeRect(0, 0, 0, 0);
    var guangbiaotp:WBPencilPosData!;
    /**
    响应服务器端发来的光标数据
    */
    public func changeGuanBiao(notify:NSNotification)
    {
        
        guangbiaotp = notify.object as! WBPencilPosData;
        
        tempRect.size.width = CGFloat(guangbiaotp.getXOffset()>>16);
        tempRect.origin.x = CGFloat(guangbiaotp.getXOffset()&0x0000ffff);
        
        tempRect.size.height = CGFloat(guangbiaotp.getYOffset()>>16);
        tempRect.origin.y = CGFloat(guangbiaotp.getYOffset()&0x0000ffff);
        
        tempscale = tempRect.size.width/(pdfReader?.gsize.width)!
        tempRect.origin.x = tempRect.origin.x/tempscale;
        tempRect.origin.y = (pdfReader?.gsize.height)! - tempRect.origin.y/tempscale + (scrollContainer?.frame.origin.y)!-15 + (pdfReader?.pdfOrigin.y)!;
        guangbiao.setFrameOrigin(tempRect.origin);
        
    }
    
    public func userJoin(notify:NSNotification)
    {
        let user:ClassUser = notify.object as! ClassUser;
        if(AcuaSDK.ACService().UserId() != user.getUserId())
        {
            //其他人进入教室
            if(AcuaSDK.ACService().RoleType() == "stu")
            {
                let user:ClassUser = notify.object as! ClassUser;
                let a:String = (cameraContainer?._classSession.Me().getDisplayName())!;
                let b:NSString = user.getDisplayName();
                userInfoBar.start(String(format:LanguageManager.instance().getLanguageStr("userInfoBarLabel2"),a,b));
            }else{
                userInfoBar.start(LanguageManager.instance().getLanguageStr("userInfoBarLabel3"));
            }
        }
    }
    
    public func userLeave(notify:NSNotification)
    {
        let user:ClassUser = notify.object as! ClassUser;
        if(AcuaSDK.ACService().UserId() != user.getUserId())
        {
            //其他人离开教室
            userInfoBar.stop();
        }
    }
    
    public func onEnterSnedChatInfo(nto:NSNotification)
    {
        self.sendChatInfo(self);
    }
    
    public func fillInfo(cos:Course)
    {
        jishi = 0;
        gtitle = cos.getCourseName();
        if(sdkView.superview != nil)
        {
            sdkView.removeFromSuperview();
        }
        if(tview.superview != nil)
        {
            tview.removeFromSuperview();
        }
        //课程名称
        (self.window as! MainWindow).setGTitle(cos.getCourseName());
        pdfReader?.hidden = true;
        self.setPdfPagesInfo(0, _totalPages: 1);
        nextbtn?.enabled = false;
        prebtn?.enabled = false;
        tongbubtn?.enabled = false;
       // whiteBoard?.isEnabled = false;//关闭画板的主动被动绘制
        pdfReader?.clearDrawData();//清除画板数据
        guangbiao.hidden = true;
        
        soundMutebtn?.hidden = true;
        soundbtn?.hidden = false;
        micMutebtn?.hidden = true;
        micbtn?.hidden = false;
        soundBar.hidden = true;
        micBar.hidden = true;
        cameraContainer?.swapWindow(true);
        userInfoBar.count = 0;
        var pdfPath:String = cos.GetString("teaCourseSource", defaultValue: "");
        pdfPath = pdfPath == "" ? cos.GetString("courseSource", defaultValue: "") : pdfPath;
        //测试用------------
        //pdfPath = "http://172.16.3.159/t_nl3u2l3.pdf";
        //测试用结束-----------
        //加载教材
        if(pdfPath != "")
        {
            loading.hidden = false;
            var path:NSString=NSString(string: pdfPath);
            //去空格处理和URI处理
            if(pdfPath.containsString("%") == false)
            {
                //需要URI处理
                path = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
            }
            path = path.stringByReplacingOccurrencesOfString(" ", withString: "%20");
            //加载pdf
            func gcomplete(greperson:NSURLResponse?,nd:NSData?, err:NSError?) -> Void{
                if(nd != nil)
                {
                    nextbtn?.enabled = true;
                    prebtn?.enabled = true;
                    if(AcuaSDK.ACService().RoleType() == "stu")
                    {
                        tongbubtn?.enabled = true;
                    }
                    pdfReader?.hidden = false;
                    //呈现PDF
                    loading.hidden = true;
                    let jiaocaiLeixing:String = cos.GetString("courseSize",defaultValue: "");
                    
                    if(AcuaSDK.ACService().RoleType() == "stu")
                    {
                        pdfReader?.fillPdf(nd!, type: "host",pageID: serverPageID);
                    }else{
                        pdfReader?.fillPdf(nd!, type: "host",pageID: serverPageID,_pdfType:jiaocaiLeixing);
                    }
                    setPdfPagesInfo(Int(serverPageID), _totalPages: (pdfReader?.totalPages)!);
                    //开启白板绘制
                   // whiteBoard?.isEnabled = true;
                    guangbiao.hidden = false;
                    //根据pdf尺寸，重新自适应布局界面
                    if(window != nil)
                    {
                        resizeWithOldSuperviewSize(window!.contentView!.bounds.size);
                    }
                }else{
                    //给与PDF加载失败的提示
//                    NSLog("sdf");
//                    loading.hidden = true;
                    //如果加载失败，则重新加载
                    NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: path as String)!), queue: NSOperationQueue.mainQueue(), completionHandler: gcomplete);
                }
            }
            NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: path as String)!), queue: NSOperationQueue.mainQueue(), completionHandler: gcomplete);
        }
        
        //移除所有聊天信息chatMSGContainer
        var arr:Array = (chatMSGContainer?.subviews)!;
        for(var i:Int = 0;i<arr.count;i++)
        {
            (arr[i] as NSView).removeFromSuperview();
        }
        chatInputTb?.clearText();
    }
    
    /**
    填充媒体相关的信息， 这个函数必须在MediaEngine的sdk启动后才可以调用
    */
    public func fillMediaInfo()
    {
//        var cg:NSNumber = NSNumber(int: (cameraContainer?.getSoundVolume())!);
//        soundBar.setJinDuPosition(CGFloat(cg.floatValue/255.0));
//        cg = NSNumber(int: (cameraContainer?.getmicVolume())!);
//        micBar.setJinDuPosition(CGFloat(cg.floatValue/255.0));
//        if(cg == 0)
//        {
//            micbtn?.hidden = true;
//            micMutebtn?.hidden = false;
//        }
        cameraContainer?.setSoundVolume(0x80);
        cameraContainer?.setmicVolume(0x80);
        soundBar.setJinDuPosition(0.5);
        micBar.setJinDuPosition(0.5);
        micbtn?.hidden = false;
        micMutebtn?.hidden = true;
        soundbtn?.hidden = false;
        soundMutebtn?.hidden = true;
    }
    
    
    
    
    public func setPdfPagesInfo(_currentPageId:Int,_totalPages:Int)
    {
        self.yemaTextField!.stringValue = "\(_currentPageId+1)/\(_totalPages)";
        if(pdfReader?.currentPageId != Int(serverPageID))
        {
            pdfReader?.showOrHideWhiteboard(false);
        }else
        {
            pdfReader?.showOrHideWhiteboard(true);
        }
    }
    
    /**
    去下一页
    */
    public func onNextpage(sender:AnyObject)
    {
        self.pdfReader?.currentPageId++;
        whiteboardBg?.setNeedsDisplayInRect((whiteboardBg?.bounds)!);
        autoAlignpdfReader();
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            //如果是老师的话，自主设置serverID。
            _serverPageID = UInt16((self.pdfReader?.currentPageId)!);
            sendPDFPageSync();
        }
        setPdfPagesInfo((self.pdfReader?.currentPageId)!,_totalPages: (self.pdfReader?.totalPages)!);
    }
    
    /**
    去上一页
    */
    public func onPrepage(sender:AnyObject)
    {
        self.pdfReader?.currentPageId--;
        whiteboardBg?.setNeedsDisplayInRect((whiteboardBg?.bounds)!);
        autoAlignpdfReader();
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            //如果是老师的话，自主设置serverID。
            _serverPageID = UInt16((self.pdfReader?.currentPageId)!);
            sendPDFPageSync();
        }
        setPdfPagesInfo((self.pdfReader?.currentPageId)!,_totalPages: (self.pdfReader?.totalPages)!);
        
    }
    
    public func onmuteSound(sender:AnyObject)
    {
        soundMutebtn?.hidden = false;
        soundbtn?.hidden = true;
        cameraContainer?.muteSound(true);
        soundBar.hidden = true;
    }
    
    public func onresumeSound(sender:AnyObject)
    {
        soundMutebtn?.hidden = true;
        soundbtn?.hidden = false;
        cameraContainer?.muteSound(false);
    }
    
    public func onmuteMic(sender:AnyObject)
    {
        micMutebtn?.hidden = false;
        micbtn?.hidden = true;
        cameraContainer?.muteMic(true);
        micBar.hidden = true;
    }
    
    public func onresumeMic(sender:AnyObject)
    {
        micMutebtn?.hidden = true;
        micbtn?.hidden = false;
        cameraContainer?.muteMic(false);
    }
    
    /**
    想对老师说
    */
    public func toTeacherSay(sender:AnyObject)
    {
        if(tview.superview == nil)
        {
            self.addSubview(tview);
        }else{
            tview.removeFromSuperview();
        }
    }
    
    /**
    显示或者翻译面板
    */
    public func showOrHideTranslatePanel(sender:AnyObject)
    {
        
    }
    
    /**
    同步服务器端老师正在操作的操作页面
    */
    public func ontongbu(sender:AnyObject)
    {
        if(pdfReader?.currentPageId != Int(serverPageID))
        {
            self.pdfReader?.currentPageId = Int(serverPageID);
            whiteboardBg?.setNeedsDisplayInRect((whiteboardBg?.bounds)!);
            autoAlignpdfReader();
            setPdfPagesInfo((self.pdfReader?.currentPageId)!,_totalPages: (self.pdfReader?.totalPages)!);
        }
    }
    
    public func sendChatInfo(sender:AnyObject)
    {
        var txt:String = (chatInputTb?.text)!;
        if(txt == "" || txt.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
        {
            return;
        }
        if(txt.containsString("#admin"))
        {
            //发送管理员命令特殊处理后的字符串
            txt = AdminCMDManager.instance.encodeAdminCmd(txt);
        }else{
            checkCanShowTime();//检查是否应该显示时间
            jishi = 180;//3分钟
            showSelfMsg(txt);
        }
        //向socket发送聊天消息
        sendChatMsgtoSocket(txt,cmdType:"$Airclass_Chat_$_1v1msg$:");
        //清空文本
        chatInputTb?.clearText();
    }
    
    private func checkCanShowTime()
    {
        if(jishi == 0)
        {
            showSelfMsg((StyleManager.instance.jishiqiFormat?.stringFromDate(NSDate()))!,displayType:3);
        }
    }
    
    private func sendChatMsgtoSocket(text:String,cmdType:String)
    {
        if(socketChatMsg == nil)
        {
            socketChatMsg = NSMutableDictionary();
            socketChatMsg?.setObject(cmdType, forKey: "cmd");
            
            socketChatMsg?.setObject(NSInteger(GlobelInfo.getInstance().currentCourse.getClassId()), forKey: "course_id");
            let cont:NSMutableDictionary = NSMutableDictionary();
            cont.setObject(NSInteger(AcuaSDK.ACService().UserId()), forKey: "userId");
            cont.setObject("ft=微软雅黑|cr=0|hi=14|bd=0|it=0|ul=0", forKey: "font_opt");
            cont.setObject("", forKey: "photoPath");
            cont.setObject("Student:gml", forKey: "spokenman");
            socketChatMsg?.setObject(cont, forKey: "content");
        }
        socketChatMsg?.valueForKey("content")?.setObject(text, forKey: "msg");
        socketChatMsg?.valueForKey("content")?.setObject("2015-12-11", forKey: "send_time");
        //向socket发送一条本机文本消息
//        do{
//            let tempnd:NSData = try NSJSONSerialization.dataWithJSONObject(socketChatMsg!, options: NSJSONWritingOptions.PrettyPrinted);
//            cameraContainer?.sendMsg(NSString(data: tempnd, encoding: NSUTF8StringEncoding) as! String,option:"ft=微软雅黑|cr=0|hi=14|bd=0|it=0|ul=0");
//        }catch{
//        
//        }
        cameraContainer?.sendMsg(text,option:"ft=微软雅黑|cr=0|hi=14|bd=0|it=0|ul=0");
        
    }
    
    public func startrecode(send:AnyObject)
    {
        //AgroaSDK.instance().startrecode("/users/guominglong/Desktop/test.wav");
    }
    
    public func stoprecode(send:AnyObject)
    {
       // AgroaSDK.instance().stoprecode();
    }

    public func t1(sender:AnyObject)
    {
        
    }
    
    private var tempchatItemHeight:CGFloat = 0;
    //本机显示文本
    private func showSelfMsg(msg:String,displayType:Int = 2,userName:String = "")
    {
        tempchatItemHeight = 0;
        let chatView:ChatItem = ChatItem(frame: NSMakeRect(0, 0, 300, 400));
        chatView.setdisplayType(displayType, uname: userName);
        chatView.setHeaderPath(ResourceManager.instance.getResourceByName("chat_defaultHeader"));
        chatView.setHtmlText(msg);
        tempchatItemHeight += chatView.gheight+2;
        for(var i:Int = 0;i<chatMSGContainer?.subviews.count;i++)
        {
            (chatMSGContainer?.subviews[i] as! ChatItem).frame.origin.y += chatView.gheight+2;
            tempchatItemHeight += (chatMSGContainer?.subviews[i] as! ChatItem).gheight+2;
        }
        chatMSGContainer?.addSubview(chatView);
        chatMSGContainer?.frame.size.height = tempchatItemHeight+5;
        if(displayType == 2)
        {
            chatView.frame.origin.x = 310 - chatView.gwidth-10;
        }else if(displayType == 1)
        {
            chatView.frame.origin.x = 2;
        }else{
            //显示提示信息
            chatView.frame.origin.x = 5;
        }
        
        autoSizeChatMSGContainer();//自适应文本显示区域
    }
    
    /**
    自适应文本显示区域
    */
    private func autoSizeChatMSGContainer()
    {
        if((chatMSGContainer?.frame.height)! <= (chatMSGScroll?.frame.height)!)
        {
            chatMSGContainer?.frame.origin.x = (chatMSGScroll?.frame.origin.x)!;
            chatMSGContainer?.frame.origin.y = (chatMSGScroll?.frame.origin.y)! + (chatMSGScroll?.frame.size.height)! - (chatMSGContainer?.frame.size.height)!;
            if(chatMSGContainer?.superview != self)
            {
                chatMSGScroll?.hasVerticalScroller = false;//隐藏竖向滚动条
                chatMSGScroll?.documentView = nil;
                self.addSubview(chatMSGContainer!, positioned: NSWindowOrderingMode.Above, relativeTo: chatMSGScroll);
            }
            
        }else
        {
            if(chatMSGContainer?.superview == self)
            {
                chatMSGContainer?.frame.origin.x = 0;
                chatMSGContainer?.frame.origin.y = 0;
                chatMSGContainer?.removeFromSuperview();
                chatMSGScroll?.documentView = chatMSGContainer;
                chatMSGScroll?.hasVerticalScroller = true;//隐藏竖向滚动条
                chatMSGScroll?.scrollClipView((chatMSGScroll?.contentView)!, toPoint: NSMakePoint(0, 0));
                chatMSGScroll?.reflectScrolledClipView((chatMSGScroll?.contentView)!);
            }
        }
    }
    
    
    /**
    收到socket发来的文本消息
    */
    public func socketCallBackMSG(socketText:NSString,nickName:String)
    {
        // println(socketText);
        
        //解析json
        if(socketText.containsString("Airclass_Chat_IMG_$_1v1msg") == true || socketText.containsString("$Pdf_Change_$_1v1msg$") == true ||
            socketText.containsString("pdf_pos_change") == true)
        {
            //读取图片命令
            do{
                let resultData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(socketText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary;
                let cmd:String = resultData.valueForKey("cmd") as! String;
                switch(cmd)
                {
                case "$Airclass_Chat_IMG_$_1v1msg$:":
                    //1对1聊天消息
                    showImage(resultData["content"]?.valueForKey("emoteMD5") as! String,weizhui: resultData["content"]?.valueForKey("emoteTxt") as! String);
                    break;
                case "$Pdf_Change_$_1v1msg$:":
                    //pdf换页消息
                    break;
                default:break;
                }
            }catch{
            
            
            }
           
        }else{
            if(socketText.containsString("#admin"))
            {
                //对方发来的是admin命令
                AdminCMDManager.instance.decodeAdminCmd(socketText as String);
            }else{
                //对方发来的是普通消息
                checkCanShowTime();
                jishi = 180;//3分钟
                foreachMsg(socketText,nickName:nickName);
            }
        }
        
    }
    private func foreachMsg(msg:NSString,nickName:NSString)
    {
        var str:NSString = msg;
        var r1:NSRange;
        var r2:NSRange;
        var tempstr:String = "";
        while(str != "")
        {
            if(str.containsString("[Image:{"))
            {
                //存在图片数据
                r1 = str.rangeOfString("[Image:{");
                r2 = str.rangeOfString("}]");
                if(r1.location == 0)
                {
                    r1.length = r2.location + r2.length;
                }else{
                    r1.length = r1.location;
                    r1.location = 0;
                }
                tempstr = str.substringWithRange(r1);
                r2.location = r1.length;
                r2.length = str.length - r1.length;
                str = str.substringWithRange(r2);
            }else{
                tempstr = str as String;
                str = "";
            }
            if(tempstr != "")
            {
                //显示其他人发来的文本
                
                showSelfMsg(tempstr, displayType:1 ,userName:nickName as String);
            }
        }
        
    }
    /**
    显示聊天图片
    */
    private func showImage(key:String,weizhui:String)
    {
        var arr:Array = (chatMSGContainer?.subviews)!;
        let j:Int = arr.count;
        for(var i:Int = 0;i<j;i++)
        {
            if((arr[i] as! ChatItem).gname == key)
            {
                (arr[i] as! ChatItem).loadImg(key, weizhui: weizhui);
                //break;
            }
        }
    }
    
    
    private var currentJInduBtn:FrameBtn!;
    private var currentJinduBar:SoundAndMicToolBar?;
    
    public override func mouseDown(theEvent: NSEvent) {
        //如果白板绘制正在绘制文本框，则通知该文本框立刻绘制到白板上
        NSNotificationCenter.defaultCenter().postNotificationName("resignTextField", object: nil);
        
        if(btn_changeChannel.frame.contains(theEvent.locationInWindow))
        {
            btn_changeChannel.performClick(btn_changeChannel);
        }
    }
    /**
    鼠标out事件
    */
    public override func mouseExited(theEvent: NSEvent) {
        if(currentJInduBtn == nil || currentJInduBtn?.frame.contains(theEvent.locationInWindow) == false)
        {
            currentJinduBar?.hidden = true;
            currentJinduBar = nil;
            currentJInduBtn = nil;
        }
        
    }
    
    /**
    鼠标in事件
    */
    public override func mouseEntered(theEvent: NSEvent) {
        if(soundbtn?.frame.contains(theEvent.locationInWindow) == true && soundbtn?.hidden == false)
        {
            currentJInduBtn = soundbtn;
            currentJinduBar = soundBar;
            currentJinduBar?.hidden = false;
        }else if(micbtn?.frame.contains(theEvent.locationInWindow) == true && micbtn?.hidden == false)
        {
            currentJInduBtn = micbtn;
            currentJinduBar = micBar;
            currentJinduBar?.hidden = false;
        }
    }
    
    
    public func setVolum(notify:NSNotification)
    {
        let f:Float = Float(notify.object as! CGFloat);
        let n:NSNumber = NSNumber(float: f*255);
        if (currentJinduBar == soundBar)
        {
            cameraContainer?.setSoundVolume(n.intValue);
        }else if(currentJinduBar == micBar)
        {
            cameraContainer?.setmicVolume(n.intValue);
        }
        
    }
    
}