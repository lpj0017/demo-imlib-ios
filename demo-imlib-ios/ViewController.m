//
//  ViewController.m
//  demo-imlib-ios
//  本示例测试的场景是自己对自己发送接收
//  Created by Liv on 14/11/6.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "ViewController.h"
#import "RCMessage.h"
#import "RCImageMessage.h"
#import "RCTextMessage.h"
#import "RCVoiceMessage.h"
#import "RCIMClient.h"
#import "RCStatusDefine.h"
#import "GroupInvitationNotification.h"
#import <AVFoundation/AVFoundation.h>
#import "RCRichContentMessage.h"

//#import "imlib/Headers/iOS_IMLib/RCMessage.h"
//#import "imlib/Headers/iOS_IMLib/RCImageMessage.h"
//#import "imlib/Headers/iOS_IMLib/RCTextMessage.h"
//#import "imlib/Headers/iOS_IMLib/RCVoiceMessage.h"
//#import "imlib/Headers/iOS_IMLib/RCIMClient.h"
//#import "imlib/Headers/iOS_IMLib/RCStatusDefine.h"
//#import "GroupInvitationNotification.h"

#import <AVFoundation/AVFoundation.h>
#define TOKEN1 @"XdW7qHkF9wvKQCKzYH3nDgYqCABAn5Kcb8fca4eQhGaaWjGCFu7YYIDYzu5h5C30NeC3UICWSuu2y7b5u85R1Q=="
#define TOKEN2 @"hXfg1mnRds2ggVjzc6T0lVlsz7j8LIjffmzv+eY1iPJrmFN0Tr/J9rEORb67D46vclg18qm7AmrUOlYinP0c4A=="

@interface ViewController ()<RCReceiveMessageDelegate,RCConnectDelegate,RCSendMessageDelegate>

@property (nonatomic,strong) NSURL *recordedFile ;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic) NSString *userId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //连接融云服务器，用自己注册融云API调试下获取的Token
    [RCIMClient connect:TOKEN1 delegate:self];
    
    //设置接收消息的回调
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    //初始化录音文件路径
    _recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//发送图片消息
- (IBAction)sendImage:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"test"];
    RCImageMessage *rcImageMessage = [RCImageMessage messageWithImage:image];
    [rcImageMessage setExtra:@"(extra_text 扩展字段)"];

    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:rcImageMessage
                                      delegate:self object:nil];
}

//发送文本消息
- (IBAction)sendText:(id)sender {
    
    RCTextMessage *rcImageMessage = [RCTextMessage messageWithContent:@"This is a test message!"];
    [rcImageMessage setExtra:@"(extra_text 扩展字段)"];

    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:rcImageMessage
                                      delegate:self object:nil];
}

//按住录音
- (IBAction)sendVoip:(id)sender {
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:nil error:nil];
    [_recorder prepareToRecord];
    [_recorder record];
    
}

//松开发送语音消息
- (IBAction)sendAndPlay:(id)sender {
    [_recorder stop];

    NSData* currentRecordData =[NSData dataWithContentsOfURL:_recordedFile];

    RCVoiceMessage *message = [RCVoiceMessage messageWithAudio:currentRecordData duration:_recorder.currentTime];
    [message setExtra:@"(extra_text 扩展字段)"];

    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:message
                                      delegate:self object:nil];
    
    
    

}
//图文消息
- (IBAction)sendImgAndText:(id)sender {
    
    RCRichContentMessage *msg = [RCRichContentMessage messageWithTitle:@"图文消息" digest:@"这是一条吴文消息" imageURL:@"http://www.baidu.com" extra:@"图文扩展字段"];
    [msg setExtra:@"(extra_text 扩展字段)"];

    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.userId content:msg delegate:self object:nil];
    
    
}

//发送自定义消息
- (IBAction)sentCustomMessage:(id)sender {
    GroupInvitationNotification *message = [GroupInvitationNotification groupInvitationNotificationWith:@"1101" message:@"test"];
    [message setExtra:@"(extra_text 扩展字段)"];
    [message setPushMessage:@"push 字段"];
    [RCIMClient registerMessageType:[GroupInvitationNotification class]];
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:message
                                      delegate:self object:nil];
    

    
   
    
}
- (IBAction)reConnect:(id)sender {
    [[RCIMClient sharedRCIMClient] disconnect];
    //连接融云服务器，用自己注册融云API调试下获取的Token
    [RCIMClient connect:TOKEN1 delegate:self];
    
    //设置接收消息的回调
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
}

