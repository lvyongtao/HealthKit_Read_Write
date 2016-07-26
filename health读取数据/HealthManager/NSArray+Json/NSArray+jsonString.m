//
//  NSArray+jsonString.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/26.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "NSArray+jsonString.h"

@implementation NSArray (jsonString)
- (NSString*)arrayOrNSDictionaryToNSData{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    NSString *jsonstring = [[NSString alloc] initWithData:(NSData *)result encoding:NSUTF8StringEncoding];
    return jsonstring;
}
@end
