//
//  MainView.m
//  爱普笔记
//
//  Created by ldci on 14-1-3.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "MainView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)addView:(int)num
{
    // 设置半透明背景
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius =9.0;
    self.backView.alpha = 0.22;
    
    // 笔记本的图片
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 80, 30)];

    // 三种情况 （如果截图了用nib会更加方便）
    if (num == 0){
        // 没有笔记的时候
        
        [self.backView setFrame:CGRectMake(0, 0,self.frame.size.width,50)];
        [self addSubview:self.backView];
        [self addSubview:self.imageView];
            
    }else{
        // 有笔记的时候
    
        [self.backView setFrame:CGRectMake(0, 0,self.frame.size.width,120)];
        [self addSubview:self.backView];
        [self addSubview:self.imageView];
        
        // 横线
        UIImageView *viewH = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 1)];
        viewH.image = [UIImage imageNamed:@"beijing.png"];
        [self addSubview:viewH];
            
        if (num == 1){
            // 为1条笔记
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.leftBtn setFrame:CGRectMake(0, 42, self.frame.size.width, 75)];
             
            // 时间
            self.leftTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 10)];
            self.leftTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
            self.leftTime.textColor = [UIColor whiteColor];
            self.leftTime.backgroundColor = [UIColor redColor];
            [self.leftBtn addSubview:self.leftTime];
            
            // 笔记
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20,100, 10)];
            self.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
            self.label.textColor = [UIColor whiteColor];
            self.label.text = @"笔记";
            self.label.backgroundColor = [UIColor blackColor];
            [self.leftBtn addSubview:self.label];
            
            // 内容
            self.leftMessage = [[UILabel alloc]initWithFrame:CGRectMake(10,30, 150, 30)];
            self.leftMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
            self.leftMessage.textColor = [UIColor whiteColor];
            [self.leftBtn addSubview:self.leftMessage];
            [self addSubview:self.leftBtn];
        }else{
            // 多条笔记
            UIImageView *viewV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 40, 1, 100)];
            viewV.image = [UIImage imageNamed:@"beijing.png"];
            [self addSubview:viewV];
            
            // 左侧按钮
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.leftBtn setFrame:CGRectMake(0, 42, self.frame.size.width/2, 75)];
       
            // 时间
            self.leftTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 10)];
            self.leftTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
            self.leftTime.textColor = [UIColor whiteColor];
            [self.leftBtn addSubview:self.leftTime];
            
            // 笔记
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20,100, 10)];
            self.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
            self.label.textColor = [UIColor whiteColor];
            
            [self.leftBtn addSubview:self.label];
            // 内容
            self.leftMessage = [[UILabel alloc]initWithFrame:CGRectMake(10,30, 150, 30)];
            self.leftMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
            self.leftMessage.textColor = [UIColor whiteColor];
            [self.leftBtn addSubview:self.leftMessage];
            [self addSubview:self.leftBtn];
            
            // 右侧按钮
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.rightBtn setFrame:CGRectMake(self.frame.size.width/2, 42, self.frame.size.width/2, 75)];
            
            // 时间
            self.rightTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 10)];
            self.rightTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
            self.rightTime.textColor = [UIColor whiteColor];
            [self.rightBtn addSubview:self.rightTime];
            // 笔记
            self.rlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20,100, 10)];
            self.rlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
            self.rlabel.textColor = [UIColor whiteColor];
            [self.rightBtn addSubview:self.rlabel];
            // 内容
            self.rightMessage = [[UILabel alloc]initWithFrame:CGRectMake(10,30, 150, 30)];
            self.rightMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
            self.rightMessage.textColor = [UIColor whiteColor];
            [self.rightBtn addSubview:self.rightMessage];
            [self addSubview:self.rightBtn];
        }
    }
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"添加" forState:UIControlStateNormal];
    [self.btn setFrame:CGRectMake(self.frame.size.width-50, 7, 50, 30)];
    [self addSubview:self.btn];
}

@end
