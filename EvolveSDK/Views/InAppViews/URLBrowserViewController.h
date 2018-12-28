//
//  URLBrowserViewController.h
//  ARKitImageRecognition
//
//  Created by Cresset Admin on 11/10/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"
#import "VariableMnr.h"
#import <WebKit/WebKit.h>
#import "YTPlayerView.h"
#import <MBProgressHUD/MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

@interface URLBrowserViewController : UIViewController <YTPlayerViewDelegate>
@property (nonatomic, retain) IBOutlet UIView *webView;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *campaignID;
@property (nonatomic, retain) NSString *assetUUID;
@property(nonatomic, retain) IBOutlet YTPlayerView *playerView;
@property(nonatomic, retain) IBOutlet UIProgressView *webViewProgress;

@end

NS_ASSUME_NONNULL_END
