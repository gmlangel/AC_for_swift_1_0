//  白板数据解析类
//  WhiteBoardDataProxy.swift
//  AC for swift
//
//  Created by guominglong on 15/4/16.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation


@available(OSX 10.10, *)
public class WhiteBoardProxy
{
    var drawView:DrawView?;
    var drawType:uint8?;
    //对端绘画时的画布尺寸
    var gServerWidth:Int=0;
    var gServerHeight:Int=0;
    var temprect:CGRect?;
    var tempDrawId:Int?;
    var isUpdate:Bool = false;
    public class var instance:WhiteBoardProxy
    {
        get{
            if(InstanceManager.instance().getModuleInstaceByName("WhiteBoardProxy") == nil)
            {
                InstanceManager.instance().addModuleInstance(WhiteBoardProxy(), nameKey: "WhiteBoardProxy");
                (InstanceManager.instance().getModuleInstaceByName("WhiteBoardProxy") as! WhiteBoardProxy).ginit();
            }
        return InstanceManager.instance().getModuleInstaceByName("WhiteBoardProxy") as! WhiteBoardProxy;
        }
    }
    
    /**
    初始化
    */
    public func ginit()
    {
        temprect = CGRectMake(0, 0, 0, 0);
    }
    
    /**
    解析数据
    */
    public func decodeData(_bytes:ByteArray?,cmdType:Int,_isClient:Bool)
    {
        if(drawView == nil)
        {
            drawView = InstanceManager.instance().getModuleInstaceByName("DrawView") as? DrawView;
        }
        if(cmdType == 5 && (_bytes == nil || _bytes!.length() == 0))
        {
            drawView?.clearDrawData();//先清除，再画
            return;
        }
        if(cmdType == 4)
        {
            drawView?.clearDrawData();//清除
            return;
        }
        if(cmdType == 2)
        {
            drawView?.goback();//后退
            return;
        }
        
        if(_bytes == nil || _bytes!.length() == 0)
        {
            //无效的白班数据，舍去
            return;
        }
        
        if(cmdType == 1 || cmdType == 5 || cmdType == 3)
        {
            if(!_isClient)
            {
                //一个特殊操作，具体参见flashAC这部分源码的处理
            }
            _bytes?.setGposition(0);
            
            drawType = _bytes?.readUnsignedByte();
            
            if(drawType == 1)
            {
                
                //画矩形
                self.readCurrentInfo(_bytes!, serverWidth: &gServerWidth, serverHeight: &gServerHeight, _isUpdate: &isUpdate);
                temprect?.origin.x = CGFloat((_bytes?.readShort())!);
                temprect?.origin.y = CGFloat(gServerHeight) - CGFloat((_bytes?.readShort())!);
                temprect?.size.width = CGFloat((_bytes?.readShort())!)-(temprect?.origin.x)!;
                temprect?.size.height = (CGFloat(gServerHeight) - CGFloat((_bytes?.readShort())!)) - (temprect?.origin.y)!;
                print("\(temprect),w=\(gServerWidth),h=\(gServerHeight)");
                DrawTool.getInstance().addRect(
                    temprect!,
                    frameSize: NSMakeSize(CGFloat(gServerWidth), CGFloat(gServerHeight))
                )
                drawView?.setNeedsDisplayInRect((drawView?.bounds)!);
            }else if(drawType == 4 || drawType == 6)
            {
                //画线 或者 擦出线
                self.readCurrentInfo(_bytes!, serverWidth: &gServerWidth, serverHeight: &gServerHeight,_isUpdate: &isUpdate);
                _bytes?.readUnsignedInt64();//读取8个无用字节
                var i:UInt = UInt((_bytes?.readUnsignedInt())!);//读取画点数
                if(i == 0)
                {
                    return;
                }
                temprect?.origin.x = CGFloat((_bytes?.readShort())!);
                temprect?.origin.y = CGFloat(gServerHeight) - CGFloat((_bytes?.readShort())!);
                DrawTool.getInstance().createFreeLine((temprect?.origin)!);
                i--;
                while(i>0)
                {
                    temprect?.origin.x = CGFloat((_bytes?.readShort())!);
                    temprect?.origin.y = CGFloat(gServerHeight) - CGFloat((_bytes?.readShort())!);
                    DrawTool.getInstance().addFreePoint((temprect?.origin)!);
                    i--;
                }
                temprect?.size.width = CGFloat(gServerWidth);
                temprect?.size.height = CGFloat(gServerHeight);
                DrawTool.getInstance().endRecodFreePointAndWaitDraw((temprect?.size)!, drawType: drawType!);
                drawView?.setNeedsDisplayInRect((drawView?.bounds)!);
            }
            else if(drawType == 5)
            {
                //文本内容
                self.readCurrentInfo(_bytes!, serverWidth: &gServerWidth, serverHeight: &gServerHeight,_isUpdate: &isUpdate);
                temprect?.origin.x = CGFloat((_bytes?.readShort())!);
                temprect?.origin.y = CGFloat(gServerHeight) - CGFloat((_bytes?.readShort())!);
                temprect?.size.width = CGFloat(gServerWidth);
                temprect?.size.height = CGFloat(gServerHeight);
                _bytes?.readShort();
                _bytes?.readShort();
                let i:Int = Int((_bytes?.readUnsignedShort())!);
                
                let strByts:UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>(malloc(i));
                _bytes?.readBytes(strByts, position: (_bytes?.gposition())!, len: UInt32(i));
                if(isUpdate == true)
                {
                   
                    DrawTool.getInstance().undo();
                }
                DrawTool.getInstance().addTextField(NSString(bytes: strByts, length: i, encoding:NSUTF8StringEncoding ) as! String, point: (temprect?.origin)!, franmesize: (temprect?.size)!);
                drawView?.setNeedsDisplayInRect((drawView?.bounds)!);
            }
            
        }
    }
    
    private func readCurrentInfo(_bytes:ByteArray,inout serverWidth:Int,inout serverHeight:Int,inout _isUpdate:Bool)
    {
        //取得图形ID
        tempDrawId = Int(_bytes.readUnsignedShort());
        if(DrawTool.getInstance().wantDrawId > 0 && (DrawTool.getInstance().wantDrawId-1 == UInt16(tempDrawId!)))
        {
            _isUpdate = true;
        }else
        {
            _isUpdate = false;
        }
        
        DrawTool.getInstance().wantDrawId = UInt16(tempDrawId!);
        _bytes.readUnsignedInt64();//创建时间
        serverWidth = Int(_bytes.readShort());
        serverHeight = Int(_bytes.readShort());
        DrawTool.getInstance().LineWidth = CGFloat(_bytes.readUnsignedByte());
        DrawTool.getInstance().LineColor = _bytes.readUnsignedInt();
    }
}