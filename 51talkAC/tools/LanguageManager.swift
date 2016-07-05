//
//  LanguageManager.swift
//  51talkAC
//
//  Created by guominglong on 16/3/18.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
public class LanguageManager:NSObject{
    private var languageDic:[String:String]!;
    
    private(set) var currentLanguage:String? = "";
    public class var instance:LanguageManager{
        get{
            struct Lan{
                static let ins = LanguageManager();
            }
            return Lan.ins;
        }
    }
    
    override init() {
        super.init();
        if(NSUserDefaults.standardUserDefaults().stringForKey("51talkAC_Language") != nil)
        {
            currentLanguage = NSUserDefaults.standardUserDefaults().stringForKey("51talkAC_Language");
        }else
        {
            let b = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()["NSLanguages"];
            currentLanguage = (b as! NSArray)[0] as? String;
        }
        
        //currentLanguage = "en";//测试用
        let currentDic:NSDictionary?;
        if(currentLanguage == "en")
        {
            let endicPath:String? = NSBundle.mainBundle().pathForResource("localSuport/en_language", ofType: "plist");
            currentDic = NSDictionary(contentsOfFile: endicPath!);
        }else
        {
            let zhdicPath:String? = NSBundle.mainBundle().pathForResource("localSuport/zh_language", ofType: "plist");
            currentDic = NSDictionary(contentsOfFile: zhdicPath!);
        }
        
        if(currentDic != nil)
        {
            languageDic = [String:String]();
            var tempkey:String = "";
            for key in (currentDic?.allKeys)!
            {
                let obj:NSDictionary = (currentDic?.valueForKey(key as! String))! as! NSDictionary;
                let arr:[String] = obj.allKeys as! [String];
                let valueArr:[String] = obj.allValues as! [String];
                for(var i:Int = 0 ;i<arr.count;i++)
                {
                    tempkey = arr[i];
                    languageDic[tempkey] = valueArr[i];
                }
            }
        }
    }
    
    public func getLanguageStr(key:String)->String{
        if(languageDic[key] != nil)
        {
            return languageDic[key]! as String;
        }else{
            return "";
        }
    }
}