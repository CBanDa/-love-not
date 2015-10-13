//
//  EditView.m
//  爱普笔记
//
//  Created by ldci on 14-1-6.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "EditView.h"

@implementation EditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

- (void)dealloc
{
    self.editdelegate = nil;
}

- (IBAction)cancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)done:(id)sender
{
    if ([self.editdelegate respondsToSelector:@selector(withMessage:)]){
        [self.editdelegate  withMessage:self.edit.text];
    }
    [self removeFromSuperview];
}
@end
