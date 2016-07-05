//
//  ProtocalAdapter.h
//  AC_project
//
//  Created by guominglong on 15-1-4.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISocketData.h"
#import "ByteArray.h"
@interface ProtocalAdapter : NSObject

+(ProtocalAdapter *)getInstance;


/**
 封装ISocketData对象为用于传输的流
 */
-(NSData *)encode:(ISocketData *)_protocalObj commandID:(uint32_t)_commandID;


/**
 解析数据流，读取其中的属性，封装到ISocektData中
 */
-(ISocketData *)decode:(ByteArray *)_byts commandID:(uint32_t)_commandID;
@end
