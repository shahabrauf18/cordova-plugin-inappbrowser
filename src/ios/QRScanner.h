//
//  QRScanner.h
//  ObjCWebView
//
//  Created by Asad Khan on 7/20/19.
//  Copyright © 2019 Attribes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScanner : NSObject <AVCaptureMetadataOutputObjectsDelegate>

-(instancetype)initWith:(UIViewController*)controller;

-(void)startScanning;
-(void)stopScanning;
-(void)askForCameraPermission;
-(BOOL)checkUserPremission;

@end

NS_ASSUME_NONNULL_END

