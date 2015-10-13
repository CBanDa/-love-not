//
//  MainView.h
//  爱普笔记
//
//  Created by ldci on 14-1-3.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView
@property (strong,nonatomic)UIView   *backView;
@property (strong,nonatomic)UIButton *btn;

// 内容的两个按钮（底部）
@property (strong,nonatomic)UIButton *leftBtn;
@property (strong,nonatomic)UIButton *rightBtn;
//============time 第一行Label    message 最下面一行=================
// 左侧的信息
@property (strong,nonatomic)UILabel *leftTime;
@property (strong,nonatomic)UILabel *leftMessage;
// 右侧的信息
@property (strong,nonatomic)UILabel *rightTime;
@property (strong,nonatomic)UILabel *rightMessage;
//============time 第一行Label    message 最下面一行=================



// 笔记本或者是提醒的样式
@property (strong,nonatomic)UIImageView *imageView;//笔记本ImageView
//==================中间label==========================
@property (strong,nonatomic)UILabel *rlabel;
@property (strong,nonatomic)UILabel *label; //主页左侧Label

- (void)addView:(int)num;
@end
