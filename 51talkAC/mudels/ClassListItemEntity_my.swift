//  1v1 课程列表信息
//  ClassListItemEntity_my.swift
//  AC for swift
//
//  Created by guominglong on 15/5/20.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

public class ClassListItemEntity_my: NSObject {

    /**
    课程ID
    */
    public var cid:String = "";
    public var tag_id:String = "";
    
    /**
    老师ID
    */
    public var t_id:String = "";
    
    /**
    学生ID
    */
    public var s_id:String = "";
    
    /**
    预约的上课时间
    */
    public var start_time:NSDate?;
    
    /**
    课程结束时间
    */
    public var end_time:NSDate?;
    
    public var course_id:String = "";
    public var point_type:String = "";
    public var use_point:String = "";
    
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
    
    /**
    老师头像
    */
    public var tea_pic:String = "";
    public var tea_sign:String = "";
    
    /**
    学生昵称
    */
    public var stu_nick_name:String = "";
    
    public var stu_sign:String = "";
    
    /**
    学生头像
    */
    public var stu_avatar:String = "";
				
    /*体验课多教材用*/
    public var freeCourseSource:String = "";
    
    /**
    教材下载地址
    */
    public var courseSource:String = "";
    
    /**
    课程名称
    */
    public var courseName:String = "";
				
}
