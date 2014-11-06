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
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<RCReceiveMessageDelegate,RCConnectDelegate,RCSendMessageDelegate>

@property (nonatomic,strong) NSURL *recordedFile ;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioRecorder *recorder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //连接融云服务器，用自己注册融云API调试下获取的Token
    [RCIMClient connect:@"70YUydFc9mgnBoD1dZRq6jyXG0r4pvA1sUEQoiaxbkhsBIaUWcuu8BVdNyNuufguLj+fsZp04YzqrxN4oG4GKA==" delegate:self];
    
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
                                      targetId:[NSString stringWithFormat:@"%d",1101]
                                       content:rcImageMessage
                                      delegate:self object:nil];
}

//发送文本消息
- (IBAction)sendText:(id)sender {
    
    RCTextMessage *rcImageMessage = [RCTextMessage messageWithContent:@"This is a test message!"];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:[NSString stringWithFormat:@"%d",1101]
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
                                      targetId:@"1011"
                                       content:message
                                      delegate:self object:nil];
    
    
    

}

#pragma mark - 图片消息
-(void)sendImageMessage:(UIImage*)image{
    
    RCImageMessage *rcImageMessage = [RCImageMessage messageWithImage:image];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                        targetId:@"1011"
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
    NSLog(@"消息接收成功 ! %@",message);
}

#pragma mark - RCConnectDelegate
-(void)responseConnectSuccess:(NSString *)userId
{
    NSLog(@"连接成功！");
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
@end
