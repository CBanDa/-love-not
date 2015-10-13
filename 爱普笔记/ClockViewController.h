//
//  ClockViewController.h
//  爱普笔记
//
//  Created by ldci on 14-1-7.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSQL.h"
#import "Note.h"
#import "RemindViewController.h"
#import "Note.h"

@interface ClockViewController : UIViewController<NoteDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) NoteSQL *dataWorker;

@end
