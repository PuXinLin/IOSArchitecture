//
//  JYNoNetWorkView.m
//  JYProject
//
//  Created by dayou on 2017/8/2.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JYNoNetWorkView.h"
#import <Masonry/Masonry.h>
#import "JYMacro.h"
#import "JYCategory.h"

@interface JYNoNetWorkView()
/* 重新请求按钮 */
@property (nonatomic ,strong)UIButton *reloadButton;

/* 提示文本 */
@property (nonatomic ,strong)UILabel *messageLable;

/* MBProgressHUD */
@property (nonatomic ,strong)MBProgressHUD *superViewHUB;

@end

@implementation JYNoNetWorkView

#pragma mark ---------- Life Cycle ----------
-(instancetype)initWithView:(MBProgressHUD*)view{
    self = [super initWithFrame:view.bounds];
    if (self) {
        self.superViewHUB = view;
        [self configurationView];
        [self loadRequestData];
        [self resizeCustomView];
    }
    return self;
}

#pragma mark ---------- Private Methods ----------
#pragma mark 配置View
-(void)configurationView{}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark 页面初始化
-(void)resizeCustomView
{
    self.backgroundColor = [UIColor whiteColor];
    
    /* 背景图 */
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"网络故障"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(220, 200));
    }];
    
    /* 提示message */
    [self.messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(JY_APP_UIMarin);
        make.left.equalTo(imageView.mas_left).offset(JY_APP_UIMarin);
        make.right.equalTo(imageView.mas_right).offset(-JY_APP_UIMarin);
        make.height.mas_equalTo(30);
    }];
    
    /* 重新加载 */
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLable.mas_bottom).offset(JY_APP_UIMarin);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(156, 40));
    }];
}

#pragma mark ---------- Click Event ----------
-(void)reloadClick:(UIButton*)sender{
    [self.superViewHUB hide:YES];
    [self.delegate reloadRequest];
}

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------
-(UIButton *)reloadButton{
    if (!_reloadButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.backgroundColor = JY_ColorString(@"a394ff", 1);
        [button setTitle:@"重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton = button;
        [self addSubview:_reloadButton];
    }
    return _reloadButton;
}
-(UILabel *)messageLable{
    if (!_messageLable) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _messageLable = label;
        [self addSubview:_messageLable];
    }
    return _messageLable;
}

-(void)setMessage:(NSString *)message{
    _messageLable.text = message;
    _message = message;
}
@end
