//
//  PersonTagView.m
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/4.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import "PersonTagView.h"
#import "UIColor+RGB.h"
#import "EditTagView.h"

@interface PersonTagView ()<EditTagViewDelegate>

@property (nonatomic, assign) int row;
@property (nonatomic, assign) int tempRow;

@property (nonatomic, assign) int section;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat tempTotalWidth;

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) EditTagView *editTagView;

@property (nonatomic, strong) NSMutableArray *tagLabelArray;

@property (nonatomic, assign) BOOL lastLabelIsHigh;

@end

#define kDistance 12.f
#define kMaxLength 20
#define kInputView_Height 28.f
#define kSection_Height (kInputView_Height+kDistance)
#define kInputViewLimit 78.f

@implementation PersonTagView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

- (void)updatePersonTagView
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.section = 0;
    self.row = 0;
    self.totalWidth = 0;
    self.tempTotalWidth = 0;
    self.tempRow = 0;
    int btId = 0;
    
    self.lastLabelIsHigh = NO;
    
    if ([self.norTagArray count] != 0) {
        for (NSString *norTagName in self.norTagArray) {
            UILabel *norTagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            
            norTagLabel.tag = btId;
            
            norTagLabel.text = norTagName;
            norTagLabel.textAlignment = NSTextAlignmentCenter;
            
            norTagLabel.font = [UIFont systemFontOfSize:13];
            norTagLabel.textColor = [UIColor colorWithRGB:0x3CBAFF alpha:1];
            
            norTagLabel.layer.cornerRadius = 27.0/2;
            norTagLabel.layer.borderColor = [UIColor colorWithRGB:0x3CBAFF alpha:1].CGColor;
            norTagLabel.layer.borderWidth = 1;
            norTagLabel.layer.masksToBounds = YES;
            norTagLabel.backgroundColor = [UIColor whiteColor];
            
            norTagLabel.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
            
            [norTagLabel addGestureRecognizer:tap];
            
            CGSize labelSize = [self getButtonSizeWithTitle:norTagName];
            CGFloat labelWidth = labelSize.width + 12*2;
            
            if (self.row == 0) {
                norTagLabel.frame = CGRectMake(0, self.section * (12+28), labelWidth, 28);
                self.totalWidth = labelWidth;
                self.row ++;
            }
            else {
                if (self.totalWidth + labelWidth + 12 > [UIScreen mainScreen].bounds.size.width - 24) {
                    self.section ++;
                    self.row = 0;
                    norTagLabel.frame = CGRectMake(0, self.section * (12+28), labelWidth, 28);
                    self.totalWidth = labelWidth;
                    self.row ++;
                }
                else {
                    norTagLabel.frame = CGRectMake(self.totalWidth + 12, self.section * (12+28), labelWidth, 28);
                    self.totalWidth += 12 + labelWidth;
                    self.row ++;
                }
            }
            
            btId ++;
            
            [self addSubview:norTagLabel];
            [self.tagLabelArray addObject:norTagLabel];
        }
    }
    
    //添加一个默认输入标签的view
    CGSize textFieldSize = CGSizeZero;
    
    if (self.editTagView.editTagTextField.text.length > 0) {
        textFieldSize = [self getButtonSizeWithTitle:self.editTagView.editTagTextField.text];
    }
    else
    {
        textFieldSize = [self getButtonSizeWithTitle:@"输入标签"];
    }
    
    CGFloat inputViewWidth = textFieldSize.width + 2 * kDistance + 2;//这个额外加的2是因为计算中文长度不准确出现的偏差
    CGFloat sectionOrginY = self.section*kSection_Height;
    if (self.row == 0) {
        self.editTagView.frame = CGRectMake(0, sectionOrginY, inputViewWidth, kInputView_Height);
        self.totalWidth = 0;
        self.row++;
    }
    else
    {
        if (inputViewWidth + self.totalWidth + kDistance  > [UIScreen mainScreen].bounds.size.width - 2*kDistance) {
            self.section++;
            self.row = 0;
            self.editTagView.frame = CGRectMake(0, sectionOrginY+kSection_Height, inputViewWidth, kInputView_Height);
            self.totalWidth = 0;
            self.row++;
        }
        else
        {
            self.editTagView.frame = CGRectMake(self.totalWidth+kDistance, sectionOrginY, inputViewWidth, kInputView_Height);
            self.row++;
        }
    }
    
    [self addSubview:self.editTagView];
    
    if ([self.delegate respondsToSelector:@selector(updatePersonTagViewHeight:)]) {
        [self.delegate updatePersonTagViewHeight:self.section];
    }
}

- (void)labelClick:(id)sender
{
    [self changeLabelViewBySelected:NO label:self.selectLabel];
    
    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
    
    UILabel *label = (UILabel *)singleTap.view;
    
    [self changeLabelViewBySelected:YES label:label];
    
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    CGRect rect = CGRectMake(0.5 * label.frame.size.width, 0, 0, 0);
    
    menu.menuItems = @[[[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteTag:)]];
    
    [menu setTargetRect:rect inView:label];
    
    [menu setMenuVisible:YES animated:YES];
    
    self.selectLabel = label;
    
    [self setEditTagViewTextFieldFirstResponder];
}

- (void)changeLabelViewBySelected:(BOOL)selected label:(UILabel *)label
{
    if (selected) {
        label.backgroundColor = [UIColor colorWithRGB:0x3CBAFF alpha:1];
        label.textColor = [UIColor whiteColor];
    }
    else{
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithRGB:0x3CBAFF alpha:1];
    }
}

