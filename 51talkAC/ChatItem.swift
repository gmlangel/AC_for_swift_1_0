//  聊天单元
//  ChatItem.swift
//  AC for swift
//
//  Created by guominglong on 15/5/8.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

public class ChatItem: NSView {
    
    public var gname:String!="";
    /**
    最大宽度
    */
    private var maxWidth:CGFloat = 100;
    private var headerImg:NSImageView?;//头像
    private var userName:String = "";//用户名称
    //private var dateTitle:NSTextField?;//日期时间显示框
    private var contentTb:NSTextField?;//内容文本框
    private var userTb:NSTextField?;//用户昵称文本框
    private var bg:SpriteBmpScale9Grid?;//背景
    private var disType:Int = 0;
    private var _htmlText:NSString="";
    private var contentBmp:NSImageView?;
    
    /**
    高度
    */
    public var gheight:CGFloat = 0;
    
    public var gwidth:CGFloat = 0;
    
    private var testView:NSImageView?;
    public func htmlText()->String
    {
        return _htmlText as String;
    }
    
    public func setHtmlText(str:NSString)
    {
        _htmlText = str;
        let r1:NSRange = _htmlText.rangeOfString("[Image:{");
        let r2:NSRange = _htmlText.rangeOfString("}]");
        if(r1.location == 0 && r2.location > -1)
        {
            gname = str.substringWithRange(NSMakeRange(r1.length, r2.location-r1.length-4));
            //是一张位图
            contentTb?.hidden = true;
            contentBmp?.hidden = false;
//            var key:String = _htmlText.substringWithRange(NSMakeRange(r1.length, r2.location-4))
//            if(ResourceManager.instance.hasSource(key))
//            {
//                r2.location -= 4;
//                r2.length = 4;
//                loadImg(key, weizhui: _htmlText.substringWithRange(r2));
//            }
        }else{
            //是文本消息
            contentTb?.hidden = false;
            contentBmp?.hidden = true;
        }
        self.draw();
    }
    override public func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
        maxWidth = frameRect.size.width;
        headerImg = NSImageView(frame: NSMakeRect(0, 0, 32, 32));
        addSubview(headerImg!);
        
        
        contentTb = NSTextField(frame: NSMakeRect(0, 0, maxWidth - 66-10, 1000));
        addSubview(contentTb!);
        contentTb?.alignment = NSTextAlignment.Left;
        
        contentBmp = NSImageView(frame: NSMakeRect(30, 0, maxWidth - 66-10,maxWidth - 66-10));
        contentBmp?.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        addSubview(contentBmp!);
        //self.shadow = NSShadow();
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    /**
    设置显示样式 1为头像在左 文本在右。 2为头像在右 文本在左。 3为不显示头像和文本 只显示日期
    */
    public func setdisplayType(_type:Int,uname:String = "")
    {
        self.disType = _type;
        self.userName = uname;
        if(self.disType == 1)
        {
            userTb = NSTextField(frame: NSMakeRect(0, 0, self.maxWidth - 32, 15));
            userTb?.font = StyleManager.instance.nsfont4;
            userTb?.textColor = StyleManager.instance.nscolor2;
            userTb?.bordered = false;
            userTb?.drawsBackground = false;
            userTb?.stringValue = uname;
            userTb?.selectable = false;
            userTb?.editable = false;
            addSubview(userTb!);
        }
    }
    
    /**
    设置头像
    */
    public func setHeaderPath(img:NSImage)
    {
        headerImg?.image = img;
    }
    
