//
//  ViewController.m
//  QRCodeDemo
//
//  Created by storm on 15/11/2.
//  Copyright © 2015年 storm. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeViewController.h"
#import "QROverlayView.h"

@interface ViewController ()
@property (nonatomic,strong) QRCodeViewController *readerVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //modify
    
}
- (IBAction)gotoScan:(id)sender {
//    _readerVC = [[QRCodeViewController alloc] init];
    _readerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"scanView"];
    //QROverlayView *overlay = [[QROverlayView alloc]init];
    [_readerVC returnQRcode:^(NSString *url) {
        self.qrCode.text = url;
    }];
    [self.navigationController pushViewController:_readerVC animated:YES];
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
