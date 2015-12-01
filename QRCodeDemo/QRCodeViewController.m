//
//  QRCodeViewController.m
//  QRCodeDemo
//
//  Created by storm on 15/11/2.
//  Copyright © 2015年 storm. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QROverlayView.h"
#import "QRUtil.h"


#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface QRCodeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,ZBarReaderViewDelegate,ZBarReaderDelegate>

@property (nonatomic,assign) BOOL isFlashlightOpen;
@property (nonatomic,strong) UIImagePickerController *pickerController;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong) AVCaptureDevice *device;
@property (weak, nonatomic) IBOutlet QROverlayView *overlayView;
@property (nonatomic,strong) ZBarReaderView *readerView;

//从相册扫描
@property (nonatomic,strong) ZBarReaderViewController *QRreaderFromPhoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfImg;
@property (nonatomic) BOOL isEnterBG;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFlashlightOpen = NO;
    //设置摄像头
    self.view.backgroundColor = [UIColor clearColor];
    self.overlayView.backgroundColor = [UIColor clearColor];
    [self setupCamera];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haha) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(continueAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)haha{
    self.isEnterBG = YES;
    NSLog(@"%x",self.isEnterBG);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IOS7) {
        [self.session startRunning];
    }else{
        [self.readerView start];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startAnimation];

}


-(void)viewWillDisappear:(BOOL)animated{
    if (IOS7) {
        [self.session stopRunning];
    }else{
        [self.readerView stop];
    }
    [super viewWillDisappear:animated];
}

//返回二维码值的block
-(void)returnQRcode:(QRUrlBlock)block{
    self.qrUrlBlock = block;
}
-(void)setupCamera{
    //Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (IOS7) {
        //Input
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        //Output
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //Session
        self.session = [[AVCaptureSession alloc]init];
        
        //设置摄像头的效果为最高
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
        }
        
        AVCaptureConnection *outputConnection = [self.output connectionWithMediaType:AVMediaTypeVideo];
        outputConnection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
        
        //条码类型
        if (!TARGET_IPHONE_SIMULATOR) {
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeAztecCode];
        }
        
        //Preview
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResize;
        self.preview.frame = [QRUtil screenBounds];
        [self.view.layer insertSublayer:self.preview atIndex:0];
        self.preview.connection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
        [self.session startRunning];
    }else{
        //在iOS6上不支持官方的avcapture，使用的第三方zBarSDK
        self.readerView = [[ZBarReaderView alloc]init];
        self.readerView.readerDelegate = self;
        self.readerView.frame = [QRUtil screenBounds];
        self.readerView.allowsPinchZoom = NO;
        [self.readerView.session setSessionPreset:AVCaptureSessionPresetHigh];
        [self.view insertSubview:self.readerView aboveSubview:self.overlayView];
        [self.readerView start];
    }
}

- (IBAction)openLight:(UIButton *)sender {
    
    if (self.isFlashlightOpen) {
        if (IOS7) {
            self.isFlashlightOpen = NO;
            self.device.flashMode = AVCaptureFlashModeOff;
            self.device.torchMode = AVCaptureTorchModeOff;
            [self.device unlockForConfiguration];
        }else{
            self.isFlashlightOpen = NO;
            self.readerView.torchMode = NO;
        }
    }else{
        if (IOS7) {
            if ([self.device lockForConfiguration:NULL]) {
                self.device.flashMode = AVCaptureFlashModeOn;
                self.device.torchMode = AVCaptureTorchModeOn;
                self.isFlashlightOpen = YES;
            }
        }else{
            self.readerView.torchMode = YES;
            self.isFlashlightOpen = YES;
        }
    }
    
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    ZBarReaderController *zbarReader = [[ZBarReaderController alloc]init];
//    id<NSFastEnumeration> results = [zbarReader scanImage:img.CGImage];
//    ZBarSymbol *symbol = nil;
//    for (symbol in results){
//        NSLog(@"111111111111%@",symbol.data);
//        break;
//    }
//
//   // NSString *stringValue = symbol.data;
//    NSLog(@"二维码：%@",symbol.data);
    CIImage *ciImage = [CIImage imageWithCGImage:[img CGImage]];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    NSArray *arr = [detector featuresInImage:ciImage];
    NSString *qrCode = nil;
    if(arr.count > 0){
        CIQRCodeFeature *feature = arr[0];
        qrCode = feature.messageString;
    }
   
    if (qrCode) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.qrUrlBlock) {
            self.qrUrlBlock(qrCode);
        }
    }else{
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"error" message:@"选择的二维码无法读取，请重新选择！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
- (IBAction)openPhoto:(id)sender {
    UIImagePickerController *reader = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    reader.delegate = self;
    self.pickerController = reader;
    reader.allowsEditing = YES;
    [self presentViewController:reader animated:YES completion:^{
    }];

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue = nil;
    if ([metadataObjects count] > 0) {
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - zBarReaderViewDelegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{
    //得到扫码的内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    //NSString *symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
        //是否是条形码
    }
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@",symbol.data);
        if (self.qrUrlBlock) {
            self.qrUrlBlock(symbol.data);
            NSLog(@"二维码：%@",symbol.data);
        }
        break;
    }
    [readerView stop];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Animation

-(void)startAnimation{
    [UIView animateWithDuration:3 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.heightOfImg.constant = 250;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
       self.heightOfImg.constant = 0;
    }];
    
}
-(void)continueAnimation{
    if (self.isEnterBG) {
        [self startAnimation];
        self.isEnterBG = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