    private func draw()
    {
        gheight = 0;
        if(bg == nil && disType != 3)
        {
            
            if(disType == 1)
            {
                bg = SpriteBmpScale9Grid(_imgskin: ResourceManager.instance.getResourceByName("chat_skin_0"), _rect:ResourceManager.instance.rect0);
            }else
            {
                bg = SpriteBmpScale9Grid(_imgskin: ResourceManager.instance.getResourceByName("chat_skin_1"), _rect:ResourceManager.instance.rect1);
            }
            addSubview(bg!, positioned: NSWindowOrderingMode.Above, relativeTo: headerImg);
        }else{
            //居中显示提示信息
            contentTb?.hidden = false;
            contentTb?.frame.size.width = self.bounds.size.width;
            contentTb?.frame.size.height = 22;
            contentTb?.frame.origin.x = 0;
            contentTb?.alignment = NSTextAlignment.Center;
            contentTb?.stringValue = htmlText();
            contentTb?.backgroundColor = NSColor.clearColor();
            contentTb?.bordered = false;
            contentTb?.editable = false;
            contentTb?.selectable = false;
            contentTb?.textColor = NSColor.blackColor();
            contentTb?.font = StyleManager.instance.nsfont5;
        }
        
        if(disType != 3)
        {
            if(contentTb?.hidden != true)
            {
                //显示文本  自动收缩尺寸处理
                let ce:NSTextFieldCell = NSTextFieldCell(textCell: htmlText());
                ce.selectable = true;
                ce.drawsBackground = true;
                ce.backgroundColor = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1);
                let s:NSSize = ce.cellSizeForBounds((contentTb?.bounds)!);
                contentTb?.cell = ce;
                contentTb?.frame.size.height = s.height;
                if(s.width < contentTb?.frame.size.width)
                {
                    contentTb?.frame.size.width = s.width+2;
                }
                bg?.frame = getRect((contentTb?.frame)!);
            }else
            {
                //显示图片
                bg?.frame = getRect((contentBmp?.frame)!);
            }
        }
        

        if(disType == 1)
        {
            //左侧显示文本
            bg?.setFrameOrigin(NSMakePoint(32, 0));
            userTb?.frame.origin.x = 34;
            userTb?.frame.origin.y = (bg?.frame.size.height)!;
            headerImg?.frame.origin.y = (userTb?.frame.size.height)! + (userTb?.frame.origin.y)! - 32;
        }else if(disType == 2)
        {
            //右侧显示文本
            bg?.setFrameOrigin(NSMakePoint(0, 2));
            headerImg?.frame.origin.x = (bg?.frame.size.width)!;
            if((bg?.frame.size.height)! > 34)
            {
                
                headerImg?.frame.origin.y = (bg?.frame.size.height)! + (bg?.frame.origin.y)! - 32;
            }
            
        }else{
            //居中显示文本
            headerImg?.hidden = true;
            gheight = (contentTb?.frame.size.height)!;
            gwidth = self.bounds.width;
            return;
        }

        gheight = (headerImg?.frame.origin.y)! + (headerImg?.frame.size.height)!;
        gwidth = (headerImg?.frame.size.width)! + (bg?.frame.size.width)!;
        if(contentTb?.hidden != true)
        {
            if(disType == 1)
            {
                contentTb?.frame.origin.x = (bg?.frame.origin.x)! + 12;
            }else
            {
                contentTb?.frame.origin.x = (bg?.frame.origin.x)! + 5;
            }
            contentTb?.frame.origin.y = (bg?.frame.origin.y)! + 5;
        }else
        {
            contentBmp?.frame.origin.x = (bg?.frame.origin.x)! + 10;
            contentBmp?.frame.origin.y = (bg?.frame.origin.y)! + 5;
        }

    }
    
    private func getRect(_frame:NSRect)->NSRect
    {
        return CGRect(x: 0, y: 0, width: _frame.size.width + 15, height: _frame.size.height + 10);
    }
    
    private func getTextCell(str:String)->NSTextFieldCell
    {
        let tb:NSTextFieldCell = NSTextFieldCell(textCell: str);
        return tb;
    }
    
    
    /**
    加载图片
    */
    public func loadImg(str:NSString,weizhui:NSString)
    {
        // NSString(format: "%@%@/%@/%@%@", ,str.substringWithRange(NSMakeRange(0, 1)),str.substringWithRange(NSMakeRange(1, 2)),str,weizhui);
        var path:String = GlobelInfo.getInstance().imageLoadPath;
        path += str.substringWithRange(NSMakeRange(0, 1));
        path += "/";
        path += str.substringWithRange(NSMakeRange(1,2));
        path += "/";
       // path += str as String;
        path += weizhui as String;
        contentBmp?.image = ResourceManager.instance.getResourceByURL(str as String, sourcePath: path);
    }
}

