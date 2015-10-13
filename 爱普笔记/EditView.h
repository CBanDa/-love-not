//
//  EditView.h
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditViewDelegate <NSObject>

- (void) withMessage:(NSString *) message;

@end
// 编辑笔记本的view
@interface EditView : UIView

@property (weak, nonatomic) IBOutlet UITextView *edit;
@property (assign, nonatomic) id<EditViewDelegate> editdelegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
