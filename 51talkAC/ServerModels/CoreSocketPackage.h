//
//  CoreSocketPackage.h
//  AC_project
//
//  Created by guominglong on 15-1-5.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISocketData.h"
#import "ByteArray.h"
@interface CoreSocketPackage : NSObject
{
    ISocketData * _body;
}

/**
 * 包头标识
 * */
@property uint16_t headFlag;


/**
 * 完整包的长度
 * */
@property uint32_t size;


/**
 * 包序列号
 * */
@property uint32_t sequence;


/**
 * 包类型0x01 - 服务器=>服务器（S2S）
 0x02 - 客户端=>服务器（C2S）
 0x04 - 服务器=>客户端（S2C）
 0x08 - 客户端=>客户端（C2C）
 0x20 - 网页端=>客户端（W2C）
 * */
@property uint8_t packetType;


/**
 * 协议名称标识
 * */
@property uint32_t commandID;


/**
 * 会话类型
 * 	0x00 - 未登录（默认）0x01 - 已登录
 * */
@property uint8_t sessionType;


/**
 * 信息即时类型：
 0x00 - 即时信息（默认）
 0x01 - 离线信息
 * */
@property uint8_t offlineAct;


/**
 * 加解密方式：
 0x00 - 不加密（调试使用）
 0x01 - 加密方式1
 0x02 - 加密方式2
 0x03 - 加密方式3
 * */
@property uint8_t cryptType;

/**
 * 公钥序号
 * */
@property uint16_t pubKeyIndex;

/**
 * 超时时长，单位秒，默认15
 * */
@property uint16_t timeout;


/**
 * 源标识号
 * */
@property uint64_t source;

/**
 * 目标标识号
 * */
@property uint64_t target;

/**
 * 保留
 * */
@property uint16_t reserved;

/**
 * 协议数据的二进制形式
 * */
@property ByteArray * gdata;

/**
 * 包尾标志
 * */
@property uint8_t tailFlag;


-(void)setBody:(ISocketData *)_body;
/**
 可操作的协议体
 */
-(ISocketData *)body;
@end
