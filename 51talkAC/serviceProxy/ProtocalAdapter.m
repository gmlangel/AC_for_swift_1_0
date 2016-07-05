//  协议体得具体封装解析工具
//  ProtocalAdapter.m
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "ProtocalAdapter.h"
#import "CoreSocketCommandEnum.h"
#import "ByteArray.h"
@implementation ProtocalAdapter

static ProtocalAdapter * _instance;
+(ProtocalAdapter *)getInstance
{
    if(_instance ==nil)
    {
        _instance = [[ProtocalAdapter alloc] init];
    }
    return _instance;
}
-(NSData *)encode:(ISocketData *)_protocalObj commandID:(uint32_t)_commandID
{
    NSData * result;
    switch (_commandID) {
        case fuzaijunhengfuwu:
            result = [self encodefuzaijunheng:_protocalObj];//封装负载均衡服务
            break;
        case yonghutuichu:
        case yonghudengluwanbi:
        case kehuduanxintiao:
            result=[[NSData alloc] init];//封装	维持长连接的心跳
            break;
        case kehuduanjieru:
            result = [self encodekehuduanjieru:_protocalObj];//封装 	客户端接入
            break;
        case yonghudenglu:
            result = [self encodeyonghudenglu:_protocalObj];//封装 	用户登陆
            break;
        case biangenggerenzhuangtai:
            result = [self encodebiangenggerenzhuangtai:_protocalObj];//封装 	变更个人状态
            break;
        case shangbaoyonghudadian:
            result = [self encodeshangbaoyonghudadian:_protocalObj];//封装 	上报用户打点
            break;
        case pingtest:
            result = [self encodepingtest:_protocalObj];//封装 	请求用户pingtest
            break;
        case liaotianwenzixiaoxi:
            result = [self encodeliaotianwenzixiaoxi:_protocalObj];//封装 	聊天消息文字
            break;
        case getCommon:
            result = [self encodegetCommon:_protocalObj];//封装 	获取教室Common
            break;
        case setCommon:
            result = [self encodesetCommon:_protocalObj];//封装	设置教室Common
            break;
        case jinrujiaoshi:
            result= [self encodejinrujiaoshi:_protocalObj];//封装 	进入教室
            break;
        case likaijiaoshi://封装	离开教室
        case jinrujiaoshiwancheng:
            result= [self encodejinrujiaoshiwancheng:_protocalObj];//封装 	进入教室完成
            break;
        case likaijiaoshitongzhi:
            result = [self encodelikaijiaoshitongzhi:_protocalObj];//封装	离开教室通知
            break;
        case liaotianxiaoxi:
            result = [self encodeliaotianxiaoxi:_protocalObj];//封装	聊天消息
            break;
        case baibanshujv:
            result = [self encodebaibanshujv:_protocalObj];//封装	白板数据
            break;
        case guanbiaozhizhenweizhi:
            result = [self encodeguangbiaozhizhenweizhi:_protocalObj];//封装	光标指针位置
            break;
        case yanshiwendangfanye:
            result = [self encodeyanshiwendangfanye:_protocalObj];//封装		演示文档翻页
            break;
        case yonghujiaoshidadian:
            result = [self encodeyonghujiaoshidadian:_protocalObj];//封装	用户教室打点数据
            break;
        case xiaoceyanchuti:
            result = [self encodexiaoceyanchuti:_protocalObj];//封装	小测验出题
            break;
        case xiaoceyandati:
            result = [self encodexiaoceyandati:_protocalObj];//封装	小测验答题
            break;
        default:
            break;
    }
    return  result;
}

