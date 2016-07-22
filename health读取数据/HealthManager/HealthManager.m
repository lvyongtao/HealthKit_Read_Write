//
//  HealthManager.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "HealthManager.h"
#import "ACMacros.h"
#import "HKHealthStore+Extension.h"

#define ErrorMessage @"用户不允许"

static HealthManager *manager = nil;
@implementation HealthManager
#pragma mark -- singleton
+ (HealthManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HealthManager alloc] init];
        [manager isAvailable];
    });
    return manager;
}
- (instancetype)init{
    
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (!manager) {
            manager = [super allocWithZone:zone];
            
            return manager;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

#pragma mark --Methods
- (void)isAvailable{
    if (FSystemVersion >= 8.0) {
        if ([HKHealthStore isHealthDataAvailable]) {
            if (!self.healthStore ) {
                self.healthStore = [[HKHealthStore alloc] init];
               
                //需要读写的数据类型
//                NSSet *writeDataTypes = [self dataTypesToWrite];
                NSSet *readDataTypes = [self dataTypesRead];
                
                [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError * _Nullable error) {
                    if (!success) {
                        //不成功的处理
                        NSLog(@"%@\n\n%@",error, [error userInfo]);
                        return ;
                    }
                }];
            }
        }
    }
}

//写入权限
- (NSSet *)dataTypesToWrite{
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
}

//读取权限
- (NSSet *)dataTypesRead{
    
//    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//    HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    //HKQuantityTypeIdentifierDistanceWalkingRunning
    HKQuantityType *distanceWalkingType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//    return [NSSet setWithObjects:heightType, temperatureType,birthdayType,sexType,weightType,stepCountType, activeEnergyType,distanceWalkingType,nil];
     return [NSSet setWithObjects:stepCountType, activeEnergyType,distanceWalkingType,nil];
}

#pragma mark --当天时间段
+ (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

#pragma mark --实时获取步数
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler{
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKSampleType *sampleType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        HKObserverQuery *query = [[HKObserverQuery alloc] initWithSampleType:sampleType predicate:nil updateHandler:^(HKObserverQuery * query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
            if (error) {
                handler(0,error);
//                abort();
            }
            [self getStepCount:[HealthManager predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
                handler(value,error);
            }];
        }];
         [self.healthStore executeQuery:query];
    }
}
#pragma mark --实时获取步数数组
- (void)getRealTimeStepCountArrCompletionHandler:(void(^)(HealthModel *model, NSError *error))handler{
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKSampleType *sampleType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        HKObserverQuery *query = [[HKObserverQuery alloc] initWithSampleType:sampleType predicate:nil updateHandler:^(HKObserverQuery * query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
            if (error) {
                handler(0,error);
                abort();
            }
            [self getStepArr:[HealthManager predicateForSamplesToday] completionHandler:^(HealthModel *model, NSError *error) {
                handler(model,error);
            }];
        }];
        [self.healthStore executeQuery:query];
    }
}
#pragma mark --获取步数
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler{
    
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        [self.healthStore executeQuerySampleOfType:stepType predicate:predicate completion:^(NSArray *results, NSError *error) {
            if(error){
                handler(0,error);
            }else{
                NSInteger totleSteps = 0;
                for(HKQuantitySample *quantitySample in results)
                {
                    HKQuantity *quantity = quantitySample.quantity;
                    HKUnit *heightUnit = [HKUnit countUnit];
                    
                    double userSteps = [quantity doubleValueForUnit:heightUnit];
                    totleSteps += userSteps;
                }
                handler(totleSteps,error);
            }
        }];
    }
}
#pragma mark --获取步数数组
- (void)getStepArr:(NSPredicate *)predicate completionHandler:(void(^)(HealthModel *model, NSError *error))handler{
    
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        [self.healthStore executeQuerySampleOfType:stepType predicate:predicate completion:^(NSArray *results, NSError *error) {
            if(error){
                handler(0,error);
            }else{
                NSMutableArray *resultArr = [[NSMutableArray alloc] init];
                for (HKSample *sample in results) {
                    NSString *startDate = [self stringFromDate:sample.startDate];
                    NSString *endDate = [self stringFromDate:sample.endDate];
                    for(HKQuantitySample *quantitySample in results){
                        HKQuantity *quantity = quantitySample.quantity;
                        HKUnit *heightUnit = [HKUnit countUnit];
                        double userSteps = [quantity doubleValueForUnit:heightUnit];
                      HealthDetailModel *model = [HealthDetailModel initWithStepDouble:userSteps andStartDate:startDate andEndDate:endDate];
                        [resultArr addObject:model];
                    };
                }
                handler([HealthModel initWithStepCounts:resultArr],error);
            }
        }];
    }
}

#pragma mark --获取当天的距离
- (void)getRealTimeDistanceCompletionHandler:(void (^)(double, NSError *))handler{
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKSampleType *sampleType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
        HKObserverQuery *query = [[HKObserverQuery alloc] initWithSampleType:sampleType predicate:nil updateHandler:^(HKObserverQuery * query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
            if (error) {
                handler(0,error);
                abort();
            }
            [self getDistance:[HealthManager predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
                handler(value,error);
            }];
        }];
        [self.healthStore executeQuery:query];
    }
    
}
#pragma mark --获取距离
- (void)getDistance:(NSPredicate *)predicate completionHandler:(void (^)(double, NSError *))handler{
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
        [self.healthStore executeQuerySampleOfType:stepType predicate:predicate completion:^(NSArray *results, NSError *error) {
            if(error){
                handler(0,error);
            }else{
                NSLog(@"%@",results);
                NSInteger totleDistance = 0;
                for(HKQuantitySample *quantitySample in results)
                {
                    HKQuantity *quantity = quantitySample.quantity;
                    //一公里==1000米 （米）
                    HKUnit *heightUnit = [HKUnit meterUnit];
                    
                    double userDistance = [quantity doubleValueForUnit:heightUnit];
                    NSLog(@"%f",userDistance);
                    totleDistance += userDistance;
                }
                handler(totleDistance,error);
            }
        }];
    }
}
#pragma mark --获取距离数组
- (void)getDistanceArr:(NSPredicate *)predicate completionHandler:(void (^)(HealthModel *, NSError *))handler{
    
}

//日期显示的格式
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd HH:mm:ss zzz
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
#pragma mark --获取卡路里
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler{
    
    if(FSystemVersion < 8.0){
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:ErrorMessage code:0 userInfo:userInfo];
        handler(0,aError);
    }else{
        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            HKQuantity *sum = [result sumQuantity];
            
            double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
            if(handler){
                handler(value,error);
            }
        }];
        [self.healthStore executeQuery:query];
    }
}

@end
