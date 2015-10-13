//
//  NoteViewController.h
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSQL.h"
#import "Note.h"

@interface NoteViewController : UIViewController<NoteDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NoteSQL *dataWorker;

@property (strong, nonatomic) NSArray *colorArray;

@property int GroupID;

@end
