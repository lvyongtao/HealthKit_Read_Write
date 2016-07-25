//
//  AppDelegate.h
//  health读取数据
//
//  Created by lvyongtao on 16/7/18.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *todayArray;


@property (assign, nonatomic) NSInteger synctimes;

@property (assign, nonatomic) NSInteger synctodaytime;


@end

