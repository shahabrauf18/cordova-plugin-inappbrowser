//
//  QRScannerViewController.h
//  ObjCWebView
//
//  Created by Asad Khan on 7/20/19.
//  Copyright © 2019 Attribes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDVWKInAppBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRScannerViewController : UIViewController

-(instancetype)initWith:(NSString*)baseUrl controller:(UIViewController*)controller;
-(void)detectedCode:(NSString*)code;
-(void)askForCameraPermission;
@end

NS_ASSUME_NONNULL_END
