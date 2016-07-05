
//  MediaView.swift
//  AC for swift
//
//  Created by guominglong on 15/12/11.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
public class MediaView: NSView,MediaEngineDelegate {

    var nf:NSDateFormatter!;
    var jishi:NSTimeInterval!=0;
    var canClick:Bool! = true;
    var channel:MediaChannel?;
    public var gremoteBounds:NSRect!;
    public var smallBounds:NSRect!;
    //录音地址
    public var audioRecodePath:String!="";
    /**
    远端视频窗口
    */
    public var remoteView:CocoaRenderViewBlitz!;
    
    /**
    本地视频窗口
    */
    public var localView:CocoaRenderViewBlitz!;
    
    private var isInited:Bool! = false;
    
    /**
    与媒体服务器交互需要的id
    */
    public var sessionID:UInt32 = 0;
    
    
    public var _classSession:ClassSession!;
    private var _allUsers:ClassUserVector!;//教室成员列表
   // private var _listener:EngineEventListenerMac!;
    private var _course:Course!;
    var be:NSBezierPath!;
    var canvas:CGContextRef!;
    var myMediaID:Int32!;
    
    private var teacherIsManWindow:Bool! = true;//老师窗口为主窗口
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        nf = NSDateFormatter();
        nf.dateFormat = "yyyyMMdd_HH-mm-ss";
    }
    
    public override func viewDidMoveToWindow() {
        if self.window == nil{
            canClick = true;
        }
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder);
        
    }
    
