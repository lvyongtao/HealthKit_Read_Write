//
//  HKHealthStore+Extension.h
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import <HealthKit/HealthKit.h>
@import HealthKit;
@interface HKHealthStore (Extension)

- (void)executeQuerySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;

@end
