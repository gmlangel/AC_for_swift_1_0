//
//  FrameView2.swift
//  AC for swift
//
//  Created by guominglong on 16/1/11.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
public class FrameView2:NSView{

    var imgskin:NSImage?;
    var type:Int?;
    var sourceRect:CGRect?;
    var wantDrawRect:CGRect?;
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    public init(_imgskin:NSImage,_type:Int) {
        
        imgskin = _imgskin;
        type = _type;
        sourceRect = CGRectMake(
            0,
            0,
            CGFloat(_imgskin.size.width/CGFloat(_type)),
            _imgskin.size.height
        );
        
        
        wantDrawRect = CGRectMake(
            0,
            0,
            CGFloat(_imgskin.size.width/CGFloat(_type)),
            _imgskin.size.height
        );
        super.init(frame:sourceRect!);
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        
        // super.drawRect(dirtyRect);
        if nil == imgskin
        {
            return;
        }
        imgskin?.drawInRect(self.bounds, fromRect: wantDrawRect!, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1, respectFlipped: true, hints: nil);
    }
    
    public func setFrameIdx(var i:Int)
    {
        if(i >= type)
        {
            i = type! - 1;
        }else if(i < 0)
        {
             i = 0
        }
        wantDrawRect?.origin.x = CGFloat(i) * (sourceRect?.size.width)!;
        self.setNeedsDisplayInRect(self.frame);
    }
}