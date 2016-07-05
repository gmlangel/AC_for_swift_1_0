//
//  ChatItemTextFieldCell.swift
//  AC for swift
//
//  Created by guominglong on 15/5/12.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Cocoa

public class ChatItemTextFieldCell: NSTextFieldCell {
    
//    class var instance:ChatItemTextFieldCell
//        {
//        get{
//            if InstanceManager.instance().getModuleInstaceByName("ChatItemTextFieldCell") == nil
//            {
//                var myIns:ChatItemTextFieldCell = ChatItemTextFieldCell(textCell: "");
//                InstanceManager.instance().addModuleInstance(myIns, nameKey: "ChatItemTextFieldCell");
//            }
//            return InstanceManager.instance().getModuleInstaceByName("ChatItemTextFieldCell") as ChatItemTextFieldCell;
//        }
//    }
    
    init(textCell aString: String) {
        
    }
    
    init(imageCell image: NSImage?) {
        
    }
    
    override init() {
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
}
