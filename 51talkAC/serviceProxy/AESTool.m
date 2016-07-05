//
//  AESTool.m
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "AESTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation AESTool

static AESTool * _instance;


+(AESTool *)getInstance
{
    if(_instance ==nil)
    {
        _instance = [[AESTool alloc] init];
    }
    
    return _instance;
}

-(void)ginit:(const char *)_key len:(uint8_t)_len{
    len = _len;
    key = malloc(_len +1);//生命len+1得内存空间，用来存储key
    bzero(key, _len +1);//置所有位置为0
    //填充key的数据
    for (uint8_t i=0; i<_len; i++) {
        key[i] = _key[i];
    }
    
    iv = malloc(16);
    for (uint8_t i=0; i<16; i++) {
        iv[i]=0;
    }
        //NSLog(@"aeskey=%s",key);
}

-(NSData *)AesDecrypt:(Byte *)_bytes bytesLen:(uint32_t)_bytesLen
{
    size_t bufferSize = _bytesLen + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          key, len,
                                          NULL,
                                          _bytes, _bytesLen,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData * result =[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return result;
    }
    free(buffer);
    return nil;
}

-(NSData *)AesEncrypt:(Byte *)_bytes bytesLen:(uint32_t)_bytesLen
{
    size_t bufferSize = _bytesLen + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          key, len,
                                          iv,
                                          _bytes, _bytesLen,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData * result =[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return result;
    }
    free(buffer);
    return nil;
}
@end
