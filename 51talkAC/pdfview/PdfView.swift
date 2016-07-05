//
//  PdfView.swift
//  AC for swift
//
//  Created by guominglong on 15/4/14.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa
import AppKit
public class PdfView:NSView
{
    /**
    pdf原始尺寸
    */
    public var sourcePDFSize:NSSize! = NSMakeSize(0, 0);
    var pdfContainer:NSPDFImageRep?;
    public var h:CGFloat = 0;
    var zeroSize:NSSize = NSMakeSize(0, 0);
    public var totalPages:Int!{
        get{
           if( pdfContainer == nil)
           {
            return 1
           }else{
            return pdfContainer?.pageCount;
            }
        }
    }
    
    
    
    public var gSize:NSSize{
        get{
            if(pdfContainer != nil)
            {
                zeroSize.height = ((self.pdfContainer?.bounds.height)!)*(self.bounds.width/((self.pdfContainer?.bounds.width)!));
                zeroSize.width = self.bounds.width;
                return zeroSize;
            }
            else
            {
                return zeroSize;
            }
        }
    }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    public var currentPageId:Int{
        get{
            if(pdfContainer == nil)
            {
                return 0;
            }else
            {
                return (pdfContainer?.currentPage)!;
            }
        }
        set{
            if(pdfContainer != nil)
            {
                if(pdfContainer?.pageCount > newValue && newValue >= 0)
                {
                    pdfContainer?.currentPage = newValue;
                    self.setNeedsDisplayInRect(self.bounds);
                    //setPages!((pdfContainer?.currentPage)!,(pdfContainer?.pageCount)!);
                }
            }
        }
    }
    
    
    /**
    总页数
    */
    public func totalPageCount()->UInt
    {
        if(pdfContainer == nil)
        {
            return 0;
        }else
        {
            return UInt((pdfContainer?.pageCount)!);
        }
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        //super.drawRect(dirtyRect);
        if(nil != pdfContainer)
        {
            h = ((self.pdfContainer?.bounds.height)!)*(dirtyRect.width/((self.pdfContainer?.bounds.width)!));
            pdfContainer?.drawInRect(NSMakeRect(0, 0, dirtyRect.width, h));
            //h = dirtyRect.height-h;
        }
    }
    
    /**
    加载pdf
    */
    public func fillPdf(_pdf:AnyObject,type:String="local",pageID:UInt16)
    {
        if(type == "local")
        {
            //加载本地pdf
            pdfContainer = NSPDFImageRep.imageRepsWithContentsOfFile(_pdf as! String)![0] as? NSPDFImageRep;
        }else
        {
            //加载网络的pdf
            pdfContainer = NSPDFImageRep(data: _pdf as! NSData);
        }
        
        if(pdfContainer?.size.width == 0 || pdfContainer?.size.height == 0)
        {
            pdfContainer = nil;
            GLogger.print("教材加载失败");
            return;
        }
        let n:NSNumber = NSNumber(unsignedShort: pageID);
        currentPageId = n.integerValue;
        //setPages!(currentPageId,(pdfContainer?.pageCount)!);
        sourcePDFSize = (pdfContainer?.bounds.size)!;
        //h = ((self.pdfContainer?.bounds.height)!)*(self.frame.width/((self.pdfContainer?.bounds.width)!));
        //self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.width, h);
        self.setNeedsDisplayInRect(self.bounds);
    }
    
    
    public override func setFrameSize(newSize: NSSize) {
        super.setFrameSize(newSize);
    }
    
    
}

public class ScrollContainer:NSScrollView{
    
    public var scrolledFun:(()->Void)?;
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.postsBoundsChangedNotifications = true;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("scrollChanged:"), name: NSViewBoundsDidChangeNotification, object: nil);
        
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    public override func scrollWheel(theEvent: NSEvent) {
        super.scrollWheel(theEvent);
    }
    
    public func scrollChanged(sender: AnyObject?) {
         //NSLog("\(self.contentView.frame)");
        if(scrolledFun != nil)
        {
            scrolledFun!();
        }
    }
}


@available(OSX 10.10, *)
public class PDFDocument:NSView{

    var whiteboardLayer:WhiteBoardLayer!;
    var whiteboardView:WhiteBoardView!;
    var pdfview:PdfView!;
    var pdfType:String! = JiaoCaiType.type_old;
    
    public var totalPages:Int!{
        get{
            return pdfview.totalPages;
        }
    }
    
    /**
     设置当前窗体相对于NSWindow的位置数值
     */
    public func setTrueOffset(pos:NSPoint){
        whiteboardView.frameX = pos.x + whiteboardView.frame.origin.x;
        whiteboardView.frameY = pos.y + whiteboardView.frame.origin.y;
    }
    
