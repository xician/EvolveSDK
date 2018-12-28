//
//  VariableManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/07/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>
#import "JSONManager.h"
#import "SLAMJSONManager.h"
#import "MainViewController.h"
#import "MainCircularProgress.h"
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#define flurypost(title,param,istimedevent,currentstarted) [[VariableMnr sharedInstance] postFlurryEvent:title withParameter:param isTimedEvent:istimedevent isCurrentlyStarted:currentstarted];

#define googlepost(category,action,json,value) [[VariableMnr sharedInstance] Google_TrackingEventWithCategory:category actionName:action labelJson:json andValue:value]

#define googlescreen(screenName) [[VariableMnr sharedInstance] Google_TrackingScreen:screenName];

@interface VariableMnr : NSObject <MFMailComposeViewControllerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, retain) ARImageTrackingConfiguration *imageConfiguration;
@property (nonatomic, retain) JSONManager *jsonManager;
@property (nonatomic, retain) SLAMJSONManager *slamJsonManager;
@property (nonatomic, retain) UINavigationController *evolveNavigationController;
@property (nonatomic, retain) UIView *downloadContentPorgressView;
@property (nonatomic, retain) UIView *searchingVisionCodeProgressView;
@property (nonatomic, retain) MainCircularProgress *progressViewBar;
@property (nonatomic, retain) UIView *trackingCoverView;
@property (nonatomic, retain) NSString *scannedCode;
@property (nonatomic, retain) PopupView *thumbnailSheetPopup;
@property (nonatomic, retain) PopupView *onScreenPopup;
@property (nonatomic, weak) NSArray *imagesArrayCarousel;

@property (nonatomic, retain) NSString *campaignTitle;
@property float campaignScaleX;
@property float campaignScaleY;
@property float campaignScaleZ;

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, weak) UIImage *enlargeImage;
@property (nonatomic, retain) IBOutlet UIView *notificationView;
@property (nonatomic, retain) IBOutlet UIImageView *notificationImageView;
@property (nonatomic, retain) IBOutlet UILabel *notificationTitle;
@property (nonatomic, retain) IBOutlet UILabel *notificationDescription;

@property (nonatomic, retain) UIView *contactViewVM;
@property (nonatomic, retain) UILabel *saveContactLblVM;
@property (nonatomic, retain) UIView *eventViewVM;
@property (nonatomic, retain) UILabel *saveEventLblVM;

@property (nonatomic, retain) NSString *selectedCode;
@property (nonatomic, retain) ARReferenceImage *refrenceImage;
@property (nonatomic, retain) NSString *currentScreenName;

@property (nonatomic, retain) NSData *lastDownloadJson;

@property float zOrder;

+(VariableMnr *)sharedInstance;
+(ARWorldTrackingConfiguration *)getConfiguration;
+(SCNScene *)getMainScene;
-(void)showSearchingVisionCodeProgress;
-(void)showDownloadingContentProgress;
-(void)hideProgressView;

-(NSString *)generateKeyFromURL:(NSString *)url;
-(float)getZOrder;
-(void)msgboxWithTitle:(NSString *)title message:(NSString *)message andButton:(NSString *)button;
-(void)hostappMsgboxWithTitle:(NSString *)title message:(NSString *)message andButton:(NSString *)button;
-(void)showTrackingCover;
-(void)hideTrackingCover;
-(void)saveRecentVisionCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle;
-(NSArray *)getRecentVisionCode;
-(void)removeRecentVisionCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle;

-(void)saveFavouriteVisionCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle;
-(NSArray *)getFavouriteVisionCode;

-(BOOL)isFavouriteCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle;
-(void)unFavourite:(NSString *)visionCode withTitle:(NSString *)campaignTitle;

// Send Data to Google for Analytics
-(void)postFlurryEvent:(NSString *)eventName withParameter:(NSMutableDictionary *)param isTimedEvent:(BOOL)timedEvent isCurrentlyStarted:(BOOL)isCurrentlyStarted;

-(void)Google_TrackingScreen:(NSString *)screenName;
-(void)Google_TrackingEventWithCategory:(NSString *)category actionName:(NSString *)action labelJson:(NSString *)json andValue:(NSNumber *)value;
-(NSString*) jsonStringWithPrettyPrint:(NSDictionary *) dict;
-(NSString *)fetchBaseURL;
-(void)showNotification:(UIImage *)campaignImage withTitle:(NSString *)title andDescription:(NSString *)description;

-(void)showInitialPopupTutorialMarkerBase:(UIView *)view;
-(void)showInitialPopupTutorialMarkerLess:(UIView *)view;
-(void)showNotificationView;
-(void)hideNotificationView;
-(Model3D *)fetchSelectableNode:(SCNNode *)node;
-(SCNNode *)rotatedNodeWithVector:(SCNVector3)vector andNode:(SCNNode *)node;
@end
