//
//  QRCodeViewController.m
//  QRCodeDemo
//
//  Created by storm on 15/11/2.
//  Copyright © 2015年 storm. All rights reserved.
//

#import "QRCodeViewController.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface QRCodeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,ZBarReaderViewDelegate,ZBarReaderDelegate>

@property (nonatomic,assign) BOOL isFlashlightOpen;
@property (nonatomic,strong) UIImagePickerController *pickerController;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong) AVCaptureDevice *device;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
