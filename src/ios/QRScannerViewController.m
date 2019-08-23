//
//  QRScannerViewController.m
//  ObjCWebView
//
//  Created by Asad Khan on 7/20/19.
//  Copyright © 2019 Attribes. All rights reserved.
//

#import "QRScannerViewController.h"
#import "QRScanner.h"

@interface QRScannerViewController ()
@property (strong,nonatomic)QRScanner *worker;
@property (strong,nonatomic)UIViewController *controller;
@property (strong,nonatomic)NSString *baseUrl;
@property (strong,nonatomic)UIButton* closeButton;
@end

@implementation QRScannerViewController


-(instancetype)initWith:(NSString*)baseUrl controller:(UIViewController*)controller{
    self.controller = controller;
    self.baseUrl = baseUrl;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.// MARK: View lifecycle
        
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self startCamera];
    
   self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    
    [self.closeButton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeButton setTitle:@"Back" forState:(UIControlStateNormal)];
    [self.closeButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    
    [self.view addSubview:self.closeButton];
    
    [self.view bringSubviewToFront:self.closeButton];
        
        
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (self.worker != nil){
            
        [self.worker startScanning];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (self.worker != nil){
            [self.worker stopScanning];
            //worker.captureSession?.stopRunning()
    }
}

-(void)askForCameraPermission{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:@"Need camera permission to scan QR"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self closeController];
                             
                         }];
//    UIAlertAction* cancel = [UIAlertAction
//                             actionWithTitle:@"Cancel"
//                             style:UIAlertActionStyleDefault
//                             handler:^(UIAlertAction * action)
//                             {
//                                 [alert dismissViewControllerAnimated:YES completion:nil];
//
//                             }];
    
    [alert addAction:ok];
    //[alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)startCamera{
    
    
        self.worker  = [[QRScanner alloc] initWith:self];
        
        if ([self.worker checkUserPremission] == false){
            
            [self.worker askForCameraPermission];
        }else{
            
            [self.worker startScanning];
        }
    }


-(void)detectedCode:(NSString *)code{
    
    
    CDVWKInAppBrowserViewController *vc =  (CDVWKInAppBrowserViewController*)self.controller;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/scanner?ref=index&qrCode=%@&client=ios",self.baseUrl, code];
    
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL * url = [[NSURL alloc] initWithString:strUrl];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:url];
    
     [vc.webView loadRequest:req];
    [self closeController];
    
}

-(void)closeController{
    
    if(self.navigationController != nil){
        [self.navigationController popViewControllerAnimated:true];
    }else if (self.presentingViewController != nil){
        [self dismissViewControllerAnimated:true completion:nil];
    }
}
@end