-(ISocketData *)decode:(ByteArray *)_bytes commandID:(uint32_t)_commandID
{
    ISocketData * obj;
    switch (_commandID) {
        case fuzaijunhengfuwu:
            obj =[self decodefuzaijunheng:_bytes];
            break;
        case kehuduanjieru:
            obj = [self decodekehuduanjieru:_bytes];//解析 	客户端接入
            break;
        case yonghudenglu:
            obj = [self decodeyonghudenglu:_bytes];//解析	用户登陆
            break;
        case qiangzhiyonghuxiaxian:
            obj = [self decodeyonghuqiangzhixiaxian:_bytes];//解析    用户强制下线
            break;
        case biangenggerenzhuangtai:
            obj = [self decodebiangenggerenzhuangtai:_bytes];//解析 	变更个人状态
            break;
        case liaotianwenzixiaoxi:
            obj = [self decodeliaotianwenzixiaoxi:_bytes];//解析 	聊天消息文字
            break;
        case getCommon:
            obj = [self decodegetCommon:_bytes];//解析 	获取教室Common
            break;
        case setCommon:
            obj = [self decodegetCommon:_bytes];//解析	设置教室Common
            break;
        case commonshezhitongzhi:
            obj = [self decodejiaoshiCommonshezhitongzhi:_bytes];//解析	教室Common设置通知
            break;
        case jinrujiaoshi:
            obj = [self decodejinrujiaoshi:_bytes];//解析	进入教室：0x00130010
            break;
        case jinrujiaoshitongzhi:
            obj = [self decodejinrujiaoshitongzhi:_bytes];//解析	进入教室通知
            break;
        case jiaoshiguanbitongzhi:
            obj = [self decodejiaoshiguanbitongzhi:_bytes];//解析	教室关闭通知
            break;
        case liaotianxiaoxi:
            obj = [self decodeliaotianxiaoxi:_bytes];//解析	聊天消息
            break;
        case xiaoceyanchuti:
            obj = [self decodexiaoceyanchuti:_bytes];//解析	小测验出题
            break;
        case xiaoceyandati:
            obj = [self decodexiaoceyandati:_bytes];//解析 	小测验答题
            break;
        case baibanshujv:
            obj = [self decodebaibanshujv:_bytes];//解析 	白板数据
            break;
        case guanbiaozhizhenweizhi:
            obj = [self decodeguangbiaozhizhenweizhi:_bytes];//解析 	光标指针位置
            break;
        case yanshiwendangfanye:
            obj = [self decodegyanshiwendangfanye:_bytes];//解析 	演示文档翻页
            break;
        case likaijiaoshitongzhi:
        obj = [self decodelikaijiaoshitongzhi:_bytes];//解析 离开教室通知
            break;
    }
    return obj;
}



-(ISocketData *)decodefuzaijunheng:(ByteArray *)_bytes
{
    Fuzaijunheng * o = [[Fuzaijunheng alloc] init];
    _bytes.gposition = 0;
    o.RspCode = [_bytes readUnsignedInt];/*返回码：
                                          0x00000000-成功
                                          0x00000001-无可用服务		4*/
    o.ServerIPNum = [_bytes readUnsignedInt];/*接入服务器IP数量		4*/
    int i = 0;
    uint32_t j = o.ServerIPNum;
    o.ServerArr=[[NSMutableArray alloc] init];
    for(;i<j;i++)
    {
        ServerObj *serobj = [[ServerObj alloc] init];
        serobj.ServerIP = [_bytes readUnsignedInt];/*接入服务器IP		4*/
        serobj.PortNum = [_bytes readUnsignedInt];/*供客户端连接的端口数		4*/
        serobj.Ports =malloc(serobj.PortNum*2);/*供客户端连接的端口		serobj.PortNum * 2    */
        for(int z=0;z<serobj.PortNum;z++)
            serobj.Ports[z] = [_bytes readUnsignedShort];
        [o.ServerArr addObject:serobj];
    }
    return o;
}

