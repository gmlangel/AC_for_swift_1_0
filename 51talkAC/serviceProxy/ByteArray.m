//
//  ByteArray.m
//  AC_project
//
//  Created by guominglong on 15-1-5.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "ByteArray.h"

@implementation ByteArray






-(void)setLength:(NSInteger)_length
{
    [_mudata setLength:_length];
}

-(NSInteger)length
{
    return  [_mudata length];
}
-(void)setGposition:(uint32_t)gp
{
    _gposition = gp;
    self.bytesAvailable = (uint32_t)[_mudata length]-self.gposition;
}
-(uint32_t)gposition
{
    return _gposition;
}

-(BOOL)readBoolean
{
    if(self.bytesAvailable<1)
        return false;
    Byte *byte = alloca(1);
    [_mudata getBytes:byte range:NSMakeRange(self.gposition, 1)];
    self.gposition +=1;
    //self.bytesAvailable -=1;
    bool b =(bool)(*byte);
    return b;
}



-(int8_t)readByte
{
    if(self.bytesAvailable<1)
        return 0;
    Byte *byte = alloca(1);
    [_mudata getBytes:byte range:NSMakeRange(self.gposition, 1)];
    self.gposition +=1;
    //self.bytesAvailable -=1;
    int8_t b =(int8_t)(*byte);
    return b;
}

-(void)readBytes:(Byte *)_buffer position:(uint32_t)_position len:(uint32_t)_len
{
    [_mudata getBytes:_buffer range:NSMakeRange(_position, _len)];
    self.gposition =_position+_len;
    //self.bytesAvailable=(uint32_t)[_mudata length]-self.gposition;
}
-(uint8_t)readUnsignedByte
{
    if(self.bytesAvailable<1)
        return 0;
    Byte *byte = alloca(1);
    [_mudata getBytes:byte range:NSMakeRange(self.gposition, 1)];
    self.gposition +=1;
    //self.bytesAvailable -=1;
    uint8_t b =(uint8_t)(*byte);
    return b;
}
-(uint32_t)readUnsignedInt
{
    if(self.bytesAvailable<4)
        return 0;
    uint32_t b;
    [_mudata getBytes:&b range:NSMakeRange(self.gposition, 4)];
    self.gposition +=4;
   // self.bytesAvailable -=4;
    if(self.isBigEndian)
        b = ntohl(b);
    return b;
}
-(uint16_t)readUnsignedShort
{
    if(self.bytesAvailable<2)
        return 0;
    uint16_t b;
    [_mudata getBytes:&b range:NSMakeRange(self.gposition, 2)];
    self.gposition +=2;
   // self.bytesAvailable -=2;
    if(self.isBigEndian)
        b = ntohs(b);
    
    return b;
}

-(int16_t)readShort
{
    if(self.bytesAvailable<2)
        return 0;
    int16_t b;
    [_mudata getBytes:&b range:NSMakeRange(self.gposition, 2)];
    self.gposition +=2;
   // self.bytesAvailable -=2;
    if(self.isBigEndian)
        b = ntohs(b);
    
    return b;
}

-(NSString *)readUTFString
{
    uint32_t len = [self readUnsignedInt]-1;//去掉\0这个字节的长度
    NSString * result;
    if(len+self.gposition<=[_mudata length])
    {
        result = [
                  [NSString alloc] initWithData:
                  [_mudata subdataWithRange:NSMakeRange(self.gposition, len)] encoding:NSUTF8StringEncoding
                  ];
        //self.bytesAvailable-=len;
        self.gposition +=len;
    }
    else
        result = @"";
    [self readByte];//读取一个\0
    return result;
}

-(NSString *)readUnicodeString
{
    uint32_t len = [self readUnsignedShort];//去掉\0这个字节的长度
    NSString * result;
    if(len+self.gposition<=[_mudata length])
    {
        result = [
                  [NSString alloc] initWithData:
                  [_mudata subdataWithRange:NSMakeRange(self.gposition, len)] encoding:NSUnicodeStringEncoding
                  ];
        //self.bytesAvailable-=len;
        self.gposition +=len;
    }
    else
        result = @"";
    return result;
}

-(uint64_t)readUnsignedInt64
{
    if(self.bytesAvailable<8)
        return 0;
    uint64_t b;
    [_mudata getBytes:&b range:NSMakeRange(self.gposition, 8)];
    self.gposition +=8;
   // self.bytesAvailable -=8;
    
    b = [self ntohll:b];
    
    return b;
}


-(void)writeByte:(int8_t)byte
{
    [_mudata appendBytes:&byte length:1];
    self.bytesAvailable+=1;
}

-(void)writeBytes:(Byte *)_bytes len:(uint32_t)_len
{
    [_mudata appendBytes:_bytes length:_len];
    self.bytesAvailable+=_len;
}
-(void)writeUnsignedInt:(uint32_t)_value
{
    
    _value = htonl(_value);
    
    [_mudata appendBytes:&_value length:4];
    self.bytesAvailable+=4;
}
-(void)writeShort:(int16_t)_value
{
    
    _value = htons(_value);
    
    [_mudata appendBytes:&_value length:2];
    self.bytesAvailable+=2;
}
-(void)writeUTFString:(NSString *)_value
{
    uint32_t len;
    if(_value == nil || [_value isEqual: @""])
    {
        len = 1;//结尾\0操作
        [self writeUnsignedInt:len];
        [self writeByte:0];
        
    }
    else
    {
        NSData * dt =[_value dataUsingEncoding:NSUTF8StringEncoding];
        len = (uint32_t)[dt length]+1;
        [self writeUnsignedInt:len];
        [_mudata appendData:dt];
        [self writeByte:0];
        self.bytesAvailable += (len-1);
        dt = nil;
    }
}

-(void)writeUnicodeString:(NSString *)_value
{
    uint16_t len;
    if(_value == nil || [_value isEqual: @""])
    {
        [self writeUnsignedInt:0];
    }
    else
    {
        NSData * dt =[_value dataUsingEncoding:NSUnicodeStringEncoding];
        len = (uint16_t)[dt length];
        [self writeShort:len];
        [_mudata appendData:dt];
        self.bytesAvailable += len;
        dt = nil;
    }
}

-(void)writeUnsignedInt64:(uint64_t)_value
{
    _value = [self htonll:_value];
    
    [_mudata appendBytes:&_value length:8];
    self.bytesAvailable+=8;
}

-(id)init
{
    self = [super init];
    _mudata = [[NSMutableData alloc] init];
    self.isBigEndian = true;
    return  self;
}

-(void)clear
{
    self.length = 0;
    _mudata = nil;
}

-(uint64_t)htonll:(uint64_t)_v
{
    if(0xea67 == ntohl(0xea67))
    {
        //如果转换前和转换后得值相同，则不需要转换，也不需要按位计算
        return _v;
    }
    uint64_t result;
    result = (_v >> 32);
    result = htonl(_v >> 32);
    _v = htonl(_v & 0x00000000ffffffff);
    _v = _v << 32;
    result = result | _v;
    return result;
}

-(uint64_t)ntohll:(uint64_t)_v
{
    if(0xea67 == ntohl(0xea67))
    {
        //如果转换前和转换后得值相同，则不需要转换，也不需要按位计算
        return _v;
    }
    uint64_t result;
    result = (_v >> 32);
    result = ntohl(result);
    _v = ntohl(_v & 0x00000000ffffffff);
    _v = _v << 32;
    result = result | _v;
    return result;
}

@end
