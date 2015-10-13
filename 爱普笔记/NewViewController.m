//
//  NewViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController
//标记preViewImage的方法是在什么地方调用，2为添加图片时调用，1为初始化时调用，添加图片时调用会拼接回车，而初始化时调用，将不会多次拼接回车
static int number;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    number = 1;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor darkGrayColor];
    backView.alpha = 0.8;
    [self.view addSubview:backView];
    [self initData];
    [self initNoteTextView];
    [self setNavItem];
    self.isDisappear = YES;
    if (Version_iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
	// Do any additional setup after loading the view.
}

- (void)initData
{
    self.dataWorker = [[NoteSQL alloc] init];
    [self.dataWorker createDB];
}
- (void)setNavItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addImage)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(openPhotoLibrary:)];
}

#pragma mark ========== 初始化界面 ========
- (void)initNoteTextView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 8, 300, 33)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_sm_background"]];
    titleView.layer.cornerRadius = 5;
    [self.view addSubview:titleView];
    
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, 295, 20)];
    self.titleTextField.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    self.titleTextField.backgroundColor = [UIColor clearColor];
    self.titleTextField.delegate = self;
    self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleTextField.placeholder = @"输入标题";
    self.titleTextField.returnKeyType = UIReturnKeyNext;
    
    [titleView addSubview:self.titleTextField];
    // 设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
    self.titleTextField.adjustsFontSizeToFitWidth = YES;
    // 设置自动缩小显示的最小字体大小
    self.titleTextField.minimumFontSize = 2;
    
    self.noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 49, 300, 250)];
    self.noteTextView.delegate = self;
    self.noteTextView.layer.cornerRadius = 5;
    self.noteTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_sm_background"]];
    self.noteTextView.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    // self.noteTextView.returnKeyType =
    [self.view addSubview:self.noteTextView];
    // 判断是新建还是修改
    if (self.isFirst) {
        [self.titleTextField becomeFirstResponder];
    }else{
        NSArray *array = [self.dataWorker selectNoteText:self.GroupID :self.NoteID];
        self.titleTextField.text = [[array objectAtIndex:0] objectAtIndex:0];
        self.noteTextView.text = [[array objectAtIndex:0] objectAtIndex:1];
        NSArray *imgArray = [self.dataWorker selectNoteImage:self.GroupID :self.NoteID ];
        if ([imgArray count]) {
            NSString *imgName = [imgArray objectAtIndex:0];
            self.pickImg = [self readImage:imgName];
            [self previewImage:self.pickImg];
        }
    }
}

#pragma mark ======= 委托方法 ==========
//// 收键盘
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

// 从标题跳到内容输入
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.noteTextView becomeFirstResponder];
    return NO;
}

// 内容输入框大小调整
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.noteTextView.frame =  CGRectMake(10, 49, 300, 150);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.noteTextView.frame = CGRectMake(10, 49, 300, 250);
}

#pragma mark ========== 保存数据 ============
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 获取时间
    if (self.isDisappear) {
        [self insertData];
    }
}

- (void)insertData
{
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d-%2d-%2d",year,month,day];
    int ID ;
    if (self.isFirst) {
        if ([self.titleTextField.text length]||[self.noteTextView.text length]) {
            NSArray *array = [self.dataWorker selectNoteTitle:self.GroupID];
            if ([array count]) {
                ID = [[[array lastObject] objectAtIndex:2] intValue] + 1 ;
                [self.dataWorker insertNoteTitle:self.titleTextField.text noteText:self.noteTextView.text date:nsDateString noteID:ID noteGroupID:self.GroupID];
            }else{
                ID = 0;
                [self.dataWorker insertNoteTitle:self.titleTextField.text noteText:self.noteTextView.text date:nsDateString noteID:ID noteGroupID:self.GroupID];
            }
        }else
            return;
        
    }else{
        if ([self.titleTextField.text length]||[self.noteTextView.text length]){
            [self.dataWorker updateNoteTitle:self.titleTextField.text noteText:self.noteTextView.text date:nsDateString atGroupID:self.GroupID atNoteID:self.NoteID];
        }else{
            [self.dataWorker deleteFromNoteTable:self.GroupID :self.NoteID];
        }
    }
    // 存图片
    if (self.pickImg) {
        if (self.isFirst) {
            NSString *imageName = [NSString stringWithFormat:@"%i_%i_001",self.GroupID,ID];
            [self.dataWorker updateNoteImage:imageName GroupID:self.GroupID NoteID:ID];
            [self saveImage:self.pickImg :imageName];
            
        }else{
            NSString *imageName = [NSString stringWithFormat:@"%i_%i_001",self.GroupID,self.NoteID];
            [self.dataWorker updateNoteImage:imageName GroupID:self.GroupID NoteID:self.NoteID];
            [self saveImage:self.pickImg :imageName];
        }
    }
}

