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
#import "CustomMessage.h"
#import <AVFoundation/AVFoundation.h>

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
#define TOKEN1 @"XdW7qHkF9wvKQCKzYH3nDgYqCABAn5Kcb8fca4eQhGaaWjGCFu7YYIDYzu5h5C30NeC3UICWSuu2y7b5u85R1Q=="
    
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
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:rcImageMessage
                                      delegate:self object:nil];
}

//发送文本消息
- (IBAction)sendText:(id)sender {
    
    RCTextMessage *rcImageMessage = [RCTextMessage messageWithContent:@"This is a test message!"];
    
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
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:message
                                      delegate:self object:nil];
    
    
    

}

//发送自定义消息
- (IBAction)sentCustomMessage:(id)sender {
    CustomMessage *message = [CustomMessage customMessageTextContent:@"test" intContent:100];

    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.userId
                                       content:message
                                      delegate:self object:nil];
    
}

#pragma mark - 图片消息
-(void)sendImageMessage:(UIImage*)image{
    
    RCImageMessage *rcImageMessage = [RCImageMessage messageWithImage:image];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                        targetId:self.userId
     
                                       content:rcImageMessage
                                      delegate:self object:nil];

    
}


#pragma mark - RCReceiveMessageDelegate
-(void)responseOnReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    if ([message.content isKindOfClass:[RCVoiceMessage class]]) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:nil];
        [_player play];
    }
    
    if ([message.content isKindOfClass:[CustomMessage class]]) {
        CustomMessage *msg = (CustomMessage *) message.content;
        NSLog(@"自定消息%@",msg.textContent);
    }
    NSLog(@"消息接收成功 ! %@",message);
}

#pragma mark - RCConnectDelegate
-(void)responseConnectSuccess:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"DemoUserId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userId = userId;
    NSLog(@"连接成功！");
    [RCIMClient registerMessageType:NSClassFromString(@"CustomMessage")];
}

-(void)responseConnectError:(RCConnectErrorCode)errorCode
{
    NSLog(@"连接失败！ errorCode is %ld",errorCode);
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