    public var currentPageId:Int{
        get{
            return pdfview.currentPageId;
        }
        set{
            pdfview.currentPageId = newValue;
        }
    }
    
    /**
    总页数
    */
    public func totalPageCount()->UInt
    {
        return pdfview.totalPageCount();
    }
    
    public var sourcePDFSize:NSSize{
        get{
            return pdfview.sourcePDFSize;
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        pdfview = PdfView(frame: NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height));
        addSubview(pdfview);
        //添加白板
        whiteboardView = WhiteBoardView(frame: pdfview.frame);
        whiteboardView.ginit();
        if(AcuaSDK.ACService().RoleType() == "stu")
        {
            whiteboardView.cantoDraw = false;
        }
        whiteboardLayer = WhiteBoardLayer();
        whiteboardLayer.frame = whiteboardView.frame;
        //whiteboardLayer.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 0.3).CGColor;
        whiteboardLayer.bounds = NSMakeRect(0, 0, pdfview.frame.size.width, pdfview.frame.size.height);
        whiteboardView.layer = whiteboardLayer;
        whiteboardLayer.shadowOffset.height = 0;
        addSubview(whiteboardView);
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    /**
    加载pdf
    */
    public func fillPdf(_pdf:AnyObject,type:String="local",pageID:UInt16,_pdfType:String = JiaoCaiType.type_old){
        pdfview.fillPdf(_pdf, type: type, pageID: pageID);
        pdfType = _pdfType;
    }
    
    
    public override func setFrameSize(newSize: NSSize) {
        var tSize:NSSize = NSMakeSize(newSize.width,newSize.height);
        if(pdfview.pdfContainer == nil || pdfview.pdfContainer?.size.width == 0 || pdfview.pdfContainer?.size.height == 0)
        {
            super.setFrameSize(newSize);
            return;
        }else{
            let th = newSize.width/(pdfview.pdfContainer?.size.width)!*(pdfview.pdfContainer?.size.height)!
            tSize.width = newSize.width;
            tSize.height = th;
            if(th >= newSize.height)
            {
                super.setFrameSize(tSize);
            }else{
                super.setFrameSize(newSize);
            }
        }
        pdfview.setFrameSize(tSize);
        let th = (newSize.height - pdfview.frame.size.height)/2;
        if(th < 0)
        {
            pdfview.frame.origin.y = 0;
        }else{
            pdfview.frame.origin.y = th;
        }
        pdfview.setNeedsDisplayInRect(pdfview.frame);
        if(pdfType == JiaoCaiType.type_old || pdfType == JiaoCaiType.type_supperOld || pdfType == "")
        {
            //经典英语或者特殊经典英语
            whiteboardView.frame = pdfview.frame;
        }else if(pdfType == JiaoCaiType.type_new){
            //新经典英语
            whiteboardView.frame = NSRect(x: pdfview.frame.size.width * 0.264 + pdfview.frame.origin.x, y: pdfview.frame.size.height * 0.036 + pdfview.frame.origin.y, width: pdfview.frame.size.width * 0.73, height: pdfview.frame.size.height * 0.728);
        }else{
            //雅思英语
            whiteboardView.frame = NSRect(x: pdfview.frame.size.width * 0.236 + pdfview.frame.origin.x, y: pdfview.frame.size.height * 0.035 + pdfview.frame.origin.y, width: pdfview.frame.size.width * 0.73, height: pdfview.frame.size.height * 0.729);
        }
        whiteboardView.changeArea();//改变热区的大小
        whiteboardLayer.gScale = whiteboardView.frame.width / pdfview.sourcePDFSize.width;
        whiteboardLayer.bounds.size = whiteboardView.frame.size;
        whiteboardLayer.setNeedsDisplay();
        
    }
    
    public var gsize:NSSize!{
        get{
            return pdfview.gSize;
        }
    }
    
    public var pdfOrigin:NSPoint!{
        get{
            return pdfview.frame.origin;
        }
    }
    
    public func onwhiteBoardData(data:WBOperationData)
    {
        whiteboardLayer.incomingData(data);
    }
    
    public func clearDrawData()
    {
        whiteboardLayer.clear();
    }
    
    public func clearDrawDataAndSendToServer()
    {
        whiteboardView.clearDrawDataAndSendToServer();
    }
    
    public func showOrHideWhiteboard(b:Bool)
    {
        whiteboardView.hidden = !b;
    }
}

public class WhiteBoardView:NSView{