- (void)addImage
{
    self.isDisappear = NO;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = sourceType;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - 打开相机或相册
-(void) openCamera:(id)sender
{
    if ([self isCameraAvailable])
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.imagePicker setAllowsEditing:YES];
        [self.imagePicker setDelegate:self];
        NSArray *mediaTypesArr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.imagePicker setMediaTypes:mediaTypesArr];
        [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) openPhotoLibrary:(id)sender
{
    if ([self isPhotoLibraryAvailable])
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.imagePicker setAllowsEditing:YES];
        [self.imagePicker setDelegate:self];
        NSArray *mediaTypesArr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.imagePicker setMediaTypes:mediaTypesArr];
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片库不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 判断相机相册是否可用
-(BOOL) isCameraAvailable
{// 是否存在摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return YES;
    }
    return NO;
}

-(BOOL) isPhotoLibraryAvailable
{
    // 相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return YES;
    }
    return NO;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.isDisappear = YES;
    number = 2;
    self.pickImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [self previewImage:self.pickImg];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.isDisappear = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)previewImage:(UIImage *)image
{
    ////    float textHeight = [self heightForString:self.noteTextView.text fontSize:18.0 andWidth:300.0];
    ////    NSLog(@"qqqqqqq = %f",textHeight);
    //    NSRange range = [self.noteTextView selectedRange];
    //    //range 的location随着文本的增加而增加，根据下面的两行代码，可以算出文本有几行
    //    unsigned long location = (unsigned long)range.location;
    //    unsigned long height = location/29;
    //
    //    //图片的y坐标由基数20及行数＊20组成，多一行，图片就向下移动20.
    //    self.previewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20+20*height, 100, 100)];
    //    self.previewImgView.image = image;
    //    //[self.noteTextView addSubview:self.previewImgView];
    //    [self.noteTextView insertSubview:self.previewImgView atIndex:0];
    //
    //
    ////    NSMutableString * str=[[NSMutableString alloc] initWithString:self.noteTextView.text];
    ////    [str appendString:@"\n\n\n\n\n\n"];
    ////
    ////    self.noteTextView.text=str;
    if (number == 2) {
        NSMutableString * str=[[NSMutableString alloc] initWithString:@"\n\n\n\n\n\n"];
        [str appendString:self.noteTextView.text];
         self.noteTextView.text = str;
    }
    
    
   
    
    self.previewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.previewImgView.image = image;
    self.previewImgView.userInteractionEnabled = NO;
    //[self.noteTextView addSubview:self.previewImgView];
    [self.noteTextView insertSubview:self.previewImgView atIndex:0];
    
    
    
    
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//
////    // 保持图片在文本的最后面
//    NSRange range = [self.noteTextView selectedRange];
//    //range 的location随着文本的增加而增加，根据下面的两行代码，可以算出文本有几行
//    unsigned long location = (unsigned long)range.location;
//    unsigned long height = location/29;
////
////    // 扩大noteTextView的滑动区域，以便显示出图片
////    CGSize size = self.noteTextView.contentSize;
////    size.height  = 20+height*20+100+100;
////    self.noteTextView.contentSize = size;
//
//
////    float textHeight = [self heightForString:self.noteTextView.text fontSize:18.0 andWidth:300.0];
//   // NSLog(@"textHeight = %f",textHeight);
//
//
//    //图片的y坐标由基1数20及行数＊20组成，多一行，图片就向下移动20.
//    [self.previewImgView setFrame:CGRectMake(0,20+height*20, 100, 100)];
//}

- (NSString *)getPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    return path;
}

- (void)saveImage:(UIImage *)image :(NSString *)imageName
{
    NSString *docPath = [self getPath];
    NSString *imagePath = [docPath stringByAppendingPathComponent:imageName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath atomically:YES];
}

- (UIImage *)readImage:(NSString *)imageName
{
    NSString *docPath = [self getPath];
    NSString *imagePath = [docPath stringByAppendingPathComponent:imageName];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
