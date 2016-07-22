//
//  HealthManager.h
//  health读取数据
//
//  Created by lvyongtao on 16/7/21.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "HealthModel.h"

@interface HealthManager : NSObject

@property (strong, nonatomic) HKHealthStore *healthStore;

+ (HealthManager *)shareManager;
/*!
 *  @brief  是否获取用户权限
 */
- (void)isAvailable;

/*!
 *  @brief  获取卡路里
 *
 *  @param predicate    时间段
 *  @param quantityType 样本类型
 *  @param handler      回调
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @brief  获取当天实时步数
 *
 *  @param handler 回调
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @brief  获取当天实时步数数组
 *
 *  @param handler 回调
 */
- (void)getRealTimeStepCountArrCompletionHandler:(void(^)(HealthModel *model, NSError *error))handler;
/*!
 *  @brief  获取当天实时距离
 *
 *  @param handler 回调
 */
- (void)getRealTimeDistanceCompletionHandler:(void(^)(double value, NSError *error))handler;
/*!
 *  @brief  获取一定时间段步数
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;
/*!
 *  @brief  获取一定时间段步数数组
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getStepArr:(NSPredicate *)predicate completionHandler:(void(^)(HealthModel *model, NSError *error))handler;

/*!
 *  @brief  获取一定时间段距离
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getDistance:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;
/*!
 *  @brief  获取一定时间段距离数组
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getDistanceArr:(NSPredicate *)predicate completionHandler:(void(^)(HealthModel *model, NSError *error))handler;
/*!
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday;
@end
