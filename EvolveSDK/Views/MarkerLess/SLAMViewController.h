//
//  SLAMViewController.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 01/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>
#import "DownloadMngrr.h"
#import "Model3D.h"
#import <Lottie/LOTAnimationView.h>

@interface SLAMViewController : UIViewController <ARSCNViewDelegate, ARSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) IBOutlet UIView *animView;
@property (nonatomic, retain) IBOutlet UIView *animButtonView;

@property (nonatomic, retain) IBOutlet UICollectionView *thumbnailSlider;
@property (nonatomic, retain) IBOutlet UIView *gestureView;
@property (nonatomic, retain) SCNNode *currentModel;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet UIView *thumbnailView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *menuButtonBottomSpace;
@property (nonatomic, retain) IBOutlet UIView *containingView;

@property (nonatomic, retain) IBOutlet UIView *descriptionBoxView;
@property (nonatomic, retain) IBOutlet UILabel *boxTitleLbl;
@property (nonatomic, retain) IBOutlet UILabel *boxDescriptionLbl;
@property (nonatomic, retain) IBOutlet UILabel *boxDescriptionPrice;
@property (nonatomic, retain) IBOutlet UIScrollView *descriptionScrollV;


-(void)placeModel:(int)modelIndex;
-(IBAction)menuButtonPressed:(id)sender;
+(SLAMViewController *)sharedInstance;
-(IBAction)dismissDescriptionBox:(id)sender;
@end