//    public override func drawRect(dirtyRect: NSRect) {
//        canvas = NSGraphicsContext.currentContext()?.CGContext;
//        CGContextSaveGState(canvas);
//        be = NSBezierPath(roundedRect: NSMakeRect(0, 0, self.frame.width, self.frame.height), xRadius: 5, yRadius: 5);
//        be.addClip();
//        CGContextSetRGBFillColor(canvas, 1, 1, 1, 1);
//        CGContextFillRect(canvas, self.frame);
//    }
    
    /**
    发送文本消息
    */
    public func sendMsg(msg:String,option:String)
    {
        if(_classSession != nil)
        {
            let gcont:SendImContext = SendImContext();
            gcont.setMsg(msg);
            gcont.setOption(option);
            gcont.setSendTime(UInt64(NSDate().timeIntervalSince1970));
            _classSession.SendIm(gcont);
        }
    }
    
    /**
     发送白板数据
     */
    public func sendWD(data:WBOperationData)
    {
        if(_classSession != nil)
        {
            _classSession.OperateWB(data);
        }
    }
    
    /**
     发送翻页命令
     */
    public func sendFanye(data: WBDocumentData)
    {
        if(_classSession != nil)
        {
            _classSession.OperateDoc(data);
        }
    }
    
    /**
     发送光标同步
     */
    public func sendPOS(data:WBPencilPosData)
    {
        if(_classSession != nil)
        {
            _classSession.MovePencil(data);
        }
    }
    
    
    public var course:Course{
        get{
            return _course;
        }
        
        set{
            _course = newValue;
            if(_course != nil){
                EngineEventListenerMac.Instance().setDelegate(self);
                MediaEngine.Init(EngineEventListenerMac.Instance());
                MediaEngine.UseSdk(5);
                let ec:EngineConfig = EngineConfig();
                ec.setTrace(GlobelInfo.getInstance().medialogpath)
                MediaEngine.SDK().Initialize(ec);
                let sdks:UInt8Array = MediaEngine.SupportedSDKs();
                let acSdks:UCharVector = UCharVector();
                
                let j:UInt = sdks.size();
                for(var i:UInt = 0 ;i<j;i++)
                {
                    let sdk:UInt8 = sdks.get(i);
                    acSdks.add(sdk);
                }
                
                let info:ClassSessionInfo = ClassSessionInfo();
                info.setClassId(_course.getClassId());
                info.setCourseId(_course.getCourseId());
                info.setSdks(acSdks);
                
                let uInfo:ClassUserInfo = ClassUserInfo();
                uInfo.setDisplayName(AcuaSDK.ACService().NickName());
                if(AcuaSDK.ACService().RoleType()=="stu")
                {
                    //学员
                    uInfo.setUserId(AcuaSDK.ACService().UserId());
                    uInfo.setRole(ROLE_STUDENT);//设置用户类型
                }else{
                    //老师的处理
                    uInfo.setUserId(AcuaSDK.ACService().UserId());// | 0x1000000000000000
                    uInfo.setRole(ROLE_TEACHER);//设置用户类型
                }
                
                _classSession = ClassSession.CreateSession(info, selfInfo: uInfo, userAgent: AcuaSDK.UserAgent());
                sessionID = _classSession.Id();
                GlobelInfo.getInstance().sessionID = sessionID;
                self.addEvent(ClassStateEventArgs.TypeName(), sel: Selector("onClassState:"));
                self.addEvent(ClassStartSdkEventArgs.TypeName(), sel: Selector("onStartSdkCallBack:"));
                self.addEvent(ClassStopSdkEventArgs.TypeName(), sel: Selector("onStopSdkCallBack:"));
                self.addEvent(ClassChangeSdkRequestEventArgs.TypeName(), sel: Selector("onRequestChangeSdk:"));
                self.addEvent(ClassChangeSdkResponseEventArgs.TypeName(), sel: Selector("onResponseChangeSdk:"));
                self.addEvent(ClassUserChangedEventArgs.TypeName(), sel: Selector("onUserChangeded:"));
                self.addEvent(ClassAvlailableSDKChangedEventArgs.TypeName(), sel: Selector("onSdkListChanged:"));
                self.addEvent(ClassMediaStateChangedEventArgs.TypeName(), sel: Selector("onMediaStateChanged:"));
                
                self.addEvent(ClassRecvImEventArgs.TypeName(), sel: Selector("onMsgCallBack:"));
                self.addEvent(ClassWBDataEventArgs.TypeName(), sel: "onWbData:")
                self.addEvent(ClassWBDocumentEventArgs.TypeName(), sel: "onWbDocument:")
                self.addEvent(ClassWBPosEventArgs.TypeName(), sel: "onWbPos:")
                
                
                
                _classSession.Enter();
            }
        }
    }
    private var result:ChannelAudioStatistics! = ChannelAudioStatistics();
    //private var dotDataDaoJishi:Int! = 5;
    /**
     上传延迟打点数据
     */
    public func sendAVDotData()
    {
        if(channel == nil)
        {
            return;
        }

        channel?.GetAudioStatistics(result);
        NSNotificationCenter.defaultCenter().postNotificationName("onJitter", object: result);
//        if(dotDataDaoJishi <= 0)
//        {
//            dotDataDaoJishi = 5;
            let obj:AVDotData = AVDotData();
            obj.setClassId(_classSession.ClassId());
            if(result.getRtt()<0)
            {
                obj.setDelayP2P(UInt32(0));//点对点延迟
            }else{
                obj.setDelayP2P(UInt32(result.getRtt()));//点对点延迟
            }
            if(result.getPlayPacketLoss() < 0)
            {
                obj.setPacketLoss(UInt32(0));//播放丢包
            }else{
                obj.setPacketLoss(UInt32(result.getPlayPacketLoss())*10);//播放丢包
                
            }
        
            if(result.getNetPacketLoss() < 0)
            {
                obj.setDownPacketLoss(UInt32(0));
            }else{
                obj.setDownPacketLoss(UInt32(result.getNetPacketLoss()))
            }
            AcuaSDK.SM().StatisticService().SendAVDotData(obj);
        //}
      //  dotDataDaoJishi  = dotDataDaoJishi-1;
        
    }
    
    public func onRemoteVideoStart()
    {
        //远端视频第一次呈现
        remoteView.alphaValue = 1;
    }
    
    public func onRemoteCloseVideo()
    {
        //远端关闭视频
        remoteView.alphaValue = 0;
    }
    
    public func onRemoteResumeVideo()
    {
        //远端重新开启视频
        remoteView.alphaValue = 1;
    }
    

    
    /**
    文本消息回调
    */
    public func onMsgCallBack(notify:NSNotification)
    {
        
        NSNotificationCenter.defaultCenter().postNotificationName("msgCallBack", object: (notify.object as! ClassRecvImEventArgs));
    }
    
    /**
    白板数据
    */
    public func onWbData(notify:NSNotification)
    {
        let arg:ClassWBDataEventArgs = notify.object as! ClassWBDataEventArgs;
        NSNotificationCenter.defaultCenter().postNotificationName("onWhiteData", object: arg.getData());
    }
    
    /**
    pdf翻页
    */
    public func onWbDocument(notify:NSNotification)
    {
        let args:ClassWBDocumentEventArgs = notify.object as! ClassWBDocumentEventArgs;
        let data:WBDocumentData = args.getData();
        NSNotificationCenter.defaultCenter().postNotificationName("changePDFPage", object:  NSNumber(unsignedShort: data.getCurrentPage()));
    }
    
    /**
    光标跟随
    */
    public func onWbPos(notify:NSNotification)
    {
        let args:ClassWBPosEventArgs = notify.object as! ClassWBPosEventArgs;
        NSNotificationCenter.defaultCenter().postNotificationName("changeGuanBiao", object: args.getData());
    }
    
    public func getOtherUserName()->NSString
    {
        return (remoteUser?.getDisplayName())!;
        //return _classSession.Teacher().getDisplayName();
    }
    
    
    private var mediaSession:MediaSession?{
        get{
            if(MediaEngine.SDK() == nil || _classSession == nil)
            {
                return nil;
            }else{
                return MediaEngine.SDK().GetSession(_classSession.ClassId());
            }
        }
    }
    
    private var currentMicVolume:Int32! = 0;
    /**
    静音和恢复麦克风
    */
    public func muteMic(b:Bool)
    {
        //self.mediaSession?.Mute(b);
        if(b == false)
        {
            MediaEngine.SDK().setRecordingVolume(currentMicVolume);
        }else
        {
            currentMicVolume = MediaEngine.SDK().getPlayoutVolume();
            MediaEngine.SDK().setRecordingVolume(0);
        }
    }
    
    private var currentSoundVolume:Int32! = 0;
    /**
    静音和恢复声音 true为静音  false为回复声音
    */
    public func muteSound(b:Bool)
    {
        if(MediaEngine.SDK() == nil)
        {
            return;
        }
        
        if(b == false)
        {
            MediaEngine.SDK().setPlayoutVolume(currentSoundVolume);
        }else
        {
            currentSoundVolume = MediaEngine.SDK().getPlayoutVolume();
            MediaEngine.SDK().setPlayoutVolume(0);
            
        }
        
    }
    
    public func getSoundVolume()->Int32
    {
        if(MediaEngine.SDK() == nil)
        {
            return 0 ;
        }
        return MediaEngine.SDK().getPlayoutVolume();
    }
    
    public func getmicVolume()->Int32
    {
        if(MediaEngine.SDK() == nil)
        {
            return 0 ;
        }
        return MediaEngine.SDK().getRecordingVolume();
    }
    
    /**
    设置声音的音量 0-255之间取值
    */
    public func setSoundVolume(value:Int32)
    {
        if(MediaEngine.SDK() == nil)
        {
            return;
        }
        MediaEngine.SDK().setPlayoutVolume(value);
    }
    
    /**
    设置麦克声音
    */
    public func setmicVolume(value:Int32)
    {
        if(MediaEngine.SDK() == nil)
        {
            return;
        }
        MediaEngine.SDK().setRecordingVolume(value);
    }
    
    private var remoteUser:ClassUser?{
        get{
            let j:UInt = _allUsers.size();
            let myId:UInt64 = AcuaSDK.ACService().UserId();
            var remote:ClassUser = ClassUser();
            var b:Bool = false;
            for(var i:UInt = 0 ;i<j; i++){
                remote = _allUsers.get(i);
                if(myId != remote.getUserId())
                {
                    b = true;
                    break;
                }
            }
            if(b == true)
            {
                return remote;
            }else{
                return nil;
            }
        }
    }
    
    
    /**
    初始化
    */
    public func ginit(remoteBounds:NSRect,localBounds:NSRect)
    {
        if(isInited == true)
        {
            return;
        }
        gremoteBounds = remoteBounds;
        smallBounds = NSMakeRect((remoteBounds.size.width - localBounds.size.width), 0, localBounds.size.width, localBounds.size.height);
        isInited = true;
        remoteView = CocoaRenderViewBlitz(frame:remoteBounds);
        remoteView.frame.size.height = remoteView.frame.size.height;
        
        localView = CocoaRenderViewBlitz(frame:smallBounds);
        addSubview(remoteView);
        addSubview(localView);
        sessionID = 0;
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        swapWindow(!teacherIsManWindow);
    }
    
    /**
     切换视频窗口  true代表老师大窗口，学员小窗口
     */
    public func swapWindow(b:Bool)
    {
        if(canClick == false)
        {
            return;
        }
        jishi = 5;
        canClick = false;
        teacherIsManWindow = b;
        if(b)
        {
            remoteView.frame = gremoteBounds;
            localView.frame = smallBounds;
            remoteView.setNeedsDisplayInRect(remoteView.frame);
            localView.setNeedsDisplayInRect(localView.frame);
           // localView.removeFromSuperview();
            self.addSubview(localView, positioned: NSWindowOrderingMode.Above, relativeTo: remoteView);
        }else{
            remoteView.frame = smallBounds;
            localView.frame = gremoteBounds;
            remoteView.setNeedsDisplayInRect(remoteView.frame);
            localView.setNeedsDisplayInRect(localView.frame);
           // remoteView.removeFromSuperview();
            self.addSubview(remoteView, positioned: NSWindowOrderingMode.Above, relativeTo: localView);
        }
        
    }
    
    private func addEvent(name:String,sel:Selector)
    {
        ACNotifyCenter.Instace().addObserver(self, selector: sel, name: name, eid: _classSession.Id(), object: nil);
    }
    
    private func startrecodeAudio()
    {
        audioRecodePath = course.getCourseName().stringByReplacingOccurrencesOfString(":", withString: "：");
        audioRecodePath = course.getCourseName().stringByReplacingOccurrencesOfString(" ", withString: "");
        audioRecodePath = GlobelInfo.getInstance().recodeDic + audioRecodePath + nf.stringFromDate(NSDate()) + ".mp3";
        self.mediaSession?.StartRecordAudio(audioRecodePath);
    }
    
    public func removeAllEvents()
    {
        ACNotifyCenter.Instace().removeObserver(self);
    }
    
    private var tempCourse:Course?;
    /**
    开始媒体服务器通讯
    */
    public func startMedia(cos:Course){
        tempCourse = cos;
        swapWindow(teacherIsManWindow);
        yanchiStartMedia();
    }
    
    func yanchiStartMedia()
    {
        self.course = tempCourse!;
        tempCourse = nil;
        channel = nil;
        NSNotificationCenter.defaultCenter().postNotificationName("changSDK", object: nil);
        HeartbeatManager.instance.addTask(Selector("daojishi"), ti: 1, tg: self, taskName: "daojishi");//每次点击切换窗口后需要5秒冷却
        HeartbeatManager.instance.addTask(Selector("sendAVDotData"), ti: 5, tg: self, taskName: "sendAVDotData");//每5秒发送打点数据到服务器
        sendAVDotData();
        remoteView.alphaValue = 0;
        if(channel != nil)
        {
            localView = getLocalRender(localView.frame);
            if(teacherIsManWindow == true)
            {
                self.addSubview(localView, positioned: NSWindowOrderingMode.Above, relativeTo: remoteView);
            }else{
                self.addSubview(localView, positioned: NSWindowOrderingMode.Below, relativeTo: remoteView);
            }
            channel?.StartRender(localView);
        }
    }
    
    /**
    关闭媒体收发
    */
    public func stopMedia()
    {
        if(tempCourse != nil)
        {
            //进入这个流程，证明媒体服务器还没有启动。所以不需要执行之后的释放操作
            return;
        }
        channel = nil;
        if(_classSession != nil)
        {
            _classSession.Leave();
        }
        ClassSession.ReleaseSession(sessionID);//关闭聊天室媒体会话
        _classSession = nil;
        MediaEngine.UnInit();//停止引擎
        HeartbeatManager.instance.removeTask("daojishi");
        HeartbeatManager.instance.removeTask("sendAVDotData");
        HeartbeatManager.instance.removeTask("reportStatistic")
        if(channel != nil)
        {
            channel?.StopRender();
        }
    }
    
    func daojishi()
    {
        if(jishi > 0)
        {
            jishi = jishi - 1;
        }else{
            canClick = true;
        }
    }
    
    /**
    sdk列表变更
    */
    public func onSdkListChanged(notify:NSNotification)
    {
        GLogger.print("sdk列表变更");
        let aSdks:UCharVector = _classSession.AvailableSdks();
        if(aSdks.size() == 0)
        {
            //提示用户没有可用的sdk
            NSNotificationCenter.defaultCenter().postNotificationName("noSDKList", object: nil);
        }

    }
    
    /**
    媒体通讯状态变更
    */
    public func onMediaStateChanged(notify:NSNotification)
    {
        let args:ClassMediaStateChangedEventArgs = notify.object as! ClassMediaStateChangedEventArgs;
        let old:UInt32 = args.getOld().rawValue
        let ns:UInt32 = args.getNew().rawValue;
        if(old == MEDIA_STATE_TRYING.rawValue && ns == MEDIA_STATE_CONNECTED.rawValue){
            GLogger.print("双方自动匹配成功，使用SDK \(MediaEngine.CurrentSDK())");
            GLogger.print("此处应该更新视图的备选sdk效果");
        }else if(old == MEDIA_STATE_TRYING.rawValue && ns == MEDIA_STATE_TERMINATED.rawValue){
            GLogger.print("双方自动匹配失败");
            //提示用户没有可用的sdk
            NSNotificationCenter.defaultCenter().postNotificationName("setTishiInfo", object: ["type":"tips","content":"没有可匹配的SDK"]);
        }else if(old == MEDIA_STATE_SWITCHING.rawValue && ns == MEDIA_STATE_TERMINATED.rawValue){
            GLogger.print("切换SDK失败");
        }else if(old == MEDIA_STATE_SWITCHING.rawValue && ns == MEDIA_STATE_CONNECTED.rawValue){
            GLogger.print("切换成功，使用SDK \(MediaEngine.CurrentSDK())");
        }
    }
    
    /**
    创建一个媒体会话结构体
    */
    private func createMedinSessionInfo()->MediaSessionInfo
    {
        let minInfo:MediaSessionInfo = MediaSessionInfo();
        minInfo.setSessionId(_classSession.ClassId());
        let me:ClassUser = _classSession.Me();
        minInfo.setUserId(getResultMediaID(me));
        let va:NSNumber = NSNumber(int: MediaEngine.SDK().Capacity());
        if((va.unsignedIntValue & CAP_VIDEO.rawValue) != 0)
        {
            minInfo.setType(MediaType_AudioVideo);//音视频通讯
        }else
        {
            minInfo.setType(MediaType_Audio);// 纯音频通讯
        }
        
        let videoServers:MediaServerInfoArray = MediaServerInfoArray();
        let audioServers:MediaServerInfoArray = MediaServerInfoArray();
        
        pushServers(videoServers,source: _classSession.VideoServers());
        pushServers(audioServers,source: _classSession.AudioServers());
        
        minInfo.setVideoServers(videoServers);
        minInfo.setAudioServers(audioServers);
        return minInfo;
    }
    
    private func pushServers(servers:MediaServerInfoArray,source:MediaServerVector)
    {
        let serArr:MediaServerVector = source;
        var ports:UInt16Vector;
        let j:UInt = serArr.size();
        var kj:UInt;
        for(var i:UInt=0;i<j;i++)
        {
            let ms:MediaServer = serArr.get(i);
            let info:MediaServerInfo = MediaServerInfo();
            info.setIp(ms.getIp());
            ports = ms.getPorts();
            kj = ports.size();
            for(var k:UInt=0;k<kj;k++)
            {
                info.getPorts().add(ports.get(k));
            }
            servers.add(info);
        }
    }
    
    /**
    启动sdk后的回调
    */
    public func onStartSdkCallBack(notify:NSNotification)
    {
        let args:ClassStartSdkEventArgs = notify.object as! ClassStartSdkEventArgs;
        let sdkid = args.getSdkId();
        MediaEngine.UseSdk(sdkid);
        GLogger.print("开始启动SDK \(MediaEngine.CurrentSDK())");
        let ec:EngineConfig = EngineConfig();
        ec.setJid(self._classSession.Jid());
        ec.setTrace(GlobelInfo.getInstance().medialogpath);
        var ret:Int32 = MediaEngine.SDK().Initialize(ec);
        
        let va:NSNumber = NSNumber(int: MediaEngine.SDK().Capacity());
        if((va.unsignedIntValue & CAP_VIDEO.rawValue) != 0)
        {
            var camera:Int32 = 0;
            camera |= MediaEngine.SDK().setCameraDevice(0);
            camera |= MediaEngine.SDK().startCamera();
            camera |= MediaEngine.SDK().startPreview(self.localView);
            if(camera != 0){
                GLogger.print("摄像头启动失败");
            }
        }
        ret |= MediaEngine.SDK().CreateSession(self.createMedinSessionInfo());
        ret |= (self.mediaSession?.Enter())!;
        //ret |= (self.mediaSession?.EnableALR())!;
        if (ret != 0) {
            GLogger.print("SDK \(sdkid) 启动失败");
            self._classSession.FailedSdk(MediaEngine.CurrentSDK());
            return;
        }
       
    }
    
    /**
    关闭sdk后的回调
    */
    public func onStopSdkCallBack(notify:NSNotification)
    {
        let args:ClassStopSdkEventArgs = notify.object as! ClassStopSdkEventArgs;
        GLogger.print("正在停止SDK \(args.getSdkId())");
        MediaEngine.SDK().Terminate();
        self.mediaSession?.StopRecordAudio();
        channel = nil;
    }
    
    /**
    对方请求切换sdk的状态信息
    */
    public func onRequestChangeSdk(notify:NSNotification)
    {
        let args:ClassChangeSdkRequestEventArgs = notify.object as! ClassChangeSdkRequestEventArgs;
        _classSession.AcceptChangeSdk(args.getSdkId());
        GLogger.print("对方请求切换SDK \(args.getSdkId()),自动接受切换");
    }
    
    /**
    对方应答sdk切换结果
    */
    
    public func onResponseChangeSdk(notify:NSNotification)
    {
        let args:ClassChangeSdkResponseEventArgs = notify.object as! ClassChangeSdkResponseEventArgs;
        if(args.getAccepted() == true)
        {
            GLogger.print("对方答应切换SDK");
        }else{
            GLogger.print("对方拒绝切换SDK");
        }
    }
    
    public func onUserChangeded(notify:NSNotification)
    {
        let args:ClassUserChangedEventArgs = notify.object as! ClassUserChangedEventArgs;
        var i:UInt = 0;
        var j:UInt = 0;
        var user:ClassUser;
        var usersToAdd:ClassUserVector;
        if(args.getOp().rawValue == OP_ADD.rawValue){
            usersToAdd = args.getUsers();
            j = usersToAdd.size();
            i = 0;
            for(;i<j;i++)
            {
                user = usersToAdd.get(i);
                //remoteView.alphaValue = 1;
                GLogger.print("\(user.getDisplayName())进入教室");
                NSNotificationCenter.defaultCenter().postNotificationName("userJoin", object: user);
                if(self.mediaSession == nil)
                {
                    break;
                }
                self.mediaSession?.EnableALR();
                if((self.mediaSession?.State())!.rawValue == SESSION_STATE_ENTERED.rawValue)
                {
                    self.mediaSession?.CreateChannel(getResultMediaID(user));
                    startrecodeAudio();
                    if(HeartbeatManager.instance.hasTask("reportStatistic") == false)
                    {
                        HeartbeatManager.instance.addTask(Selector("reportStatistic"), ti: 5, tg: self, taskName: "reportStatistic");
                    }
                    remoteView = getRemoteRender(remoteView.frame);
                    if(teacherIsManWindow == true)
                    {
                        self.addSubview(remoteView, positioned: NSWindowOrderingMode.Below, relativeTo: localView);
                    }else{
                        self.addSubview(remoteView, positioned: NSWindowOrderingMode.Above, relativeTo: localView);
                    }
                    channel = (self.mediaSession?.GetChannel(getResultMediaID(user)))!;
                        channel!.StartRender(remoteView);
                }
            }
        }else if(args.getOp().rawValue == OP_REMOVE.rawValue){
            usersToAdd = args.getUsers();
            j = usersToAdd.size();
            i = 0;
            for(;i<j;i++)
            {
                user = usersToAdd.get(i);
                //对端退出教室，关闭远端视频窗口
                //remoteView.alphaValue = 0;
                GLogger.print("\(user.getDisplayName())离开教室");
                NSNotificationCenter.defaultCenter().postNotificationName("userLeave", object: user);
                if(self.mediaSession == nil)
                {
                    break;
                }
                self.mediaSession?.EnableALR();
                if((self.mediaSession?.State())!.rawValue == SESSION_STATE_ENTERED.rawValue)
                {
                    self.onRemoteCloseVideo();
                    self.mediaSession?.StopRecordAudio();
                    self.mediaSession?.DeleteChannel(getResultMediaID(user));
                    channel = nil;
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("updateUserList", object: _allUsers);
    }
    
    /**
    进入教室的状态信息
    */
    public func onClassState(notify:NSNotification)
    {
        let args:ClassStateEventArgs = notify.object as! ClassStateEventArgs;
        let state:UInt32 = args.getState().rawValue;
        switch(state){
            case STATE_ENTERING.rawValue:
                GLogger.print("正在进入教室");
                break;
        case STATE_ENTERED.rawValue:
            _allUsers = _classSession.AllUsers();
            NSNotificationCenter.defaultCenter().postNotificationName("updateUserList", object: _allUsers);
            GLogger.print("成功进入教室");
            break;
        case STATE_LEAVE.rawValue:
            _classSession = nil;
            break;
        default:break;
        }
    }
    
    func getResultMediaID(user:ClassUser)->UserId
    {
        let uid = UserId();
        uid.setMediaId(user.getMediaId());
        //这个ID是其它SDK使用的，千万不要改动，具体生成规则找海滨。
        let otherId:UInt32 = UInt32(user.getUserId() & 0x00000000ffffffff);
        if(user.getRole() == ROLE_STUDENT)
        {
            uid.setOtherId(otherId);
        }else if(user.getRole() == ROLE_TEACHER)
        {
            uid.setOtherId(otherId|0xE0000000);
        }
        
        uid.setMediaId(user.getMediaId());
        return uid;
    }
    
    
    public func OnEngineEvent(ev:EngineEvent)
    {
        if(ev.EventName() == EngineSessionStateEvent.TypeName())
        {
            let eve:EngineSessionStateEvent = ev as! EngineSessionStateEvent;
            if(eve.getNewState().rawValue == SESSION_STATE_ENTERED.rawValue && eve.getOldState().rawValue == SESSION_STATE_ENTERING.rawValue)
            {
                var ret:Int32 = -1;
                if(self.remoteUser != nil)
                {
                    let remote = self.remoteUser!;
                    GLogger.print(String(format: "教室内有 %@,mid %d",(remote.getDisplayName())!,(remote.getMediaId())));
                    ret = self.mediaSession!.CreateChannel(getResultMediaID(remote));
                    self.mediaSession?.EnableALR();
                    if(ret != 0)
                    {
                        GLogger.print(String(format: "sdk %d 创建channel失败，",MediaEngine.CurrentSDK()));
                        _classSession?.FailedSdk(MediaEngine.CurrentSDK());
                        return;
                    }
                    channel = (self.mediaSession?.GetChannel(getResultMediaID(remote)))!;
                    remoteView = getRemoteRender(remoteView.frame);
                    if(teacherIsManWindow == true)
                    {
                        self.addSubview(remoteView, positioned: NSWindowOrderingMode.Below, relativeTo: localView);
                    }else{
                        self.addSubview(remoteView, positioned: NSWindowOrderingMode.Above, relativeTo: localView);
                    }
                    ret |= channel!.StartRender(remoteView);
                    if(ret != 0)
                    {
                         assert(false, "");
                        _classSession.FailedSdk(MediaEngine.CurrentSDK());
                        return;
                    }
                    startrecodeAudio();
                    if(HeartbeatManager.instance.hasTask("reportStatistic") == false)
                    {
                        HeartbeatManager.instance.addTask(Selector("reportStatistic"), ti: 5, tg: self, taskName: "reportStatistic");
                    }
                }
                GLogger.print("SDK \(MediaEngine.CurrentSDK()) 进入通话成功");
                _classSession.SuccessSdk(MediaEngine.CurrentSDK());
                reportMediaInfo();
                NSNotificationCenter.defaultCenter().postNotificationName("changSDK", object: NSString(format: "%u", MediaEngine.CurrentSDK()));
            }else if(eve.getNewState().rawValue == SESSION_STATE_LEAVE.rawValue && eve.getOldState().rawValue == SESSION_STATE_ENTERING.rawValue)
            {
                GLogger.print("SDK \(MediaEngine.CurrentSDK()) 进入通话失败");
                _classSession.FailedSdk(MediaEngine.CurrentSDK());
            }
        }else if(ev.EventName() == EngineVLREvent.TypeName())
        {
            NSNotificationCenter.defaultCenter().postNotificationName("maizhenCallBack", object: ev);
        }else if(ev.EventName() == EngineFirstPictureEvent.TypeName())
        {
            self.onRemoteVideoStart();
            reportMediaInfo();
        }else if(ev.EventName() == EngineNoPictureEvent.TypeName())
        {
            self.onRemoteCloseVideo();
            reportMediaInfo();
        }else if(ev.EventName() == EngineRecoverPictureEvent.TypeName())
        {
            self.onRemoteResumeVideo();
            reportMediaInfo();
        }
        else if(ev.EventName() == EngineFailedEvent.TypeName())
        {
            GLogger.print("SDK \(MediaEngine.CurrentSDK())error");
            _classSession.FailedSdk(MediaEngine.CurrentSDK());
        }
        
    }
    
    func assignIntItems(from:KVIArray,to:IntKVVector)
    {
        for i:UInt in 0 ..< from.size()
        {
            let key = from.get(i).getType();
            let val = from.get(i).getValue();
            let tokv = IntKV();
            tokv.setType(key);
            tokv.setValue(val);
            to.add(tokv);
        }
    }
    
    
    func assignStringItems(from:KVSArray,to:StringKVVector)
    {
        for i:UInt in 0 ..< from.size()
        {
            let key = from.get(i).getType();
            let val = from.get(i).getValue();
            let tokv = StringKV();
            tokv.setType(key);
            tokv.setValue(val);
            to.add(tokv);
        }
    }
    
    //meida id 与 user id 转换
    func fromMediaIdToUserId(from:UInt32) -> UInt64
    {
        //需要重写
        let j:UInt = _allUsers.size();
        var userID:UInt64 = 0;
        
        for(var i:UInt = 0 ;i<j; i++){
            let remote = _allUsers.get(i);
            if(from == remote.getMediaId())
            {
                userID = remote.getUserId();
                break;
            }
        }
        return userID;
    }
    
    func assignRemoteItems(from:ChannelStatisticArray,to:StatisticRemoteVector)
    {
         for i:UInt in 0 ..< from.size(){
            let sr = StatisticRemote();
            let uid = fromMediaIdToUserId(from.get(i).getUserId().getMediaId())
            sr.setUserId(uid);
            to.add(sr);
            assignIntItems(from.get(i).getIntItems(), to: sr.getIntItems());
            assignStringItems(from.get(i).getStringItems(), to: sr.getStringItems());
        }
    }
    
    
    //开始音视频通话后，有人进入创建channel后，每隔5秒执行一次
    func reportStatistic()
    {
        if self.mediaSession != nil
        {
            if self.mediaSession?.State().rawValue == SESSION_STATE_ENTERED.rawValue
            {
                NSLog("get statis");
                let stats = MediaStatistic();
                let ret = mediaSession?.GetMediaStatistics(stats);
                if ret == 0{
                    let data = StatisticData();
                    data.setClassId((_classSession?.ClassId())!);
                    data.setMessageId(100);
                    data.setUserId(AcuaSDK.ACService().UserId());
                    data.setSdkId(MediaEngine.CurrentSDK());
                    assignIntItems(stats.getIntItems(), to:data.getIntItems());
                    assignStringItems(stats.getStringItems(), to: data.getStringItems());
                    assignRemoteItems(stats.getChannelItems(), to: data.getRemoteItems());
                    AcuaSDK.StatsService().ReportStatistics(data);
                }
            }
        }
    }
    
    
    //启动SDK成功 后执行一次，者摄像头，麦克风列表变化的时候执行一次
    func reportMediaInfo()
    {
        if MediaEngine.SDK() != nil
        {
            let info = MediaInfo();
            let ret = MediaEngine.SDK().GetMediaInfo(info);
            if ret == 0
            {
                let data = StatisticData();
                data.setClassId((_classSession?.ClassId())!);
                data.setMessageId(101);
                data.setUserId(AcuaSDK.ACService().UserId());
                data.setSdkId(MediaEngine.CurrentSDK());
                assignIntItems(info.getIntItems(), to:data.getIntItems());
                assignStringItems(info.getStringItems(), to: data.getStringItems());
                AcuaSDK.StatsService().ReportStatistics(data);
            }
        }
    }
    
    /**
     切换sdk
     */
    func changeSDK(sdkID:UInt8)
    {
        if(_classSession != nil && (sdkID==4||sdkID==5))
        {
            if(sdkID == MediaEngine.CurrentSDK())
            {
                return;
            }
            _classSession.RequestChangeSdk(sdkID);
            GLogger.print("请求对方切换sdk \(sdkID)");
        }else{
            GLogger.print("sdk \(sdkID),本地不支持");
        }
    }
    
    
    func getLocalRender(tempFrame:NSRect) -> CocoaRenderViewBlitz
    {
        if(self.localView != nil)
        {
            self.localView?.removeFromSuperview();
        }
        return CocoaRenderViewBlitz(frame: tempFrame);
    }
    func getRemoteRender(tempFrame:NSRect) ->CocoaRenderViewBlitz
    {
        if(remoteView != nil)
        {
            remoteView?.removeFromSuperview();
        }
        return CocoaRenderViewBlitz(frame: tempFrame);
    }
}