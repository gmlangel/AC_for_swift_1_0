//  心跳控制器
//  HeartbeatManager.swift
//  AC for swift
//
//  Created by guominglong on 15/5/20.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

public class HeartbeatManager: NSObject {
    
    private var taskArr:NSMutableDictionary;
    public class var instance:HeartbeatManager{
        get{
            if(InstanceManager.instance().getModuleInstaceByName("HeartbeatManager") == nil)
            {
                let ins:HeartbeatManager = HeartbeatManager();
                InstanceManager.instance().addModuleInstance(ins, nameKey: "HeartbeatManager");
            }
            return InstanceManager.instance().getModuleInstaceByName("HeartbeatManager") as! HeartbeatManager;
        }
    }
    
    public override init() {
        taskArr = NSMutableDictionary();
        super.init();
    }
    
    public func hasTask(taskName:String)->Bool
    {
        return taskArr.valueForKey(taskName) != nil;
    }
    
    /**
    绑定任务
    sel 要绑定的函数
    ti  间隔时间
    tg  target
    taskName 绑定名称
    repeats 是否循环执行
    */
    public func addTask(sel:Selector,ti:NSTimeInterval,tg:AnyObject,taskName:String,repeats:Bool = true)
    {
        let nt:NSTimer = NSTimer.scheduledTimerWithTimeInterval(ti, target: tg, selector: sel, userInfo: nil, repeats: repeats);
        taskArr.setObject(nt, forKey: taskName);
    }
    
    /**
    删除绑定的任务
    */
    public func removeTask(taskName:String)
    {
        if(hasTask(taskName) == false)
        {
            return;
        }
        let nt:NSTimer = taskArr.objectForKey(taskName)as! NSTimer;
        nt.invalidate();
        taskArr.removeObjectForKey(taskName);
    }
    
    /**
    移除所有任务
    */
    public func removeAllTask()
    {
        var arr:Array = taskArr.allKeys;
        var nt:NSTimer;
        for(var i:Int=0;i<arr.count;i++)
        {
            nt = taskArr.objectForKey(arr[i]) as! NSTimer;
            nt.invalidate();
            taskArr.removeObjectForKey(arr[i]);
        }
    }
    

    
}
