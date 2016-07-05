//  数据包封装，解析工具
//  CoreSocketDataAdapter.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketTool.h"
#import "ISocketData.h"
#import "ByteArray.h"
@interface CoreSocketDataAdapter : NSObject
{
    /**
     * 接收到的数据流
     * */
    ByteArray *responsedataBytes;
    
    /*
     加密工具
     */
    NSObject *aes;
    SocketTool * pro;
    
}

/**
 * 包序列
 * */
@property uint32_t sequence;

+(CoreSocketDataAdapter *)getInstance;

-(void)setSocketProxy:(SocketTool *)_gproxy;

/**
 初始化操作
 */
-(void)ginit;



/**
 封装包数据
 */
-(ByteArray *)packPackage:(ISocketData *)_protocalObj commandID:(uint32_t)_commandID;

/**
 * 从源数据流中读取len个字节的数据，追加到responsedataBytes尾部
 * */
-(void)pushResponseData:(NSData *)_inputstream;

/**
 * 检查是否有一个可以解析的完整包，如果有则解析包，并新建responsedataBytes，将原有responsedataBytes中剩余数据Copy到新的responsedataBytes中
 * */
-(void)checkCanReadPackage;


/**
 * 通过AES算法解密二进制流
 * */
-(ByteArray *)decode:(Byte *)_bytes len:(uint32_t)_len;

/**
 * 通过AES算法加密二进制流
 * */
-(NSData *)encode:(Byte *)_bytes len:(uint32_t)_len;


/**
 * 根据二进制形式的协议，获得object形式的协议内容
 * @param _bytes byte[] 二进制形式的协议
 * @param commandID uint32 协议命令标识
 * */
-(ISocketData *)createProtoColByBytes:(ByteArray *)_bytes commandID:(uint32_t)_commandID;


@end
