//
//  RemindViewController.h
//  爱普笔记
//
//  Created by ldci on 14-1-7.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSQL.h"
@interface RemindViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) NSDictionary *list;
@property (strong, nonatomic) NoteSQL *dataWorker;
@property (retain, nonatomic) UIDatePicker *datePicker;
@property (retain, nonatomic) UITextView *eventTextView;
@property int rowID;

@end
