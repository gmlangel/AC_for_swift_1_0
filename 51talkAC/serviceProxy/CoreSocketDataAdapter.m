//
//  CoreSocketDataAdapter.m
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "CoreSocketDataAdapter.h"
#import "AESTool.h"
#import "ByteArray.h"
#import "CoreSocketPackage.h"
#import "ByteArray.h"
#import "GLogger.h"
#import "ProtocalAdapter.h"
@implementation CoreSocketDataAdapter

/**
 单例
 */
static CoreSocketDataAdapter  *_instance;


+(CoreSocketDataAdapter *)getInstance
{
    if(_instance == nil)
    {
        _instance = [[CoreSocketDataAdapter alloc] init];
        [_instance ginit];
    }
    return _instance;
}

-(void)setSocketProxy:(SocketTool *)_gproxy
{
    pro=_gproxy;
}

-(void)ginit
{
    //初始化respondataBytes
    responsedataBytes = [[ByteArray alloc] init];
    //初始化加密工具
    NSString * key =@"{971E1D3A-042B-41da-8E97-181F8073D8E2}";
    [[AESTool getInstance] ginit:[key UTF8String] len:32];
}


/**
 封装包数据
 */
-(ByteArray *)packPackage:(ISocketData *)_protocalObj commandID:(uint32_t)_commandID
{
    
    self.sequence++;
    NSData * body =[[ProtocalAdapter getInstance] encode:_protocalObj commandID:_commandID];//获得协议体
    NSData * afterEncodeody = [self encode:(Byte *)[body bytes] len:(uint32_t)[body length]];
    body =nil;
    uint32_t size = (uint32_t)[afterEncodeody length]+41;
    uint16_t headFlag = 0xEA67;
    uint8_t tailFlag = 0xEB;;
    /**
     用于存储要发送的数据
     */
    ByteArray * packbyts = [[ByteArray alloc] init];
    [packbyts writeShort:headFlag];//包头标志	2
    [packbyts writeUnsignedInt:size];//包大小	4
    [packbyts writeUnsignedInt:self.sequence];//包序列号	4
    [packbyts writeByte:0x20];/*包类型：
                              0x01 - 服务器=>服务器（S2S）
                              0x02 - 客户端=>服务器（C2S）
                              0x04 - 服务器=>客户端（S2C）
                              0x08 - 客户端=>客户端（C2C）
                              0x20 - 网页端=>客户端（W2C）	1*/
    [packbyts writeUnsignedInt:_commandID];//协议命令字		4
    [packbyts writeByte:0x00];/*会话类型：
                              0x00 - 未登录（默认）
                              0x01 - 已登录		1*/
    [packbyts writeByte:0x00];/*信息即时类型：
                              0x00 - 即时信息（默认）
                              0x01 - 离线信息		1*/
    [packbyts writeByte:0x02];/*加解密方式：
                              0x00 - 不加密（调试使用）(暂时先用1代替)
                              0x01 - 加密方式1
                              0x02 - 加密方式2
                              0x03 - 加密方式3		1*/
    [packbyts writeShort:13];//公钥序号	2
    [packbyts writeShort:15];//超时时长，单位秒，默认15	2
    
    //源标识号	8
    [packbyts writeUnsignedInt64:0];
    
    //目标标识号	8
    [packbyts writeUnsignedInt64:0];
    [packbyts writeShort:0];//保留 	2
    [packbyts writeBytes:(Byte *)[afterEncodeody bytes] len:(uint32_t)[afterEncodeody length]];//协议体
    [packbyts writeByte:tailFlag];//包尾标志	1
    afterEncodeody = nil;//回收资源
    
    return packbyts;
}

/**
 * 从源数据流中读取len个字节的数据，追加到responsedataBytes尾部
 * */
-(void)pushResponseData:(NSData *)_inputstream
{
    [responsedataBytes writeBytes:(Byte *)[_inputstream bytes] len:(uint32_t)[_inputstream length]];
    [self checkCanReadPackage];//检查可读包
}

