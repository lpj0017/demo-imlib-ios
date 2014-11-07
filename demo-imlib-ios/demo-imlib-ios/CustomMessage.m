//
//  CustomMessage.m
//  demo-imlib-ios
//
//  Created by Liv on 14/11/7.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "CustomMessage.h"

@implementation CustomMessage


-(NSData *)encode
{
    NSDictionary* dataDict = @{@"textContent":_text,@"intContent":[NSNumber numberWithInteger:_intContent]};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDict
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* error = nil;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    self.text = jsonDict[@"textContent"];
    self.intContent = [jsonDict[@"intContent"] integerValue];
}

+(instancetype)customMessageTextContent:(NSString *)textContent intContent:(NSInteger)intContent
{
    CustomMessage *message = [[CustomMessage alloc] init];
    message.intContent = intContent;
    message.text = textContent;
    return message;
    
}
@end
