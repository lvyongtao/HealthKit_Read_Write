//
//  ViewController.m
//  health读取数据
//
//  Created by lvyongtao on 16/7/18.
//  Copyright © 2016年 lvyongtao. All rights reserved.
//

#import "ViewController.h"
#import "HealthManager.h"
#import "HealthModel.h"
#import "ACMacros.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *stepLable;

@property (assign, nonatomic) float step;

@property (strong, nonatomic) UITableView *HealthtableView;

@property (strong, nonatomic) NSMutableArray *dataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHealthData];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
 
}

- (void)initTableView{
    
    _HealthtableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height - 64) style:UITableViewStylePlain];
    _HealthtableView.delegate = self;
    _HealthtableView.dataSource = self;
    _HealthtableView.backgroundColor = [UIColor clearColor];
    _HealthtableView.bounces = YES;
    _HealthtableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_HealthtableView];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)initHealthData{
    
    [[HealthManager shareManager] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"当天行走步数 = %.fstep",value);
        self.step = value ;
        HealthDetailModel *detailModel = [[HealthDetailModel alloc] init];
        detailModel.stepDouble = value;
        [self.dataArray addObject:detailModel];
        
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    }];
    
    [[HealthManager shareManager] getKilocalorieUnit:[HealthManager predicateForSamplesToday] quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"当天消耗的卡路里 ＝ %.2lfkcal",value);
        HealthDetailModel *detailModel = [[HealthDetailModel alloc] init];
        detailModel.stepDouble = value;
        [self.dataArray addObject:detailModel];
    }];
    
//    [[HealthManager shareManager] getRealTimeStepCountArrCompletionHandler:^(HealthModel *model, NSError *error) {
//        if ([model.stepCounts count] >0) {
//            for (int i = 0; i < [model.stepCounts count]; i ++) {
//                HealthDetailModel *detailModel = model.stepCounts[i];
//                NSLog(@"当天detailModel---->%@---->%@---->%f",detailModel.startDate,detailModel.endDate,detailModel.stepDouble);
//            }
//            self.dataArray = model.stepCounts;
//             [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
//        }else{
//            NSLog(@"当天没有运动");
//        }
//    }];
//
//    

//
//    
    NSDate *endDate = [NSDate date];
    //设置时间短
    NSTimeInterval timeInterval= [endDate timeIntervalSinceReferenceDate];
    timeInterval -=3600*24*32;
    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
//    NSDate *Date = [NSDate d]
    NSPredicate *predicate_date =
    [NSPredicate predicateWithFormat:@"endDate >= %@ AND startDate <= %@", beginDate,endDate];
    
    
    
    
    
    
    [[HealthManager shareManager] getKilocalorieUnit:predicate_date quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"消耗的卡路里 ＝ %.2lf",value);
        HealthDetailModel *detailModel = [[HealthDetailModel alloc] init];
        detailModel.stepDouble = value;
        [self.dataArray addObject:detailModel];
    }];
//
//    [[HealthManager shareManager] getStepCount:predicate_date completionHandler:^(double value, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//        NSLog(@"10天行走步数 = %.2lf",value);
//    }];
    
    
//    [[HealthManager shareManager] getStepArr:predicate_date completionHandler:^(HealthModel *model, NSError *error) {
//        if ([model.stepCounts count] >0) {
//            for (int i = 0; i < [model.stepCounts count]; i ++) {
//                HealthDetailModel *detailModel = model.stepCounts[i];
//                NSLog(@"detailModel---->%@---->%@---->%f",detailModel.startDate,detailModel.endDate,detailModel.stepDouble);
//            }
//             self.dataArray = model.stepCounts;
//             [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
//        }else{
//            NSLog(@"时间段没有运动");
//        }
//    }];
    
//    [[HealthManager shareManager] getRealTimeDistanceCompletionHandler:^(double value, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//        NSLog(@"当天行走距离 = %.2lf",value);
//    }];
//    [[HealthManager shareManager] getDistance:predicate_date completionHandler:^(double value, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//            NSLog(@"10天行走距离 = %.2lf",value);
//    }];
    

}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd HH:mm:ss zzz
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
#pragma mark
#pragma mark ——UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"healthkitDataCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    HealthDetailModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"当天能量消耗： %.f kcal",model.stepDouble];
    }else if(indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"某段时间能量消耗： %.fkcal",model.stepDouble];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"当天步数：     %.f 步",model.stepDouble];
        
    }
   
    cell.textLabel.numberOfLines =0;
    
    return cell;
}
#pragma mark ——UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)updateUI{
    if (!_HealthtableView) {
         [self initTableView];
    }
   
//     self.stepLable.text = [NSString stringWithFormat:@"%.f",self.step];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
