//
//  QRUtil.h
//  QRCodeDemo
//
//  Created by storm on 15/11/13.
//  Copyright © 2015年 storm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface QRUtil : NSObject

+ (CGRect)screenBounds;

+ (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation;
@end
