//
//  NSObject+AgroaSDK.m
//  AC for swift
//
//  Created by guominglong on 15/11/5.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

//#import "AgroaSDK.h"
//
//@implementation AgroaSDK
//@synthesize agoraRtcEngine;
//@synthesize AGROAkey;
//@synthesize hasJoinedChannel;
//@synthesize sdkUID;
//@synthesize canJoin;
//@synthesize canvas;
//
//static AgroaSDK * _instace;
//
////单例
//+(AgroaSDK *)instance
//{
//    if(nil == _instace)
//    {
//        _instace = [[AgroaSDK alloc] init];
//    }
//    return _instace;
//}
//
//-(void)ginit{
//    AGROAkey =@"6D7A26A1D3554A54A9F43BE6797FE3E2";//@"c13956cf1fab43eeb515e03f60630295";//;//
//    canvas = [[AgoraRtcVideoCanvas alloc] init];
//    canJoin = true;
//    sdkUID = 0;
//    hasJoinedChannel = false;
//    //开启agroasdk
//    self.agoraRtcEngine = [[AgoraRtcEngineKit alloc] initWithVendorKey:AGROAkey error:^(AgoraRtcErrorCode errorCode) {
//        //打印错误
//        [GLogger print:[NSString stringWithFormat:@"error code: %lu", (long)errorCode]];
//        canJoin = false;
//    }];
//    
//    //开启日志
//    NSURL *docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSString *logDir = [docURL path];
//    NSString *logTextPath = [logDir stringByAppendingPathComponent:@"com.agora.CacheLogs/agorasdk.log"];
//    [self.agoraRtcEngine setLogFile:logTextPath];
//    
//    //添加回调监听
//    [self.agoraRtcEngine leaveChannelBlock:^(AgoraRtcSessionStat *stat) {
//        [GLogger print:[NSString stringWithFormat:@"离开频道 通话时长:%lu tx %lu rx %lu", (unsigned long)stat.duration,(unsigned long)stat.txBytes, (unsigned long)stat.rxBytes ]];
//    }];
//    
//    [self.agoraRtcEngine updateSessionStatBlock:^(AgoraRtcSessionStat *stat) {
//        //NSLog(@"duration %d tx %d rx %d", stat.duration, stat.txBytes, stat.rxBytes);
//    }];
//    
//    [self.agoraRtcEngine networkQualityBlock:^(AgoraRtcQuality quality) {
//        //__strong typeof(weakSelf) strongSelf = weakSelf;
//        //[strongSelf appendLogString:[NSString stringWithFormat:@"network quality: %d", (int)quality]];
//    }];
//}
//-(void)joinChinnel:(NSString *)sid{
//    
//    if(sid == nil || [sid  isEqual:@""])
//    {
//        [GLogger print:@"频道ID不能为空"];
//        return;
//    }
//    if(self.hasJoinedChannel == true)
//    {
//        [GLogger print:@"已经在频道中了，无法再次进入频道"];
//        return;
//    }
//    [self.agoraRtcEngine userJoinedBlock:^(NSUInteger uid, NSInteger elapsed) {
//        [GLogger print:[NSString stringWithFormat:@"user %u joined in %d ms", (uint32_t)uid, (int)elapsed]];
//    }];
//    
//    [self.agoraRtcEngine userOfflineBlock:^(NSUInteger uid) {
//        [GLogger print:[NSString stringWithFormat:@"user %u offline", (uint32_t)uid]];
//    }];
//    
//    [self.agoraRtcEngine userMuteAudioBlock:^(NSUInteger uid, bool muted) {
//        [GLogger print:[NSString stringWithFormat:@"user %u audio %@", (uint32_t)uid, muted ? @"muted" : @"unmuted"]];
//    }];
//    
//    [self.agoraRtcEngine userMuteVideoBlock:^(NSUInteger uid, bool muted) {
//        [GLogger print:[NSString stringWithFormat:@"user %u video %@", (uint32_t)uid, muted ? @"muted" : @"unmuted"]];
//    }];
//    [self.agoraRtcEngine audioQualityBlock:^(NSUInteger uid, AgoraRtcQuality quality, NSUInteger delay, NSUInteger lost) {
//        [GLogger print:[NSString stringWithFormat:@"user %u ,delay:%lu,lost:%lu", (uint32_t)uid,(unsigned long)delay,(unsigned long)lost]];
//    }];
//    
//    if(self.canJoin == true)
//    {
//        [self.agoraRtcEngine joinChannelByKey:nil channelName:sid info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
//            [GLogger print:[NSString stringWithFormat:@"进入频道成功 频道名称:%@,自动分配的uid:%lu",channel,(unsigned long)uid]];
//            sdkUID = uid;
//            self.hasJoinedChannel = true;
//        }];
//    }
//    
//    
//}
//-(void)startOnlyAudio{
//    if(self.canJoin == true)
//    {
//        [self.agoraRtcEngine disableVideo];
//    }
//}
//
//-(void)startVideo{
//    if(self.canJoin == true)
//    {
//        [self.agoraRtcEngine enableVideo];
//    }
//}
//
//
//-(void)leaveChinnel{
//    if(self.hasJoinedChannel == true)
//    {
//        self.canvas.view = nil;
//        [self.agoraRtcEngine leaveChannel];
//    }
//}
//
///**
// 设置视频窗口
// */
//-(void)setVideoHandler:(NSView *)view{
//    if(self.canJoin)
//    {
//        canvas.view = view;
//        canvas.renderMode = AgoraRtc_Render_Fit;
//        [self.agoraRtcEngine setupRemoteVideo:canvas];
//    }
//}
//
//-(void)startrecode:(NSString *)_path
//{
//    [self.agoraRtcEngine startAudioRecording:_path];
//}
//
//-(void)stoprecode
//{
//    [self.agoraRtcEngine stopAudioRecording];
//}
//@end
