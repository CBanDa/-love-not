//
//  GroupViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "GroupViewController.h"
#import "EditView.h"
@interface GroupViewController ()

@end

@implementation GroupViewController

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
    self.title = @"笔记本";
    [self initNavBar];
    [self initScrollView];
    [self initData];
    [self initView];
    self.colorArray = [NSArray arrayWithObjects:[UIColor colorWithRed:0.773830F green:0.767224F blue:0.725974F alpha:0.5F],[UIColor colorWithRed:0.773830F green:0.873416F blue:0.725974F alpha:0.5F],[UIColor colorWithRed:0.873416F green:0.681577F blue:0.758009F alpha:0.5F],[UIColor whiteColor],[UIColor colorWithRed:0.615054F green:0.798404F blue:0.873416F alpha:0.5F], nil];
	// Do any additional setup after loading the view.
}

- (void)initView
{
    _editView = [[[NSBundle mainBundle] loadNibNamed:@"EditView" owner:self options:nil] lastObject];
    [_editView setFrame:CGRectMake(10, 20, _editView.frame.size.width, _editView.frame.size.height)];
    _editView.layer.masksToBounds = YES;
    _editView.layer.cornerRadius = 8.0;
    
    _editView.editdelegate = self;
}

- (void)initNavBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNote)];
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
#pragma mark ==== 刷新页面 =================

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
    NSMutableArray *array = [self.dataWorker selectGroupData];
    // 打印
    for (int i = 0; i < [array count]; i++) {
        Note *note = [[Note alloc] initWithFrame:CGRectMake(0, 3 + i*51, 320, 46)];
        note.delegate = self;
        note.titleLbl.text = [[array objectAtIndex:i] objectAtIndex:0];
        note.timeLbl.text = @"";
        note.ID = [[[array objectAtIndex:i] objectAtIndex:1] intValue];
        [self.scrollView addSubview:note];
        note.backgroundView.backgroundColor = [self.colorArray objectAtIndex:i%5];
        if (i>7) {
            self.scrollView.contentSize = CGSizeMake(320, 54+i*51);
        }
    }
}

- (void)createNote
{
    [_editView.edit becomeFirstResponder];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.7;
    [self.view addSubview:self.backView];
    _editView.edit.text = @"";
    [self.view addSubview:_editView];
}

- (void) withMessage:(NSString *)message
{
    [self.backView removeFromSuperview];
    // 存储数据
    if ([message length] == 0) {
        NSDate *  senddate=[NSDate date];

        NSCalendar  * cal = [NSCalendar  currentCalendar];
        NSUInteger  unitFlags =NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
        // NSInteger year = [conponent year];
        NSInteger month = [conponent month];
        NSInteger day = [conponent day];
        NSInteger hour = [conponent hour];
        NSInteger minute = [conponent minute];
        message = [NSString stringWithFormat:@"%2d:%02d,%2d/%2d",hour,minute,day,month];
    }
        NSArray *array = [self.dataWorker selectGroupData];
        int ID ;
        if ([array count]) {
            ID = [[[array objectAtIndex:[array count]-1] objectAtIndex:1] intValue] + 1 ;
            
            [self.dataWorker insertGroupTitle:message andGroupID:ID];
        }else{
            ID = 0;
            [self.dataWorker insertGroupTitle:message andGroupID:0];
        }
    [self printNote];
}

- (void)noteDidSelect:(Note *)note
{
    NoteViewController *noteVC = [[NoteViewController alloc] init];
    noteVC.GroupID = note.ID;
    noteVC.title = @"笔记";
    [self.navigationController pushViewController:noteVC animated:YES];
}

#pragma mark ========== 删除Note ==========
- (void)noteDidDelete:(Note *)note
{
    [self.dataWorker deleteFromGroupTable:note.ID];
    [self.dataWorker deleteAllFromNoteTable:note.ID];
    [self printNote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
