//
//  SettingsTableViewCell.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 08/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *campaignImgView;
@property (nonatomic, retain) IBOutlet UILabel *campaignLbl;
@property (nonatomic, retain) NSString *campaignId;

@end
