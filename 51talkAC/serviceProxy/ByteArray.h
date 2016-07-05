//
//  ByteArray.h
//  AC_project
//
//  Created by guominglong on 15-1-5.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ByteArray : NSObject
{
    uint32_t _gposition;
}

/**
 是否是大字节序的流
 */
@property BOOL isBigEndian;
/**
 数据容器
 */
@property NSMutableData * mudata;

/**
 剩余的可读数据
 */
@property uint32_t bytesAvailable;

-(void)setLength:(NSInteger)_length;
-(NSInteger)length;

/**
 当前读取的数据位置
 */
-(uint32_t)gposition;
-(void)setGposition:(uint32_t)gp;

-(BOOL)readBoolean;
-(int8_t)readByte;
-(void)readBytes:(Byte *)_buffer position:(uint32_t)_position len:(uint32_t)_len;
-(uint8_t)readUnsignedByte;
-(uint32_t)readUnsignedInt;
-(uint16_t)readUnsignedShort;
-(int16_t)readShort;
-(NSString *)readUTFString;
-(NSString *)readUnicodeString;
-(uint64_t)readUnsignedInt64;


-(void)writeByte:(int8_t)byte;
-(void)writeBytes:(Byte *)_bytes len:(uint32_t)_len;
-(void)writeUnsignedInt:(uint32_t)_value;
-(void)writeShort:(int16_t)_value;
-(void)writeUTFString:(NSString *)_value;
-(void)writeUnicodeString:(NSString *)_value;
-(void)writeUnsignedInt64:(uint64_t)_value;
/**
 清空字节流
 */
-(void)clear;
@end


