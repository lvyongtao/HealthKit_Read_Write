//
//  HealthModel.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "HealthModel.h"

@implementation HealthDetailModel
- (HealthDetailModel *)initWithStepDouble:(double)stepDouble andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate{
    if (self = [super init]) {
        self.stepDouble = stepDouble;
        self.startDate = startDate;
        self.endDate = endDate;
    }
    return self;
}
+ (HealthDetailModel *)initWithStepDouble:(double)stepDouble andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate{
    HealthDetailModel *model = [[HealthDetailModel alloc] initWithStepDouble:stepDouble andStartDate:startDate andEndDate:endDate];
    return model;
}

@end
@implementation HealthModel

- (HealthModel *)initWithStepCounts:(NSMutableArray *)stepCounts{
    if (self = [super init]) {
        self.stepCounts = stepCounts;
    }
    return self;
}
+ (HealthModel *)initWithStepCounts:(NSMutableArray *)stepCounts{
    HealthModel *model = [[HealthModel alloc] initWithStepCounts:stepCounts];
    return model;
}

@end
