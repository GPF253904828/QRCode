//
//  RecognitionViewController.m
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "RecognitionViewController.h"
#import "D_QRCode.h"

@interface RecognitionViewController ()
@property (strong, nonatomic)  UIImageView *initalImgView;
@property (strong, nonatomic)  UIButton *recognitionBtn;
@property (strong, nonatomic)  UIImageView *showImgView;
@property (strong, nonatomic)  UILabel *text;
@end

@implementation RecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    self.initalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 140, 170)];
    [self.view addSubview:self.initalImgView];
    self.initalImgView.image = [UIImage imageNamed:@"recognition"];
    
    self.showImgView =  [[UIImageView alloc] initWithFrame:CGRectMake(50, 230, 150, 150)];
    [self.view addSubview:self.showImgView];

    self.recognitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recognitionBtn setTitle:@"点击截取并识别图中二维码" forState:UIControlStateNormal];
    [self.recognitionBtn addTarget:self action:@selector(recognitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.recognitionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.recognitionBtn.backgroundColor   = [UIColor blackColor];
    self.recognitionBtn.frame = CGRectMake(50, 200, 200, 30);
    [self.view addSubview:self.recognitionBtn];
    
    self.text= [UILabel new];
    self.text.textColor = [UIColor blackColor];
    self.text.numberOfLines = 0;
    self.text.font  = [UIFont systemFontOfSize:12];
    self.text.frame = CGRectMake(5, CGRectGetMaxY(self.showImgView.frame)+10, CGRectGetWidth(self.view.frame)-10, 100);
    self.text.backgroundColor  = [UIColor greenColor];
    [self.view addSubview:self.text];
    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"back" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(0, 40, 50, 50);
    [self.view addSubview:bt];
}
- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)recognitionBtnClick:(id)sender {
    
    UIImage * initImg = self.initalImgView.image;
    __weak typeof(self) __weakSelf = self;

    [D_QRCode getQRCodeFromImage:initImg completionHandler:^(UIImage *imgWithQRCode, NSString * message) {
        __weakSelf.showImgView.image = imgWithQRCode;
        __weakSelf.text.text = message;
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
