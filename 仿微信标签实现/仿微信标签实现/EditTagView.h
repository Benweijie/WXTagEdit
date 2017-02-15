//
//  EditTagView.h
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/6.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTagTextField.h"

@class EditTagView;

@protocol EditTagViewDelegate <NSObject>

- (void)editTextFieldDidChange;
- (void)editTextFieldReturn:(NSString *)tagName;

- (void)editTextFieldDeleteBackward;

@end

@interface EditTagView : UIView

@property (nonatomic, strong) EditTagTextField *editTagTextField;
@property (nonatomic, assign) BOOL textFieldKeyBoardVisible;
@property (nonatomic, weak) id<EditTagViewDelegate> delegate;

@end
