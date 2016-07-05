//
//  AESTool.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESTool : NSObject
{
    char * key;//秘钥字符串
    uint8_t len;//采用 kCCKeySizeAES128 kCCKeySizeAES192 kCCKeySizeAES256 方式加密
    uint8_t * iv;
}


+(AESTool *)getInstance;



/**
 加密
 */
-(NSData *)AesEncrypt:(Byte *)_bytes bytesLen:(uint32_t)_bytesLen;

/**
 解密
 */
-(NSData *)AesDecrypt:(Byte *)_bytes bytesLen:(uint32_t)_bytesLen;

/**
 初始化
 */
-(void)ginit:(const char *)_key len:(uint8_t)_len;

//@property () NSString * s;
@end
