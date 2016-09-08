//
//  ScanViewController.m
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "ScanViewController.h"
#import "D_QRCode.h"
#import "D_ScanQRCodeView.h"

@interface ScanViewController ()

@property (strong, nonatomic) UILabel *scanLab;

@end


@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

    D_ScanQRCodeView * scan = [[D_ScanQRCodeView alloc] initWithFrame:CGRectMake(50, 20, 200, 200)];
    self.scanLab = [UILabel new];
    _scanLab.textColor = [UIColor blackColor];
    _scanLab.numberOfLines = 0;
    _scanLab.font  = [UIFont systemFontOfSize:12];
    _scanLab.frame = CGRectMake(5, CGRectGetHeight(self.view.frame)-150, CGRectGetWidth(self.view.frame)-10, 100);
    _scanLab.backgroundColor  = [UIColor greenColor];
    [self.view addSubview:_scanLab];
    __weak typeof(self) __weakSelf = self;
    [self.view addSubview:scan];
    [scan begenScanQRCode:^(NSString *message) {
        __weakSelf.scanLab.text = message;
    }];
    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"back" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(0, 40, 45, 45);
    [self.view addSubview:bt];
}
- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
