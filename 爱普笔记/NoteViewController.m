//
//  NoteViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "NoteViewController.h"
#import "NewViewController.h"
@interface NoteViewController ()

@end

@implementation NoteViewController

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
    
    [self initNavBar];
    [self initScrollView];
    [self initData];
    if (Version_iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.colorArray = [NSArray arrayWithObjects:[UIColor colorWithRed:0.773830F green:0.767224F blue:0.725974F alpha:0.5F],[UIColor colorWithRed:0.773830F green:0.873416F blue:0.725974F alpha:0.5F],[UIColor colorWithRed:0.873416F green:0.681577F blue:0.758009F alpha:0.5F],[UIColor whiteColor],[UIColor colorWithRed:0.615054F green:0.798404F blue:0.873416F alpha:0.5F], nil];
	// Do any additional setup after loading the view.
}

- (void)initNavBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNote)];
}

#pragma mark ========= scrollView ============

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.scrollView.contentSize = CGSizeMake(320, 416);
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_sm_background"]];
}

#pragma mark ======= initData ==========
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
    NSMutableArray *array = [self.dataWorker selectNoteTitle:self.GroupID];
    // 打印
    for (int i = 0; i < [array count]; i++) {
        Note *note = [[Note alloc] initWithFrame:CGRectMake(0, 3 + i*51, 320, 46)];
        note.delegate = self;
        note.titleLbl.text = [[array objectAtIndex:i] objectAtIndex:0];
        note.timeLbl.text = [[array objectAtIndex:i] objectAtIndex:1];
        note.ID = [[[array objectAtIndex:i] objectAtIndex:2] intValue];
        [self.scrollView addSubview:note];
        note.backgroundView.backgroundColor = [self.colorArray objectAtIndex:i%5];
        if (i>7) {
            self.scrollView.contentSize = CGSizeMake(320, 54+i*51);
        }
    }
}

#pragma mark ======= 新建Note ===========
- (void)createNote
{
    NewViewController *new = [[NewViewController alloc]init];
    new.title = @"新笔记";
    new.GroupID = self.GroupID;
    new.isFirst = YES;
    [self.navigationController pushViewController:new animated:YES];
}

#pragma  mark ====== note 单击响应 ============
- (void)noteDidSelect:(Note *)note
{
    NewViewController *new = [[NewViewController alloc]init];
    new.NoteID = note.ID;
    new.GroupID = self.GroupID;
    new.title = @" 新笔记";
    new.isFirst = NO;
    [self.navigationController pushViewController:new animated:YES];
}

#pragma mark ========== 删除Note ==========
- (void)noteDidDelete:(Note *)note
{
    [self.dataWorker deleteFromNoteTable:self.GroupID :note.ID];
    [self printNote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
