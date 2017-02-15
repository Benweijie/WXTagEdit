//
//  EditTagTextField.m
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/6.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import "EditTagTextField.h"

@implementation EditTagTextField

//这个方法是为了解决ios10textfield动态修改宽度时光标下移以及往前突的问题。
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIScrollView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            CGPoint offset = [view contentOffset];
            if (offset.y != 0) {
                offset.y = 0;
                [view setContentOffset:offset];
            }
            if (offset.x != 0) {
                offset.x = 0;
                [view setContentOffset:offset];
            }
            break;
        }
    }
}

- (void)deleteBackward
{
    [super deleteBackward];
    
    if ([self.editTextFieldDelegate respondsToSelector:@selector(textFieldDeleteBackward:)]) {
        [self.editTextFieldDelegate textFieldDeleteBackward:self];
    }
}

@end
