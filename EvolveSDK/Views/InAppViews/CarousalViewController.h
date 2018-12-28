//
//  CarousalViewController.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 10/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PVOnboardKit/PVOnboardKit.h>
@interface CarousalViewController : UIViewController <PVOnboardViewDelegate, PVOnboardViewDataSource>

@property (nonatomic, retain) IBOutlet PVOnboardView *pvOnboard;
@property (nonatomic, retain) IBOutlet NSMutableArray *carousalImages;

@end
