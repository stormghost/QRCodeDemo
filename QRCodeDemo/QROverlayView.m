//
//  QROverlayView.m
//  QRCodeDemo
//
//  Created by storm on 15/11/20.
//  Copyright © 2015年 storm. All rights reserved.
//

#import "QROverlayView.h"
#import "QRUtil.h"

@interface QROverlayView()

@property (weak,nonatomic) IBOutlet UIImageView *scanBg;

@end

@implementation QROverlayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =[QRUtil screenBounds].size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = self.scanBg.frame;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

@end
