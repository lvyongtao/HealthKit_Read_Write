//
//  AppDelegate+Extension.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/22.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "AppDelegate+Extension.h"
@implementation AppDelegate (Extension)

- (void)initHealthData{
    //获取健康数据
    self.synctimes = 0;
    self.synctodaytime = 0;
    [self initTodayHealthData];
    
//    [CustomClass sethealthStatusDate:@"2016-7-20"];
//    NSLog(@"-------->%@",[CustomClass gethealthStatusDate]);
//    if (![[CustomClass gethealthStatusDate] isEqualToString:[HealthManager predicateForSamplesTodayString]]) {
//        [self initHistoryMemoryHealthDataWith:[self numberOfDaysWithFromDate:[CustomClass gethealthStatusDate] toDate:[HealthManager predicateForSamplesTodayString]]];
//    }
    
}

- (void)initTodayHealthData{
    
    [[HealthManager shareManager] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
//        NSLog(@"%@",[NSThread currentThread]);
//        NSLog(@"当天行走步数 = %.fstep",value);
        [self syncTodayDataWith:[HealthManagerModel initWithType:kis_step Startdate:[HealthManager predicateForSamplesTodayString] Healthcontent:[NSString stringWithFormat:@"%.f",value]]];
    }];
    
    [[HealthManager shareManager] getKilocalorieUnit:[HealthManager predicateForSamplesToday] quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
//        NSLog(@"%@",[NSThread currentThread]);
//        NSLog(@"当天消耗的卡路里 ＝ %.2lfkcal",value);
         [self syncTodayDataWith:[HealthManagerModel initWithType:kis_calorie Startdate:[HealthManager predicateForSamplesTodayString] Healthcontent:[NSString stringWithFormat:@"%.f",value]]];
       
    }];
    
//        [[HealthManager shareManager] getRealTimeStepCountArrCompletionHandler:^(HealthModel *model, NSError *error) {
//            if ([model.stepCounts count] >0) {
//                for (int i = 0; i < [model.stepCounts count]; i ++) {
//                    HealthDetailModel *detailModel = model.stepCounts[i];
//                    NSLog(@"当天具体消耗的步数---->%@---->%@---->%f",detailModel.startDate,detailModel.endDate,detailModel.stepDouble);
//                }
//            }else{
//                NSLog(@"当天没有运动");
//            }
//        }];
    
    [[HealthManager shareManager] getRealTimeDistanceCompletionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
         [self syncTodayDataWith:[HealthManagerModel initWithType:kis_distance Startdate:[HealthManager predicateForSamplesTodayString] Healthcontent:[NSString stringWithFormat:@"%.f",value]]];
//        NSLog(@"当天行走距离 = %.2lf",value);
    }];
}
- (void)initHistoryMemoryHealthDataWith:(NSInteger)count{
    
    for (NSInteger i = count; i > 0; i --) {
        
        [self initDayHealthDataWith:i WithSum:count];
        
    }

}

