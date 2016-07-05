//  主Socket入口
//  MainSocket.h
//  AC_project
//
//  Created by guominglong on 15-1-10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "SocketTool.h"

@interface MainSocket : SocketTool
{
    /**
     用于连接Socket
     */
    AsyncSocket * gsocket;
    
    
    /**
     已经循环重链的次数
     */
    int currentConnectCount;
    
    /**
     断线重连计时器
     */
    NSTimer * nt;
    
    /**
     时间间隔
     */
    NSTimeInterval time;
}

+(MainSocket *)getInstance;

/***
 负载均衡获得的socket ip集合
 */
@property NSMutableArray *socketList;

/**
 逐条尝试链接负载均衡服务返回的socket链接集合
 */
-(BOOL)testLinkdataSocket;
@end
