//  课程列表项
//  ClassListItem.swift
//  AC for swift
//
//  Created by guominglong on 15/5/21.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
public class ClassListItem: NSView {

    /**
    类型 person:1v1  open:公开课  small_*:小班课
    */
    private var _gtype:NSString = "";
    
    private var bg:NSView!;
    private var mc_point1:NSImageView!;
    private var mc_point1Start:NSImageView!;
    private var mc_point2:NSImageView!;
    private var mc_point2Start:NSImageView!;
    
    private var classLine1:NSImageView!;
    private var classLine2:NSImageView!;
    
    private var tb_startTime:NSTextField!;//开课时间
    private var tb_endTime:NSTextField!;//结束时间
    private var lessonheader:NSImageView!;//课程的头像
    private var tb_courseTypeName:NSTextField?;//课程类型，名称
    private var tb_teacherNameAndCourseName:NSTextField?;//老师昵称 + 课程名称
    private var tb_details:NSTextField?;//课程描述
    public var currentCourse:Course!;//课程信息
    
    public var btn_joinRoom:FrameColorBtn!;//进入教室按钮
    public var btn_quxiaoyuyue:NSButton?;//取消预约
    private var canvas:CGContextRef?;
    
    /**
    离开课时间的倒计时时间戳
    */
    private var beginOffset:NSTimeInterval! = 0;
    
    /**
    倒计时文本框
    */
    private var tb_daojiashiTime:NSTextField!;
    
    /**
    日期条
    */
    private var dateBar:NSView!;
    private var dateBarTb:NSTextField!;
    private var needDateBar:Bool!;
    
    /**
     是否已经上完课
     */
    private var isEnd:Bool = false;
    public override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        canvas = NSGraphicsContext.currentContext()?.CGContext
        //设置线条样式
        CGContextSetLineCap(canvas, CGLineCap.Round);
        //设置线条粗细宽度
        CGContextSetLineWidth(canvas, 1);
        //设置颜色
        CGContextSetRGBStrokeColor(canvas, 0xde/255.0,0xde/255.0,0xde/255.0,1);
        //开始一个起始路径
        CGContextBeginPath(canvas);
        CGContextMoveToPoint(canvas, 108, 2);
        CGContextAddLineToPoint(canvas, self.frame.width-10, 2);
        if(needDateBar == true)
        {
            CGContextMoveToPoint(canvas, 20, dateBar.frame.origin.y);
            CGContextAddLineToPoint(canvas, self.frame.width-10, dateBar.frame.origin.y);
        }
        CGContextStrokePath(canvas);
        // Drawing code here.
        
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public init(type:String,frameRect:NSRect)
    {
        _gtype = type;
        super.init(frame: frameRect);
        let bglayer:CALayer = CALayer();
        
        //添加热区层，用于接收鼠标移动移入，移出监听
        self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false);
        
        var rect:NSRect = NSRect(x: 10, y: 40, width: 60, height: 25);
        //绘制背景
        var rightbg:NSImageView!;//右侧背景
        var leftbg:NSImageView!;//左侧背景
        bg = NSView(frame: self.bounds);
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = 100;
        rect.size.height = self.frame.size.height;
        leftbg = NSImageView(frame: rect);
        bg.addSubview(leftbg);
        leftbg.image = ResourceManager.instance.getResourceByName("itemleftbg");
        rect.origin.x = 100;
        rect.origin.y = 0;
        rect.size.width = self.frame.size.width-100;
        rect.size.height = self.frame.size.height;
        rightbg = NSImageView(frame: rect);
        bg.addSubview(rightbg);
        rightbg.layer = bglayer;
        bglayer.backgroundColor = StyleManager.instance.color3.CGColor;
        addSubview(bg);
        bg.hidden = true;
        
        //小点
        rect.origin.x = 17;
        rect.origin.y = 108;
        rect.size.width = 24;
        rect.size.height = 24;
        mc_point1 = NSImageView(frame: rect);
        mc_point1.image = ResourceManager.instance.getResourceByName("class_itemicon1");
        mc_point1Start = NSImageView(frame: rect);
        mc_point1Start.image = ResourceManager.instance.getResourceByName("class_itemicon2");
        addSubview(mc_point1);
        addSubview(mc_point1Start);
        
        rect.origin.x = 17;
        rect.origin.y = 30;
        rect.size.width = 24;
        rect.size.height = 24;
        mc_point2 = NSImageView(frame: rect);
        mc_point2.image = ResourceManager.instance.getResourceByName("class_itemicon1");
        mc_point2Start = NSImageView(frame: rect);
        mc_point2Start.image = ResourceManager.instance.getResourceByName("class_itemicon2");
        bg.addSubview(mc_point2);
        //bg.addSubview(mc_point2Start);
        
