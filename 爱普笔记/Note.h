//
//  Note.h
//  爱普笔记本
//
//  Created by XieJunqiang on 13-11-27.
//  Copyright (c) 2013年 ldci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol NoteDelegate;

@interface Note : UIView<UIScrollViewDelegate>

@property (assign)id<NoteDelegate>delegate;

@property  int ID;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *titleLbl;   // 笔记标题

@property (strong, nonatomic) UILabel *timeLbl;    // 创建或修改的时间

@property (strong, nonatomic) UIButton *deleteBtn;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIView *backgroundView;

@end

@protocol NoteDelegate <NSObject>

- (void)noteDidDelete:(Note *)note;
- (void)noteDidSelect:(Note *)note;

@end
