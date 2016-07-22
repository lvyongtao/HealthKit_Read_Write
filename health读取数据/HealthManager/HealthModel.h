//
//  HealthModel.h
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthDetailModel : NSObject

@property (assign, nonatomic) double stepDouble;

@property (copy, nonatomic) NSString *startDate;

@property (copy, nonatomic) NSString *endDate;

- (HealthDetailModel *)initWithStepDouble:(double )stepDouble andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate;
+ (HealthDetailModel *)initWithStepDouble:(double )stepDouble andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate;
@end

@interface HealthModel : NSObject

@property (strong, nonatomic) NSMutableArray<HealthDetailModel *> *stepCounts;

- (HealthModel *)initWithStepCounts:(NSMutableArray *)stepCounts;
+ (HealthModel *)initWithStepCounts:(NSMutableArray *)stepCounts;
@end


