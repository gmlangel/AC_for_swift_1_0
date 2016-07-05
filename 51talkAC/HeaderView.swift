//  圆形头像视图
//  HeaderLayer.swift
//  AC for swift
//
//  Created by guominglong on 15/12/29.
//  Copyright © 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
public class HeaderView:NSView{
    
    private var headLayer:HeaderLayer!;//头像图层
    private var shadowLayer:CALayer!;//阴影
    public var currentImg:NSImage!;//当前图像
    
    
    public override init(frame framerate:NSRect)
    {
        super.init(frame:framerate);
        self.layer = CALayer();
        
        currentImg = ResourceManager.instance.getResourceByName("login_logo");
        let layBounds:NSRect = NSMakeRect(0, 0, currentImg.size.width, currentImg.size.height);

        shadowLayer = CALayer();
        shadowLayer.bounds = layBounds;
        shadowLayer.position = CGPoint(x:0,y:0);
        shadowLayer.cornerRadius = shadowLayer.bounds.size.width/2;
        shadowLayer.borderColor = NSColor.whiteColor().CGColor;
        shadowLayer.borderWidth = 2;
        shadowLayer.shadowColor = NSColor.grayColor().CGColor;//StyleManager.instance.color2.CGColor;
        shadowLayer.shadowOffset=CGSizeMake(1, -1);
        shadowLayer.shadowOpacity = 1;
        self.layer?.addSublayer(shadowLayer);
        
        headLayer = HeaderLayer();
        headLayer.setImg(currentImg);
        headLayer.bounds = layBounds;
        headLayer.position = CGPoint(x:0,y:0);
        headLayer.cornerRadius = currentImg.size.width/2;
        headLayer.borderColor = NSColor.whiteColor().CGColor;
        headLayer.borderWidth = 2;
        headLayer.masksToBounds = true;
        
        headLayer.setNeedsDisplay();
        self.layer?.addSublayer(headLayer);
    }
    
    public func setImg(img:NSImage)
    {
        currentImg = img;
        headLayer.setImg(img);
        let layBounds:NSRect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        shadowLayer.bounds = layBounds;
        shadowLayer.cornerRadius = layBounds.size.width/2;
        headLayer.bounds = layBounds;
        headLayer.cornerRadius = layBounds.size.width/2;
        headLayer.needsDisplay();
    }
    
    public required init(coder: NSCoder) {
        super.init(coder:coder)!;
    }
    
}


public class HeaderLayer:CALayer{
    
    public var cgimg:CGImageRef!;
    public var currentImg:NSImage!;//当前图像
    public override func drawInContext(ctx: CGContext) {
        CGContextSaveGState(ctx);
        let scale:CGFloat = self.bounds.size.width / currentImg.size.width;
        CGContextScaleCTM(ctx, scale, scale);
        CGContextDrawImage(ctx, CGRect(x: 0, y: 0, width: currentImg.size.width, height: currentImg.size.height), cgimg);
        CGContextRestoreGState(ctx);
    }
    
    
    /**
     设置要显示的头像
     */
    public func setImg(img:NSImage)
    {
        currentImg = img;
        cgimg = getCGImage(currentImg);
    }
    
    private func getCGImage(img:NSImage)->CGImageRef
    {
        let nd:NSData = img.TIFFRepresentation!;
        let imageSource:CGImageSourceRef =
        CGImageSourceCreateWithData(
            (nd as CFDataRef),  nil)!;
        
        return CGImageSourceCreateImageAtIndex(
            imageSource, 0,nil)!;
    }
}