-(ISocketData *)decodekehuduanjieru:(ByteArray *)_bytes
{
    Kehuduanjieru * o = [[Kehuduanjieru alloc]init];
    o.RspCode = [_bytes readUnsignedInt];/*返回码：
                                          0x00000000-成功
                                          0x00000001-无可用服务		4*/
    o.SessionKeyLength = [_bytes readUnsignedInt];/*用户会话密钥长度		4*/
    o.SessionKey = malloc(o.SessionKeyLength );
    [_bytes readBytes:o.SessionKey position:_bytes.gposition len:o.SessionKeyLength];/*用户会话密钥 	*/
    o.UpgradeInfo = [_bytes readUTFString];/* 客户端软件升级信息*/
    o.ClientInternetIP = [_bytes readUnsignedInt];/* 客户端的公网IP	4*/
    o.ClientPilotTips = [_bytes readUTFString];/* 客户端引导提示信息*/
    o.NetworkCommitInterval = [_bytes readUnsignedInt];/*客户端网络状况提交间隔，0表示不提交，单位：秒		4*/
    return o;
}

-(ISocketData *)decodeyonghuqiangzhixiaxian:(ByteArray *)_bytes
{
    Yonghuqiangzhixiaxian * o =[[Yonghuqiangzhixiaxian alloc]init];
    o.reasion = [_bytes readUnsignedInt];
    return o;
}

-(ISocketData *)decodeyonghudenglu:(ByteArray *)_bytes
{
    Yonghudenglu * o = [[Yonghudenglu alloc]init];
    o.RspCode = [_bytes readUnsignedInt];/*返回码：
                                          0x00000000-成功
                                          0x00000009-数据库访问错误
                                          0x01040001-不支持的客户端版本
                                          0x02010001-未知的帐号类型
                                          0x02010002-帐号格式错
                                          0x02010003-帐号不存在
                                          0x02010004-登录密码错
                                          0x02010005-帐号已锁定
                                          0x02010006-帐号未激活		4*/
    o.UID = [_bytes readUnsignedInt64];//用户唯一标识号		8
    o.UserName = [_bytes readUTFString];//用户名
    o.ServerTime = [_bytes readUnsignedInt64];//服务器时间	8
    o.LastLoginTime = [_bytes readUnsignedInt64];//服务器时间	8
    o.UserRight = [_bytes readUnsignedInt64];//用户功能权限：位标识	8
    o.DefaultStatus = [_bytes readUnsignedByte];/*用户登录成功后缺省状态
                                                 0-在线、1-忙碌、2-勿扰、3-离开、4-隐身		1*/
    return o;
}

-(ISocketData *)decodebiangenggerenzhuangtai:(ByteArray *)_bytes
{
    Biangenggerenzhuangtai * o =[[Biangenggerenzhuangtai alloc] init];
    o.status = [_bytes readUnsignedInt];
    return  o;
}

-(ISocketData *)decodeliaotianwenzixiaoxi:(ByteArray *)_bytes
{
    Liaotianwenzixiaoxi * o = [[Liaotianwenzixiaoxi alloc]init];
    o.SentTime = [_bytes readUnsignedInt];//发送时间	4
    o.Option = [_bytes readUTFString];//消息设置：
    o.ChatMessage = [_bytes readUTFString];//消息设置：
    return o;
}

-(ISocketData *)decodegetCommon:(ByteArray *)_bytes
{
    
    JiaoshiCommon * o = [[JiaoshiCommon alloc]init];
    o.RspCode = [_bytes readUnsignedInt];//返回码	4
    o.CID = [_bytes readUnsignedInt64];/*教室ID	8*/
    o.TxtMsgSize = [_bytes readUnsignedInt];//最大文本消息长度	4
    o.TxtMsgRate = [_bytes readUnsignedInt];//发送文本消息频率	4
    o.Set = [_bytes readUnsignedInt];//设置4
    o.SetArrayNum = [_bytes readUnsignedInt];//自定义设置数量
    o.SetArray = malloc(o.SetArrayNum * 4);
    for (int i =0; i<o.SetArrayNum; i++) {
        o.SetArray[i] = [_bytes readUnsignedInt];
    }
    return o;
}

