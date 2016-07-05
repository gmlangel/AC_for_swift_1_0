//
//  TranslatePanel.swift
//  51talkAC
//
//  Created by guominglong on 16/3/10.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
class TranslatePanel:NSView{
    private var tb_input:NSTextField!;
    private var btn_translate:NSButton!;
    
    private var urlstr:String!;
    private var url:NSURL!;
    private var uq:NSMutableURLRequest!;
    
    private var translateResult:String! = "";
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
        self.wantsLayer = true;
        self.layer?.backgroundColor = NSColor(red: 0xf9/255.0, green: 0xf9/255.0, blue: 0xf9/255.0, alpha: 1).CGColor;
        tb_input = NSTextField(frame: NSRect(x: 8, y: 4, width: self.bounds.size.width - 90, height: self.bounds.size.height - 8));
        tb_input.placeholderString = "请输入翻译内容";
        tb_input.cell?.scrollable = true;
        tb_input.cell?.wraps = false;
        addSubview(tb_input);
        
        btn_translate = NSButton(frame: NSRect(x: tb_input.frame.origin.x + tb_input.frame.size.width + 2, y: 0, width: 80, height: self.bounds.size.height - 2));
        btn_translate.title = "翻译";
        btn_translate.target = self;
        btn_translate.action = Selector("ontranslateClick:");
        (btn_translate.cell as? NSButtonCell)?.bezelStyle = NSBezelStyle.RoundedBezelStyle;
        addSubview(btn_translate);
        
        urlstr = "http://fanyi.youdao.com/openapi.do?keyfrom=51talk&key=1566149960&type=data&doctype=json&version=1.1&q=%@";
    }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    func ontranslateClick(sender:AnyObject)
    {
        if(tb_input.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "")
        {
            return;
        }
        translateResult = "";
        url = NSURL(string: String(format: urlstr, tb_input.stringValue).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
        uq = NSMutableURLRequest(URL: url);
        uq.HTTPMethod = "POST";
        NSURLConnection.sendAsynchronousRequest(uq, queue: NSOperationQueue.mainQueue(), completionHandler: onfanyiCallBack);
    }
    
    func onfanyiCallBack(urlresp:NSURLResponse?,nd:NSData?,ne:NSError?) ->Void
    {
        //解析JSON。
        if(ne == nil)
        {
            do{
                let resultData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(nd!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary;
                
                fenxiJSON(resultData);
            }catch{
                NSLog("翻译JSON发生错误");
            }
            
        }
    }
    
    func fenxiJSON(dic:NSDictionary)
    {
        let resultCode:Int = dic.valueForKey("errorCode") as! Int;
        switch(resultCode)
        {
        case 0:
            checkType(dic);
            break;
        case 20:
            showError("翻译内容过长");
            break;
        case 30:
            showError("没有找到对应的翻译结果");
            break;
        case 40:
            showError("暂不支持此语言类型");
            break;
        case 50:
            showError("翻译功能暂时不可用");
            break;
        case 60:
            showError("没有找到对应的翻译结果");
            break;
        default:break;
        }
    }
    
    func showError(str:String)
    {
        
    }
    
    func checkType(dic:NSDictionary)
    {
        
    }
}


//class TranslateView