#pragma mark - 图片消息
-(void)sendImageMessage:(UIImage*)image{
    
    RCImageMessage *rcImageMessage = [RCImageMessage messageWithImage:image];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                        targetId:self.userId
     
                                       content:rcImageMessage
                                      delegate:self object:nil];

    
}
-(void)publishLocalNotification:(NSString *)message {
    //设置1秒之后
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2];
    
    //chuagjian一个本地推送
    
    UILocalNotification *noti = [[UILocalNotification alloc] init] ;
    
    //设置推送时间
    
    noti.fireDate = date;
    
    //设置时区
    
    noti.timeZone = [NSTimeZone defaultTimeZone];
    
    //设置重复间隔
    
    noti.repeatInterval = NSCalendarUnitWeekday;
    
    //推送声音
    
    noti.soundName = UILocalNotificationDefaultSoundName;
    //内容
    
    noti.alertBody = message;
    
    //显示在icon上的红色圈中的数子
    
    noti.applicationIconBadgeNumber = 1;
    
    //设置userinfo 方便在之后需要撤销的时候使用
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
    
    noti.userInfo = infoDic;
    
    //添加推送到uiapplication
    
    UIApplication *app = [UIApplication sharedApplication];
    
    [app scheduleLocalNotification:noti];
}

#pragma mark - RCReceiveMessageDelegate
-(void)responseOnReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    NSLog(@"消息接收成功 ! ");
    
    NSString *mmm = nil;

    if ([message.content isKindOfClass:[RCVoiceMessage class]]) {
        RCVoiceMessage *msg = (RCVoiceMessage *) message.content;
        _player = [[AVAudioPlayer alloc] initWithData:msg.wavAudioData error:NULL];
        [_player play];
        NSLog(@"======>>>> 语音消息内容 %@ <<<===>>> 扩展字段 %@",message,message.extra);
        mmm = @"xxx";
    }
    
    if ([message.content isKindOfClass:[GroupInvitationNotification class]]) {
        GroupInvitationNotification *notti = (GroupInvitationNotification *) message.content;
        NSLog(@"======>>>> 自定消息内容 %@ %@ <<<===>>> 扩展字段 %@",notti.groupId,notti.message,notti.extra);
        
        //[self publishLocalNotification:notti.pushMessage];
        mmm = @"GroupInvitationNotification";
    }

    if ([message.content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *msg = (RCImageMessage *) message.content;
        NSLog(@"=======>>>> 图片消息 %@ <<<===>>> 扩展字段 %@",msg,msg.extra);
        mmm = @"RCImageMessage";
    }
    
    if ([message.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *msg = (RCTextMessage *) message.content;
        NSLog(@"=======>>>>>> 文字消息 %@ <<<===>>> 扩展字段 %@",msg.content,msg.extra);
        mmm = @"RCTextMessage";
    }
    
    if ([message.content isKindOfClass:[RCRichContentMessage class]]) {
        RCRichContentMessage *msg = (RCRichContentMessage *) message.content;
        NSLog(@"=======>>>>>> 图文消息 %@ <<<===>>> 扩展字段 %@",msg,msg.extra);
        mmm = @"RCRichContentMessage";
    }
    [self publishLocalNotification:mmm];
    
}

#pragma mark - RCConnectDelegate
-(void)responseConnectSuccess:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"DemoUserId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userId = userId;
    NSLog(@"连接成功！");
}

-(void)responseConnectError:(RCConnectErrorCode)errorCode
{
    NSLog(@"连接失败！ errorCode is %ld",(long)errorCode);
}




#pragma mark - RCSendMessageDelegate
- (void)responseSendMessageStatus:(RCErrorCode)errorCode messageId:(long)messageId object:(id)object
{
    if(errorCode == 0)
        NSLog(@"消息已发送!");
}

-(void)responseProgress:(int)progress messageId:(long)messageId object:(id)object
{
    NSLog(@"图片发送进度 %d",progress);
    if (progress == 100) {
        NSLog(@"发送图片成功!");
    }
}

-(void)responseError:(int)errorCode messageId:(long)messageId object:(id)object {

}
@end