-(ISocketData *)decodejiaoshiCommonshezhitongzhi:(ByteArray *)_bytes
{
    JiaoshiCommon * o = [[JiaoshiCommon alloc]init];
    o.CID = [_bytes readUnsignedInt64];/*教室ID	8*/
    o.TxtMsgSize = [_bytes readUnsignedInt];//最大文本消息长度	4
    o.TxtMsgRate = [_bytes readUnsignedInt];//发送文本消息频率	4
    o.Set = [_bytes readUnsignedInt];//设置4
    o.SetArrayNum = [_bytes readUnsignedInt];//自定义设置数量
    o.SetArray = malloc(o.SetArrayNum * 4);
    for (int i =0; i<o.SetArrayNum; i++) {
        o.SetArray[i] = [_bytes readUnsignedInt];
    }
    return o;
}

-(ISocketData *)decodexiaoceyanchuti:(ByteArray *)_bytes
{
    XiaoceyanChuti * o = [[XiaoceyanChuti alloc] init];
    o.CID = [_bytes readUnsignedInt64];//8
    o.QuestionID = [_bytes readUnsignedInt64];//8
    o.Type = [_bytes readUnsignedByte];//1
    o.Title = [_bytes readUTFString];
    o.Content = [_bytes readUTFString];
    o.OptionNum	= [_bytes readUnsignedInt];//4
    o.OptionItem = [[NSMutableArray alloc]init];
    int i=0;int j;
    if(o.OptionNum>0)
    {
        j = o.OptionNum;
        for(;i<j;i++)
        {
            [o.OptionItem addObject:[_bytes readUTFString]];
        }
        
    }
    o.AnserNum = [_bytes readUnsignedInt];//4
    o.AnserItem= malloc(o.AnserNum);
    [_bytes readBytes:o.AnserItem position:_bytes.gposition len:o.AnserNum];
    return o;
}

-(ISocketData *)decodejinrujiaoshi:(ByteArray *)_bytes
{
    Jinrujiaoshi * o = [[Jinrujiaoshi alloc] init];
    o.RspCode = [_bytes readUnsignedInt];//4
    //学校ID uint64处理	8
    o.SID = [_bytes readUnsignedInt64];
    //教室ID uint64处理	8
    o.CID = [_bytes readUnsignedInt64];
    //	8
    o.CourseID = [_bytes readUnsignedInt64];
    o.SchoolName = [_bytes readUTFString];
    o.ClassName = [_bytes readUTFString];
    o.StartTime = [_bytes readUnsignedInt];//开始上课时间
    o.Status = [_bytes readUnsignedByte];//课程状态		1
    o.MsgMode = [_bytes readUnsignedByte];//消息模式	1
    
    //学校ID uint64处理	8
    o.SwitchFlag = [_bytes readUnsignedInt64];
    //教室ID uint64处理	8
    o.OperatonFlag = [_bytes readUnsignedInt64];
    //	8
    o.OwnerID = [_bytes readUnsignedInt64];
    o.OwnerIn = [_bytes readUnsignedByte];//校长是否在教室内	1
    o.OwnerName = [_bytes readUTFString];//校长名称
    //老师ID 	8
    o.TeacherID = [_bytes readUnsignedInt64];
    o.TeacherIn = [_bytes readUnsignedByte];//校长是否在教室内	1
    o.TeacherName = [_bytes readUTFString];//校长名称
    o.AssistantNum = [_bytes readUnsignedInt];//助教数量 	4
    o.AssistantID = malloc(o.AssistantNum * 8);
    int i = 0;int j;
    j = o.AssistantNum;
    for (; i<j; i++) {
        o.AssistantID[i] = [_bytes readUnsignedInt64];
    }
    
    
    o.StudentNum = [_bytes readUnsignedInt];//学生数量 	4
    
    i=0;j= o.StudentNum;
    o.StudentID= malloc(o.StudentNum * 8);
    for (; i<j; i++) {
        o.StudentID[i] = [_bytes readUnsignedInt64];
    }
    return o;
}

-(ISocketData *)decodejinrujiaoshitongzhi:(ByteArray *)_bytes
{
    JinrujiaoshiTongzhi * o = [[JinrujiaoshiTongzhi alloc] init];
    o.SID = [_bytes readUnsignedInt64];//8
    o.CID = [_bytes readUnsignedInt64];//8
    o.CourseID = [_bytes readUnsignedInt64];//8
    o.UID = [_bytes readUnsignedInt64];//8
    o.UserName = [_bytes readUTFString];
    o.UserIdentity = [_bytes readUnsignedByte];//1
    o.UserRight = [_bytes readUnsignedByte];//1
    o.UserSwitchFlag = [_bytes readUnsignedInt64];//8
    return o;
}

