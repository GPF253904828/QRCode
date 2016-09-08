//
//  D_QRCode.h
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface D_QRCode : NSObject

//创建一个二维码
+ (UIImage *)createQRCodeData:(NSData *)data;

//+ (void ) getQRCodeFromImage:(UIImage *)image completionHandler:(void (^)(UIImage * imgWithQRCode))completion;
//识别图片中二维码
+ (void ) getQRCodeFromImage:(UIImage *)image completionHandler:(void (^)(UIImage * imgWithQRCode,NSString *message))completion;

//扫描二维码

@end