        rect.size.height = 62;
        rect.origin.x = 18;
        rect.origin.y = 50;
        classLine1 = NSImageView(frame: rect);
        classLine1.image = ResourceManager.instance.getResourceByName("classLine1");
        
        classLine2 = NSImageView(frame: rect);
        classLine2.image = ResourceManager.instance.getResourceByName("classLine2");
        //bg.addSubview(classLine1);
        //bg.addSubview(classLine2);
        //课程开始时间
        rect.origin.x = 48;
        rect.origin.y = 108;
        rect.size.width = 100;
        rect.size.height = 25;
        tb_startTime = getTb(StyleManager.instance.nsfont7!,color: StyleManager.instance.color2,rect:rect);
        addSubview(tb_startTime!);
        
        rect.origin.y = 30;
        tb_endTime = getTb(StyleManager.instance.nsfont7!,color: StyleManager.instance.color2,rect:rect);
        //bg.addSubview(tb_endTime!);
        
        
        
        //课程缩略图
        rect.origin.x = 108;
        rect.origin.y = 29;
        rect.size.width = 132;
        rect.size.height = 102;
        lessonheader = NSImageView(frame: rect);
        lessonheader.wantsLayer = true;
        lessonheader.layer?.backgroundColor = NSColor.whiteColor().CGColor;
        lessonheader.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        addSubview(lessonheader);
        
        //课程类型名称
        rect.size.width = 132;
        rect.size.height = 25;
        let courseTypeNamebg:NSView = NSView(frame: rect);
        courseTypeNamebg.layer = CALayer();
        courseTypeNamebg.layer?.backgroundColor = NSColor(red: 0.0, green: 0, blue: 0, alpha: 0.5).CGColor;
        addSubview(courseTypeNamebg);
        tb_courseTypeName = getTb(StyleManager.instance.nsfont7!,color: NSColor.whiteColor(),rect:rect);
        tb_courseTypeName?.alignment = NSTextAlignment.Center;
        addSubview(tb_courseTypeName!);
        
        //老师名称+课程名称
        rect.origin.x = 259;
        rect.origin.y = 108 - 25;
        rect.size.width = self.frame.width-250;
        rect.size.height = 50;
        tb_teacherNameAndCourseName = getTb(StyleManager.instance.nsfont7!,color: StyleManager.instance.color2,rect:rect);
        tb_teacherNameAndCourseName?.cell?.wraps = true;
        addSubview(tb_teacherNameAndCourseName!);
        
        
        rect.origin.x = 259;
        rect.origin.y = 84;
        rect.size.width = self.frame.width-270;
        rect.size.height = 25;
        tb_details = getTb(StyleManager.instance.nsfont7!,color: StyleManager.instance.color1!,rect:rect);
        if(AcuaSDK.ACService().RoleType() != "stu")
        {
            addSubview(tb_details!);
        }
        
        rect.origin.x = 259;
        rect.origin.y = 29;
        btn_joinRoom = FrameColorBtn(_enabledImgskin: ResourceManager.instance.getResourceByName("btn_joinroom_enable"), _disabledImgskin: ResourceManager.instance.getResourceByName("btn_joinroom_disable"), _enabledThirdColorArr: [NSColor.whiteColor(),NSColor.whiteColor(),NSColor.whiteColor()], _disabledThirdColorArr: [StyleManager.instance.color2,StyleManager.instance.color2,StyleManager.instance.color2]);
        
        btn_joinRoom.setText(LanguageManager.instance().getLanguageStr("btn_joinRoomText"), tfont: StyleManager.instance.nsfont7!);
        btn_joinRoom.tb.frame.size.height = 23;
        btn_joinRoom.tb.frame.origin.y = 5;
        addSubview(btn_joinRoom!);
        btn_joinRoom.frame.origin = rect.origin;
        
        //课程开始时间倒计时
        rect.origin.x = 259 + btn_joinRoom.bounds.size.width + 20;
        rect.origin.y = 32;
        rect.size.width = 400;
        rect.size.height = 25;
        tb_daojiashiTime = getTb(StyleManager.instance.nsfont7!,color: StyleManager.instance.color1,rect:rect);
        bg.addSubview(tb_daojiashiTime);
        
