//
//  GlobelTimer.swift
//  AC for swift
//
//  Created by guominglong on 15/12/14.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class GlobelTimer:NSObject{
    
    private var nt:NSTimer!;
    //private var ndCom:NSDateComponents!;
    public var nd:NSDate!;
    //private var ncr:NSCalendar!;
    class var instance:GlobelTimer{
        get{
            if(InstanceManager.instance().getModuleInstaceByName("GlobelTimer") == nil)
            {
                InstanceManager.instance().addModuleInstance(GlobelTimer(), nameKey: "GlobelTimer");
            }
            return InstanceManager.instance().getModuleInstaceByName("GlobelTimer") as! GlobelTimer;
        }
    }
    
    public func start()
    {
        nt = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("changeTime"), userInfo: nil, repeats: true);
        nd = NSDate();
    }
    
    public func stop()
    {
        if(nt != nil)
        {
            nt.invalidate();
        }
    }
    
    public func changeTime()
    {
        nd = NSDate();
        //println(StyleManager.instance.jishiqiFormat?.stringFromDate(NSDate()));
    }
}