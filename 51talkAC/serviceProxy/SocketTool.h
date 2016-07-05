//  Socekt连接器
//  SocketTool.h
//  AC_project
//
//  Created by guominglong on 15-1-1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreSocketPackage.h"
#import "AsyncSocket.h"


@interface SocketTool : NSObject<AsyncSocketDelegate>




@property bool iscontected;

/**
 是否需要断线重连
 */
@property bool needConnect;

 /**
 存放待处理的数据包
 */
@property NSMutableArray * waitProtocal;



/**
 Socket地址
 */
+(NSString *)ghost;
+(void)setGhost:(NSString *)h;

/**
 可连接的端口
 */
+(uint16_t)gport;
+(void)setGport:(uint16_t)p;

/**
 连接Socket
 */
-(void)connect:(NSString *)_host port:(UInt16)_port;

/**
 关闭Socket
 */
-(void)close;

/**
 获得了一个待处理的数据包
 */
-(void)pushSocketData:(CoreSocketPackage *)_data;


/**
 根据uint获得IP
 */
-(NSString *)getIPStringByUint:(uint32_t)_value type:(uint8_t)_type;

/**
 向socket发送数据
 */
-(void)sendSocketData:(AsyncSocket *)socket byts:(ByteArray *)_byts commandId:(uint32_t)_commandId sequence:(uint32_t)_sequence;

/**
 对socket数据进行断言
 */
-(Boolean)assert:(uint32_t)status sequence:(uint32_t)_sequence;
@end
