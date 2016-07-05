//
//  StyleManager.swift
//  AC for swift
//
//  Created by guominglong on 15/4/10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation

public class StyleManager:NSObject{
    
    
    class var instance:StyleManager
    {
        get{
            if InstanceManager.instance().getModuleInstaceByName("StyleManager") == nil
            {
                let myIns:StyleManager = StyleManager();
                InstanceManager.instance().addModuleInstance(myIns, nameKey: "StyleManager");
            }
            return InstanceManager.instance().getModuleInstaceByName("StyleManager") as! StyleManager;
        }
    }
    public var nsfont1:NSFont?;
    public var nsfont2:NSFont?;
    public var nsfont4:NSFont?;
    public var nsfont5:NSFont!;
    public var nsfont6:NSFont!;
    public var nsfont7:NSFont!;
    public var nscolor1:NSColor?;
    public var nscolor2:NSColor?;
    //#999999
    public var color1:NSColor!;
    
    //#333333
    public var color2:NSColor!;
    
    //f7f7f7
    public var color3:NSColor!;
    //ff8200
    public var color4:NSColor!;
    
    public var jishiqiFormat:NSDateFormatter?;
    public var daojishiFormat:NSDateFormatter!;
    /**
    几月几日
    */
    public var tf2:NSDateFormatter?;
    
    /**
    几点几分
    */
    public var tf3:NSDateFormatter?;
    public override init() {
        
        super.init();
        nsfont1 = NSFont(name: "Helvetica Neue", size: 16);
        nsfont2 = NSFont(name: "Heiti SC", size: 12);
        nsfont4 = NSFont(name: "Heiti SC", size: 10);
        nsfont5 = NSFont(name: "Helvetica Neue", size: 13);
        nsfont6 = NSFont(name: "Helvetica Neue", size: 12);
        nsfont7 = NSFont(name: "Helvetica Neue", size: 15);
        
        nscolor1 = NSColor(deviceRed: 77.0/255, green: 77.0/255, blue: 77.0/255, alpha: 1);
        nscolor2 = NSColor(deviceRed: 0.8, green: 0.8, blue: 0.8, alpha: 1);
        
        color1 = NSColor(red: CGFloat(0x99/255.0), green: CGFloat(0x99/255.0), blue: CGFloat(0x99/255.0), alpha: 1);
        
        color2 = NSColor(red: CGFloat(0x33/255.0), green: CGFloat(0x33/255.0), blue: CGFloat(0x33/255.0), alpha: 1);
        
        color3 = NSColor(red: CGFloat(0xf7/255.0), green: CGFloat(0xf7/255.0), blue: CGFloat(0xf7/255.0), alpha: 1);
        
        color4 = NSColor(red: CGFloat(0xff/255.0), green: CGFloat(0x82/255.0), blue: CGFloat(0x00/255.0), alpha: 1);
        
        jishiqiFormat = NSDateFormatter();
        jishiqiFormat?.dateFormat = "yyyy-MM-dd HH:mm:ss";
        
        daojishiFormat = NSDateFormatter();
        daojishiFormat.dateFormat = "d天H小时m分s秒";
        
        tf2 = NSDateFormatter();
        tf2?.dateFormat = "MM-dd";
        
        tf3 = NSDateFormatter();
        tf3?.dateFormat = "HH:mm";
    }
    
    
    
}