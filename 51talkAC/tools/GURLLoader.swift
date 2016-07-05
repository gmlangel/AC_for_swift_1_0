//
//  GURLLoader.swift
//  AC for swift
//
//  Created by guominglong on 15/4/27.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

class GURLLoader:NSURLConnection, NSURLConnectionDelegate,NSURLConnectionDataDelegate {

    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        
        print(NSString(data: data, encoding: NSUTF8StringEncoding))
    }
    
    //连接失败
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
    }
}
