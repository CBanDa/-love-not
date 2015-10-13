//
//  HomeViewController.h
//  爱普笔记
//
//  Created by ldci on 14-1-2.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSQL.h"
#import "MainView.h"
#import "GroupViewController.h"
#import "ClockViewController.h"


//写一个协议，调用NewCiewController里面的方法
@protocol useCamera
-(void) openCamera:(id)sender;
-(void) openPhotoLibrary:(id)sender;
@end

@interface HomeViewController : UIViewController
// 存储每个笔记本封面
@property (strong, nonatomic) NSMutableArray *noteCoverMArray;
// 存储提醒
@property (strong, nonatomic) NSMutableArray *remindCoverMArray;

//数据库
@property (strong, nonatomic) NoteSQL *dataWorker;
@property (strong, nonatomic) MainView *main;
@property (strong, nonatomic) MainView *remind;
@property (strong, nonatomic) NSString *message;

//调用相机和相册用
@property (nonatomic, strong) UIImagePickerController *imagePicker;
//用于存储获取下来的图片
@property (nonatomic, strong) UIImage * getImage;


@property (nonatomic, strong) id<useCamera> delegate;
@end

