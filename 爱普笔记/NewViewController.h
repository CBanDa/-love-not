//
//  NewViewController.h
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NoteSQL.h"
#import "HomeViewController.h"
@interface NewViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,useCamera>

@property BOOL isFirst;     // 判断是修改还是创建;

@property BOOL isDisappear; // 判断是否真的返回

@property int NoteID;

@property int GroupID;

@property (strong, nonatomic) UITextField *titleTextField;

@property (strong, nonatomic) UITextView *noteTextView;

@property (strong, nonatomic) NoteSQL *dataWorker;

@property (strong, nonatomic) UIImage  *pickImg;

@property (strong, nonatomic) UIImageView *previewImgView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;



@end
