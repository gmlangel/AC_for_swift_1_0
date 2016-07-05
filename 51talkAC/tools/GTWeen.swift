//缓动工具
//  GTWeen.swift
//  AC for swift
//
//  Created by guominglong on 15/4/23.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

class GTWeen: NSAnimation {

    //缓动参数
    var gparams:NSDictionary?;
    
    var completeFunc:()->Void!;
    var updateFunc:(NSAnimationProgress)->Void!;
    var beControled:AnyObject!;
    
    var sourceRect:CGRect;
    var sourceAlpha:CGFloat;
    
    var wantToRect:CGRect;
    var wangToAlpha:CGFloat?;
    init(obj:AnyObject!,duration: NSTimeInterval,_params:NSDictionary, animationCurve: NSAnimationCurve,_onComplete:()->Void!,_onUpdate:(NSAnimationProgress)->Void!) {
        gparams = _params;
        completeFunc = _onComplete;
        updateFunc = _onUpdate;
        beControled = obj;
        
        sourceRect = CGRectMake(beControled.frame.origin.x, beControled.frame.origin.y, beControled.frame.size.width, beControled.frame.size.height);
        wantToRect = CGRectMake(0, 0, 0, 0);
        sourceAlpha = beControled.alphaValue;
        super.init(duration: duration, animationCurve: animationCurve);
        self.animationBlockingMode = NSAnimationBlockingMode.Nonblocking;
        
    }
    
    
    override var currentProgress: NSAnimationProgress{
        get{
            return super.currentProgress;
        }
        set{
            super.currentProgress = newValue;
            updateFunc(newValue);
            gTweenUpdate();
            if(super.currentProgress == 1)
            {
                completeFunc();
                gparams = nil;//清空无用的东东
            }
        }
    }
    
    
    private func gTweenUpdate()
    {
        if(gparams == nil)
        {
            return ;
        }
        var tempkey:String;
        var cf:CGRect = CGRectMake(beControled.frame.origin.x, beControled.frame.origin.y, beControled.frame.size.width, beControled.frame.size.height);
        for key in (gparams?.allKeys)!
        {
            tempkey = key as! String;
            switch(tempkey)
            {
            case "alpha":
                
               // println(CGFloat(1 - currentProgress) * CGFloat((gparams?.valueForKey(tempkey)?.floatValue)!));
                beControled.setValue(CGFloat(currentProgress) * (CGFloat((gparams?.valueForKey(tempkey)?.floatValue)!) - sourceAlpha) + sourceAlpha, forKey: "alphaValue");
                break;
            case "width":
                cf.size.width = CGFloat(currentProgress) * (CGFloat((gparams?.valueForKey(tempkey)?.floatValue)!) - sourceRect.size.width) + sourceRect.size.width;
                beControled.setFrameSize(cf.size);
               // beControled.setFrame(cf, display: true);
                break;
            case "height":
                cf.size.height = CGFloat(currentProgress) * (CGFloat((gparams?.valueForKey(tempkey)?.floatValue)!) - sourceRect.size.height) + sourceRect.size.height;
                beControled.setFrameSize(cf.size);
                // beControled.setFrame(cf, display: true);
                break;
            case "x":
                cf.origin.x = CGFloat(currentProgress) * (CGFloat((gparams?.valueForKey(tempkey)?.floatValue)!) - sourceRect.origin.x) + sourceRect.origin.x;
                beControled.setFrameOrigin(cf.origin);
                //beControled.setFrame(cf, display: true);
                break;
            case "y":
                cf.origin.y = CGFloat(currentProgress) * (CGFloat((gparams?.valueForKey(tempkey)?.floatValue)!) - sourceRect.origin.y) + sourceRect.origin.y;
                beControled.setFrameOrigin(cf.origin);
                break;
            default:break;
            }
            
            
        }
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
