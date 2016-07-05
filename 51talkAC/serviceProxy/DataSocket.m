//
//  DataSocket.m
//  AC_project
//
//  Created by guominglong on 15-1-10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "DataSocket.h"
#import "MainSocket.h"
#import "CoreSocketDataAdapter.h"
#import "GLogger.h"
#import "CoreSocketCommandEnum.h"
#import "GlobelInfo.h"
#import "InstanceManager.h"
@implementation DataSocket

static DataSocket *_instance = nil;



/**
 用于发送数据
 */
AsyncSocket * dsocket;


+(DataSocket *)getInstance
{
    if (_instance == nil) {
        _instance = [[DataSocket alloc]init];
        _instance.waitProtocal = [[NSMutableArray alloc] init];
    }
    return _instance;
}

-(void)connect:(NSString *)_host port:(UInt16)_port
{
    self.needConnect = true;
    NSError *err = nil;
    if(dsocket == nil)
    {
        dsocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    [[CoreSocketDataAdapter getInstance] setSocketProxy:self];
    if(![dsocket connectToHost:_host onPort:_port error:&err])
    {
        NSLog(@"Error: %@", err);
    }
    
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    [[[MainSocket getInstance] socketList] removeObjectAtIndex:0];//移除一个可尝试的链接，确保再次链接socket时，链接的是一个新的端口
    [GLogger print:[[NSString alloc] initWithFormat:@"Socket错误:%@",err]];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    
    self.iscontected = true;
    [GLogger print:@"[didConnectToHost]dataSocket连接成功"];
    [self clientIn];//调用客户端登陆接口
    //开启心跳
    nt = [NSTimer scheduledTimerWithTimeInterval:jiange target:self selector:@selector(heartbeat) userInfo:nil repeats:YES];
}


-(void)toclose
{
    if (dsocket != nil && [dsocket isConnected]==true) {
        [dsocket disconnect];
    }
}

/**
 手动关闭socket，不执行断线重练
 */
-(void)close
{
    //停止心跳

    [self toclose];
}

/**
 调用客户端接入接口
 */
-(void)clientIn
{
//    ByteArray * byts = [[CoreSocketDataAdapter getInstance] packPackage:[GlobelInfo getInstance].kehuinfo commandID:kehuduanjieru];
//    [self sendSocketData:dsocket byts:byts commandId:kehuduanjieru sequence:[[CoreSocketDataAdapter getInstance] sequence]];
}

-(void)pushSocketData:(CoreSocketPackage *)_data
{
    switch([_data commandID])
    {
        case kehuduanjieru:
            [self func2:_data];
            break;
        case yonghudenglu:
            [self func3:_data];
            break;
        case qiangzhiyonghuxiaxian:
            self.needConnect = false;
            [GLogger print:@"服务器端强制用户下线"];
            [self close];//当服务器强制下线时,自己关闭socket链接，不再自动重连
            break;
        case jinrujiaoshitongzhi:
            //[GlobelInfo getInstance].jiaoshitongzhi = (JinrujiaoshiTongzhi *)[_data body];
            break;
        default:
            [self.waitProtocal addObject:_data];
            //            if(AC_player.inited)
            //            {
            //处理waitProtocal中的所有等待处理的协议
            [self execWaitProtocal];
            //}
            break;
    }
}

/**
 Socket断开了
 */
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //[GlobelInfo getInstance].islogin = false;//更改用户登录状态
    //如果用于传输数据的Socket断开，则自动重连
    [GLogger print:@"[onYuanDuanclose]Socket连接已经断开"];
    self.iscontected = false;
    //断开维持长连接的心跳
    [nt invalidate];
    //链接被关闭
    if(self.needConnect)
    {
        //调用Socket主入口，重新连接Socket
        [[MainSocket getInstance] connect:[SocketTool ghost] port:[SocketTool gport]];
        
        
    }
}

-(void)func2:(CoreSocketPackage *)_data
{
    Kehuduanjieru * protocolData = (Kehuduanjieru *)[_data body];
    if([self assert:protocolData.RspCode sequence:_data.sequence] == true)
    {
        //用户登录
        Yonghudenglu_e * yonghu = [[Yonghudenglu_e alloc] init];
        yonghu.AccountType = 0;
       // yonghu.Account = [[GlobelInfo getInstance] webserviceUserid];
        yonghu.AuthTicket = malloc(0);
        yonghu.AuthTicketLength = 0;
        yonghu.DefaultStatus = 0;
        yonghu.ExternPassword = @"no";
        ByteArray * byts = [[CoreSocketDataAdapter getInstance] packPackage:yonghu commandID:yonghudenglu];
        [self sendSocketData:dsocket byts:byts commandId:yonghudenglu sequence:[[CoreSocketDataAdapter getInstance] sequence]];
    }
}

