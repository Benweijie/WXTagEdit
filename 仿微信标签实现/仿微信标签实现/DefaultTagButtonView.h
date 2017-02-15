//
//  defaultTagButtonView.h
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/4.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DefaultTagButtonView;

@protocol DefaultTagButtonViewDelegate <NSObject>

- (void)defaultTagButtonView:(DefaultTagButtonView *)defaultTagButtonView didClickTag:(NSString *)tagName;

@end

@interface DefaultTagButtonView : UIView

@property (nonatomic, strong) NSString *selectTagName;
@property (nonatomic, strong) NSArray *defaultTags;
@property (nonatomic, strong) NSArray *personTags;

@property (nonatomic, weak) id<DefaultTagButtonViewDelegate> delegate;

- (void)changeDefaultTagSelect:(NSString *)delectTagName;

@end
