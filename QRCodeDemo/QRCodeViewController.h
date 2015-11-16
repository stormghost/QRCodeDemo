//
//  QRCodeViewController.h
//  QRCodeDemo
//
//  Created by storm on 15/11/2.
//  Copyright © 2015年 storm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^QRUrlBlock) (NSString *url);
@interface QRCodeViewController : UIViewController
@property (nonatomic,copy) QRUrlBlock qrUrlBlock;

-(void)returnQRcode:(QRUrlBlock)block;

@end