-(void)func3:(CoreSocketPackage *)_data
{
    //用户登录成功
    Yonghudenglu *  protocolData= (Yonghudenglu *)[_data body];
    if([self assert:protocolData.RspCode sequence:_data.sequence] == true)
    {
        //[GlobelInfo getInstance].islogin = true;//更改用户登录状态
       // [GlobelInfo getInstance].socketUserid = [NSString stringWithFormat:@"%llu",protocolData.UID];
        //链接成功
        self.iscontected = true;
        //this.dispatchEvent(new Event(Event.COMPLETE));向上层发送登陆成功命令
        //向服务器发送 用户已登录命令
        ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:nil commandID:yonghudengluwanbi];
        [self sendSocketData:dsocket byts:bys commandId:yonghudengluwanbi sequence:[[CoreSocketDataAdapter getInstance] sequence]];
        
        //变更用户状态
        Biangenggerenzhuangtai * o = [[Biangenggerenzhuangtai alloc] init];
        o.status = 0;
        bys = [[CoreSocketDataAdapter getInstance] packPackage:o commandID:biangenggerenzhuangtai];
        [self sendSocketData:dsocket byts:bys commandId:biangenggerenzhuangtai sequence:[[CoreSocketDataAdapter getInstance] sequence]];
        //进入教室
        //[self joinRoom:0 cid:[[GlobelInfo getInstance] CID] courseid:0 flag:0 userName:[GlobelInfo getInstance].socketUserid];//测试用
    }
}
-(void)func4:(CoreSocketPackage *)_data
{
//    Baibanshujv * protocolData = (Baibanshujv *)[_data body];
//    BaibanItem * item;
//    //获得白板数据
//    int j=protocolData.ItemNum;
//    DrawView * drawView = (DrawView *)[[InstanceManager instance] getModuleInstaceByName:@"DrawView"];
//    if(protocolData.ItemOperate == 4 || protocolData.ItemOperate==5)
//    {
//        [drawView clearDrawData];
//    }
//    
//    for(int i =0;i<j;i++)
//    {
//        NSLog(@"执行一条绘画命令");
//        item = (BaibanItem *)protocolData.Items[i];
//        ByteArray * bytes = [[ByteArray alloc] init];
//        bytes.isBigEndian = false;
//        [bytes writeBytes:item.ItemData len:item.ItemDataLength];
//        [drawView syncDraw:bytes cmdType:protocolData.ItemOperate];
//
//        //千万不要清除流，因为whiteBoardProxy还需要用到
//        //if([item ItemData])
//           // free(item.ItemData);//清除无用的二进制流
//    }
}
-(void)func5:(CoreSocketPackage *)_data
{
    Jinrujiaoshi * protocolData = (Jinrujiaoshi *)[_data body];
    if([self assert:protocolData.RspCode sequence:_data.sequence] == true)
    {
        //[GlobelInfo getInstance].classroomInfo = protocolData;
        //发送进入教室完成命令
        Jinrujiaoshi_e * o =[[Jinrujiaoshi_e alloc] init];
        o.SID = protocolData.SID;
        o.CID = protocolData.CID;
        o.CourseID = protocolData.CourseID;
        ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:o commandID:jinrujiaoshiwancheng];
        [self sendSocketData:dsocket byts:bys commandId:jinrujiaoshiwancheng sequence:[[CoreSocketDataAdapter getInstance] sequence]];
    }else{
        //[GLogger print:[NSString stringWithFormat:@"%llu进入教室失败",[GlobelInfo getInstance].CID]];
    }
}
-(void)func6:(CoreSocketPackage *)_data
{
    //接到服务器发来的设置教室通知
    JiaoshiCommon * protocolData = (JiaoshiCommon *)[_data body];
    if([self assert:protocolData.RspCode sequence:_data.sequence] == true)
    {
        //[GlobelInfo getInstance].currentClassRoomInfo =protocolData;
    }
}
-(void)func7:(CoreSocketPackage *)_data
{
    //设置光标
    Guangbiaoshujv * protocolData = (Guangbiaoshujv *)[_data body];
    
    NSLog(@"获得光标数据,w=%u,h=%u,x=%u,y=%u",
          protocolData.width,
          protocolData.height,
          protocolData.X_Offset,
          protocolData.Y_Offset);
}
-(void)func8:(CoreSocketPackage *)_data
{
    //演示文档翻页
    Yanshiwendangfanye * protocolData = (Yanshiwendangfanye *)[_data body];
    NSLog(@"演示文档翻页当前显示页=%u,总页数=%u",protocolData.CurrentPage,protocolData.TotalPage);
    
}

-(void)func9:(CoreSocketPackage *)_data
{
    //收到一条聊天消息
   // Liaotianxiaoxi * protocolData = (Liaotianxiaoxi *)[_data body];
//    if([[InstanceManager instance] getModuleInstaceByName:@"mainView"] != nil && [[[InstanceManager instance] getModuleInstaceByName:@"mainView"] respondsToSelector:@selector(socketCallBackMSG:)] == true)
//    {
//        [[[InstanceManager instance] getModuleInstaceByName:@"mainView"] performSelectorOnMainThread:@selector(socketCallBackMSG:) withObject:protocolData.Text waitUntilDone:false];
//    }
}