    var drawType:Int?;
    var canvas:CGContextRef?;
    var beginX:CGFloat?;
    var beginY:CGFloat?;
    var endX:CGFloat?;
    var endY:CGFloat?;
    var frameX:CGFloat! = 0;//白板相对于NSWindow的X轴坐标
    var frameY:CGFloat! = 0;//白板相对于NSWindow的Y轴坐标
    var mouseX:CGFloat! = 0;
    var mouseY:CGFloat! = 0;
    var tbView:WhiteBoardTextFieldView!;
    var area:NSTrackingArea!;
    private var tempRect:CGRect!;
    private var tempPoint:CGPoint!;
    /**
     允许点击屏幕绘制图形
     */
    public var cantoDraw:Bool!;
    
    
    var gsize:NSSize{
        get{
            //return (InstanceManager.instance().getModuleInstaceByName("pdfReader") as PdfView).gSize;
            return self.frame.size;
        }
    }
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        cantoDraw = true;
        tbView = WhiteBoardTextFieldView(frame: NSZeroRect);
        
        area = NSTrackingArea(rect: self.bounds, options: NSTrackingAreaOptions(rawValue: NSTrackingAreaOptions.MouseMoved.rawValue|NSTrackingAreaOptions.MouseEnteredAndExited.rawValue|NSTrackingAreaOptions.ActiveInKeyWindow.rawValue), owner: self, userInfo: nil);
        
        self.addTrackingArea(area)
        //self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false);
    }
    