- (void)editTextFieldDidChange
{
    NSString *toBeString = self.editTagView.editTagTextField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"en-US"]) {
        UITextRange *selectedRange = [self.editTagView.editTagTextField markedTextRange];       //获取高亮部分
        UITextPosition *position = [self.editTagView.editTagTextField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                self.editTagView.editTagTextField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }
    
    //计算文本框的长度
    CGSize textFieldSize = [self getButtonSizeWithTitle:self.editTagView.editTagTextField.text];
    CGFloat inputViewWidth = textFieldSize.width + 2*kDistance;
    CGFloat sectionOrginY = self.section * kSection_Height;
    
    //当文字长度大于53的时候才动态移动宽度。
    if (inputViewWidth > kInputViewLimit) {
        //自动换行
        if (inputViewWidth + self.totalWidth + kDistance  > [UIScreen mainScreen].bounds.size.width - 2 *kDistance) {
            if (self.row > 1) {
                self.tempRow = self.row - 1;
                self.tempTotalWidth = self.totalWidth;
                self.section++;
                self.row = 0;
                self.totalWidth = 0;
                self.row++;
                self.editTagView.frame = CGRectMake(self.totalWidth, sectionOrginY+kSection_Height, inputViewWidth, kInputView_Height);
            }
        }
        //长度不够就不换
        else
        {
            if (self.tempTotalWidth > 0 && (inputViewWidth + self.tempTotalWidth + kDistance  < [UIScreen mainScreen].bounds.size.width - 2 * kDistance)) {
                if (self.row == 1) {
                    self.totalWidth = self.tempTotalWidth;
                    self.section--;
                    self.row = self.tempRow + 1;
                    self.tempTotalWidth = 0;
                    self.tempRow = 0;
                    
                    self.editTagView.frame = CGRectMake(self.totalWidth + kDistance, sectionOrginY-kSection_Height, inputViewWidth, kInputView_Height);
                }
                else{
                    self.editTagView.frame = CGRectMake(self.totalWidth, sectionOrginY, inputViewWidth, kInputView_Height);
                }
            }
            else{
                if (self.row > 1) {
                    self.editTagView.frame = CGRectMake(self.totalWidth + kDistance, sectionOrginY, inputViewWidth, kInputView_Height);
                }
                else{
                    self.editTagView.frame = CGRectMake(self.totalWidth, sectionOrginY, inputViewWidth, kInputView_Height);
                }
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(updatePersonTagViewHeight:)]) {
        [self.delegate updatePersonTagViewHeight:self.section];
    }
}

- (void)editTextFieldDeleteBackward
{
    if (self.lastLabelIsHigh) {
        if ([self.delegate respondsToSelector:@selector(changeDefaultTagSelect:)]) {
            [self.delegate changeDefaultTagSelect:self.norTagArray.lastObject];
        }
        
        [self.norTagArray removeLastObject];
        [self updatePersonTagView];
        self.lastLabelIsHigh = NO;
        [self setEditTagViewTextFieldFirstResponder];
    }
    else{
        if (self.tagLabelArray.count > 0) {
            UILabel *lastButton = self.tagLabelArray.lastObject;
            lastButton.backgroundColor = [UIColor colorWithRGB:0x3CBAFF alpha:1];
            lastButton.textColor = [UIColor whiteColor];
        }
        self.lastLabelIsHigh = YES;
    }
}

- (void)editTextFieldReturn:(NSString *)tagName
{
    BOOL isDif = YES;
    
    for (NSString *tempName in self.norTagArray) {
        if ([tempName isEqualToString:tagName]) {
            isDif = false;
            break;
        }
    }
    
    if (isDif) {
        [self.norTagArray addObject:tagName];
    }
    
    [self updatePersonTagView];
    
    if ([self.delegate respondsToSelector:@selector(setRightItemEnable)]) {
        [self.delegate setRightItemEnable];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)deleteTag:(UIMenuItem *)sender
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    
    [self.norTagArray removeObjectAtIndex:self.selectLabel.tag];
    
    [self.tagLabelArray removeObject:self.selectLabel];
    
    if ([self.delegate respondsToSelector:@selector(changeDefaultTagSelect:)]) {
        [self.delegate changeDefaultTagSelect:self.selectLabel.text];
    }
    
    [self updatePersonTagView];
    
    [self setEditTagViewTextFieldFirstResponder];
}

- (void)setNorTagArray:(NSArray *)norTagArray
{
    _norTagArray = [norTagArray mutableCopy];
    
    [self updatePersonTagView];
}

- (CGSize)getTitleSize:(NSString *)title
{
    return  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
}

- (CGSize)getButtonSizeWithTitle:(NSString *)title
{
    if (!title || title.length == 0) {
        return CGSizeZero;
    }
    CGSize titleSize = [self getTitleSize:title];
    return CGSizeMake(titleSize.width, 28);
}

- (void)setEditTagViewTextFieldFirstResponder
{
    if (self.editTagView.textFieldKeyBoardVisible) {
        [self.editTagView.editTagTextField becomeFirstResponder];
    }
}

- (EditTagView *)editTagView
{
    if (!_editTagView) {
        _editTagView = [[EditTagView alloc] init];
        _editTagView.delegate = self;
    }
    return _editTagView;
}

- (NSMutableArray *)tagLabelArray
{
    if (!_tagLabelArray) {
        _tagLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tagLabelArray;
}

@end
