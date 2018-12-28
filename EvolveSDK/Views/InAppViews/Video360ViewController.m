//
//  Video360ViewController.m
//  ARKitImageRecognition
//
//  Created by Cresset Admin on 12/10/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "Video360ViewController.h"
#import "VariableMnr.h"
@interface Video360ViewController ()

@end

@implementation Video360ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[VariableMnr sharedInstance] Google_TrackingScreen:SCREENNAME_VIDEO360];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
    [param setObject:self.assetUUID forKey:EVENT_ASSET_ID];
    [param setObject:self.url forKey:VIDEO360_ACTION_KEY];
    
    flurypost(SCREENNAME_VIDEO360, param, false, false);
    NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
    googlepost(SCREENNAME_VIDEO360, SCREENNAME_VIDEO360, json, 0);

    self.view.backgroundColor = [UIColor blackColor];
    
    // Create an AVPlayer for a 360º video:
    NSURL * const videoURL = [[NSURL alloc] initWithString:self.url];
//    NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://staging.evolvear.app/evolve-ar/static/app/media/abc.mp4"];
    self.player = [[AVPlayer alloc] initWithURL:videoURL];
    
    // Create a NYT360ViewController with the AVPlayer and our app's motion manager:
    id<NYT360MotionManagement> const manager = [NYT360MotionManager sharedManager];
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player motionManager:manager];

    // Embed the player view controller in our UI, via view controller containment:
    [self addChildViewController:self.nyt360VC];
    [self.view addSubview:self.nyt360VC.view];
    [self.nyt360VC didMoveToParentViewController:self];
    
    // Begin playing the 360º video:
    [self.player play];
    // In this example, tapping the video will place the horizon in the middle of the screen:
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reorientVerticalCameraAngle:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)reorientVerticalCameraAngle:(id)sender {
    [self.nyt360VC reorientVerticalCameraAngleToHorizon:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
