//
//  SettingsViewController.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 08/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSString *codesType;
@end
