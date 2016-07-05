//  我的课表模块
//  ClassList_qingdan.swift
//  AC for swift
//
//  Created by guominglong on 15/5/21.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
public class ClassList_qingdan: NSView {
    
    private var courseArr:[Course]!;
    private var sourceFrame:NSRect?;
    public override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
    
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        courseArr = [];
        sourceFrame = NSMakeRect(frameRect.origin.x, frameRect.origin.y, frameRect.size.width, frameRect.size.height);
    }
    
    public required init!(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    public func fillInfo(obj:CourseVector,type:String)
    {
        jiexishujv(obj,type:type);
        
        fillinPanel();
    }
    
    /**
    解析数据
    */
    private func jiexishujv(obj:CourseVector,type:String)
    {
        //删除已经上过的课程
        let tj:UInt = obj.size();
        courseArr.removeAll();
        for(var i:UInt = 0;i<tj;i++)
        {
            courseArr.append(obj.get(i));
        }
        var cos:Course;
        
        if(type == "btn_myClass")
        {
            //1对1课程
            
            let j:Int = courseArr.count;
            for(var i:Int = 0;i<j;i++)
            {
                //冒泡排序， 时间最早的放在数组最前位置
                for(var z:Int = i+1; z<j;z++)
                {
                    if(getStartTime(courseArr[z]) < getStartTime(courseArr[i]))
                    {
                        //交换位置
                        cos = courseArr[i];
                        courseArr[i] = courseArr[z];
                        courseArr[z] = cos;
                    }
                }
            }
        }else if(type == "btn_openClass")
        {
            //公开课
        }else{
            //小班课
        }
    }
    
    
    private func getStartTime(obj:Course)->NSTimeInterval
    {
        return (StyleManager.instance.jishiqiFormat?.dateFromString(obj.getStartTime()))!.timeIntervalSince1970;
    }
    
    private var tempRange:NSRange = NSMakeRange(0, 10);
    /**
    将数据填充到显示列表
    */
    private func fillinPanel()
    {
        var arr:NSArray = self.subviews as NSArray;
        var i:Int = 0;
        var j:Int = arr.count;
        
        //清除所有的显示对象
        for(;i<j;i++)
        {
            (arr[i] as! NSView).removeFromSuperview();
        }
        
        //还原窗口的尺寸
        self.frame.size.height = (sourceFrame?.size.height)!;
        
        //重新添加
        var ii:Int = courseArr.count;
        var ty:CGFloat = 0;
        var ci:ClassListItem;
        let frameWid:CGFloat = self.frame.width;
        var cos:Course;
        var date:String = "";
        let b:Bool = AcuaSDK.ACService().RoleType() == "stu";
        for(;ii>0;)
        {
            ii--;
            cos = courseArr[ii];
            //cos.GetString("status", defaultValue: "") != "on" 这个状态指代 非预约状态
            if(cos.getCourseTypeId() != 0)
            {
                //不是1对1课程
                continue;
            }
            
            if(b  && (cos.getCourseTypeId() == 0 && cos.GetString("status", defaultValue: "") != "on"))
            {
                //老师缺席
                continue;
            }
            
            ci = ClassListItem(type: "person",frameRect: NSMakeRect(0, ty, frameWid, 145));
            addSubview(ci);//添加到显示列表
            let stT:NSString = cos.getStartTime();
            if(date == "")
            {
               date = stT.substringWithRange(NSMakeRange(0, 10));
            }
            if(ii == 0 || getTimeStr(cos) != getTimeStr(courseArr[ii-1]))
            {
                date = stT.substringWithRange(NSMakeRange(0, 10));
                ci.fillInfo(cos,dateStr: date);//填充数据
            }else{
                ci.fillInfo(cos, dateStr: "");
            }
            ty += ci.frame.size.height;
            ci.btn_joinRoom?.target = self;
            ci.btn_joinRoom?.action = Selector("onjoinRoom:");
            if(ty > sourceFrame?.height)
            {
                self.frame.size.height = ty;
            }
            
        }
        //如果显示内容的高度小于预期高度，则将像是内容显示到窗口的上方
        if(ty < sourceFrame?.height)
        {
            ty = (sourceFrame?.height)! - ty;
            arr = self.subviews as NSArray;
            i = 0;
            j = arr.count;
            for(;i<j;i++)
            {
                //println((arr[i] as NSView));
                (arr[i] as! NSView).frame.origin.y = (arr[i].frame.origin.y) + ty;
            }
        }
    }
    
    public func getTimeStr(cos:Course)->NSString{
        return (cos.getStartTime() as NSString).substringWithRange(tempRange);
    }
    
    
    /**
    进入教室
    */
    public func onjoinRoom(sender:AnyObject)
    {
        
        let classID:UInt64 = UInt64((sender as! NSButton).identifier! as String)!;
        var cos:Course = Course();
        var b:Bool=false;
        let j:Int = courseArr.count;
        for (var i:Int=0;i<j;i++)
        {
            if(courseArr[i].getClassId() == classID)
            {
                cos = courseArr[i];
                b = true;
                break;
            }
        }
        if(b == true)
        {
            GlobelInfo.getInstance().currentCourse = cos;
            
            //切换到教室页面
            (InstanceManager.instance().getModuleInstaceByName("stroyClassList")as! ClassListPage).goOneToOneClassRoom(sender);
            
            //调用进入教室日志接口
            uploadJoinRoomLog();
        }
        
    }
    
    /**
     上传进入教室的日志
     */
    func uploadJoinRoomLog()
    {
        func onComplete(ns:NSURLResponse?,nd:NSData?,err:NSError?)->Void{
            if(err == nil)
            {
                do{
                    let resultData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(nd!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary;
                    
                    NSLog("%d", (resultData.valueForKey("code")?.integerValue)!);
                   
                }catch{
                    
                }
                
            }
        }
        let urlrequest:NSURLRequest = NSURLRequest(URL: NSURL(string: NSString(format: GMLConfig.inOutRoomInterface,"min",AcuaSDK.ACService().UserId(),"private",GlobelInfo.getInstance().currentCourse.getClassId(),GlobelInfo.getInstance().currentCourse.getClassId(),AcuaSDK.ACService().RoleType()) as String)!);
        
        NSURLConnection.sendAsynchronousRequest(urlrequest, queue: NSOperationQueue.mainQueue(), completionHandler: onComplete)
    }
}
