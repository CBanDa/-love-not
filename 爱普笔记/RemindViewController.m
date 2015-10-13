//
//  RemindViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-7.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "RemindViewController.h"

@interface RemindViewController ()

@end

@implementation RemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.list = [[NSDictionary alloc]init];
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
    self.title = @"新提醒";

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.7;
    [self.view addSubview:backView];
    [self initData];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 25, 250, 216)];
    [self.view addSubview:self.datePicker];
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(15, 244, 290, 96)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    self.eventTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 249, 280, 86)];
    self.eventTextView.delegate = self;
    [self.view addSubview:self.eventTextView];

    if (self.list.count != 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [dateFormatter dateFromString:[self.list objectForKey:@"time"]];
        self.datePicker.date = date;
        self.eventTextView.text = [self.list objectForKey:@"message"];
    }

	// Do any additional setup after loading the view.
}
- (void)initData
{
    self.dataWorker = [[NoteSQL alloc] init];
    [self.dataWorker createDB];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 获取时间
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    if (notification!=nil && self.eventTextView.text != nil) {
        
        notification.fireDate = self.datePicker.date;
        // 0时区的时间
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:self.datePicker.date];
        // 本地时区的时间
        
        // 使用本地时区
        notification.timeZone=[NSTimeZone localTimeZone];
        notification.alertBody= [NSString stringWithFormat:@"%@,到了",destDateString];
        notification.userInfo = [NSDictionary dictionaryWithObject:destDateString forKey:@"AlarmKey"];
        
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        notification.alertAction=[NSString stringWithFormat:@"%@",self.eventTextView.text];
        [self.eventTextView resignFirstResponder];
        
        notification.hasAction = YES;
        // 这个通知到时间时，你的应用程序右上角显示的数字。
        notification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [self.dataWorker insertData:destDateString andMessage:self.eventTextView.text andid:self.rowID];
        self.eventTextView.text = @"";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = textView.frame;
    int flag = frame.origin.y+frame.size.height-(self.view.frame.size.height -216);
    if (flag > 0) {
        self.view.frame = CGRectMake(0, -flag, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

// 取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.eventTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
