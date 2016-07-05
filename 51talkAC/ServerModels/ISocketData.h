//
//  ISocketData.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISocketData : NSObject

@end

//
//  Fuzaijunheng.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Fuzaijunheng : ISocketData

/***
 
 是否调用成功*/
@property uint32_t RspCode;

/***
 ip数量
 */
@property uint32_t ServerIPNum;

/***
 ip集合
 */
@property NSMutableArray *ServerArr;
@end


//
//  ServerObj.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface ServerObj : ISocketData

/***
 ip
 */
@property uint32_t ServerIP;

/***
 可连接的端口数量
 */
@property  uint32_t PortNum;

/***
 端口集合
 */
@property  uint16_t * Ports;//端口数组
@end

@interface ServerEntity : ISocketData

@property NSString * host;
@property uint16_t port;
@end

//
//  Jinrujiaoshi.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Jinrujiaoshi : ISocketData

@property uint32_t RspCode;

/***
 学校ID uint64处理	8*/
@property uint64_t SID ;
/**教室ID uint64处理	8*/
@property uint64_t CID;

@property uint64_t CourseID;
@property NSString * SchoolName;
@property NSString * ClassName;
@property uint32_t StartTime;//开始上课时间
@property uint8_t Status;//课程状态		1
@property uint8_t MsgMode;//消息模式	1

//学校ID uint64处理	8
@property uint64_t SwitchFlag;
//教室ID uint64处理	8
@property uint64_t OperatonFlag;
//	8
@property uint64_t OwnerID;

@property uint8_t OwnerIn;//校长是否在教室内	1
@property NSString *OwnerName;//校长名称
//老师ID 	8
@property uint64_t TeacherID;

@property uint8_t TeacherIn;//校长是否在教室内	1
@property NSString * TeacherName ;//校长名称
@property uint32_t AssistantNum;//助教数量 	4
@property uint64_t * AssistantID;

@property uint32_t StudentNum;//学生数量 	4
@property uint64_t * StudentID;

@end

@interface Jinrujiaoshi_e : ISocketData

/***
 学校ID uint64处理	8*/
@property uint64_t SID ;
/**教室ID uint64处理	8*/
@property uint64_t CID;

@property uint64_t CourseID;
@property uint32_t UserSwitchFlag;
@property NSString * UserName;
@end

//
//  JinrujiaoshiTongzhi.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface JinrujiaoshiTongzhi : ISocketData

/***
 学校ID uint64处理	8*/
@property uint64_t SID ;
/**教室ID uint64处理	8*/
@property uint64_t CID;

@property uint64_t CourseID;
@property uint64_t UID;
@property NSString * UserName;
@property uint8_t UserIdentity;
@property uint8_t UserRight;
@property uint64_t UserSwitchFlag;
@end

//
//  Kehuduanjieru.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Kehuduanjieru:ISocketData
/**返回码：
 0x00000000-成功
 0x00000001-无可用服务		4*/
@property uint32_t RspCode;

/**用户会话密钥长度		4*/
@property uint32_t SessionKeyLength;

/**用户会话密钥 	*/
@property Byte * SessionKey;
/** 客户端软件升级信息*/
@property NSString * UpgradeInfo;

/** 客户端的公网IP	4*/
@property uint32_t ClientInternetIP;
/** 客户端引导提示信息*/
@property NSString * ClientPilotTips;

/****客户端网络状况提交间隔，0表示不提交，单位：秒		4*/
@property uint32_t NetworkCommitInterval;
@end


//
//  Yonghuqiangzhixiaxian.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Yonghuqiangzhixiaxian : ISocketData

/**强制用户下线原因说明*/
@property uint32_t reasion;
@end

@interface Yonghudenglu : ISocketData
/*返回码：
 0x00000000-成功
 0x00000009-数据库访问错误
 0x01040001-不支持的客户端版本
 0x02010001-未知的帐号类型
 0x02010002-帐号格式错
 0x02010003-帐号不存在
 0x02010004-登录密码错
 0x02010005-帐号已锁定
 0x02010006-帐号未激活		4*/
@property uint32_t RspCode;
@property uint64_t UID;//用户唯一标识号		8
@property NSString * UserName;//用户名
@property uint64_t ServerTime;//服务器时间	8
@property uint64_t LastLoginTime;//服务器时间	8
@property uint64_t UserRight;//用户功能权限：位标识	8
/**用户登录成功后缺省状态
 0-在线、1-忙碌、2-勿扰、3-离开、4-隐身		1*/
@property uint8_t DefaultStatus;
@end

@interface Yonghudenglu_e : ISocketData

/*用户登录帐号类型：
 0-用户唯一标识号、1-用户名	1*/
@property int8_t AccountType;

//用户帐号
@property NSString * Account;

//验证票据长度		4
@property uint32_t AuthTicketLength;

