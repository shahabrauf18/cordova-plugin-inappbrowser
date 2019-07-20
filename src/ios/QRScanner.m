//
//  QRScanner.m
//  ObjCWebView
//
//  Created by Asad Khan on 7/20/19.
//  Copyright © 2019 Attribes. All rights reserved.
//

#import "QRScanner.h"
#import "QRScannerViewController.h"

@interface QRScanner()

@property (strong,nonatomic) QRScannerViewController *controller;

@property (strong,nonatomic)NSArray<NSString*>*qrTYpes;

@property (strong,nonatomic)AVCaptureDevice *device;

@property (strong,nonatomic)AVCaptureDeviceInput *input;

@property (strong,nonatomic)AVCaptureMetadataOutput *output;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer *prevLayer;

@property (strong,nonatomic)AVCaptureSession * captureSession;

@end

@implementation QRScanner



-(instancetype)initWith:(QRScannerViewController*)controller{
    
    self.controller = controller;
    self.qrTYpes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                                    AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                                    AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self setup];
    
    return self;
}

-(BOOL)checkUserPremission{
    
    
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized) {
        //already authorized
        return true;
    }
    return false;
    
}

-(void)askForCameraPermission{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        if (granted){
            
            [self startScanning];
        }else{
            
            [self.controller askForCameraPermission];
        }
        
    }];
    
}
-(void)setup{
    
    _device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_captureSession addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_captureSession addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _prevLayer.frame = self.controller.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.controller.view.layer addSublayer:_prevLayer];
}


-(void)startScanning{
    
    [_captureSession startRunning];
}

-(void)stopScanning{
    [_captureSession stopRunning];
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects.count == 0) {
        //            qrCodeFrameView?.frame = CGRect.zero
        //            messageLabel.text = "No barcode/QR code is detected"
        return;
    }
    
    // Get the metadata object.
    AVMetadataMachineReadableCodeObject* metadataObj = (AVMetadataMachineReadableCodeObject*)metadataObjects.firstObject;
    
    // Here we use filter method to check if the type of metadataObj is supported
    // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
    // can be found in the array of supported bar codes.
    
    if ([self.qrTYpes containsObject:metadataObj.type]){
        //        if metadataObj.type == AVMetadataObjectTypeQRCode {
        // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
        [self.prevLayer transformedMetadataObjectForMetadataObject:metadataObj];
        
       // _ = worker?.videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        //qrCodeFrameView?.frame = barCodeObject!.bounds
        
        if (metadataObj.stringValue) {
            
            [self stopScanning];
            //Complex operation that are not important
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.controller detectedCode:metadataObj.stringValue];
            });
            
            
            
        }
    }
    
    
}
@end
