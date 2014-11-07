//
//  CustomMessage.h
//  demo-imlib-ios
//
//  Created by Liv on 14/11/7.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "RCMessageContent.h"

@interface CustomMessage : RCMessageContent

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) NSInteger intContent;

+(instancetype) customMessageTextContent : (NSString *) textContent
                               intContent: (NSInteger) intContent;
@end