-(ISocketData *)decodejiaoshiguanbitongzhi:(ByteArray *)_bytes
{
    Jiaoshiguanbitongzhi * o = [[Jiaoshiguanbitongzhi alloc] init];
    o.SID = [_bytes readUnsignedInt64];//8
    o.CID = [_bytes readUnsignedInt64];//8
    o.CourseID = [_bytes readUnsignedInt64];//8
    o.Reason = [_bytes readUnsignedShort];//2
    return  o;
}

-(ISocketData *)decodeliaotianxiaoxi:(ByteArray *)_bytes
{
    Liaotianxiaoxi * o = [[Liaotianxiaoxi alloc]init];
    o.CID = [_bytes readUnsignedInt64];//8
    o.SentTime = [_bytes readUnsignedInt64];//8
    o.Option = [_bytes readUTFString];
    o.Text = [_bytes readUTFString];
    return o;
}

-(ISocketData *)decodexiaoceyandati:(ByteArray *)_bytes
{
    Xiaoceyandati * o =[[Xiaoceyandati alloc]init];
    o.CID = [_bytes readUnsignedInt64];//8
    o.QuestionID = [_bytes readUnsignedInt64];//8
    o.UID = [_bytes readUnsignedInt64];//8
    o.AnserNum = [_bytes readUnsignedInt];//4
    o.AnserItem= malloc(o.AnserNum);
    [_bytes readBytes:o.AnserItem position:_bytes.gposition len:o.AnserNum];
    return o;
}

-(ISocketData *)decodebaibanshujv:(ByteArray *)_bytes
{
    Baibanshujv * o = [[Baibanshujv alloc] init];
    o.CID = [_bytes readUnsignedInt64];//8
    o.SentTime = [_bytes readUnsignedInt];//4
    o.MD5Length = [_bytes readUnsignedInt];//4
    o.BackgroundMD5 = malloc(o.MD5Length);
    [_bytes readBytes:o.BackgroundMD5 position:_bytes.gposition len:o.MD5Length];
    o.ItemOperate = [_bytes readUnsignedByte];/*None    = 0,
                                               Add     = 1,添加
                                               Delete  = 2,删除指定的图像
                                               Edit    = 3,
                                               Clear   = 4,全部删除
                                               Syn     = 5先清除，再添加所有图形*/
    o.ItemNum = [_bytes readUnsignedInt];//4
    o.Items = [[NSMutableArray alloc]init];
    int j = o.ItemNum;
    for(int i = 0;i<j;i++)
    {
        BaibanItem * item = [[BaibanItem alloc]init];
        item.itemClientSeq = [_bytes readUnsignedInt];//4
        item.ItemServerSeq = [_bytes readUnsignedInt];//4
        item.ItemDataLength = [_bytes readUnsignedInt];//4
        item.ItemData = malloc(item.ItemDataLength);
        [_bytes readBytes:item.ItemData position:_bytes.gposition len:item.ItemDataLength];
        [o.Items addObject:item];
    }
    
    return o;
}

-(ISocketData *)decodeguangbiaozhizhenweizhi:(ByteArray *)_bytes
{
    Guangbiaoshujv * o = [[Guangbiaoshujv alloc] init];
    o.CID = [_bytes readUnsignedInt64];//8
    o.SentTime = [_bytes readUnsignedInt64];//8
    o.PencilType = [_bytes readUnsignedByte];//1
    o.width = [_bytes readUnsignedShort];//2
    o.X_Offset = [_bytes readUnsignedShort];//2
    o.height = [_bytes readUnsignedShort];//2
    o.Y_Offset = [_bytes readUnsignedShort];//2
    return o;
}

