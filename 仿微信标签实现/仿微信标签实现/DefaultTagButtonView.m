//
//  defaultTagButtonView.m
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/4.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import "DefaultTagButtonView.h"
#import "UIColor+RGB.h"

@interface DefaultTagButtonView ()

@property (nonatomic, strong) NSMutableArray *defaultTagButtonArray;

@end

@implementation DefaultTagButtonView

- (void)updateDefaultTagLabels
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    int section = 0;
    int row = 0;
    CGFloat totalWidth = 0;
    int btId = 0;
    for (NSString *tag in _defaultTags) {
        
        BOOL contain = [self containsExtTag:tag];
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        bt.selected = contain;
        bt.titleLabel.font = [UIFont systemFontOfSize:13];
        [bt setTitleColor:[UIColor colorWithRGB:0x5D6972 alpha:1] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithRGB:0x3CBAFF alpha:1] forState:UIControlStateSelected];
        
        [bt setBackgroundImage:nil forState:UIControlStateSelected];
        [bt setTitle:tag forState:UIControlStateNormal];
        
        bt.layer.cornerRadius = 28.0/2;
        bt.layer.borderColor = contain? [UIColor colorWithRGB:0x3CBAFF alpha:1].CGColor: [UIColor colorWithRGB:0xD9E5EA alpha:1] .CGColor;
        bt.layer.borderWidth = 0.5;
        bt.backgroundColor = [UIColor colorWithRGB:0xFFFFFF alpha:1];
        [bt addTarget:self action:@selector(didClickTag:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = btId;
        btId++;
        CGSize buttonSize = [self getButtonSizeWithTitle:tag];
        CGFloat buttonWidth = buttonSize.width + 12 * 2;
        
        if (row == 0) {
            bt.frame = CGRectMake(0, section * (12 + 28) ,buttonWidth , 28);
            totalWidth = buttonWidth;
            row++;
        }
        else
        {
            if (buttonWidth + totalWidth + 12  > [UIScreen mainScreen].bounds.size.width - 24) {
                section++;
                row = 0;
                bt.frame = CGRectMake(0, section * (12 + 28) ,buttonWidth , 28);
                totalWidth = buttonWidth;
                row++;
            }
            else
            {
                bt.frame = CGRectMake(totalWidth + 12, section * (12 + 28), buttonWidth, 28);
                totalWidth += 12 + buttonWidth;
                row++;
            }
        }
        [self addSubview:bt];
        [self.defaultTagButtonArray addObject:bt];
    }
}

- (BOOL)containsExtTag:(NSString *)defaultTagName
{
    for (NSString *tagName in _personTags) {
        if ([tagName isEqualToString:defaultTagName]) {
            return YES;
        }
    }
    
    if ([defaultTagName isEqualToString:self.selectTagName]) {
        return YES;
    }
    
    return NO;
}

- (void)setDefaultTags:(NSArray *)defaultTags
{
    _defaultTags = defaultTags;
    
    [self updateDefaultTagLabels];
}

- (void)setPersonTags:(NSArray *)personTags
{
    _personTags = personTags;
}

- (void)didClickTag:(UIButton *)sender
{
    UIButton *button = sender;
    
    if (button.selected) {
        button.layer.borderColor = [UIColor colorWithRGB:0xD9E5EA alpha:1].CGColor;
    }
    else{
        button.layer.borderColor = [UIColor colorWithRGB:0x3CBAFF alpha:1].CGColor;
    }

    button.selected = !button.selected;
    
    if ([_delegate respondsToSelector:@selector(defaultTagButtonView:didClickTag:)]) {
        [_delegate defaultTagButtonView:self didClickTag:[sender titleForState:UIControlStateNormal]];
    }
}

- (void)changeDefaultTagSelect:(NSString *)delectTagName
{
    for (UIButton *bt in self.defaultTagButtonArray) {
        if ([bt.titleLabel.text isEqualToString:delectTagName]) {
            if (bt.selected) {
                bt.layer.borderColor = [UIColor colorWithRGB:0xD9E5EA alpha:1].CGColor;
            }
            else{
                bt.layer.borderColor = [UIColor colorWithRGB:0x3CBAFF alpha:1].CGColor;
            }
            bt.selected = !bt.selected;
            break;
        }
    }
}

- (CGSize)getButtonSizeWithTitle:(NSString *)title
{
    if (!title || title.length == 0) {
        return CGSizeZero;
    }
    CGSize titleSize = [self getTitleSize:title];
    return CGSizeMake(titleSize.width, 28);
}

- (CGSize)getTitleSize:(NSString *)title
{
    return  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 27) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
}

- (NSMutableArray *)defaultTagButtonArray
{
    if (!_defaultTagButtonArray) {
        _defaultTagButtonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _defaultTagButtonArray;
}

@end
