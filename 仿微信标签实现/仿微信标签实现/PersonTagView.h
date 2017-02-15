//
//  PersonTagView.h
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/4.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonTagView;

@protocol PersonTagViewDelegate <NSObject>

- (void)updatePersonTagViewHeight:(NSInteger)section;
- (void)setRightItemEnable;
- (void)changeDefaultTagSelect:(NSString *)deleteTagName;

@end

@interface PersonTagView : UIView

@property (nonatomic, strong) NSMutableArray *norTagArray;//默认已有的按钮
@property (nonatomic, weak) id<PersonTagViewDelegate> delegate;

- (void)setEditTagViewTextFieldFirstResponder;

@end