-(ISocketData *)decodegyanshiwendangfanye:(ByteArray *)_bytes
{
    Yanshiwendangfanye * o =[[Yanshiwendangfanye alloc]init];
    o.CID = [_bytes readUnsignedInt64];//8
    o.SentTime = [_bytes readUnsignedInt64];//8
    o.Type = [_bytes readUnsignedByte];//1
    o.TotalPage = [_bytes readUnsignedShort];//2
    o.CurrentPage = [_bytes readUnsignedShort];//2
    o.CurrentPageMD5 = [_bytes readUTFString];
    return o;
}
-(ISocketData *)decodelikaijiaoshitongzhi:(ByteArray *)_bytes
{
    JinrujiaoshiTongzhi * o = [[JinrujiaoshiTongzhi alloc] init];
    o.SID = [_bytes readUnsignedInt64];//8
    o.CID = [_bytes readUnsignedInt64];//8
    o.CourseID = [_bytes readUnsignedInt64];//8
    o.UID = [_bytes readUnsignedInt64];//8
    o.UserName = [_bytes readUTFString];
    o.UserIdentity = [_bytes readUnsignedByte];//1
    o.UserRight = [_bytes readUnsignedByte];//1
    o.UserSwitchFlag = [_bytes readUnsignedInt64];//8
    return o;
}


//------------------------------以下是encode--------------------------------


-(NSData *)encodefuzaijunheng:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc] init];
    //测试用
    [byts writeUnsignedInt:0];
    [byts writeByte:0];
    [byts writeByte:0];
    [byts writeUnsignedInt:0];
    [byts writeUnsignedInt:0];
    Byte * buff = malloc([byts bytesAvailable]);
    [byts readBytes:buff position:0 len:[byts bytesAvailable]];
    return [byts mudata];
}

-(NSData *)encodekehuduanjieru:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc] init];
    Kehuduanjieru_e * obj = (Kehuduanjieru_e *)_protocalObj;
    //客户端类型		4
    [byts writeUnsignedInt:obj.ClientType];
    //客户端版本
    [byts writeUTFString:obj.ClientVer];
    //客户机标识：MAC
    [byts writeUTFString:obj.ClientFlag];
    //客户机操作系统标志：0-未知、1-XP、2-Vista、3-Win7、4-Win8		1
    [byts writeByte:obj.ClientOSFlag];
    return [byts mudata];
}




-(NSData *)encodeyonghudenglu:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc] init];
    Yonghudenglu_e * obj = (Yonghudenglu_e *)_protocalObj;
    [byts writeByte:obj.AccountType];/*用户登录帐号类型：
                                      0-用户唯一标识号、1-用户名	1*/
    //用户帐号
    [byts writeUTFString:obj.Account];
    
    [byts writeUnsignedInt:obj.AuthTicketLength];//验证票据长度		4
    if(obj.AuthTicketLength>0)
        [byts writeBytes:obj.AuthTicket len:obj.AuthTicketLength];/*验证票据：MD5(MD5(用户密码) + 会话密钥)*/
    [byts writeByte:obj.DefaultStatus];/*用户登录成功后缺省状态 0-在线、1-忙碌、2-勿扰、3-离开、4-隐身		1*/
    
    //扩展用户密码
    [byts writeUTFString:obj.ExternPassword];
    
    return [byts mudata];
}

-(NSData *)encodebiangenggerenzhuangtai:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc] init];
    [byts writeUnsignedInt:[(Biangenggerenzhuangtai *)_protocalObj status]];
    return [byts mudata];
}

-(NSData *)encodeliaotianwenzixiaoxi:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Liaotianwenzixiaoxi * o = (Liaotianwenzixiaoxi *)_protocalObj;
    [byts writeUnsignedInt:o.SentTime];
    //消息设置：字体样式什么的
    [byts writeUTFString:o.Option];
    //聊天消息文字
    [byts writeUTFString:o.ChatMessage];
    return [byts mudata];
}

-(NSData *)encodegetCommon:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    JiaoshiCommon * o = (JiaoshiCommon *)_protocalObj;
    [byts writeUnsignedInt64:o.CID];
    return [byts mudata];
}

