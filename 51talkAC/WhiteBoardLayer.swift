//
//  WhiteBoardLayer.swift
//  AC for swift
//
//  Created by guominglong on 15/12/18.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
import Cocoa

@available(OSX 10.10, *)
public class WhiteBoardLayer:CALayer{
    
    var gScale:CGFloat = 1;
    var _dInfos:[DrawInfo] = [];
    
    var _tempLayer:AniWhiteBoardLayer!;
    var _waitDrawDrawInfo:DrawInfo?;//当前等待绘制的图形，只有在老师端才会用到。因为学员端不支持主动绘制
    
    var tuxingID:Int32!=0;
    override init() {
        super.init();
        
        _tempLayer = AniWhiteBoardLayer();
        _tempLayer.frame = self.bounds;
        //_tempLayer.backgroundColor = NSColor(red: 0, green: 1, blue: 0, alpha: 0.3).CGColor;
        addSublayer(_tempLayer);
        self.contentsScale = NSScreen.mainScreen()!.backingScaleFactor;
        _tempLayer.contentsScale = NSScreen.mainScreen()!.backingScaleFactor;
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    
    
    public override func setNeedsDisplay() {
        super.setNeedsDisplay();
        _tempLayer.frame = self.bounds;
        _tempLayer.bounds = self.bounds;
        _tempLayer.setNeedsDisplay();
    }
    
    
    /**
     创建一条临时线条，供老师使用
     */
    func createFreeLine(cp:CGPoint,drawType:DrawType)
    {
        if(drawType == .Erase)
        {
            _waitDrawDrawInfo = _tempLayer.createFreeLine(cp, drawType: drawType,penWidth: Int8(20 * gScale));
        }else{
            _waitDrawDrawInfo = _tempLayer.createFreeLine(cp, drawType: drawType);
        }
        if(_waitDrawDrawInfo != nil)
        {
            self.setNeedsDisplay();
        }
    }
    
    /**
     向临时线条中添加点
     */
    func addFreePoint(cp:CGPoint)
    {
        _waitDrawDrawInfo = _tempLayer.addFreePoint(cp);
        if(_waitDrawDrawInfo != nil)
        {
            self.setNeedsDisplay();
        }
    }
    
    /**
     结束临时线条的绘制，并隐藏临时线条。将该线条数据存储到_dInfos集合中，等待最终的白板真实绘制
     */
    func endAndWaitDraw()
    {
        _waitDrawDrawInfo = nil;//因为马上就要开始正式绘制了，所以_waitDrawDrawInfo这个临时绘制笔触没有用了，制空
        let di:DrawInfo? = _tempLayer.endAndWaitDraw(tuxingID);
        if(di != nil)
        {
            addDrawInfo(di!);
            self.setNeedsDisplay();//重绘界面
            //发送数据服务器，同步对端
            let wd:WBOperationData = encodeWD(di!);
            NSNotificationCenter.defaultCenter().postNotificationName("sendWhiteBoardInfoToServer", object: wd);
        }
    }
    
    /**
     创建一个临时矩形图形，供老师观看
     */
    func createRect(cr:CGRect)
    {
        self.tuxingID = self.tuxingID + 1;
        _tempLayer.createRect(cr, tuxingID: self.tuxingID);
    }
    
    /**
     改变临时矩形图形的尺寸，供老师观看
     */
    func changeRect(cr:CGRect)
    {
        _tempLayer.changeRect(cr);
    }


    /**
     停止修改文本框内容，隐藏临时文本框。将该文本框数据存储在_dInfos集合中，等待最终的白板真实绘制
     */
    func endTextFieldAndWaitDraw(text:String, point: CGPoint, franmesize: CGSize,fontSize:CGFloat)
    {
        self.tuxingID = self.tuxingID + 1;
        let _tempDrawInfo:DrawInfo? = DrawInfo();
        _tempDrawInfo!.Type = .Text;
        _tempDrawInfo!.UToken = tuxingID;
        _tempDrawInfo!.Cx = Int16(self.bounds.width);
        _tempDrawInfo!.Cy = Int16(self.bounds.height);
        _tempDrawInfo!.Token = (UInt64(tuxingID)&0xffffffff)|((UInt64(NSDate().timeIntervalSince1970)<<32)&0xffffffff00000000);
        _tempDrawInfo!.Color = 0x0000ff;
        _tempDrawInfo!.Pen = Int8(fontSize);
        _tempDrawInfo!.Left = point.x;
        _tempDrawInfo!.Top = point.y + franmesize.height;
        _tempDrawInfo!.Right = point.x + franmesize.width;
        _tempDrawInfo!.Bottom = _tempDrawInfo!.Top + franmesize.height;
        _tempDrawInfo?.text = text;
        

        addDrawInfo(_tempDrawInfo!);
        self.setNeedsDisplay();//重绘界面
        //发送数据服务器，同步对端
        let wd:WBOperationData = encodeWD(_tempDrawInfo!);
        NSNotificationCenter.defaultCenter().postNotificationName("sendWhiteBoardInfoToServer", object: wd);
        
    }
    
    func addDrawInfo(di:DrawInfo)
    {
        _dInfos.append(di);
    }
    func removeDrawInfo(token:UInt64)->DrawInfo?
    {
        for i in 0 ..< _dInfos.count
        {
            let di = _dInfos[i];
            if di.Token == token
            {
                return _dInfos.removeAtIndex(i);
            }
        }
        return nil;
    }
    
    func removeAll()
    {
        _dInfos.removeAll();
    }
    
    
    func unDo()->DrawInfo?
    {
        if _dInfos.count == 0
        {
            return nil;
        }
        return _dInfos.removeLast();
        
    }
    
    /**
    后退操作
    */
    public func back()->DrawInfo?
    {
        let di = unDo();
        setNeedsDisplay();
        return di;
    }
    
    /**
    清空画板
    */
    public func clear()
    {
        self.tuxingID = self.tuxingID + 1;
        removeAll();
        setNeedsDisplay();
    }
    
    private func getPoints(sourcePs:[CGPoint],scaleX:CGFloat,scaleY:CGFloat)->[CGPoint]
    {
        var resultPoints:[CGPoint] = [CGPoint]();
        for(var i:Int=0;i<sourcePs.count;i++)
        {
            resultPoints.append(NSMakePoint(sourcePs[i].x * scaleX, sourcePs[i].y * scaleY));
        }
        return resultPoints;
    }
    
    //重绘
    override public func drawInContext(ctx: CGContext) {
        //CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
        //CGContextScaleCTM(ctx, 1.0, -1.0);
        var xScale:CGFloat=0;
        var yScale:CGFloat=0;
        if(_waitDrawDrawInfo != nil)
        {
            _dInfos.append(_waitDrawDrawInfo!);//临时添加一个笔触，绘制完后，删除
        }
        for di in _dInfos
        {
            xScale = self.frame.width/CGFloat(di.Cx);
            yScale = self.frame.height/CGFloat(di.Cy);
            var point:[CGPoint];
            CGContextSaveGState(ctx);
            
            CGContextSetRGBStrokeColor(ctx, CGFloat(di.Color&0x0000ff)/255.0, CGFloat((di.Color>>8)&0x0000ff)/255.0, CGFloat(di.Color>>16)/255.0, 1);
            if(di.Type == DrawType.Line)
            {
                point = getPoints(di.Point,scaleX: xScale,scaleY: yScale);
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                CGContextAddLines(ctx,point,point.count);
                CGContextSetLineWidth(ctx, 2);
                CGContextDrawPath(ctx,CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
                point.removeAll(keepCapacity: false);
            }
            else if di.Type == DrawType.Erase
            {
                point = getPoints(di.Point,scaleX: xScale,scaleY: yScale);
                CGContextSetBlendMode(ctx, CGBlendMode.Clear);
                CGContextAddLines(ctx,point,point.count);
                CGContextSetLineWidth(ctx, 20);
                CGContextDrawPath(ctx,CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
                point.removeAll(keepCapacity: false);
            }
            else if di.Type == DrawType.Rect
            {
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                let rect = CGRect(x: di.Left * xScale, y: di.Top * yScale, width: (di.Right-di.Left) * xScale, height: (di.Bottom-di.Top) * yScale);
                CGContextAddRect(ctx, rect);
                CGContextSetLineWidth(ctx, 2);
                CGContextDrawPath(ctx,CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
                

            }
            else if di.Type == DrawType.Ellipse
            {
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                let rect = CGRect(x: di.Left * xScale, y: di.Top * yScale, width: (di.Right-di.Left) * xScale, height: (di.Bottom-di.Top) * yScale);
                CGContextAddEllipseInRect(ctx, rect);
                CGContextSetLineWidth(ctx, 2);
                CGContextDrawPath(ctx, CGPathDrawingMode.Stroke);
                CGContextFillPath(ctx);
            }else if di.Type == DrawType.Text
            {
                
//                var font:CGFontRef = CGFontCreateWithFontName("Helvetica Neue");//NSFont(name: "Helvetica Neue", size: 10)!;
//                CGContextSetBlendMode(ctx, kCGBlendModeCopy);
//
//                CGContextSetFont(ctx, font);
//                CGContextSetFontSize(ctx, 14);//CGFloat(di.Pen)
//                CGContextSetTextDrawingMode(ctx, kCGTextFill);
//                CGContextSetTextPosition(ctx, di.Left * xScale, di.Top * yScale);
//                CGContextSetRGBStrokeColor (ctx, 1, 0, 0, 1); // 7
//                CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
//                //CGContextDrawPath(ctx,kCGPathStroke);
//                //CGContextFillPath(ctx);
//               // di.text.drawAtPoint(NSPoint(x: di.Left * xScale, y: di.Top * yScale), withAttributes: [NSFontAttributeName: font,NSForegroundColorAttributeName:NSColor.redColor()])
                let currentCTX = NSGraphicsContext.currentContext();
                NSGraphicsContext.setCurrentContext(NSGraphicsContext(CGContext: ctx, flipped: false));
                font = NSFont(name: "Helvetica Neue", size: CGFloat(NSNumber(char: di.Pen).integerValue) * xScale);
                CGContextSetBlendMode(ctx, CGBlendMode.Normal);
                CGContextSetRGBFillColor(ctx, CGFloat(di.Color&0x0000ff)/255.0, CGFloat((di.Color>>8)&0x0000ff)/255.0, CGFloat(di.Color>>16)/255.0, 1);
                di.text.drawAtPoint(NSPoint(x: di.Left * xScale, y: di.Top * yScale - font.pointSize), withAttributes: [NSFontAttributeName: font,NSForegroundColorAttributeName:NSColor(red: CGFloat(di.Color&0x0000ff)/255.0, green: CGFloat((di.Color>>8)&0x0000ff)/255.0, blue: CGFloat(di.Color>>16)/255.0, alpha: 1)]);
                NSGraphicsContext.setCurrentContext(currentCTX);
            }
            CGContextRestoreGState(ctx);
        }
        
        if(_waitDrawDrawInfo != nil)
        {
            _dInfos.removeLast();
        }
        
        
    }
    var font:NSFont!;
    
    /**
    解析白斑数据
    */
    func getDrawInfo(type:Int8,data:NSData,var index:Int32,cx:CGFloat,cy:CGFloat)->DrawInfo
    {
        
        let di:DrawInfo = DrawInfo();
        if type == 1
        {
            di.Type = DrawType.Rect;
        }
        else if type == 2
        {
            di.Type = DrawType.Ellipse;
        }
        else if type == 3
        {
            di.Type = DrawType.ArrowLine;
        }
        else if type == 4
        {
            di.Type = DrawType.Line
        }
        else if type == 5
        {
            di.Type = DrawType.Text
        }
        else
        {
            di.Type = DrawType.Erase;
        }
        if(data.length < Int(index+8))
        {
            return di;
        }
        di.Left = CGFloat(dataToInt16(data, gposition: index));
        index += 2;
        di.Top = cy - CGFloat(dataToInt16(data, gposition: index));
        index += 2;
        di.Right = CGFloat(dataToInt16(data, gposition: index));
        index += 2;
        di.Bottom = cy - CGFloat(dataToInt16(data, gposition: index));
        index += 2;
        
        if di.Type == DrawType.Line || di.Type == DrawType.Erase
        {
            if(data.length < Int(index+4))
            {
                assert(false);
                return di;
            }
            let pSize = dataToInt32(data, gposition: index)
            index += 4;
            if data.length < Int(index+pSize*4)
            {
                assert(false);
                return di;
            }
            for i in 0 ..< pSize
            {
                var point = CGPoint();
                point.x = CGFloat(dataToInt16(data, gposition: index + (i*4)));
                point.y = cy - CGFloat(dataToInt16(data, gposition: index + (i*4+2)));
                di.Point.append(point);
            }
        }else if(di.Type == DrawType.Text)
        {
            let len:UInt16 = dataToUInt16(data, gposition: index);
            index += 2;
            
            di.text = NSString(data: data.subdataWithRange(NSMakeRange(Int(index), Int(len + 1)*2)), encoding: NSUTF16LittleEndianStringEncoding);
        }
        return di;
    }
    
    /**
     解析白板数据
     */
    func incomingData(data:WBOperationData)
    {
        let op = data.getOperation();
        if op.rawValue == WBO_ADD.rawValue || op.rawValue == WBO_SYN.rawValue
        {
            let items = data.getItems()
            let itemSize = items.size();
            if items.size() == 0
            {
                return;
            }
            if(op.rawValue == WBO_SYN.rawValue)
            {
                removeAll();
            }
            for i in 0 ..< itemSize
            {
                let item = items.get(i);
                let itemData = item.getData();
                let nsData = itemData.getData();
                let drawType = itemData.get(0)
                let uToken = Int32(dataToUInt16(nsData, gposition:1))
                let time = dataToUInt64(nsData, gposition:3);
                let cx = dataToInt16(nsData, gposition: 11);
                let cy = dataToInt16(nsData, gposition: 13);
                let penwidth = itemData.get(15);
                let color = dataToUInt32(nsData,gposition: 16);
                let token64 = (UInt64(uToken)&0xffffffff)|((time<<32)&0xffffffff00000000)
                let di = getDrawInfo(drawType, data: nsData, index: 20,cx: CGFloat(cx),cy: CGFloat(cy));
                
                di.UToken = uToken;
                di.Cx = cx;
                di.Cy = cy;
                di.Token = token64;
                di.Color = color
                di.Pen = penwidth;
                
                addDrawInfo(di);
            }
            setNeedsDisplay();
        }
        else if op.rawValue == WBO_DELETE.rawValue
        {
            let items = data.getItems()
            let itemSize = items.size();
            if items.size() == 0
            {
                return;
            }
            if(op.rawValue == WBO_SYN.rawValue)
            {
                removeAll();
            }
            for i in 0 ..< itemSize
            {
                let item = items.get(i);
                
                let sseq = item.getServerSeq();
                let cseq = item.getClientSeq();
                let uToken = (UInt64(sseq)&0xffffffff) | ((UInt64(cseq)<<32)&0xffffffff00000000);
                removeDrawInfo(uToken);
            }
            setNeedsDisplay();
        }
        else if op.rawValue == WBO_CLEAR.rawValue
        {
            removeAll();
            setNeedsDisplay();
            
        }
    }
    
    func getdrawType(dp:DrawType)->Int
    {
        var result:Int = 1;
        switch(dp)
        {
        case .Rect:result = 1;break;
            case .Ellipse:result = 2;break;
            case .ArrowLine:result = 3;break;
            case .Line:result = 4;break;
            case .Text:result = 5;break;
        case .Erase:result = 6;break;
        default:result = 1;break;
        }
        return result;
    }
    
    /**
     封装白板数据
     */
    func encodeWD(di:DrawInfo)->WBOperationData
    {
        
        let nd:NSMutableData = NSMutableData();
        var type:Int = getdrawType(di.Type);
        nd.appendBytes(&type, length: 1);//图形类型
        nd.appendBytes(&di.UToken, length: 2)//图形ID
        var time:UInt64 = UInt64(NSDate().timeIntervalSince1970);
        nd.appendBytes(&time, length: 8);//图形创建时间
        nd.appendBytes(&di.Cx, length: 2);//画质图形时的画布宽度
        nd.appendBytes(&di.Cy, length: 2);//画质图形时的画布高度
        nd.appendBytes(&di.Pen, length: 1);//笔触宽度
        nd.appendBytes(&di.Color, length: 4);//笔触颜色
        if(type == 1)
        {
            var tt = Int16(self.bounds.size.height - di.Top);
            var tb = Int16(self.bounds.size.height - di.Bottom);
            var tl = Int16(di.Left);
            var tr = Int16(di.Right);
            //矩形数据
            nd.appendBytes(&tl, length: 2);
            nd.appendBytes(&tt, length: 2);
            nd.appendBytes(&tr, length: 2);
            nd.appendBytes(&tb, length: 2);
        }else if(type == 4 || type == 6)
        {
            //任意线条
            var tt = Int16(self.bounds.size.height - di.Top);
            var tb = Int16(self.bounds.size.height - di.Bottom);
            var tl = Int16(di.Left);
            var tr = Int16(di.Right);
            nd.appendBytes(&tl, length: 2);
            nd.appendBytes(&tt, length: 2);
            nd.appendBytes(&tr, length: 2);
            nd.appendBytes(&tb, length: 2);
            var con:Int = di.Point.count;
            nd.appendBytes(&con, length: 4);
            var p:CGPoint = CGPointZero;
            for i in 0 ..< con
            {
                p = di.Point[i];
                var ty = Int16(self.bounds.size.height - p.y);
                var tx = Int16(p.x);
                nd.appendBytes(&tx, length: 2);
                nd.appendBytes(&ty, length: 2);
            }
        }else if(type == 5)
        {
            //画文本
            let th = Int16(di.Bottom) - Int16(di.Top);
            var tt = Int16(self.bounds.size.height - di.Top);
            var tb = tt + th;
            var tl = Int16(di.Left);
            var tr = Int16(di.Right);
            nd.appendBytes(&tl, length: 2);
            nd.appendBytes(&tt, length: 2);
            nd.appendBytes(&tr, length: 2);
            nd.appendBytes(&tb, length: 2);
            let textNd:NSData = di.text.dataUsingEncoding(NSUTF16LittleEndianStringEncoding)!;
            var len = Int16(textNd.length) / 2;
            nd.appendBytes(&len, length: 2);
            nd.appendBytes(textNd.bytes, length: Int(len*2));
            var endFu:UInt16 = 0;
            nd.appendBytes(&endFu, length: 2);
        }
        
        let data:CharVector = CharVector();
        data.setData(nd);
        
        let item:WBOperationItem = WBOperationItem();
        item.setClientSeq(UInt32(di.Token>>32));
        item.setServerSeq(UInt32(di.Token & 0x00000000ffffffff));
        item.setData(data);
        let arr:WBOperationItemVector = WBOperationItemVector();
        arr.add(item);
        let wd:WBOperationData = WBOperationData();
        wd.setOperation(WBO_ADD);
        wd.setSendTime(UInt64(NSDate().timeIntervalSince1970));
        wd.setBGMd5("");
        wd.setItems(arr);
        return wd;
    }
    
    private var tempRange:NSRange! = NSMakeRange(0, 0);
    func dataToInt16(nd:NSData,gposition:Int32)->Int16
    {
        tempRange.location = Int(gposition);
        tempRange.length = 2;
        var val:Int16=0;
        nd.getBytes(&val, range: tempRange);
        return val;
    }
    
    func dataToUInt16(nd:NSData,gposition:Int32)->UInt16
    {
        tempRange.location = Int(gposition);
        tempRange.length = 2;
        var val:UInt16=0;
        nd.getBytes(&val, range: tempRange);
        return val;
    }
    
    func dataToInt32(nd:NSData,gposition:Int32)->Int32
    {
        tempRange.location = Int(gposition);
        tempRange.length = 4;
        var val:Int32=0;
        nd.getBytes(&val, range: tempRange);
        return val;
    }
    
    func dataToUInt32(nd:NSData,gposition:Int32)->UInt32
    {
        tempRange.location = Int(gposition);
        tempRange.length = 4;
        var val:UInt32=0;
        nd.getBytes(&val, range: tempRange);
        return val;
    }
    
    
    func dataToUInt64(nd:NSData,gposition:Int32)->UInt64
    {
        tempRange.location = Int(gposition);
        tempRange.length = 8;
        var val:UInt64=0;
        nd.getBytes(&val, range: tempRange);
        return val;
    }
}

//一条白板数据信息
public class DrawInfo
{
    var Type:DrawType = DrawType.None;
    var Point:[CGPoint] = []
    var Context:AnyObject?;
    var UToken:Int32 = 0;//图形ID
    var Token:UInt64 = 0;//时间戳+图形ID生成的token
    var Left:CGFloat = 0;
    var Top:CGFloat = 0;
    var Right:CGFloat = 0;
    var Bottom:CGFloat = 0;
    var Cx:Int16 = 0;
    var Cy:Int16 = 0;
    var Pen:Int8 = 1;
    var Color:UInt32 = 0;
    var text:NSString! = "";
    
}

//绘制类型
enum DrawType
{
    case ArrowLine /*箭头线*/
    case Line  /*普通线条*/
    case Rect   /*矩形*/
    case Ellipse    /*Ellipse*/
    case Text   /*文本*/
    case Erase  /*擦出*/
    case None   
}