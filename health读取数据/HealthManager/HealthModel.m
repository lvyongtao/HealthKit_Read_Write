//
//  HealthModel.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "HealthModel.h"

@implementation DateModel

- (DateModel *)initWithNSPredicate:(NSPredicate *)predicate_date NSDate:(NSString *)startdate{
    if (self = [super init]) {
        _predicate_date = predicate_date;
        _startdate = startdate;
    }
    return self;
}
+ (DateModel *)initWithNSPredicate:(NSPredicate *)predicate_date NSDate:(NSString *)startdate{
    DateModel *model = [[DateModel alloc] initWithNSPredicate:predicate_date NSDate:startdate];
    return model;
}


@end

@implementation HealthDetailModel

- (HealthDetailModel *)initWithStepDouble:(double)stepDouble andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate{
    if (self = [super init]) {
        _stepDouble = stepDouble;
        _startDate = startDate;
        _endDate = endDate;
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
        _stepCounts = stepCounts;
    }
    return self;
}
+ (HealthModel *)initWithStepCounts:(NSMutableArray *)stepCounts{
    HealthModel *model = [[HealthModel alloc] initWithStepCounts:stepCounts];
    return model;
}



@end
@implementation HealthManagerModel

- (HealthManagerModel *)initWithType:(NSString *)type Startdate:(NSString *)startdate Healthcontent:(NSString *)healthcontent{
    if (self = [super init]) {
        _type = type;
        _startdate = startdate;
        _healthcontent = healthcontent;
    }
    return self;
}
+ (HealthManagerModel *)initWithType:(NSString *)type Startdate:(NSString *)startdate Healthcontent:(NSString *)healthcontent{
    HealthManagerModel *model = [[HealthManagerModel alloc] initWithType:type Startdate:startdate Healthcontent:healthcontent];
    return model;
}

@end
