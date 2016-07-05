//
//  CoreSocketPackage.m
//  AC_project
//
//  Created by guominglong on 15-1-5.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "CoreSocketPackage.h"
#import "CoreSocketDataAdapter.h"
#import "CoreSocketCommandEnum.h"
@implementation CoreSocketPackage



-(void)setBody:(ISocketData *)_b
{
    _body = _b;
}

-(ISocketData *)body
{
    if(_body == nil)
    {
        //解析data二进制流
        if(self.cryptType!=0)
        {
            uint32_t len =(uint32_t)self.gdata.length;
            Byte * byts=malloc(len);
            [self.gdata readBytes:byts position:0 len:len];
            self.gdata = [[CoreSocketDataAdapter getInstance] decode:byts len:len];/*needDecode为解密类型*/
            self.cryptType = 0;
        }
        _body = [[CoreSocketDataAdapter getInstance] createProtoColByBytes:[self gdata] commandID:[self commandID]];
        [self.gdata clear];
    }
    return _body;
}
@end
