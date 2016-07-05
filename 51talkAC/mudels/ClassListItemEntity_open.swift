//  空开课课程列表信息
//  ClassListItemEntity_open.swift
//  AC for swift
//
//  Created by guominglong on 15/5/20.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

public class ClassListItemEntity_open: NSObject {

    /**
    课程ID
    */
    public var cid:String = "";
    
    /**
    老师ID
    */
    public var t_id:String = "";
    
    /**
    是否可以自由翻页教材
    */
    public var pdf_page:String = "";
    
    /**
    预约的上课时间
    */
    public var start_time:NSDate?;
    
    
    /**
    课程结束时间
    */
    public var end_time:NSDate?;
    
    /**
    服务器当前时间
    */
    public var server_date:NSDate?;
    
    /*课程类型 person:1v1  open:公开课  small_*:小班课*/
    public var course_type:String = "";
    
    /**
    老师昵称
    */
    public var tea_real_name:String = "";
    

    public var tea_sign:String = "";
    
    
    /**
    教材下载地址
    */
    public var courseSource:String = "";
    
    /**
    课程名称
    */
    public var courseName:String = "";
    
    /**
    课程图标
    */
    public var course_pic:String = "";
				
    public var book_tag:Bool = false;
    public var course_begin:Bool = false;
    /*连接到网站的课程介绍页*/
    public var web_site_url:String="";
    
    /*当前已经预约该课程的学生人数*/
    public var total_stu:Int = 0;
			
    /*公开课用于登陆YY的课程ID*/
    public var yy_room_number:String = "";
				
}
