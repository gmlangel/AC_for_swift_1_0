//
//  GMLConfig.swift
//  AC for swift
//
//  Created by guominglong on 15/4/27.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

class GMLConfig: NSObject {

    
   class var loginInterface:NSString {
        get{
            return "http://www.51talk.com/Api/Im/user_login?user_name=%@&password=%@";
        }
    }
    
    class var classListInterface: NSString {
        get{
            return "http://www.51talk.com/Api/Im/stu_reserve_list_new?stu_id=%@";
        }
        
    }
    
    class var binnerPath:NSString{
        get{
            return "http://www.51talk.com/Ac/User/getAcBanner?occup=%@&user_type=%d&buildver=%@&lang=En";
        }
    }
    
    /**
     进出教室的日志
     */
    class var inOutRoomInterface: NSString {
        get{
            return "http://www.51talk.com/Ac/Log/loginRoom?type=%@&userId=%d&roomType=%@&roomId=%d&classId=%d&userType=%@";
        }
        
    }
}
