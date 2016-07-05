//
//  SocketTool.m
//  AC_project
//
//  Created by guominglong on 15-1-1.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "SocketTool.h"
#import "CoreSocketDataAdapter.h"
#import "CoreSocketCommandEnum.h"
#import "GLogger.h"
#import "AsyncSocket.h"
@implementation SocketTool


static NSString * _ghost;

static uint32_t _gprot;



/**
 Socket地址
 */
+(NSString *)ghost
{
    return _ghost;
}
+(void)setGhost:(NSString *)h
{
    _ghost = h;
}

/**
 可连接的端口
 */
+(uint16_t)gport
{
    return _gprot;
}
+(void)setGport:(uint16_t)p
{
    _gprot = p;
}


/**
 处理socket返回的数据
 */
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [[CoreSocketDataAdapter getInstance] pushResponseData:data];//交给数据处理工具来处理
}


/**
 向服务器发送数据
 */
-(void)sendSocketData:(AsyncSocket *)socket byts:(ByteArray *)_byts commandId:(uint32_t)_commandId sequence:(uint32_t)_sequence
{
    NSString * log = [NSString stringWithFormat:@"[sendSocketData]发送数据包，by数据包ID:%u，CommandID：%x",_sequence,_commandId];
    [GLogger print:log];
    [socket writeData:[_byts mudata] withTimeout:-1 tag:_sequence];
    switch (_commandId) {
        case kehuduanxintiao:
        case jinrujiaoshiwancheng:
        case likaijiaoshi:
        case yonghudengluwanbi:
        case biangenggerenzhuangtai:
            return;//不添加等待socket返回消息的命令
            break;
            
        default:
            [socket readDataWithTimeout:-1 tag:_sequence];//等待服务器返回数据
            break;
    }
    
}


-(NSString *)getIPStringByUint:(uint32_t)_value type:(uint8_t)_type
{
    if (_type != 0) {
        //转大字节序
        _value = htonl(_value);
    }
    
    return [[NSString alloc] initWithFormat:@"%i.%i.%i.%i",
            (_value >> 24),
            ((_value >> 16) &0x00ff),
            ((_value >> 8) & 0x0000ff),
            (_value & 0x000000ff)];
}

/**
 * 对服务器返回信息状态进行断言
 * */
-(Boolean)assert:(uint32_t)status sequence:(uint32_t)_sequence
{
    bool b;
    NSString * logstr;
    switch(status){
        case chenggong:
            b=true;
            logstr = [[NSString alloc] initWithFormat:@"[assert]成功返回数据by数据包ID:%x",_sequence];
            break;
        case shujvkufangwencuowu:
            logstr = [[NSString alloc] initWithFormat:@"[assert]数据库访问错误by数据包ID:%x",_sequence];
            break;
        case weizhijiamifangshi:
            logstr = [[NSString alloc] initWithFormat:@"[assert]未知加密方式by数据包ID:%x",_sequence];
            break;
        case weizhimubiaolixianfangshi:
            logstr = [[NSString alloc] initWithFormat:@"[assert]未知目标离线方式by数据包ID:%x",_sequence];
            break;
        case weizhixieyibaoleixing:
            logstr = [[NSString alloc] initWithFormat:@"[assert]未知协议包类型by数据包ID:%x",_sequence];
            break;
        case wukeyongfuwu:
            logstr = [[NSString alloc] initWithFormat:@"[assert]无可用服务by数据包ID:%x",_sequence];
            break;
        case xieyibanbenbuzhichi:
            logstr = [[NSString alloc] initWithFormat:@"[assert]协议版本不支持by数据包ID:%x",_sequence];
            break;
        case xieyishujvchangduguoda:
            logstr = [[NSString alloc] initWithFormat:@"[assert]协议数据长度过大by数据包ID:%x",_sequence];
            break;
        case xieyiziduanjiexicuo:
            logstr = [[NSString alloc] initWithFormat:@"[assert]协议字段解析错误by数据包ID:%x",_sequence];
            break;
        case zhengbaoyanzhengcuowu:
            logstr = [[NSString alloc] initWithFormat:@"[assert]整包校验错误by数据包ID:%x",_sequence];
            break;
        default :
            NSLog(@"逻辑有问题");
            break;
    }
    [GLogger print:logstr];
    return b;
}

-(void)alertBytes:(Byte *)_bytes len:(NSInteger)_len
{
    NSData * ns = [NSData dataWithBytes:_bytes length:_len];
    NSLog(@"%@",ns);
}

/**
 连接Socket
 */
-(void)connect:(NSString *)_host port:(UInt16)_port
{
    NSLog(@"ok");
}

/**
 关闭Socket
 */
-(void)close
{
    
}

/**
 获得了一个待处理的数据包
 */
-(void)pushSocketData:(CoreSocketPackage *)_data
{
    NSLog(@"如果消息发送动这里，说明错了");
}
@end
