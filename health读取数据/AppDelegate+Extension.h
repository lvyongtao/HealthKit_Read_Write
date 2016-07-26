//
//  AppDelegate+Extension.h
//  health读取数据
//
//  Created by lvyongtao on 16/7/22.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "AppDelegate.h"
#import "HealthManager.h"
#import "NSArray+jsonString.h"

#define kis_step @"step"
#define kis_distance @"distance"
#define kis_calorie @"calorie"


@interface AppDelegate (Extension)


- (void)initHealthData;

- (void)initTodayHealthData;

//- (void)syncHealthDataWithJavaWith:(HealthManagerModel *)model;

- (void)initHistoryMemoryHealthDataWith:(NSInteger )count;

@end
