//  圆形头像控件
//  HeaderView.swift
//  AC for swift
//
//  Created by guominglong on 15/12/1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
@available(OSX 10.10, *)
public class MaskImageView:NSView{

    private var imgmask:CGImageRef!;
    private var canvas:CGContextRef!;
    private var image:CGImageRef!;
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        
        
    }

    public override func drawRect(dirtyRect: NSRect) {
        canvas = NSGraphicsContext.currentContext()?.CGContext;
        CGContextSaveGState(canvas);
        if(self.imgmask != nil){
            CGContextClipToMask(canvas, self.bounds, imgmask);
        }
        if(self.image != nil){
            CGContextDrawImage(canvas, self.bounds, image);
        }
        CGContextRestoreGState(canvas);
        super.drawRect(dirtyRect);
    }
    
    
    
    private func getCGImageRef(nd:NSData)->CGImageRef
    {
        let imageSource:CGImageSourceRef =
        CGImageSourceCreateWithData(
            (nd as CFDataRef),  nil)!;
        
        return CGImageSourceCreateImageAtIndex(
            imageSource, 0,nil)!;
    }
    
    public func setImage(img:NSImage)
    {
        let imageData:NSData = img.TIFFRepresentation!;
        image = getCGImageRef(imageData);
        self.setNeedsDisplayInRect(self.frame);
    }
    
    public func setImageByNSData(imageData:NSData)
    {
        image = getCGImageRef(imageData);
        self.setNeedsDisplayInRect(self.frame);
    }
    
    public func setMaskImage(img:NSImage)
    {
        let imageData:NSData = img.TIFFRepresentation!;
        imgmask = getCGImageRef(imageData);
        self.setNeedsDisplayInRect(self.frame);
    }
    
    public func setMaskImageByNSData(imageData:NSData)
    {
        imgmask = getCGImageRef(imageData);
        self.setNeedsDisplayInRect(self.frame);
    }
    
}