- (void)initDayHealthDataWith:(NSInteger )count WithSum:(NSInteger )sums{
    
    
    
    NSPredicate *predicate_date = [HealthManager predicateForCompenentsDay:count].predicate_date;
    [[HealthManager shareManager] getKilocalorieUnit:predicate_date quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
//        NSLog(@"%@",[NSThread currentThread]);
//        NSLog(@" %@消耗的卡路里 ＝ %.2lf",[HealthManager predicateForCompenentsDay:count].startdate,value);
//        HealthDetailModel *detailModel = [[HealthDetailModel alloc] init];
//        detailModel.stepDouble = value;
//        if (value != 0) {
            HealthManagerModel *model = [HealthManagerModel initWithType:kis_calorie Startdate:[[HealthManager predicateForCompenentsDay:count] startdate] Healthcontent:[NSString stringWithFormat:@"%.f",value]];
            [self syncHealthDataWithJavaWith:model With:sums];
            
//        }
        
        
    }];
    //
    [[HealthManager shareManager] getStepCount:predicate_date completionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
//        NSLog(@" %@行走步数 = %.2lf",[HealthManager predicateForCompenentsDay:count].startdate,value);
//        if (value != 0) {
            HealthManagerModel *model = [HealthManagerModel initWithType:kis_step Startdate:[[HealthManager predicateForCompenentsDay:count] startdate] Healthcontent:[NSString stringWithFormat:@"%.f",value]];
            [self syncHealthDataWithJavaWith:model With:sums];

//        }
        }];
    
    
    [[HealthManager shareManager] getStepArr:predicate_date completionHandler:^(HealthModel *model, NSError *error) {
        if ([model.stepCounts count] >0) {
//            for (int i = 0; i < [model.stepCounts count]; i ++) {
//                HealthDetailModel *detailModel = model.stepCounts[i];
//                NSLog(@"detailModel---->%@---->%@---->%f",detailModel.startDate,detailModel.endDate,detailModel.stepDouble);
//            }
            
        }else{
            //                NSLog(@"时间段没有运动");
        }
    }];
    
    
    
    
    [[HealthManager shareManager] getDistance:predicate_date completionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
//        NSLog(@" %@行走距离 = %.2lf",[HealthManager predicateForCompenentsDay:count].startdate,value);
//        if (value !=0) {
            HealthManagerModel *model = [HealthManagerModel initWithType:kis_distance Startdate:[[HealthManager predicateForCompenentsDay:count] startdate] Healthcontent:[NSString stringWithFormat:@"%.f",value]];
            [self syncHealthDataWithJavaWith:model With:sums];
//        }
       
    }];
}

//- (NSPredicate *)setDayWithCount:(NSInteger )count{
//    NSDate *endDate = [NSDate date];
//    //设置时间段
//    NSTimeInterval timeInterval= [endDate timeIntervalSinceReferenceDate];
//    timeInterval -=3600*24*count;
//    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
//    //    NSDate *Date = [NSDate d]
//    NSLog(@"startDate= %@",beginDate);
//    NSPredicate *predicate_date =
//    [NSPredicate predicateWithFormat:@"endDate >= %@ AND startDate <= %@", beginDate,endDate];
//    return predicate_date;
//}
- (void)syncTodayDataWith:(HealthManagerModel *)model{
    self.synctodaytime ++;
    NSMutableDictionary *reqDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [reqDic setObject:model.type forKey:@"type"];
    [reqDic setObject:model.startdate forKey:@"startdate"];
    [reqDic setObject:model.healthcontent forKey:@"healthcontent"];
    [self.todayArray addObject:reqDic];
    if (self.synctodaytime == 3) {
        NSArray *arr = [self.todayArray copy];
        NSString *jsonstring = [arr arrayOrNSDictionaryToNSData];
        NSLog(@"今日消耗---->%@",jsonstring);
    }
}

- (void)syncHealthDataWithJavaWith:(HealthManagerModel *)model With:(NSInteger )sums{
   
    self.synctimes ++;
    NSMutableDictionary *reqDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [reqDic setObject:model.type forKey:@"type"];
    [reqDic setObject:model.startdate forKey:@"startdate"];
    [reqDic setObject:model.healthcontent forKey:@"healthcontent"];
    [self.dataArray addObject:reqDic];
    if (self.synctimes == sums*3) {
        NSArray *arr = [self.todayArray copy];
        NSString *jsonstring = [arr arrayOrNSDictionaryToNSData];
        NSLog(@"以往纪录---->%@",jsonstring);
    }

    
}

- (NSInteger)numberOfDaysWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate{
    
    NSLog(@"startdae =%@ ,enddate =%@",fromDate,toDate);
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *fromdate =[dateFormat dateFromString:fromDate];
    
    NSDate *todate = [dateFormat dateFromString:toDate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:fromdate toDate:todate options:NSCalendarWrapComponents];
    NSLog(@"时间差---->%ld",components.day);
    return components.day;
    
}
@end