        rect.origin.x = 590;
        rect.origin.y = 75;
        rect.size.width = 80;
        rect.size.height = 20;
        btn_quxiaoyuyue = NSButton(frame: rect);
        btn_quxiaoyuyue?.title = "取消预约";
        //addSubview(btn_quxiaoyuyue!);
        
        rect.origin.x = 0;
        rect.origin.y = self.bounds.size.height;
        rect.size.width = self.bounds.size.width;
        rect.size.height = 40;
        dateBar = NSView(frame: rect);
        
        rect.origin.x = 20;
        rect.origin.y = 5;
        rect.size.width = 400;
        rect.size.height = 25;
        dateBarTb = getTb(StyleManager.instance.nsfont7!,color: StyleManager.instance.color2,rect:rect);
        dateBar.addSubview(dateBarTb);
        
        //enableOrUnable(true);
        
        
    }
    
    /**
    更新课程状态
    */
    public func updateCourse()
    {
        if(isEnd == true)
        {
            return;
        }
        if(mc_point1.hidden == true || AcuaSDK.ACService().RoleType() != "stu")
        {
            tb_daojiashiTime.stringValue = "";//"课程已开始";
            return;
        }
        beginOffset = beginOffset - 1;
        if(beginOffset <= 3600 && beginOffset >= -300)
        {
            //课前1小时，课后5分钟（PS：上课时间为30分钟）
            enableOrUnable(true);
        }else
        {
            if(beginOffset > 3600)
            {
                tb_daojiashiTime.stringValue = String(format:LanguageManager.instance().getLanguageStr("tb_daojiashiTimeText1"),getBeginOffsetStr());
            }else{
                enableOrUnable(false);
                tb_daojiashiTime.stringValue = LanguageManager.instance().getLanguageStr("tb_daojiashiTimeText2");
            }
            
        }
        
    }
    
    private func getTb(font:NSFont,color:NSColor,rect:NSRect)->NSTextField
    {
        let tb:NSTextField = NSTextField(frame: rect);
        tb.bordered = false;
        tb.font = font;
        tb.textColor = color;
        tb.backgroundColor = NSColor.clearColor();
        tb.editable = false;
        tb.alignment = NSTextAlignment.Left;
        return tb;
    }
    
    /**
    开启或者禁用
    */
    public func enableOrUnable(b:Bool)
    {
        if(GlobelInfo.getInstance().CustomAppConfigDic.keys.contains("canjoinroom"))
        {
            if((GlobelInfo.getInstance().CustomAppConfigDic["canjoinroom"] as! String) == "1")
            {
                btn_joinRoom.setGEnable(true);
            }else{
                btn_joinRoom.setGEnable(b);
            }
        }else{
            btn_joinRoom.setGEnable(b);
        }
        mc_point1Start.hidden = !b;
        mc_point1.hidden = b;
        mc_point2Start.hidden = !b;
        mc_point2.hidden = true;
        classLine1.hidden = b;
        classLine2.hidden = !b;
        
//        btn_joinRoom.setGEnable(true);
//        mc_point1Start.hidden = false;
//        mc_point1.hidden = true;
//        mc_point2Start.hidden = false;
//        mc_point2.hidden = true;
//        classLine1.hidden = true;
//        classLine2.hidden = false;
    }
    
    public func fillInfo(obj:Course,dateStr:String)
    {
        let teaFormat:String = LanguageManager.instance().getLanguageStr("tb_teaAndCourse");
        needDateBar = false;
        //展开的样式
        if(_gtype == "person")
        {
            //1v1
            currentCourse = obj;
            var date:NSDate = (StyleManager.instance.jishiqiFormat?.dateFromString(currentCourse.getStartTime()))!;
            
            tb_startTime?.stringValue = (StyleManager.instance.tf3?.stringFromDate(date))!;
            
            let date2:NSDate = (StyleManager.instance.jishiqiFormat?.dateFromString(currentCourse.GetString("serverDate", defaultValue: "2015-01-01 00:00:00")))!;
            if(date.timeIntervalSince1970 >= date2.timeIntervalSince1970)
            {
                beginOffset = date.timeIntervalSince1970 - date2.timeIntervalSince1970
                tb_daojiashiTime.stringValue = String(format:LanguageManager.instance().getLanguageStr("tb_daojiashiTimeText1"),getBeginOffsetStr());
            }else if(date.timeIntervalSince1970 + 30 * 60 < date2.timeIntervalSince1970){
                beginOffset = date.timeIntervalSince1970 - date2.timeIntervalSince1970
                tb_daojiashiTime.stringValue = LanguageManager.instance().getLanguageStr("tb_daojiashiTimeText2");
                isEnd = true;
            }else{
                beginOffset = 0;
                tb_daojiashiTime.stringValue = LanguageManager.instance().getLanguageStr("tb_daojiashiTimeText3");
            }
            
            if(AcuaSDK.ACService().RoleType() == "tea")
            {
                tb_daojiashiTime.stringValue = "";
            }
            
            if(beginOffset < 0)
            {
                //课程已经结束
                enableOrUnable(false);
            }
            else if(beginOffset <= 3600)
            {
                //一小时之内的课程
                enableOrUnable(true);
            }else{
                if(AcuaSDK.ACService().RoleType() == "tea")
                {
                    enableOrUnable(true);//课前老师任何时间都可以进入教室
                }else{
                    enableOrUnable(false);
                }
            }
            date = (StyleManager.instance.jishiqiFormat?.dateFromString(currentCourse.GetString("endTime", defaultValue: currentCourse.getStartTime()!)))!;
            tb_endTime?.stringValue = (StyleManager.instance.tf3?.stringFromDate(date))!;
            let strpath:String = currentCourse.GetString("teaPic", defaultValue: "");
            if(strpath != "")
            {
                loadlessonimg(NSURL(string: strpath)!);//加载课程图片
            }else{
                lessonheader.image = ResourceManager.instance.getResourceByName("1v1Default");
            }
            tb_courseTypeName?.stringValue = LanguageManager.instance().getLanguageStr("tb_courseTypeNameText");
            tb_teacherNameAndCourseName?.stringValue = NSString(format: teaFormat, (currentCourse.getTeacherName())!,(currentCourse.getCourseName())!) as String;
            tb_teacherNameAndCourseName?.frame.size = (tb_teacherNameAndCourseName?.cell?.cellSizeForBounds((tb_teacherNameAndCourseName?.bounds)!))!;
            tb_teacherNameAndCourseName?.frame.origin.y = 142 - (tb_teacherNameAndCourseName?.frame.size.height)! - 10;
            
            
            if(AcuaSDK.ACService().RoleType() == "stu")
            {
                tb_details?.stringValue = NSString(format: LanguageManager.instance().getLanguageStr("tb_detailsFormaterText1"), (currentCourse.GetString("total_stu", defaultValue: "0"))!) as String;
            }else{
                tb_details?.stringValue = NSString(format: LanguageManager.instance().getLanguageStr("tb_detailsFormaterText2"), (currentCourse.GetString("courseClassName", defaultValue: ""))!) as String;
            }
            
            tb_details?.frame.origin.y = (tb_teacherNameAndCourseName?.frame.origin.y)! - 30;
            btn_joinRoom?.identifier = String(currentCourse.getClassId());
            if(dateStr != "")
            {
                needDateBar = true;
                addSubview(dateBar);
                self.frame.size.height += dateBar.frame.size.height;
                dateBarTb.stringValue = dateStr;
            }
        }
        
        self.setNeedsDisplayInRect(self.bounds);
    }
    
    /**
    获得倒计时字符串
    */
    private func getBeginOffsetStr()->String
    {
        let d:Int = Int(beginOffset/86400);
        if(d == 0)
        {
           return String(format:LanguageManager.instance().getLanguageStr("tb_daojiashiTimeFormat1"),Int(beginOffset/3600%24),Int((beginOffset/60)%60),Int(beginOffset%60));
        }else{
            return String(format:LanguageManager.instance().getLanguageStr("tb_daojiashiTimeFormat2"),d,Int(beginOffset/3600%24),Int((beginOffset/60)%60),Int(beginOffset%60));
            //"\(d)天\(Int(beginOffset/3600%24))小时\(Int((beginOffset/60)%60))分\(Int(beginOffset%60))秒"
        }
        
        //StyleManager.instance.daojishiFormat.stringFromDate(NSDate(timeIntervalSince1970: beginOffset));
    }
    
    /**
    加载课程缩略图
    */
    private func loadlessonimg(url:NSURL)
    {
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue.mainQueue(), completionHandler: onlessonimgCallback);
    }
    
    func onlessonimgCallback(ns:NSURLResponse?,data:NSData?,err:NSError?)->Void
    {
        if(err == nil)
        {
            lessonheader.image = NSImage(data: data!);
        }else
        {
            //调用失败
            GLogger.print("课程图像加载失败");
        }
        
    }
    
    //mouseOut
    public override func mouseExited(theEvent: NSEvent) {
        
        bg.hidden=true;
        
    }
    
    
    //mouseOver
    public override func mouseEntered(theEvent: NSEvent) {
        bg.hidden=false;
        
    }
    
}
