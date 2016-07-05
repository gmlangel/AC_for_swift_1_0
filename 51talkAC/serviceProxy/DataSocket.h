//  数据协议处理类
//  DataSocket.h
//  AC_project
//
//  Created by guominglong on 15-1-10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "SocketTool.h"

@interface DataSocket : SocketTool
{
    /**
     心跳timer
     */
    NSTimer * nt;
    
    /**
     心跳间隔
     */
    uint32_t jiange;
}

+(DataSocket *)getInstance;
/**
 socket是否已经连接成功
 */
@property bool iscontected;

/**
 调用进入教室
 */
-(void)joinRoom:(uint64_t)_sid cid:(uint64_t)_cid courseid:(uint64_t)_courseid flag:(uint32_t)_flag userName:(NSString *)_userName;

-(void)sendChatMsg:(uint64_t)_sendTime tf:(NSString *)_textFormat text:(NSString *)_text;

/**
 * 发送登出
 * */
-(void)logOff;
/**
 退出教室
 */
-(void)exitClassRoom;


@end
