//
//  UserListPanel.swift
//  AC for swift
//
//  Created by guominglong on 16/1/5.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
public class UserListPanel:NSView{

    private var items:NSMutableArray!;
    private var tb:NSTextField!;
    private var itemFrame:NSRect!;
    public override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
        self.layer = CALayer();
        self.layer?.bounds = self.bounds;
        self.layer?.backgroundColor = NSColor.whiteColor().CGColor;
        self.layer?.borderWidth = 1;
        self.layer?.borderColor = NSColor(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1).CGColor;
        self.layer?.setNeedsDisplay();
        items = NSMutableArray();
        tb = NSTextField(frame: NSMakeRect(10,0,120,20));
        tb.backgroundColor = NSColor.clearColor();
        tb.bordered = false;
        tb.selectable = false;
        tb.editable = false;
        tb.font = StyleManager.instance.nsfont5;
        addSubview(tb);
        tb.stringValue = LanguageManager.instance().getLanguageStr("tb_userListPanelTitle");
        
        itemFrame = NSMakeRect(0,0,self.frame.width,26);
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder:coder);
    }
    
    public func setFrameIdx(mID:Int32,val:Int32)
    {
        var i:Int = 1;
        //移除现有的
        for(;i<self.subviews.count;i++)
        {
            if((self.subviews[i] as! UserItem).mediaID == mID)
            {
                (self.subviews[i] as! UserItem).setFrameIdx(Int(val/2));
                break;
            }
        }
    }
    
    public func fillList(arr:ClassUserVector){
        var views:Array = self.subviews;
        var i:Int = 1
        //移除现有的
        for(;i<views.count;i++)
        {
            views[i].removeFromSuperview();
            items.addObject(views[i]);//添加到对象池
        }
        
        var ii:UInt=0;
        let j:UInt = arr.size();
        var ty:CGFloat = 0;
        var item:UserItem;
        
        for(;ii<j;ii++)
        {
            if(items.count > 0)
            {
                item = (items[0] as! UserItem);
                items.removeObject(items[0]);
            }else{
                item = UserItem(frame: itemFrame);
            }
            item.fillInfo(arr.get(ii));
            NSLog("ID=%D", item.mediaID);
            item.frame.origin.y = ty;
            ty = ty + item.frame.height;
            addSubview(item);
        }
        
        tb.frame.origin.y = ty + 5;
        self.frame.size.height = tb.frame.origin.y + tb.frame.size.height + 8;
        self.setNeedsDisplayInRect(self.frame);
    }
    
    
}

public class UserItem:NSView
{
    var headImg:NSImageView!;
    var cameraImg:NSImageView!;
    var micImg:FrameView2!;
    var imgjindu:NSView!;
    var tb_nickName:NSTextField!;
    var userID:UInt64! = 0;
    var mediaID:Int32!=0;
    public override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
        var position:NSRect = NSMakeRect(10, 7, 20, 20);
        headImg = NSImageView(frame: position);
        addSubview(headImg);
        position.origin.x = frameRect.width - 20;
        position.origin.y = 9;
        micImg = FrameView2(_imgskin: ResourceManager.instance.getResourceByName("mic_values"), _type: 5);
        addSubview(micImg);
        micImg.setFrameOrigin(position.origin);
        
        position.size.width = 8;
        position.origin.x = frameRect.width - 20;
        imgjindu = NSView(frame: position);
        imgjindu.layer = CALayer();
        imgjindu.layer?.backgroundColor = NSColor.clearColor().CGColor;
        addSubview(imgjindu);
        
        position.size.width = 20;
        position.origin.x = position.origin.x - 25;
        position.origin.y = 7;
        cameraImg = NSImageView(frame: position);
        cameraImg.image = ResourceManager.instance.getResourceByName("userlist_camera");
        addSubview(cameraImg);
        
        
        
        position.origin.x = 35;
        position.size.width = 130;
        tb_nickName = NSTextField(frame: position);
        tb_nickName.backgroundColor = NSColor.clearColor();
        tb_nickName.bordered = false;
        tb_nickName.selectable = false;
        tb_nickName.editable = false;
        tb_nickName.font = StyleManager.instance.nsfont5;
        addSubview(tb_nickName);
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder:coder);
    }
    
    
    public func fillInfo(cu:ClassUser)
    {
        userID = cu.getUserId();
        mediaID = Int32(cu.getMediaId());
        if(cu.getRole().rawValue == ROLE_STUDENT.rawValue)
        {
            //学生样式
            headImg.image = ResourceManager.instance.getResourceByName("1v1_student");
        }else{
            //老师样式
            headImg.image = ResourceManager.instance.getResourceByName("1v1_teacher");
        }
        tb_nickName.stringValue = cu.getDisplayName();
    }
    
    public func setFrameIdx(i:Int)
    {
        micImg.setFrameIdx(i);
    }
}