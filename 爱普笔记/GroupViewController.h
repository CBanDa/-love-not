//
//  GroupViewController.h
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSQL.h"
#import "Note.h"
#import "NoteViewController.h"
#import "EditView.h"
@interface GroupViewController : UIViewController<NoteDelegate,EditViewDelegate>{
    EditView *_editView;
}
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NoteViewController *noteVC;

@property (strong, nonatomic) NoteSQL *dataWorker;

@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) NSString *string;

@property int GroupID;
@property (strong,nonatomic)UIView *backView;
@end
