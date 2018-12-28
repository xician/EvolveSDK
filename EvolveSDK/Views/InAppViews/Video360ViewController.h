//
//  Video360ViewController.h
//  ARKitImageRecognition
//
//  Created by Cresset Admin on 12/10/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NYT360Video/NYT360Video.h>

NS_ASSUME_NONNULL_BEGIN

@interface Video360ViewController : UIViewController 
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *campaignID;
@property (nonatomic, retain) NSString *assetUUID;

@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) NYT360ViewController *nyt360VC;
@end

NS_ASSUME_NONNULL_END
