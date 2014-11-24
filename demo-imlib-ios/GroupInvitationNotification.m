//
//  GroupInvitationNotification.m
//  demo-imlib-ios
//
//  Created by Liv on 14/11/7.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "GroupInvitationNotification.h"
#define kUndefinedMessageTypeIdentifier @"RC:GroupInvationMsg"
@implementation GroupInvitationNotification


-(NSData *)encode {
    
    NSDictionary *dict = @{@"groupId": self.groupId, @"message":self.message,@"extra":self.extra};
    NSError *__error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&__error];
    if (!__error) {
        return data;
    } else {
        NSDictionary *userInfo = @{@"error": __error};
        @throw [NSException exceptionWithName:@"Failed at conversing RCLocationMessage instance to JSON data"
                                       reason:@"please check encode method"
                                     userInfo:userInfo];
    }
    
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError *__error = nil;
    if (!data) {
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&__error];
    if (!__error && dict) {
        self.groupId = dict[@"groupId"] ;
        self.message = dict[@"message"] ;
        self.extra = dict[@"extra"];
    } else {
        self.rawJSONData = data;
    }
}

+(instancetype)groupInvitationNotificationWith:(NSString *)groupId message:(NSString *)message
{
    GroupInvitationNotification *noti = [[GroupInvitationNotification alloc] init];
    noti.groupId = groupId;
    noti.message = message;
    
    return noti;
}

+ (NSString *)getObjectName {
    return kUndefinedMessageTypeIdentifier;
}


@end
