//
//  GroupInvitationNotification.h
//  demo-imlib-ios
//
//  Created by Liv on 14/11/7.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCNotificationMessage.h"



@interface GroupInvitationNotification : RCNotificationMessage


@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *extra;

+(instancetype)groupInvitationNotificationWith:(NSString *)groupId
                                       message:(NSString *)message
                                         extra:(NSString *) extra;
+ (NSString *)getObjectName;
@end
