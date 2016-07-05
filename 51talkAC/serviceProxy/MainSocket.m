//
//  MainSocket.m
//  AC_project
//
//  Created by guominglong on 15-1-10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "MainSocket.h"
#import "DataSocket.h"
#import "CoreSocketDataAdapter.h"
#import "GLogger.h"
#import "CoreSocketCommandEnum.h"
@implementation MainSocket


static MainSocket * _instance = nil;
@synthesize socketList;


+(MainSocket *)getInstance
{
    if (_instance == nil) {
        _instance = [[MainSocket alloc]init];
        _instance.waitProtocal = [[NSMutableArray alloc] init];
        _instance.socketList = [[NSMutableArray alloc] init];
    }
    return _instance;
}

-(void)connect:(NSString *)_host port:(UInt16)_port
{
    if([self testLinkdataSocket] == true)
    {
        //还有可以尝试的DataSocket链接，不要从头链接Socket，应该继续尝试
        return;
    }
    SocketTool.ghost = _host;
    SocketTool.gport = _port;
    NSError *err = nil;
    if(gsocket == nil)
    {
        gsocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    self.needConnect = true;
    [[CoreSocketDataAdapter getInstance] setSocketProxy:self];//指定socket返回的数据由本类处理
    if(![gsocket connectToHost:_host onPort:_port error:&err])
    {
        NSLog(@"Error: %@", err);
    }
    
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    [GLogger print:[[NSString alloc] initWithFormat:@"Socket错误:%@",err]];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    [GLogger print:@"[didConnectToHost]CoreSocket正在分配线路"];
    //链接服务器分配的最优化的线路
    ByteArray * byts = [[CoreSocketDataAdapter getInstance] packPackage:nil commandID:fuzaijunhengfuwu];
    [self sendSocketData:gsocket byts:byts commandId:fuzaijunhengfuwu sequence:
     [[CoreSocketDataAdapter getInstance] sequence]];
}


-(void)toclose
{
    if (gsocket != nil && [gsocket isConnected]==true) {
        [gsocket disconnect];
    }
}

/**
 手动关闭socket，不执行断线重练
 */
-(void)close
{
    self.needConnect = false;
    [self toclose];
}



-(void)pushSocketData:(CoreSocketPackage *)_data
{
    switch([_data commandID])
    {
        case fuzaijunhengfuwu:
            [self func1:_data];
            break;
    }
}

/**
 Socket断开了
 */
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"MainSocket被断开");
    //链接被关闭
    if(self.needConnect)
    {
        
        time = 0;
        currentConnectCount ++;
        NSLog(@"正在尝试重连，重连次数：%i第次",currentConnectCount);
        //重新链接
        //if(![nt isValid])
            nt = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnect) userInfo:nil repeats:NO];
        //        GlobalDisplayManager.proload.setProloaderInfo("socket连接断开，正在重新链接...尝试"+(currentConnectCount+1)+"次");
        //        GlobalDisplayManager.proload.hideOrShow(true);
        
    }
}

-(void)func1:(CoreSocketPackage *)_data
{
    //拿到了负载均衡数据后，断开当前的MainSocket，尝试去链接DataSocket
    [self close];
    currentConnectCount = 0;
    //获得分线数据， 尝试连接dataSocket
    Fuzaijunheng * protocolData = (Fuzaijunheng *)_data.body;
    
    NSString * _host;
    if([self assert:protocolData.RspCode sequence:_data.sequence] == true)
    {
        [self.socketList removeAllObjects];//清楚之前无用的socket链接地址
        int i=0;int j=protocolData.ServerIPNum;
        for(;i<j;i++)
        {
            ServerObj * so =((ServerObj *)protocolData.ServerArr[i]);
            _host = [self getIPStringByUint:so.ServerIP
                                       type:0];
            for (int z =0 ; z<so.PortNum; z++) {
                ServerEntity * se = [[ServerEntity alloc] init];
                se.host = _host;
                se.port = (uint16_t)(so.Ports[z]);
                [self.socketList addObject:se];
            }
        }
        
    }
    
    if([self testLinkdataSocket] == false)
    {
        //重链Socket
        [self reconnect];
    }
    
}

-(BOOL)testLinkdataSocket
{
    if([self.socketList count] == 0)
        return false;
    ServerEntity * se =(ServerEntity *)(self.socketList[0]);
    if(![se.host isEqualToString:@""] && se.port > 0)
    {
        [[DataSocket getInstance] connect:se.host port:se.port];
        return true;
    }else
    {
        [self.socketList removeObjectAtIndex:0];
        if([self.socketList count] > 0)
            return [self testLinkdataSocket];
        else
            return false;
    }
    
}


-(void)reconnect
{
    if(time<60)
        time +=10;
    //重连一次
    [self connect:[SocketTool ghost] port:[SocketTool gport]];
}




@end