/*验证票据：MD5(MD5(用户密码) + 会话密钥)*/
@property Byte * AuthTicket;

/*用户登录成功后缺省状态 0-在线、1-忙碌、2-勿扰、3-离开、4-隐身		1*/
@property int8_t DefaultStatus;

//扩展用户密码
@property NSString * ExternPassword;

@end


//
//  Biangenggerenzhuangtai.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Biangenggerenzhuangtai : ISocketData
/**用户状态变更原因说明*/
@property uint32_t status;
@end


//
//  Jiaoshiguanbitongzhi.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Jiaoshiguanbitongzhi : ISocketData

/***
 学校ID uint64处理	8*/
@property uint64_t SID ;
/**教室ID uint64处理	8*/
@property uint64_t CID;

@property uint64_t CourseID;

@property uint16_t Reason;
@end


//
//  liaotianxiaoxi.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Liaotianxiaoxi : ISocketData

/**教室ID uint64处理	8*/
@property uint64_t CID;


@property uint64_t SentTime;


@property NSString * Option;


@property NSString * Text;
@end

//
//  xiaoceyandati.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Xiaoceyandati : ISocketData

/**教室ID uint64处理	8*/
@property uint64_t CID;

/**问题ID*/
@property uint64_t QuestionID;

@property uint64_t UID;

@property uint32_t AnserNum;

@property Byte * AnserItem;
@end


//
//  XiaoceyanChuti.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface XiaoceyanChuti : Xiaoceyandati

@property uint8_t Type;//1
@property NSString * Title;
@property NSString * Content;

@property uint32_t OptionNum;

@property NSMutableArray * OptionItem;
@end


//
//  baibanshujv.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Baibanshujv : ISocketData

@property uint64_t CID;//8
@property uint32_t SentTime;//4
@property uint32_t MD5Length;//4
@property Byte * BackgroundMD5;

/**None    = 0,
 Add     = 1,添加
 Delete  = 2,删除指定的图像
 Edit    = 3,
 Clear   = 4,全部删除
 Syn     = 5先清除，再添加所有图形*/
@property uint8_t ItemOperate;
@property uint32_t ItemNum;//4
@property NSMutableArray * Items;

@end

@interface BaibanItem : ISocketData


@property uint32_t itemClientSeq;//4
@property uint32_t ItemServerSeq;//4
@property uint32_t ItemDataLength;//4

/**
 白班的具体形状，绘画命令数据
 */
@property Byte * ItemData;

@end


//
//  Guanbiaoshujv.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Guangbiaoshujv : ISocketData
@property uint64_t CID;//8
@property uint64_t SentTime;//8
@property uint8_t PencilType;//1
@property uint16_t width;//2
@property uint16_t X_Offset;//2
@property uint16_t height;//2
@property uint16_t Y_Offset;//2
@end


//
//  Yanshiwendangfanye.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Yanshiwendangfanye : ISocketData

@property uint64_t CID;//8
@property uint64_t SentTime;//8
@property uint8_t Type;//1
@property uint16_t TotalPage;//2
@property uint16_t CurrentPage;//2
@property NSString * CurrentPageMD5;
@end

//
//  Liaotianwenzixiaoxi.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Liaotianwenzixiaoxi : ISocketData

@property uint32_t SentTime;//发送时间	4
@property NSString * Option;//消息设置：
@property NSString * ChatMessage;//消息设置：
@end


//
//  JiaoshiCommon.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface JiaoshiCommon : ISocketData

@property uint32_t RspCode;//返回码	4
@property uint64_t CID ;/*教室ID	8*/
@property uint32_t TxtMsgSize;//最大文本消息长度	4
@property uint32_t TxtMsgRate ;//发送文本消息频率	4
@property uint32_t Set;//设置
@property uint32_t SetArrayNum ;//自定义设置数量
@property uint32_t * SetArray;
@end


//
//  通过访问webservice而获得的课程列表信息
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface ClassListInfo : ISocketData

@end


//
//  Kehuduanjieru_e.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Kehuduanjieru_e : ISocketData

@property uint32_t ClientType;//客户端类型		4
//客户端版本
@property NSString * ClientVer;

//客户机标识：MAC
@property NSString * ClientFlag;

//客户机操作系统标志：0-未知、1-XP、2-Vista、3-Win7、4-Win8		1
@property uint8_t ClientOSFlag;
@end


//
//  Yonghudadian.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//
@interface Yonghudadian : ISocketData
@property int8_t Type;
@property uint32_t Data1;
@property uint32_t Data2;
@property uint32_t Data3;
@property uint32_t Data4;
@property uint32_t MoreDataLength;
@property Byte * MoreData;
@end

@interface Jiaoshiyonghudadian_e : ISocketData

@property uint64_t CID;
@property int8_t Type;
@property uint32_t Data1;
@property uint32_t Data2;
@property uint32_t Data3;
@property uint32_t Data4;
@property NSString * MoreData;
@end