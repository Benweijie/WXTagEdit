//
//  ViewController.m
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/1.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "UIColor+RGB.h"
#import "DefaultTagButtonView.h"
#import "PersonTagView.h"

@interface ViewController ()<DefaultTagButtonViewDelegate,PersonTagViewDelegate>

@property (nonatomic, strong) NSArray *defaultTagArray;
@property (nonatomic, strong) NSMutableArray *personTagArray;

@property (nonatomic, strong) DefaultTagButtonView *defaultTagView;
@property (nonatomic, strong) PersonTagView *personTagView;

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIView *selectTagsView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *backColor = [UIColor colorWithRGB:0xEAEFF3 alpha:1];
    
    self.view.backgroundColor = backColor;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
    
    self.navigationItem.rightBarButtonItem.enabled = (self.personTagArray.count > 0);
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x98A1A8 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateDisabled];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x3CBAFF alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    self.title = @"设置标签";
    
    [self setupUI];
}

- (void) setupUI
{
    [self.selectTagsView addSubview:self.personTagView];
    [self.view addSubview:self.selectTagsView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.defaultTagView];
    
    [self.personTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-12);
    }];
    
    [self.selectTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.right.equalTo(self.view);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectTagsView.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
    }];
    
    [self.defaultTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(200);
    }];
}

- (void)defaultTagButtonView:(DefaultTagButtonView *)defaultTagButtonView didClickTag:(NSString *)tagName
{
    [self changeRightItemEnable];
    
    [self.personTagArray removeAllObjects];
    
    self.personTagArray = self.personTagView.norTagArray;
    
    BOOL isDif = true;
    
    if (self.personTagArray.count > 0) {
        for (NSString *name in self.personTagArray) {
            if ([name isEqualToString:tagName]) {
                isDif = false;
                [self.personTagArray removeObject:tagName];
                break;
            }
        }
    }
    
    if (isDif) {
        [self.personTagArray addObject:tagName];
    }
    
    self.personTagView.norTagArray = self.personTagArray;
    
    [self.personTagView setEditTagViewTextFieldFirstResponder];
}

- (void)save:(UIButton *)sender
{
    NSString *arrayString = [self.personTagView.norTagArray componentsJoinedByString:@","];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取到的标签数列" message:arrayString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updatePersonTagViewHeight:(NSInteger)section
{
    [self.personTagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((section + 1) * 28 + section * 12);
    }];
}

- (void)setRightItemEnable
{
    [self changeRightItemEnable];
}

- (void)changeDefaultTagSelect:(NSString *)deleteTagName
{
    for (NSString *defaultName in self.defaultTagArray) {
        if ([defaultName isEqualToString:deleteTagName]) {
            [self.defaultTagView changeDefaultTagSelect:deleteTagName];
            break;
        }
    }
}

- (void)changeRightItemEnable
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (UIView *)selectTagsView
{
    if (!_selectTagsView) {
        _selectTagsView = [[UIView alloc] init];
        _selectTagsView.backgroundColor = [UIColor whiteColor];
    }
    return _selectTagsView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
            _tipsLabel = [[UILabel alloc] init];
            _tipsLabel.font = [UIFont systemFontOfSize:12];
            _tipsLabel.textColor = [UIColor blackColor];
            _tipsLabel.text = @"所有标签";
    }
    return _tipsLabel;
}

- (NSArray *)defaultTagArray
{
    if (!_defaultTagArray) {
        _defaultTagArray = @[@"测试标签1",@"测试标签2",@"测试标签3",@"测试标签4"];
    }
    return _defaultTagArray;
}

- (NSMutableArray *)personTagArray
{
    if (!_personTagArray) {
        //NSArray *exArray = @[@"测试标签1",@"默认2",@"默认3"];
        NSArray *exArray = @[];
        _personTagArray = [exArray mutableCopy];
    }
    return _personTagArray;
}

- (DefaultTagButtonView *)defaultTagView
{
    if (!_defaultTagView) {
        _defaultTagView = [[DefaultTagButtonView alloc] init];
        _defaultTagView.delegate = self;
        _defaultTagView.defaultTags = self.defaultTagArray;
        _defaultTagView.personTags = self.personTagArray;
    }
    return _defaultTagView;
}

- (PersonTagView *)personTagView
{
    if (!_personTagView) {
        _personTagView = [[PersonTagView alloc] init];
        _personTagView.delegate = self;
        _personTagView.norTagArray = self.personTagArray;
    }
    return _personTagView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
