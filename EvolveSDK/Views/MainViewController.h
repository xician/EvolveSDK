//
//  MainViewController.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 24/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PopupKit/PopupView.h>
#import <iCarousel/iCarousel.h>
#import "MainCircularProgress.h"
#import <PopupKit/PopupView.h>
#import <UIView_Shimmer/UIView+Shimmer.h>
#import "SLAMViewController.h"
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>

@interface MainViewController : UIViewController <iCarouselDelegate, iCarouselDataSource, UITextFieldDelegate>


@property (nonatomic, retain) IBOutlet UIView *mainCanvasView;
    // Progress Animation
        @property (nonatomic, retain) IBOutlet MainCircularProgress *contentDownloadingProgressView;
        @property (nonatomic, retain) IBOutlet UIView *searchingVisionCodeView;
        @property (nonatomic, retain) IBOutlet UIView *contentDownloadingView;

    ////
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UIView *notificationView;
@property (nonatomic, retain) IBOutlet UIImageView *notificationImageView;
@property (nonatomic, retain) IBOutlet UILabel *notificationTitle;
@property (nonatomic, retain) IBOutlet UILabel *notificationDescription;

@property (nonatomic, retain) IBOutlet UIView *arView;
@property (nonatomic, retain) IBOutlet UIView *pdfViewer;
@property (nonatomic, retain) IBOutlet UIImageView *enlargeImage;
@property (nonatomic, retain) IBOutlet UIView *enlargeImageView;
@property (nonatomic, retain) IBOutlet UIView *contactView;
@property (nonatomic, retain) IBOutlet UILabel *saveContactLbl;

@property (nonatomic, retain) IBOutlet UIView *eventView;
@property (nonatomic, retain) IBOutlet UILabel *saveEventLbl;

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *campaignIDTextViewBottom;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *arViewLeftConstraint;
@property (nonatomic, retain) IBOutlet UITextField *campaignIDTextField;
@property (nonatomic, retain) IBOutlet UILabel *campaignIDTextFieldBG;
@property (nonatomic, retain) IBOutlet UIView *campaignIDTextFieldBGView;
@property (nonatomic, retain) IBOutlet UIButton *goButton;
@property (nonatomic, retain) IBOutlet iCarousel *carouselView;

@property (nonatomic, retain) IBOutlet UIImageView *borderImg;

-(IBAction)placeModelButtonPressed:(id)sender;
-(IBAction)typedCodeChanged:(id)sender;
-(void)showDownloadContentsNavigationBar;
-(void)initializeUIContent;
-(IBAction)goButtonPressed:(id)sender;
@end
