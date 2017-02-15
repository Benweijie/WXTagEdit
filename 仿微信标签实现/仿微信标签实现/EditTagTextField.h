//
//  EditTagTextField.h
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/6.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditTagTextField;

@protocol EditTagTextFieldDelegate <NSObject>

- (void)textFieldDeleteBackward:(EditTagTextField *)textField;

@end

@interface EditTagTextField : UITextField

@property (nonatomic, weak) id<EditTagTextFieldDelegate> editTextFieldDelegate;

@end
