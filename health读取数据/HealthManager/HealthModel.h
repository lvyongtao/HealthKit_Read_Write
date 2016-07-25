//
//  HealthModel.h
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DateModel : NSObject

@property (strong, nonatomic) NSPredicate *predicate_date;

@property (copy, nonatomic) NSString *startdate;

- (DateModel *)initWithNSPredicate:(NSPredicate *)predicate_date NSDate:(NSString *)startdate;
+ (DateModel *)initWithNSPredicate:(NSPredicate *)predicate_date NSDate:(NSString *)startdate;

@end

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


@interface HealthManagerModel : NSObject


@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *startdate;

@property (copy, nonatomic) NSString *healthcontent;

- (HealthManagerModel *)initWithType:(NSString *)type Startdate:(NSString *)startdate Healthcontent:(NSString *)healthcontent;
+ (HealthManagerModel *)initWithType:(NSString *)type Startdate:(NSString *)startdate Healthcontent:(NSString *)healthcontent;

@end





