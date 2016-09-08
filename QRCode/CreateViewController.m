//
//  CreateViewController.m
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "CreateViewController.h"
#import "D_QRCode.h"

@interface CreateViewController ()
@property (strong, nonatomic)  UIButton *createBtn;
@property (strong, nonatomic)  UIImageView *showImgView;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createBtn setTitle:@"点击创建二维码(www.baidu.com)" forState:UIControlStateNormal];
    [_createBtn addTarget:self action:@selector(createBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _createBtn.backgroundColor = [UIColor redColor];
    _createBtn.frame = CGRectMake(20, 100, 250, 40);
    [self.view addSubview:_createBtn];
    
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, 250, 250)];
    [self.view addSubview:self.showImgView];
    
    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"back" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(0, 40, 50, 50);
    [self.view addSubview:bt];
    ////////////
}
- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)createBtnClick:(id)sender {
    NSString * str  = @"wwww.baidu.com";
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *image = [D_QRCode createQRCodeData:data];
    self.showImgView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
