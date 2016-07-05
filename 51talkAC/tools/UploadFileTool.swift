//
//  UploadFileTool.swift
//  AC for swift
//
//  Created by guominglong on 16/1/27.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
public class UploadFileTool:NSObject{
    
    private var tf1:NSDateFormatter!;
    private var tf2:NSDateFormatter!;
    public var currentFilePath:String!;
    public override init()
    {
        tf1 = NSDateFormatter();
        tf1.dateFormat = "yyyy-MM-dd";
        
        tf2 = NSDateFormatter();
        tf2.dateFormat = "yyyyMMddHHmmss";
    }
    
    /**
     POST方式向服务器上传文件流
     */
    public func uploadFileData(utf8Data:NSData,uid:UInt64=0,mimaType:NSString = "application/octet-stream")
    {
        let date:NSDate = NSDate();
        let fileName:String = "\(tf2.stringFromDate(date))&S_\(uid).logs";
        
        // 文件上传
        let tongyong:String = "Maclog";
        let url:NSURL = NSURL(string: "http://v0.api.upyun.com/talk51/ac/LogsNew/logs/\(tf1.stringFromDate(date))/S_\(uid)/")!;
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url);
        request.HTTPMethod = "POST";
        
        let body:NSMutableData = NSMutableData();
        body.appendData(utf8Encode("--\(tongyong)\r\n"));
        body.appendData(utf8Encode("Content-Disposition: form-data; name=\"\(fileName.utf8)\"; filename=\"\(fileName)\"\r\n"));
        body.appendData(utf8Encode("Content-Type: \(mimaType)\r\n"));
        
        body.appendData(utf8Encode("\r\n"));
        body.appendData(utf8Data);
        body.appendData(utf8Encode("\r\n"));
        body.appendData(utf8Encode("--\(tongyong)--\r\n"));
        request.HTTPBody = body;
        request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length");
        request.setValue("multipart/form-data; boundary=\(tongyong)", forHTTPHeaderField: "Content-Type");

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: httpCallBack);
    }
    //body.appendData(utf8Encode("Authorization:Basic eGlhb2NodW46YmJqSiUldzg=\r\n"));
   // body.appendData(utf8Encode("mkdir:true\r\n"));
    
    
    /**
    PUT方式向服务器提交文件
    */
    public func uploadFileByPath(dictoryPath:String,uid:UInt64=0,extensionName:String="S")
    {
        let date:NSDate = NSDate();
        let fileName:String = "\(tf2.stringFromDate(date))&\(extensionName)_\(uid).logs";
        //var urlStr:String = "http://v0.api.upyun.com/acvideo/test/";
        var urlStr:String = "http://v0.api.upyun.com/talk51/ac/LogsNew/logsmac/\(tf1.stringFromDate(date))/\(extensionName)_\(uid)/";
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        
        beginUploadlogFile(dictoryPath,urlStr:urlStr,urlFileName: fileName);
   
    }
    //
    /**
     PUT方式向服务器提交崩溃日志
     */
    public func uploadCrashByPath(filePath:String,uid:UInt64=0,extensionName:String="S")
    {
        currentFilePath = filePath;
        let date:NSDate = NSDate();
        let fileName:String = "\(tf2.stringFromDate(date))&\(extensionName)_\(uid).crash";
        var urlStr:String = "http://v0.api.upyun.com/talk51/ac/LogsNew/crashmac/\(tf1.stringFromDate(date))/\(GlobelInfo.getInstance().appVersion)/\(GlobelInfo.getInstance().appVersion)&\(fileName)";
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        beginUploadFile(filePath,urlStr: urlStr,_completionHandler: httpCallBack3);
    }
    
    /**
     上传普通日志
     */
    private func beginUploadlogFile(dic:String,urlStr:String,urlFileName:String)
    {
        var files:[String] = [];
        do{
            let tempFiles:[String] = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(dic);
            for f in tempFiles{
                if(f.containsString("acua") || f.containsString("acme")){
                    files.append(f);
                }
            }
        }catch{
            
        }
        var args:[String] = [dic,"log",urlStr,urlFileName];
        args += files;
        NSTask.launchedTaskWithLaunchPath(NSBundle.mainBundle().pathForResource("Uploadlog", ofType: "")!, arguments: args);
    }
    
    /**
     开始上传崩溃
     */
    public func beginUploadFile(filePath:String,urlStr:String,_completionHandler:(NSData?,NSURLResponse?,NSError?)->Void)
    {
        let url:NSURL = NSURL(string: urlStr)!;
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url);
        request.HTTPMethod = "PUT";
        request.addValue("Basic eGlhb2NodW46YmJqSiUldzg=", forHTTPHeaderField: "Authorization");
        request.addValue("true", forHTTPHeaderField: "mkdir");
        let len:Int = (NSData(contentsOfFile: filePath)?.length)!;
        request.setValue(String(len), forHTTPHeaderField: "Content-Length");
        
        let session:NSURLSession = NSURLSession.sharedSession();
        let nd:NSData = NSData(contentsOfFile: filePath)!;
        session.uploadTaskWithRequest(request, fromData: nd, completionHandler: _completionHandler).resume();
    }
    
    func httpCallBack3(nd:NSData?,ns:NSURLResponse?,ne:NSError?)->Void
    {
        if(nd == nil)
        {
            NSNotificationCenter.defaultCenter().postNotificationName("uploadCrashCallBack", object: "faild");
        }else
        {
            let result:NSString = NSString(data: nd!, encoding: NSUTF8StringEncoding)!;
            NSLog(result as String);
            NSNotificationCenter.defaultCenter().postNotificationName("uploadCrashCallBack", object: "complete");
        }
    }
    
    
    func httpCallBack2(nd:NSData?,ns:NSURLResponse?,ne:NSError?)->Void
    {
        if(nd == nil)
        {
            NSNotificationCenter.defaultCenter().postNotificationName("uploadCallBack", object: ["state":"faild","path":currentFilePath]);
        }else
        {
            let result:NSString = NSString(data: nd!, encoding: NSUTF8StringEncoding)!;
            NSLog(result as String);
            NSNotificationCenter.defaultCenter().postNotificationName("uploadCallBack", object: ["state":"complete","path":currentFilePath]);
        }
    }
    
    
    func httpCallBack(ns:NSURLResponse?,nd:NSData?,ne:NSError?)->Void
    {
        if(nd == nil)
        {
            NSNotificationCenter.defaultCenter().postNotificationName("uploadCallBack", object: "faild");
        }else
        {
            let result:NSString = NSString(data: nd!, encoding: NSUTF8StringEncoding)!;
            NSLog(result as String);
            NSNotificationCenter.defaultCenter().postNotificationName("uploadCallBack", object: "complete");
        }
    }
    
    public func utf8Encode(str:String)->NSData
    {
        return str.dataUsingEncoding(NSUTF8StringEncoding)!;
    }
}