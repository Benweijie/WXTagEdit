//
//  EditTagView.m
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/6.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import "EditTagView.h"
#import "UIColor+RGB.h"
#import "Masonry.h"

@interface EditTagView ()<UITextFieldDelegate,EditTagTextFieldDelegate>

@end

@implementation EditTagView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.layer.cornerRadius = 27.0/2;
        
        self.textFieldKeyBoardVisible = NO;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
        
        [self addSubview:self.editTagTextField];
        
        [self.editTagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (EditTagTextField *)editTagTextField
{
    if (!_editTagTextField) {
        _editTagTextField = [[EditTagTextField alloc] init];
        _editTagTextField.delegate = self;
        _editTagTextField.editTextFieldDelegate = self;
        [_editTagTextField setValue:[UIColor colorWithRGB:0xC2CBD0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        [_editTagTextField setTextColor:[UIColor colorWithRGB:0x5D6972 alpha:1]];
        [_editTagTextField setFont:[UIFont systemFontOfSize:13]];
        _editTagTextField.returnKeyType = UIReturnKeyDone;
        _editTagTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_editTagTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

        _editTagTextField.placeholder = @"输入标签";
    }
    return _editTagTextField;
}

- (void)textFieldDidChange
{
    if ([self.delegate respondsToSelector:@selector(editTextFieldDidChange)]) {
        [self.delegate editTextFieldDidChange];
    }
    
    if (self.editTagTextField.text.length == 0) {
        [self removeLayer];
    }
    else{
        [self updateTextFieldLayerBorder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text && textField.text.length > 0) {
        NSString *tempTagName = textField.text;
        
        textField.text = @"";
        
        textField.layer.borderColor = [UIColor colorWithRGB:0xFFFFFF alpha:1].CGColor;
        
        [self removeLayer];
        
        if ([self.delegate respondsToSelector:@selector(editTextFieldReturn:)]) {
            [self.delegate editTextFieldReturn:tempTagName];
        }
        
        [textField becomeFirstResponder];
    }
    return YES;
}

- (void)updateTextFieldLayerBorder
{
    [self removeLayer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@4, @4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithRGB:0xC2CBD0 alpha:1].CGColor;
    [self.layer addSublayer:borderLayer];
}

- (void)textFieldDeleteBackward:(EditTagTextField *)textField
{
    if (textField.text.length == 0) {
        if([self.delegate respondsToSelector:@selector(editTextFieldDeleteBackward)]){
            [self.delegate editTextFieldDeleteBackward];
        }
    }
}

- (void)removeLayer
{
    if (self.layer.sublayers.count != 1) {
        CALayer *lastLayer = self.layer.sublayers.lastObject;
        [lastLayer removeFromSuperlayer];
    }
}

- (void)keyboardDidShow
{
    self.textFieldKeyBoardVisible =YES;
}

- (void)keyboardDidHide
{
}

@end