-(NSData *)encodeshangbaoyonghudadian:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Yonghudadian * obj = (Yonghudadian *)_protocalObj;
    [byts writeByte:obj.Type];
    [byts writeUnsignedInt:obj.Data1];
    [byts writeUnsignedInt:obj.Data2];
    [byts writeUnsignedInt:obj.Data3];
    [byts writeUnsignedInt:obj.Data4];
    [byts writeUnsignedInt:obj.MoreDataLength];
    if(obj.MoreDataLength >0)
        [byts writeBytes:obj.MoreData len:obj.MoreDataLength];
    return [byts mudata];
}

-(NSData *)encodexiaoceyanchuti:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    XiaoceyanChuti * obj = (XiaoceyanChuti *)_protocalObj;
    //8
    [byts writeUnsignedInt64:obj.CID];
    
    //8
    [byts writeUnsignedInt64:obj.QuestionID];
    
    [byts writeByte:obj.Type];//1
    
    [byts writeUTFString:obj.Title];
    
    [byts writeUTFString:obj.Content];
    
    [byts writeUnsignedInt:obj.OptionNum];//4
    int i =0;int j;
    if(obj.OptionNum >0)
    {
        i=0;
        j = obj.OptionNum;
        for(;i<j;i++)
        {
            NSString * ns = obj.OptionItem[i];
            [byts writeUTFString:ns];
        }
    }
    
    [byts writeUnsignedInt:obj.AnserNum];//4
    if(obj.AnserNum >0)
    {
        [byts writeBytes:obj.AnserItem len:obj.AnserNum];
    }
    return [byts mudata];
}

-(NSData *)encodejinrujiaoshi:(ISocketData *)_protocalObj
{
    Jinrujiaoshi_e * obj =(Jinrujiaoshi_e *)_protocalObj;
    ByteArray * byts =[[ByteArray alloc] init];
    //学校ID uint64处理	8
    [byts writeUnsignedInt64:obj.SID];
    //教室ID uint64处理	8
    [byts writeUnsignedInt64:obj.CID];
    //	8
    [byts writeUnsignedInt64:obj.CourseID];
    
    [byts writeUnsignedInt:obj.UserSwitchFlag];//4
    [byts writeUTFString:obj.UserName];
    return [byts mudata];
    
}

-(NSData *)encodepingtest:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Yonghudadian * obj = (Yonghudadian *)_protocalObj;
    [byts writeByte:obj.Type];
    [byts writeUnsignedInt:obj.Data1];
    [byts writeUnsignedInt:obj.Data2];
    return [byts mudata];
}

-(NSData *)encodesetCommon:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    JiaoshiCommon * obj = (JiaoshiCommon *)_protocalObj;
    //教室ID uint64处理	8
    [byts writeUnsignedInt64:obj.CID];
    
    [byts writeUnsignedInt:obj.TxtMsgSize];//最大文本消息长度	4
    [byts writeUnsignedInt:obj.TxtMsgRate];//发送文本消息频率	4
    [byts writeUnsignedInt:obj.Set];//设置	4
    [byts writeUnsignedInt:obj.SetArrayNum];//自定义设置数量		4
    if(obj.SetArrayNum >0)
    {
        uint32_t * setArr =((uint32_t *)obj.SetArray);
        for(int i =0;i<obj.SetArrayNum;i++)
        {
            [byts writeUnsignedInt:setArr[i]];
        }
    }
    return [byts mudata];
}

-(NSData *)encodeliaotianxiaoxi:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Liaotianxiaoxi * o = (Liaotianxiaoxi * )_protocalObj;
    [byts writeUnsignedInt64:o.CID];
    [byts writeUnsignedInt64:o.SentTime];
    [byts writeUTFString:o.Option];
    [byts writeUTFString:o.Text];
    return [byts mudata];
}