-(void)func10:(CoreSocketPackage *)_data
{
    //对方进入教室
    JinrujiaoshiTongzhi * protocolData = (JinrujiaoshiTongzhi *)[_data body];
    NSLog(@"%d进入了教室",(uint32_t)protocolData.UID);
}

-(void)func11:(CoreSocketPackage *)_data
{
    //有一个人离开教室
    JinrujiaoshiTongzhi * protocolData = (JinrujiaoshiTongzhi *)[_data body];
    NSLog(@"%d离开了教室",(uint32_t)protocolData.UID);
}

-(void)sendChatMsg:(uint64_t)_sendTime tf:(NSString *)_textFormat text:(NSString *)_text
{
    Liaotianxiaoxi * proData = [[Liaotianxiaoxi alloc] init];
   // proData.CID = [GlobelInfo getInstance].CID;
    proData.SentTime = _sendTime;
    proData.Option = _textFormat;
    proData.Text = _text;
    ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:proData commandID:liaotianxiaoxi];
    [self sendSocketData:dsocket byts:bys commandId:liaotianxiaoxi sequence:[[CoreSocketDataAdapter getInstance] sequence]];
}

-(void)joinRoom:(uint64_t)_sid cid:(uint64_t)_cid courseid:(uint64_t)_courseid flag:(uint32_t)_flag userName:(NSString *)_userName
{
    
    Jinrujiaoshi_e * o = [[Jinrujiaoshi_e alloc] init];
    o.SID = _sid;
    o.CID = _cid;
    o.CourseID = _courseid;
    o.UserSwitchFlag = _flag;
    o.UserName = _userName;
    
    ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:o commandID:jinrujiaoshi];
    [self sendSocketData:dsocket byts:bys commandId:jinrujiaoshi sequence:[[CoreSocketDataAdapter getInstance] sequence]];
}


/**
 * 发送登出
 * */
-(void)logOff
{
    //[GlobelInfo getInstance].islogin = false;//更改用户登录状态
    //发送用户登出
    ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:nil commandID:yonghutuichu];
    [self sendSocketData:dsocket byts:bys commandId:yonghutuichu sequence:[[CoreSocketDataAdapter getInstance] sequence]];
}

/**
 退出教室
 */
-(void)exitClassRoom
{
    //发送离开教室
    Jinrujiaoshi_e * o = [[Jinrujiaoshi_e alloc] init];
   // o.SID = [GlobelInfo getInstance].classroomInfo.SID;
    //o.CID = [GlobelInfo getInstance].classroomInfo.CID;
    //o.CourseID = [GlobelInfo getInstance].classroomInfo.CourseID;
    ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:o commandID:likaijiaoshi];
    [self sendSocketData:dsocket byts:bys commandId:likaijiaoshi sequence:[[CoreSocketDataAdapter getInstance] sequence]];
   
}


/**
 处理还没有处理的数据包
 */
-(void)execWaitProtocal
{
    
    for (CoreSocketPackage * cp in [self waitProtocal]) {
        switch(cp.commandID)
        {
            case baibanshujv:
                [self func4:cp];
                break;
            case biangenggerenzhuangtai:
                [self assert:0 sequence:cp.sequence];
                break;
            case jinrujiaoshi:
                [self func5:cp];
                break;
            case setCommon:
                [self func6:cp];
                break;
            case guanbiaozhizhenweizhi:
                [self func7:cp];
                break;
            case yanshiwendangfanye:
                [self func8:cp];
                break;
            case liaotianxiaoxi:
                [self func9:cp];
                break;
            case jinrujiaoshitongzhi:
                [self func10:cp];
                break;
            case likaijiaoshitongzhi:
                [self func11:cp];
                break;
            default:break;
        }
    }
    [self.waitProtocal removeAllObjects];//移除处理过的内容
    [dsocket readDataWithTimeout:-1 tag:-1];//等待服务器返回数据(用作被动接收服务器传过来的数据)
}

-(void)alertBytes:(Byte *)_bytes len:(NSInteger)_len
{
    NSData * ns = [NSData dataWithBytes:_bytes length:_len];
    NSLog(@"%@",ns);
}

-(id)init
{
    self = [super init];
    jiange = 60;//1分钟
    return self;
}

-(void)heartbeat
{
    //维持socket长链接的心跳
    ByteArray * bys = [[CoreSocketDataAdapter getInstance] packPackage:nil commandID:kehuduanxintiao];
    [self sendSocketData:dsocket byts:bys commandId:kehuduanxintiao sequence:[[CoreSocketDataAdapter getInstance] sequence]];
}
@end
