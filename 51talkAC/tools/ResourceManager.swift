//
//  ResourceManager.swift
//  AC for swift
//
//  Created by guominglong on 15/4/10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class ResourceManager:NSObject
{
    
    var imgSkinDic:Dictionary<String,NSImage>?;
    
    public var rect0:CGRect = CGRect(x: 12, y: 5, width: 131, height: 19);
    
    public var rect1:CGRect = CGRect(x: 5, y: 5, width: 131, height: 19);
    class var instance:ResourceManager
        {
        get{
            if InstanceManager.instance().getModuleInstaceByName("ResourceManager") == nil
            {
                let myIns:ResourceManager = ResourceManager();
                InstanceManager.instance().addModuleInstance(myIns, nameKey: "ResourceManager");
            }
            return InstanceManager.instance().getModuleInstaceByName("ResourceManager") as! ResourceManager;
        }
    }
    
    override init() {
        
        imgSkinDic = [String:NSImage]();
        
        super.init();
    }
    
    public func getResourceByName(sourceName:String)->NSImage
    {
       if imgSkinDic![sourceName] == nil
       {
        imgSkinDic![sourceName] = NSImage(named: sourceName);
       }
        return imgSkinDic![sourceName]!;
    }
    
    public func hasSource(sourceName:String)->Bool
    {
        return (imgSkinDic![sourceName] == nil);
    }
    
    /**
     加载网络，或者文件夹资源
    */
    public func getResourceByURL(sourceName:String,sourcePath:String)->NSImage?{
        if(imgSkinDic![sourceName] == nil)
        {
            let url:NSURL = NSURL(string: sourcePath)!;
            imgSkinDic![sourceName] = NSImage(contentsOfURL: url);
        }
        return imgSkinDic![sourceName];
    }
}