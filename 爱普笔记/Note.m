//
//  Note.m
//  爱普笔记本
//
//  Created by XieJunqiang on 13-11-27.
//  Copyright (c) 2013年 ldci. All rights reserved.
//

#import "Note.h"

@implementation Note

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(540, 46);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        // 为了圆角,添加一个uiview
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        // 圆角
        self.backgroundView.layer.cornerRadius = 10;
        [self.scrollView addSubview:self.backgroundView];
        
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 46)];
        self.titleLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        [self.backgroundView addSubview:self.titleLbl];
        self.titleLbl.backgroundColor = [UIColor clearColor];
       
        self.timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(232, 0, 75, 46)];
        self.timeLbl.font = [UIFont systemFontOfSize:14];
        self.timeLbl.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.timeLbl];
        self.timeLbl.backgroundColor = [UIColor clearColor];
       
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.deleteBtn.frame = CGRectMake(360, 5, 60, 36);
        [self.deleteBtn setTitle:@"删除"forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        [self.deleteBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.tag = 0;
        [self.scrollView addSubview:self.deleteBtn];
    
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.cancelBtn.frame = CGRectMake(460, 5, 60, 36);
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.cancelBtn.tag = 1;
        [self.scrollView addSubview:self.cancelBtn];
        
        [self addSubview:self.scrollView];
        
        // 单击响应
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

// btn响应方法
- (void)btnDown:(UIButton *)btn
{
    if (btn.tag){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        if ([self.delegate respondsToSelector:@selector(noteDidDelete:)]){
            [self.delegate noteDidDelete:self];
        }
        [self removeFromSuperview];
    }
}

- (void)tapSelector
{
    [self.delegate noteDidSelect:self];
}
@end
