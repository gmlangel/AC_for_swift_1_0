//
//  CoreSocketCommandEnum.h
//  AC_project
//
//  Created by guominglong on 15-1-5.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreSocketCommandEnum : NSObject

enum{
    /**
     * 负载均衡服务
     * */
    fuzaijunhengfuwu = 0x00100011,
    
    /**
     * 客户端心跳
     * */
    kehuduanxintiao = 0x00110010,
    
    /**
     * 客户端接入
     * */
    kehuduanjieru = 0x00110011,
    
    
    /**
     * 用户登录
     * */
    yonghudenglu = 0x00110012,
    
    /**
     * 用户退出
     * */
    yonghutuichu = 0x00110013,
    
    /**
     * 强制用户下线
     * */
    qiangzhiyonghuxiaxian = 0x00110014,
    
    /**
     * 用户登录完毕
     * */
    yonghudengluwanbi = 0x00110015,
    
    /**
     * 变更个人状态
     * */
    biangenggerenzhuangtai = 0x00110016,
    
    
    /**
     * 上报用户打点
     * */
    shangbaoyonghudadian = 0x00110017,
    
    
    /**
     * 用户请求pingtest
     * */
    pingtest = 0x00110019,
    
    
    /**
     * 聊天文字消息
     * */
    liaotianwenzixiaoxi = 0x03040001,
    
    /**
     * 获取教室Common
     * */
    getCommon = 0x00130001,
    
    
    /**
     * 设置教室Common
     * */
    setCommon = 0x00130002,
    
    /**
     * 教室Common设置通知
     * */
    commonshezhitongzhi = 0x00130003,
    
    
    /**
     * 请求进入教室
     * */
    jinrujiaoshi = 0x00130010,
    
    /**
     * 进入教室通知
     * */
    jinrujiaoshitongzhi = 0x00130011,
    
    /**
     * 进入教室完成
     * */
    jinrujiaoshiwancheng = 0x00130012,
    
    
    /**
     * 离开教室
     * */
    likaijiaoshi = 0x00130013,
    
    
    /**
     * 离开教室通知
     * */
    likaijiaoshitongzhi = 0x00130014,
    
    /**
     * 教师关闭通知
     * */
    jiaoshiguanbitongzhi = 0x00130015,
    
    /**
     * 聊天消息
     * */
    liaotianxiaoxi = 0x00130016,
    
    /**
     * 白板数据
     * */
    baibanshujv = 0x00130017,
    
    /**
     * 光标指针位置
     * */
    guanbiaozhizhenweizhi = 0x00130018,
    
    /**
     * 演示文档翻页
     * */
    yanshiwendangfanye = 0x00130019,
    
    /**
     * 用户教室打点数据
     * */
    yonghujiaoshidadian = 0x00130020,
    
    
    /**
     * 小测验出题
     * */
    xiaoceyanchuti = 0x00130021,
    
    /**
     * 小测验答题
     * */
    xiaoceyandati = 0x00130022
};

enum{
    /**
     * 成功
     * */
    chenggong = 0x00000000,
    
    /**
     * 无可用服务
     * */
    wukeyongfuwu = 0x00000001,
    
    /**
     * 整包校验错误（如包头包尾标志错，可不返回，直接丢弃）
     * */
    zhengbaoyanzhengcuowu = 0x00000002,
    
    /**
     * 协议版本不支持
     * */
    xieyibanbenbuzhichi = 0x00000003,
    
    /**
     * 未知协议包类型
     * */
    weizhixieyibaoleixing = 0x00000004,
    
    /**
     * 未知加密方式
     * */
    weizhijiamifangshi = 0x00000005,
    
    /**
     * 未知目标离线方式
     * */
    weizhimubiaolixianfangshi = 0x00000006,
    
    /**
     * 协议数据长度过大
     * */
    xieyishujvchangduguoda = 0x00000007,
    
    /**
     * 协议字段解析错误
     * */
    xieyiziduanjiexicuo = 0x00000008,
    
    /**
     * 数据库访问错误
     * */
    shujvkufangwencuowu = 0x00000009
};
@end
