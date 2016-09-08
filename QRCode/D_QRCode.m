//
//  D_QRCode.m
//  QRCode
//
//  Created by Damon on 16/9/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "D_QRCode.h"

@implementation D_QRCode

+ (UIImage *)createQRCodeData:(NSData *)data{
    if (!data) {
        return nil;
    }
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    UIImage * retImg = nil;
    retImg = [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
    // 5.将CIImage转换成UIImage，并放大显示
    retImg = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    return retImg;
}
+ (void ) getQRCodeFromImage:(UIImage *)image completionHandler:(void (^)(UIImage * imgWithQRCode,NSString *message))completion{
//+ (void ) getQRCodeFromImage:(UIImage *)image completionHandler:(void (^)(UIImage * imgWithQRCode))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block UIImage * img = [self normalizedImage:image];
        if (img) {
            CIImage *ciImage = [[CIImage alloc] initWithImage:img];
            NSString *accuracy = CIDetectorAccuracyHigh;
            NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:options];
            NSArray *featuresArray = [detector featuresInImage:ciImage];
            CIQRCodeFeature * choosenQRCodeFeature = [self bestQRCodeFeaturesInFeatherArray:featuresArray];
            if (choosenQRCodeFeature) {
                CGRect bounds = [choosenQRCodeFeature bounds];
                CGFloat xPos = bounds.origin.x;
                CGFloat yPos = img.size.height - bounds.origin.y - bounds.size.height;
                CGRect faceFrame = CGRectMake(xPos, yPos, bounds.size.width, bounds.size.height);
                CGRect fixedFrame = [self frameForSuggestSize:CGSizeMake(150, 150) faceFrame:faceFrame imageFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
                CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, fixedFrame);
                UIImage * resultImg = [UIImage imageWithCGImage:(__bridge CGImageRef)CFBridgingRelease(subImageRef)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(resultImg,choosenQRCodeFeature.messageString);
                });
            }else {
                CGRect centerFrame = [self centerFrameForSize:CGSizeMake(150, 150) inFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
                CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, centerFrame);
                UIImage * resultImg = [UIImage imageWithCGImage:(__bridge CGImageRef)CFBridgingRelease(subImageRef)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(resultImg,@"");
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,nil);
            });
        }
    });
    

}
+ (CGRect)frameForSuggestSize:(CGSize)imgSize faceFrame:(CGRect)faceFrame imageFrame:(CGRect)imgFrame {
    imgSize = [self bestImgSizeForFaceFrame:faceFrame imgSize:imgSize];
    CGSize acceptableImgSize = [self acceptableSize:imgSize maxSize:imgFrame.size];
    CGPoint faceCenter = CGPointMake(CGRectGetMidX(faceFrame), CGRectGetMidY(faceFrame));
    CGFloat xPos = faceCenter.x >= acceptableImgSize.width/2.0 ? (faceCenter.x-acceptableImgSize.width/2.0) : 0.0;
    CGFloat yPos = faceCenter.y >= acceptableImgSize.height/2.0 ? (faceCenter.y-acceptableImgSize.height/2.0) : 0.0;
    return CGRectMake(xPos, yPos, acceptableImgSize.width, acceptableImgSize.height);
}
+ (CGRect)centerFrameForSize:(CGSize)size inFrame:(CGRect)frame {
    CGSize acceptableImgSize = [self acceptableSize:size maxSize:frame.size];
    CGFloat xPos = (frame.size.width-acceptableImgSize.width)/2.0;
    CGFloat yPos = (frame.size.height-acceptableImgSize.height)/2.0;
    return CGRectMake(xPos, yPos, size.width, size.height);
}
+ (CGSize)bestImgSizeForFaceFrame:(CGRect)faceFrame imgSize:(CGSize)imgSize {
    CGFloat xScale = faceFrame.size.width/imgSize.width;
    CGFloat yScale = faceFrame.size.height/imgSize.height;
    CGFloat maxScale = MAX(xScale, yScale);
    if (maxScale > 1.0) {
        return CGSizeMake(imgSize.width*maxScale, imgSize.height*maxScale);
    }
    return imgSize;
}
+ (CGSize)acceptableSize:(CGSize)size maxSize:(CGSize)maxSize {
    CGFloat xScale = size.width / maxSize.width;
    CGFloat yScale = size.height / maxSize.height;
    CGFloat maxScale = MAX(xScale, yScale);
    if (maxScale > 1.0) {
        return CGSizeMake(size.width/maxScale, size.height/maxScale);
    }
    return size;
}

+ (CIQRCodeFeature *)bestQRCodeFeaturesInFeatherArray:(NSArray *)featureArray {
    //get the bestFaceFeature by the maxnum bounds Square size
    CGFloat maxFaceSquare = 0.0;
    CIQRCodeFeature * chooseFaceFeature = nil;
    for (CIQRCodeFeature * faceFeathre in featureArray) {
        CGRect bounds = faceFeathre.bounds;
        CGFloat currentFaceSqu = CGRectGetWidth(bounds)*CGRectGetHeight(bounds);
        if (currentFaceSqu > maxFaceSquare) {
            maxFaceSquare = currentFaceSqu;
            chooseFaceFeature = faceFeathre;
        }
    }
    return chooseFaceFeature;
}
+ (UIImage *)normalizedImage:(UIImage *)img {
    if (img.imageOrientation == UIImageOrientationUp)
        return img;
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    [img drawInRect:(CGRect){0, 0, img.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}



@end
