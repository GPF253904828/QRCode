//
//  ViewController.m
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "ViewController.h"
#import "CreateViewController.h"
#import "RecognitionViewController.h"
#import "ScanViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createQRCode;
@property (weak, nonatomic) IBOutlet UIButton *recognitionQRCode;
@property (weak, nonatomic) IBOutlet UIButton *scanQRCode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//创建
- (IBAction)createBtnClick:(id)sender {
    CreateViewController * vc = [[CreateViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
//识别
- (IBAction)recognitionBtnClick:(id)sender {
    RecognitionViewController * vc = [[RecognitionViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
//扫描
- (IBAction)scanBtnClick:(id)sender {
    ScanViewController * vc = [[ScanViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
