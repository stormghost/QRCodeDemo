//
//  QRUtil.m
//  QRCodeDemo
//
//  Created by storm on 15/11/13.
//  Copyright © 2015年 storm. All rights reserved.
//

#import "QRUtil.h"

@implementation QRUtil

+ (CGRect)screenBounds {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        //        screenRect = CGRectMake(screen.bounds.origin.x, screen.bounds.origin.y, screen.bounds.size.height, screen.bounds.size.width);
        screenRect = CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    } else {
        screenRect = screen.bounds;
    }
    
    return screenRect;
    
}

+ (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
        NSLog(@"UIInterfaceOrientationPortrait");
        return AVCaptureVideoOrientationPortrait;
        
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"AVCaptureVideoOrientationLandscapeLeft");
        return AVCaptureVideoOrientationLandscapeLeft;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        NSLog(@"UIInterfaceOrientationLandscapeRight");
        return AVCaptureVideoOrientationLandscapeRight;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

@end
