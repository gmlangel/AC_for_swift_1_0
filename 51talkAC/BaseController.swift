//  所有NSViewController的基类
//  BaseController.swift
//  AC for swift
//
//  Created by guominglong on 15/11/30.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class BaseController:NSViewController{
    
    public var isInited:Bool! = false;
    public required init!(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    /**
    去下一页
    */
    public func gonextPage()
    {
    
    }
    
    
    /**
    去上一页
    */
    public func goprePage()
    {
        
    }
    
    //进入制定页面
    internal func showPage(vc:NSViewController)
    {
        func gComplete()->Void{
            
        }
        
        func gupdate(progress:NSAnimationProgress)->Void
        {
            
        }
        let gt:GTWeen = GTWeen(
            obj: vc.view.window,
            duration: 0.5,
            _params: ["alpha":1],
            animationCurve: NSAnimationCurve.EaseInOut,
            _onComplete: gComplete,
            _onUpdate: gupdate);
        gt.startAnimation();
        
    }
    
    public func ginit()
    {
        isInited = true;
    }
}