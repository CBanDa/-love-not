//
//  MainViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-2.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

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
    
    // 滚动试图
    _scorll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_scorll setContentSize:CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height)];
    _scorll.pagingEnabled = YES;
    _scorll.showsHorizontalScrollIndicator = NO;
    _scorll.showsVerticalScrollIndicator = NO;
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    image1.image = [UIImage imageNamed:@"second.png"];
    [_scorll addSubview:image1];
  
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    image2.image = [UIImage imageNamed:@"first.png"];
    [_scorll addSubview:image2];
   
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    image3.image = [UIImage imageNamed:@"third.png"];
    image3.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(105, 165, 100, 50)];
    [button setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [image3 addSubview:button];
    
    [_scorll addSubview:image3];
    
    [self.view addSubview:_scorll];
	// Do any additional setup after loading the view.
}

- (void)check
{
    HomeViewController *home = [[HomeViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