/**
 * 检查是否有一个可以解析的完整包，如果有则解析包，并新建responsedataBytes，将原有responsedataBytes中剩余数据Copy到新的responsedataBytes中
 * */
-(void)checkCanReadPackage
{
    bool b=true;
    uint32_t size;
    uint16_t headFlag;
    if([responsedataBytes length] >=40)
    {
        responsedataBytes.gposition = 0;
        //识别到一段有可能是包头的数据
        headFlag = [responsedataBytes readUnsignedShort];
        if(headFlag != 0XEA67)
            b=false;//一个不可识别的包头标识
        if(!b)
            return;
        size = [responsedataBytes readUnsignedInt];
        if([responsedataBytes length] < size)
            b=false;//包不完整
        if(!b)
            return;
        CoreSocketPackage * packageData = [[CoreSocketPackage alloc] init];
        packageData.headFlag = headFlag;//2
        packageData.size = size;//4
        packageData.sequence = [responsedataBytes readUnsignedInt];//4
        packageData.packetType = [responsedataBytes readUnsignedByte];//1
        packageData.commandID = [responsedataBytes readUnsignedInt];//4
        packageData.sessionType = [responsedataBytes readUnsignedByte];//1
        packageData.offlineAct = [responsedataBytes readUnsignedByte];//1
        packageData.cryptType = [responsedataBytes readUnsignedByte];//1
        packageData.pubKeyIndex = [responsedataBytes readUnsignedShort];//2
        packageData.timeout = [responsedataBytes readUnsignedShort];//2
        packageData.source = [responsedataBytes readUnsignedInt64];//8
        packageData.target = [responsedataBytes readUnsignedInt64];//8
        packageData.reserved = [responsedataBytes readUnsignedShort];//2
        
        //读取包体的字节而不解析处理
        uint32_t datalen =packageData.size-41;
        Byte *bs = malloc(datalen);
        [responsedataBytes readBytes:bs position:[responsedataBytes gposition] len:datalen];
        packageData.gdata = [[ByteArray alloc] init];
        [packageData.gdata writeBytes:bs len:datalen];
        //free(bs);//---------------可能有问题
        
        //读包尾巴
        packageData.tailFlag = [responsedataBytes readUnsignedByte];
        if(packageData.tailFlag != 0xEB)
        {
            [GLogger print:@"[checkCanReadPackage]数据包解析异常"];
            return;
        }
        //数据包解析结束时的操作
        ByteArray * byts = [[ByteArray alloc] init];
        datalen =[responsedataBytes bytesAvailable];
        Byte * databs = malloc(datalen);
        [responsedataBytes readBytes:databs position:[responsedataBytes gposition] len:[responsedataBytes bytesAvailable]];
        [byts writeBytes:databs len:datalen];
        [responsedataBytes clear];
        responsedataBytes = byts;
        [pro pushSocketData:packageData];//派发一个可操作的数据包，给处理类
        [self checkCanReadPackage];//检查是否有一个可以解析的完整包

    }
}


/**
 * 通过AES算法解密二进制流
 * */
-(ByteArray *)decode:(Byte *)_bytes len:(uint32_t)_len
{
    NSData *result =[[AESTool getInstance]AesDecrypt:_bytes bytesLen:_len];
    ByteArray * byresult = [[ByteArray alloc] init];
    [byresult writeBytes:(Byte *)[result bytes] len:(uint32_t)[result length]];
    return byresult;
}

/**
 * 通过AES算法加密二进制流
 * */
-(NSData *)encode:(Byte *)_bytes len:(uint32_t)_len
{
    NSData *result =[[AESTool getInstance]AesEncrypt:_bytes bytesLen:_len];
    return result;
}


/**
 * 根据二进制形式的协议，获得指定形式的协议内容
 * @param _bytes byte[] 二进制形式的协议
 * @param commandID uint32 协议命令标识
 * */
-(ISocketData *)createProtoColByBytes:(ByteArray *)_bytes commandID:(uint32_t)_commandID
{
    return  [[ProtocalAdapter getInstance] decode:_bytes commandID:_commandID];
}
@end
