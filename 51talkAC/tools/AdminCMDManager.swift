//  管理员命令控制器
//  AdminCMDManager.swift
//  51talkAC
//
//  Created by guominglong on 16/4/29.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation

enum AdminCmd:String{
    case EXIT = "0"
    case UPLOAD_LOG = "1"
}

class AdminCMDManager:NSObject {
    
    /**
     秘钥集合
     */

    let ck = NSString(string: "{971E1D3A-042B-41da-8E97-181F8073D8E2}").UTF8String;
//    let keyArr = [
//        NSString(string: "{971E1D3A-042B-41da-8E97-181F8073D8E2}").UTF8String,
//        NSString(string: "{971004EA-042B-41da-8897-181F8076D8E8}").UTF8String,
//        NSString(string: "{999E1D3A-042B-42Ca-8E97-181F3333D8E9}").UTF8String
//    ]
    
    class var instance:AdminCMDManager{
        get{
            struct AdminIns {
                static var ins:AdminCMDManager = AdminCMDManager();
            }
            return AdminIns.ins;
        }
    }
    
    override init() {
        super.init()
    }
    
    /**
     封装管理员命令
     */
    func encodeAdminCmd(txt:String)->String{
        //进行加密
//        
//        //初始化加密工具
//        AESTool.getInstance().ginit(ck, len: 32);
//        //拆分文本体
//        let t = NSString(string: txt)
//        let th = t.substringWithRange(NSMakeRange(0, 6));
//        var tbodyND:NSData = t.substringWithRange(NSMakeRange(6, t.length - 6)).dataUsingEncoding(NSUTF8StringEncoding)!;
//        //加密
//        tbodyND = AESTool.getInstance().AesEncrypt(UnsafeMutablePointer<UInt8>(tbodyND.bytes), bytesLen: UInt32(tbodyND.length));
//        let result = String(data:tbodyND, encoding: NSUTF16StringEncoding)!
//        return th.stringByAppendingString(result);
//        return txt;
        
        //拆分文本体
        let t = NSString(string: txt)
        let th = t.substringWithRange(NSMakeRange(0, 6));
        let tbodyND:NSData = t.substringWithRange(NSMakeRange(6, t.length - 6)).dataUsingEncoding(NSUTF8StringEncoding)!;
        //加密
        let result = tbodyND.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        return th.stringByAppendingString(result);
    }
    
    /**
    解析管理员命令
    */
    func decodeAdminCmd(txt:String){
        //初始化加密工具
        AESTool.getInstance().ginit(ck, len: 32);
        //拆分文本体
      //  let t = NSString(string: txt)
//        var tbodyND:NSData = t.substringWithRange(NSMakeRange(6, t.length - 6)).dataUsingEncoding(NSUTF16StringEncoding)!;
//        //解密
//        tbodyND = AESTool.getInstance().AesDecrypt(UnsafeMutablePointer<UInt8>(tbodyND.bytes), bytesLen: UInt32(tbodyND.length));
//        let result = String(data:tbodyND, encoding: NSUTF8StringEncoding)!
//        self.execCmd(AdminCmd.EXIT);
        
        var t = NSString(string:txt);
        //解密
        t = t.substringWithRange(NSMakeRange(6, t.length - 6));
        
        do{
            
            let tbodyND = NSData(base64EncodedString: t as String, options: NSDataBase64DecodingOptions(rawValue: 0));
            var result:NSString? = NSString(string:"");
            if(tbodyND == nil)
            {
                result = t as NSString;
            }else{
                result = NSString(data: tbodyND!, encoding: NSUTF8StringEncoding)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if(result == nil)
                {
                    result = "";
                }
            }
            execCmd(result! as String);
        }catch{
        
        }
       
    }
    
    func temp(tbodyND:NSData) throws->Void{
        guard let b = NSString(data: tbodyND, encoding: NSUTF8StringEncoding)else{
            throw MyError.StringJiXiShiBai;//字符串解析失败
        }
    }
    
    
    func execCmd(cmdStr:String){
        
        var arr = cmdStr.componentsSeparatedByString("-");
        arr.removeAtIndex(0);
        if(arr.count > 0)
        {
            let type = arr[0];
            switch(type){
                case AdminCmd.EXIT.rawValue:
                    NSApp.stopModalWithCode(1);
                    NSApplication.sharedApplication().terminate(nil);//关闭程序
                    break;
                case AdminCmd.UPLOAD_LOG.rawValue:
                    ( NSApplication.sharedApplication().delegate as! AcMain).uploadLog();//上传日志
                    break;
                default:NSLog("解析admin命令失败");break;
            }
        }
    }
}

enum MyError: ErrorType {
    case StringJiXiShiBai
    case OutOfRange
}