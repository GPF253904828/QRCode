//
//  D_ScanQRCodeView.m
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "D_ScanQRCodeView.h"
#import <AVFoundation/AVFoundation.h>


@interface D_ScanQRCodeView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    int y;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic,strong) UIImageView * line;

@property (nonatomic, copy)void (^ getCompletion)(NSString * message);

@end

@implementation D_ScanQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        y =  10;
        upOrdown = NO;
        num =0;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"scanframe"];
        [self addSubview:imageView];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(10, y+10, self.bounds.size.width-20, 2)];
        _line.image = [UIImage imageNamed:@"scanline"];
        [self addSubview:_line];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        
    }
    return self;
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(10, y+2*num, self.bounds.size.width-20, 2);
        if (2*num == CGRectGetHeight(self.bounds)-20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(10, y+2*num, self.bounds.size.width-20, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
- (void) begenScanQRCode:(void (^)(NSString *message))completion{
    self.getCompletion = completion;
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]){
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]){
        [_session addOutput:self.output];
    }
    //二维码
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode] ;

    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(5, 5, CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-10);
    [self.layer insertSublayer:self.preview atIndex:0];
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *message = @"";
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        message = metadataObject.stringValue;
    }
    [_session stopRunning];
    [timer invalidate];
    _line.hidden = YES;
    NSLog(@"扫描完成获取信息 ：%@",message);
    self.getCompletion(message);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