-(NSData *)encodexiaoceyandati:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Xiaoceyandati * o =(Xiaoceyandati *)_protocalObj;
    [byts writeUnsignedInt64:o.CID];
    [byts writeUnsignedInt64:o.QuestionID];
    [byts writeUnsignedInt64:o.UID];
    [byts writeUnsignedInt:o.AnserNum];
    if(o.AnserNum >0)
    {
        [byts writeBytes:o.AnserItem len:o.AnserNum];
    }
    return [byts mudata];
}

-(NSData *)encodebaibanshujv:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Baibanshujv * o = (Baibanshujv *)_protocalObj;
    [byts writeUnsignedInt64:o.CID];//8
    [byts writeUnsignedInt:o.SentTime];//4
    [byts writeUnsignedInt:o.MD5Length];//4
    [byts writeBytes:o.BackgroundMD5 len:o.MD5Length];
    [byts writeByte:o.ItemOperate];/*None    = 0,
                                    Add     = 1,添加
                                    Delete  = 2,删除指定的图像
                                    Edit    = 3,
                                    Clear   = 4,全部删除
                                    Syn     = 5先清除，再添加所有图形*/
    [byts writeUnsignedInt64:o.ItemNum];//4
    int j = o.ItemNum;
    for(int i = 0;i<j;i++)
    {
        BaibanItem * item = o.Items[i];
        [byts writeUnsignedInt:item.itemClientSeq];//4
        [byts writeUnsignedInt:item.ItemServerSeq];//4
        [byts writeUnsignedInt:item.ItemDataLength];//4
        [byts writeBytes:item.ItemData len:item.ItemDataLength];
    }
    
    return [byts mudata];
}

-(NSData *)encodeguangbiaozhizhenweizhi:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Guangbiaoshujv * o = (Guangbiaoshujv *)_protocalObj;
    [byts writeUnsignedInt64:o.CID];//8
    [byts writeUnsignedInt64:o.SentTime];//8
    [byts writeByte:o.PencilType];//1
    [byts writeShort:o.width];//2
    [byts writeShort:o.X_Offset];//2
    [byts writeShort:o.height];//2
    [byts writeShort:o.Y_Offset];//2
    return [byts mudata];
}

-(NSData *)encodeyanshiwendangfanye:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Yanshiwendangfanye * o = (Yanshiwendangfanye *)_protocalObj;
    [byts writeUnsignedInt64:o.CID];//8
    [byts writeUnsignedInt64:o.SentTime];//8
    [byts writeByte:o.Type];//1
    [byts writeShort:o.TotalPage];//2
    [byts writeShort:o.CurrentPage];//2
    [byts writeUTFString:o.CurrentPageMD5];
    return [byts mudata];
}


-(NSData *)encodejinrujiaoshiwancheng:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Jinrujiaoshi_e * o = (Jinrujiaoshi_e *)_protocalObj;
    [byts writeUnsignedInt64:o.SID];
    [byts writeUnsignedInt64:o.CID];
    [byts writeUnsignedInt64:o.CourseID];
    return [byts mudata];
}

-(NSData *)encodelikaijiaoshitongzhi:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    JinrujiaoshiTongzhi * o = (JinrujiaoshiTongzhi *)_protocalObj;
    [byts writeUnsignedInt64:o.SID];
    [byts writeUnsignedInt64:o.CID];
    [byts writeUnsignedInt64:o.CourseID];
    [byts writeUnsignedInt64:o.UID];
    [byts writeUTFString:o.UserName];
    [byts writeUnsignedInt64:o.UserSwitchFlag];
    return [byts mudata];
}


-(NSData *)encodeyonghujiaoshidadian:(ISocketData *)_protocalObj
{
    ByteArray * byts = [[ByteArray alloc]init];
    Jiaoshiyonghudadian_e * obj = (Jiaoshiyonghudadian_e *)_protocalObj;
    [byts writeUnsignedInt64:obj.CID];
    [byts writeByte:obj.Type];
    [byts writeUnsignedInt:obj.Data1];
    [byts writeUnsignedInt:obj.Data2];
    [byts writeUnsignedInt:obj.Data3];
    [byts writeUnsignedInt:obj.Data4];
    [byts writeUTFString:obj.MoreData];
    return [byts mudata];
}

@end