    func changeArea()
    {
        self.removeTrackingArea(self.trackingAreas[0]);
        area = NSTrackingArea(rect: self.bounds, options: NSTrackingAreaOptions(rawValue: NSTrackingAreaOptions.MouseMoved.rawValue|NSTrackingAreaOptions.MouseEnteredAndExited.rawValue|NSTrackingAreaOptions.ActiveInKeyWindow.rawValue), owner: self, userInfo: nil);
        
        self.addTrackingArea(area)
    }
    
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    public override func viewDidMoveToWindow() {
        if(self.window == nil)
        {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "drawWhiteBoardText", object: nil);
            HeartbeatManager.instance.removeTask("sendGuangbiao");
            if(tbView.superview != nil)
            {
                tbView.removeFromSuperview();
            }
        }else{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("drawWhiteBoardText:"), name: "drawWhiteBoardText", object: nil);
            if(AcuaSDK.ACService().RoleType() == "tea")
            {
                HeartbeatManager.instance.addTask(Selector("sendGuangbiao"), ti: 1, tg: self, taskName: "sendGuangbiao");
            }
        }
    }
    
    /**
     每0.5秒向对端发送光标同步数据
     */
    public func sendGuangbiao()
    {
        let data:WBPencilPosData = WBPencilPosData();
        data.setPenType(207);
        data.setSendTime(0);
        data.setXOffset((UInt32(self.frame.size.width) << 16) | UInt32(mouseX));
        data.setYOffset((UInt32(self.frame.size.height) << 16) | UInt32(mouseY))
        NSNotificationCenter.defaultCenter().postNotificationName("sendguangbiao", object: data);
    }
    
    public func setgDrawType(value:String)
    {
        self.drawType = Int(value);
        if drawType == 8
        {
            self.clearDrawDataAndSendToServer();//清除操作
        }else if(self.drawType == 7)
        {
            self.goback();//回退操作
        }
    }
    
    public func ginit()
    {
        self.drawType = 4;
        tempPoint = CGPointZero;
        tempRect = CGRectZero;
    }
    
    public override func mouseMoved(theEvent: NSEvent) {
        mouseX = theEvent.locationInWindow.x-frameX;
        mouseY = self.bounds.height - (theEvent.locationInWindow.y-frameY);
        if(mouseY < 0)
        {
            mouseY = 0;
        }
        if(mouseX < 0)
        {
            mouseX = 0;
        }
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        if(cantoDraw == false)
        {
            return;
        }
        
        beginX = theEvent.locationInWindow.x-frameX;
        beginY = theEvent.locationInWindow.y-frameY;
       // NSLog("x=\(beginX),y=\(beginY)");
        
        let i:Int = drawType!;
        switch i {
        case 1:
            tempRect.origin.x = beginX!;
            tempRect.origin.y = beginY!;
            tempRect.size.width = 0;
            tempRect.size.height = 0;
            getLayer().createRect(tempRect);
            break;
        case 6:
            tempPoint.x = beginX!;
            tempPoint.y = beginY!;
            getLayer().createFreeLine(tempPoint, drawType: DrawType.Erase);
            break;
        case 4:
            tempPoint.x = beginX!;
            tempPoint.y = beginY!;
            getLayer().createFreeLine(tempPoint, drawType: DrawType.Line);
            break;
        case 5:
            if(tbView.superview == nil)
            {
                tempPoint.x = beginX!;
                tempPoint.y = beginY!;
                createTextField(tempPoint);
            }else{
                super.mouseDown(theEvent);
            }
            break;
            
        default:
            break;
        }
    }
    
    private func getLayer()->WhiteBoardLayer
    {
       return (self.layer as! WhiteBoardLayer)
    }
    
    public override func mouseDragged(theEvent: NSEvent) {
        
        mouseX = theEvent.locationInWindow.x-frameX;
        mouseY = self.bounds.height - (theEvent.locationInWindow.y-frameY);
        if(mouseY < 0)
        {
            mouseY = 0;
        }
        if(mouseX < 0)
        {
            mouseX = 0;
        }
        
        if(cantoDraw == false)
        {
            return;
        }
        
        endX = theEvent.locationInWindow.x-frameX;
        endY = theEvent.locationInWindow.y-frameY;
        let i:Int = drawType!;
        switch (i) {
        case 1:
            tempRect.size.width = endX! - beginX!;
            tempRect.size.height = endY! - beginY!;
            getLayer().changeRect(tempRect);
            break;
        case 6:
            tempPoint.x = endX!;
            tempPoint.y = endY!;
            getLayer().addFreePoint(tempPoint);
            break;
        case 4:
            tempPoint.x = endX!;
            tempPoint.y = endY!;
            getLayer().addFreePoint(tempPoint);
            break;
        default:
            break;
        }
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        
        if(cantoDraw == false)
        {
            return;
        }
        endX = theEvent.locationInWindow.x-frameX;
        endY = theEvent.locationInWindow.y-frameY;
        let i:Int = drawType!;
        switch (i) {
        case 1:
            //保存这个矩形的数据，等待真实绘制
            tempRect.size.width = endX! - beginX!;
            tempRect.size.height = endY! - beginY!;
            getLayer().changeRect(tempRect);
            getLayer().endAndWaitDraw();
            break;
        case 4:
            getLayer().endAndWaitDraw();
            break;
        case 6:
            getLayer().endAndWaitDraw();
            break;
        default:
            break;
        }
        getLayer().setNeedsDisplay();
    }
    
    /**
     创建一个文本框
     */
    func createTextField(point: NSPoint)
    {
        if(tbView.superview != nil)
        {
            return;
        }
        tbView.frame.origin = point;
        tbView.greset();
        if(tbView.superview == nil)
        {
            addSubview(tbView);
        }
    }
    
    /**
     结束一个对文本框的修改，等待最终绘制
     */
    func endTextFieldAndWaitDraw()
    {
        tempPoint.x = tbView.frame.origin.x + 10;
        tempPoint.y = tbView.frame.origin.y + 10;
        tempRect.size.width = tbView.frame.width - 20;
        tempRect.size.height = tbView.frame.height - 20;
        
        tbView.removeFromSuperview();
        getLayer().endTextFieldAndWaitDraw(tbView.value, point: tempPoint, franmesize: tempRect.size,fontSize:26);
    }
    
    func drawWhiteBoardText(notify:NSNotification)
    {
        endTextFieldAndWaitDraw();
    }
    
    
    /**
     清除绘画笔记
     */
    public func clearDrawDataAndSendToServer()
    {
        //清空画板数据
        getLayer().clear();
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            //向远端发送清除命令
            
            let arr:WBOperationItemVector = WBOperationItemVector();
            arr.add(WBOperationItem());
            let wd:WBOperationData = WBOperationData();
            wd.setOperation(WBO_CLEAR);
            wd.setSendTime(UInt64(NSDate().timeIntervalSince1970));
            wd.setBGMd5("");
            wd.setItems(arr);
            NSNotificationCenter.defaultCenter().postNotificationName("sendWhiteBoardInfoToServer", object: wd);
        }
    }
    
    /**
     后退操作
     */
    public func goback()
    {
        let di = getLayer().back();
        if(di == nil)
        {
            return;
        }
        if(AcuaSDK.ACService().RoleType() == "tea")
        {
            //向远端发送后退命令
            let wd = getLayer().encodeWD(di!);
            wd.setOperation(WBO_DELETE);
            NSNotificationCenter.defaultCenter().postNotificationName("sendWhiteBoardInfoToServer", object: wd);
        }
    }
    
    
    /**
     执行绘画动作
     */
    private func execCMD(isNeedAni:Bool=false)
    {
        
    }
}