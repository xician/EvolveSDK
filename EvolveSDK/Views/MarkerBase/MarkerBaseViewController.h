//
//  MarkerBaseViewController.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 01/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>
#import "DownloadMngrr.h"
#import "Model3D.h"
#import <MessageUI/MessageUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface MarkerBaseViewController : UIViewController <ARSCNViewDelegate, ARSessionDelegate, MFMailComposeViewControllerDelegate, CNContactViewControllerDelegate, JSONManagerDelegate, DownloadMngrDelegate>
@property BOOL isARAlreadyLoaded;

@property (nonatomic, retain) IBOutlet UIView *descriptionBoxView;
@property (nonatomic, retain) IBOutlet UIImageView *descriptionBoxImgView;

+(MarkerBaseViewController *)sharedInstance;

@end
