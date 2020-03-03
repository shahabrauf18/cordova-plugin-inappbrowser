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

#import "GInAppBrowser.h"
#import "GInAppBrowserOptions.h"
#if !WK_WEB_VIEW_ONLY
#import "GUIInAppBrowser.h"
#endif
#import "GWKInAppBrowser.h"
#import <Cordova/CDVPluginResult.h>


#pragma mark GInAppBrowser

@implementation GInAppBrowser

- (void)pluginInitialize
{
    // default values
    self.usewkwebview = NO;

#if __has_include("GWKWebViewEngine.h")
    self.wkwebviewavailable = YES;
#else
    self.wkwebviewavailable = NO;
#endif
}

- (void)open:(CDVInvokedUrlCommand*)command
{
    NSString* options = [command argumentAtIndex:2 withDefault:@"" andClass:[NSString class]];
    GInAppBrowserOptions* browserOptions = [GInAppBrowserOptions parseOptions:options];
    if(browserOptions.usewkwebview && !self.wkwebviewavailable){
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{@"type":@"loaderror", @"message": @"usewkwebview option specified but but no plugin that supplies a WKWebView engine is present"}] callbackId:command.callbackId];
        return;
    }
    self.usewkwebview = browserOptions.usewkwebview;
     [[GWKInAppBrowser getInstance] open:command];
//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] open:command];
//    }else{
//        [[GUIInAppBrowser getInstance] open:command];
//    }
}

- (void)close:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] close:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] close:command];
//    }else{
//        [[GUIInAppBrowser getInstance] close:command];
//    }
}


- (void)show:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] show:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] show:command];
//    }else{
//        [[GUIInAppBrowser getInstance] show:command];
//    }
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] hide:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] hide:command];
//    }else{
//        [[GUIInAppBrowser getInstance] hide:command];
//    }
}


- (void)injectScriptCode:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] injectScriptCode:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] injectScriptCode:command];
//    }else{
//        [[GUIInAppBrowser getInstance] injectScriptCode:command];
//    }
}

- (void)injectScriptFile:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] injectScriptFile:command];

//     if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] injectScriptFile:command];
//    }else{
//        [[GUIInAppBrowser getInstance] injectScriptFile:command];
//    }
}

- (void)injectStyleCode:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] injectStyleCode:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] injectStyleCode:command];
//    }else{
//        [[GUIInAppBrowser getInstance] injectStyleCode:command];
//    }
}

- (void)injectStyleFile:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] injectStyleFile:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] injectStyleFile:command];
//    }else{
//        [[GUIInAppBrowser getInstance] injectStyleFile:command];
//    }
}

- (void)loadAfterBeforeload:(CDVInvokedUrlCommand*)command
{
    [[GWKInAppBrowser getInstance] loadAfterBeforeload:command];

//    if(self.usewkwebview){
//        [[GWKInAppBrowser getInstance] loadAfterBeforeload:command];
//    }else{
//        [[GUIInAppBrowser getInstance] loadAfterBeforeload:command];
//    }
 }


@end
