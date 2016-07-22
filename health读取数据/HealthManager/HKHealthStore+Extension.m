//
//  HKHealthStore+Extension.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "HKHealthStore+Extension.h"

@implementation HKHealthStore (Extension)

- (void)executeQuerySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *, NSError *))completion {
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        if (completion) {
            completion(results, error);
        }
    }];
    
    [self executeQuery:query];
}

@end
