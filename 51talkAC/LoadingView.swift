//
//  LoadingView.swift
//  AC for swift
//
//  Created by guominglong on 15/12/12.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class LoadingView:NSView{

    private var imageSource:[NSImage]!;
    private var currentSouceImg:NSImage!;
    private var offsettime:NSTimeInterval!;
    private var taskName:String!;
    private var currentIdx:Int = 0;
    public init(frame frameRect: NSRect,_imgSource:[NSImage]) {
        super.init(frame: frameRect);
        self.imageSource = _imgSource;
        if(self.imageSource.count > 0)
        {
            currentSouceImg = _imgSource[0];
            currentIdx = 0;
        }
        taskName = NSString(format: "loading_%u", NSDate()) as String;
        offsettime = NSTimeInterval(1/12.0);
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        currentSouceImg.drawInRect(self.bounds);
    }
    
    public override func viewDidMoveToWindow() {
        if(self.window == nil)
        {
            HeartbeatManager.instance.removeTask(taskName);
        }else{
            HeartbeatManager.instance.addTask(Selector("changeCurrentSource"), ti: offsettime, tg: self, taskName: taskName, repeats: true);
        }
    }
    
    public func changeCurrentSource()
    {
        if(currentIdx < imageSource.count-1)
        {
            currentIdx++;
        }else
        {
            currentIdx = 0;
        }
        currentSouceImg = imageSource[currentIdx];
        self.needsDisplay = true;
    }
    
}