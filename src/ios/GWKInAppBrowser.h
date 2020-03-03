/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <Cordova/GPlugin.h>
#import <Cordova/GInvokedUrlCommand.h>
#import <Cordova/GScreenOrientationDelegate.h>
#import "GWKInAppBrowserUIDelegate.h"
#import "GInAppBrowserOptions.h"
#import "GInAppBrowserNavigationController.h"
#import "QRScanner.h"
#import "QRScannerViewController.h"
#import "LocationService.h"

@class GWKInAppBrowserViewController;

@interface GWKInAppBrowser : GPlugin {
    UIWindow * tmpWindow;

    @private
    NSString* _beforeload;
    BOOL _waitForBeforeload;
    
    
}

@property (nonatomic, retain) GWKInAppBrowser* instance;
@property (nonatomic, retain) GWKInAppBrowserViewController* inAppBrowserViewController;
@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, copy) NSRegularExpression *callbackIdPattern;

+ (id) getInstance;
- (void)open:(GInvokedUrlCommand*)command;
- (void)close:(GInvokedUrlCommand*)command;
- (void)injectScriptCode:(GInvokedUrlCommand*)command;
- (void)show:(GInvokedUrlCommand*)command;
- (void)hide:(GInvokedUrlCommand*)command;
- (void)loadAfterBeforeload:(GInvokedUrlCommand*)command;

@end

@interface GWKInAppBrowserViewController : UIViewController <GScreenOrientationDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,LocationServiceDelegate>{
    @private
    NSString* _userAgent;
    NSString* _prevUserAgent;
    NSInteger _userAgentLockToken;
    GInAppBrowserOptions *_browserOptions;
    
}

@property (nonatomic, strong) IBOutlet WKWebView* webView;
@property (nonatomic, strong) IBOutlet WKWebViewConfiguration* configuration;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* closeButton;
@property (nonatomic, strong) IBOutlet UILabel* addressLabel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* forwardButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) IBOutlet GWKInAppBrowserUIDelegate* webViewUIDelegate;

@property (nonatomic, weak) id <GScreenOrientationDelegate> orientationDelegate;
@property (nonatomic, weak) GWKInAppBrowser* navigationDelegate;
@property (nonatomic) NSURL* currentURL;
@property (nonatomic, strong)LocationService* locationManager;
@property (nonatomic, strong) CLLocation* location;

- (void)close;
- (void)navigateTo:(NSURL*)url;
- (void)showLocationBar:(BOOL)show;
- (void)showToolBar:(BOOL)show : (NSString *) toolbarPosition;
- (void)setCloseButtonTitle:(NSString*)title : (NSString*) colorString : (int) buttonIndex;

- (id)initWithUserAgent:(NSString*)userAgent prevUserAgent:(NSString*)prevUserAgent browserOptions: (GInAppBrowserOptions*) browserOptions;

@end
