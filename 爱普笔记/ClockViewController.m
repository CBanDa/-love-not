//
//  ClockViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-7.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "ClockViewController.h"

@interface ClockViewController ()

@end

@implementation ClockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (Version_iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提醒";
    [self initScrollView];
    [self initData];
    self.colorArray = [NSArray arrayWithObjects:[UIColor colorWithRed:0.773830F green:0.767224F blue:0.725974F alpha:0.5F],[UIColor colorWithRed:0.773830F green:0.873416F blue:0.725974F alpha:0.5F],[UIColor colorWithRed:0.873416F green:0.681577F blue:0.758009F alpha:0.5F],[UIColor whiteColor],[UIColor colorWithRed:0.615054F green:0.798404F blue:0.873416F alpha:0.5F], nil];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewRemind)];
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.scrollView.contentSize = CGSizeMake(320, 416);
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_sm_background"]];
}

- (void)initData
{
    self.dataWorker = [[NoteSQL alloc] init];
    [self.dataWorker createDB];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self printNote];
}

- (void)printNote
{
    // 还原
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentSize = CGSizeMake(320, 416);
    // 取内容
    NSMutableArray * array = [self.dataWorker selectData];
    // 打印
    for (int i = 0; i < [array count]; i++) {
        Note *note = [[Note alloc] initWithFrame:CGRectMake(0, 3 + i*51, 320, 46)];
        note.delegate = self;
        note.ID            = [[[array objectAtIndex:i] objectForKey:@"id"] intValue];
        note.titleLbl.text = [[array objectAtIndex:i] objectForKey:@"time"];
        
        [self.scrollView addSubview:note];
        note.backgroundView.backgroundColor = [self.colorArray objectAtIndex:i%5];
        if (i>7) {
            self.scrollView.contentSize = CGSizeMake(320, 54+i*51);
        }
    }
}

#pragma mark ======= 新建Note ===========
- (void)createNewRemind
{
    RemindViewController *remind = [[RemindViewController alloc]init];
    NSMutableArray * array = [self.dataWorker selectData];
    if (array.count == 0) {
        remind.rowID = 0;
    }else{
        remind.rowID = [[[array objectAtIndex:0]objectForKey:@"id"]intValue];
        for (int i = 0; i<array.count; i++) {
            if (remind.rowID <= [[[array objectAtIndex:i]objectForKey:@"id"]intValue]) {
                remind.rowID = [[[array objectAtIndex:i]objectForKey:@"id"]intValue]+1;
            }
        }
    }
    [self.navigationController pushViewController:remind animated:YES];
}

#pragma  mark ====== note 单击响应 ============
- (void)noteDidSelect:(Note *)note
{
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * localNotification in allLocalNotification) {
        NSString * alarmValue=[localNotification.userInfo objectForKey:@"AlarmKey"];
        if ([note.titleLbl.text isEqualToString:alarmValue]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
    RemindViewController *remind = [[RemindViewController alloc]init];
    
    for (int i = 0; i<[self.dataWorker selectData].count; i++) {
        if ([[[[self.dataWorker selectData] objectAtIndex:i]objectForKey:@"id"]intValue] == note.ID) {
            remind.list = [[self.dataWorker selectData] objectAtIndex:i];
        }
    }
    remind.rowID = note.ID;

    [self.dataWorker deleteData:note.ID];
    [self.navigationController pushViewController:remind animated:YES];
}

#pragma mark ========== 删除Note ==========
- (void)noteDidDelete:(Note *)note
{
    [self.dataWorker deleteData:note.ID];
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * localNotification in allLocalNotification) {
        NSString * alarmValue=[localNotification.userInfo objectForKey:@"AlarmKey"];
        if ([note.titleLbl.text isEqualToString:alarmValue]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
    [self printNote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
