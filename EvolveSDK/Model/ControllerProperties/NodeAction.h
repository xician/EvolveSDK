//
//  NodeAction.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>
#import "GlobalConstants.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

typedef enum
{
    ActionTypeCall = 1,
    ActionTypeURL,
    ActionTypeWhatsApp,
    ActionTypeViberApp,
    ActionTypeFBMessengerApp,
    ActionTypeEmail,
    ActionTypeSaveContact,
    ActionTypeGoToScene,
    ActionTypeReplayVideo,
    ActionTypePlayAudio,
    ActionTypeEnlargeImage,
    ActionTypeCarousel,
    ActionTypeSaveEvent,
    ActionTypeHostMessage,
    ActionType360Video,
    ActionDescriptionBox,
    ActionScalling
    
} ActionType;

typedef enum
{
    TriggerTypeTap = 1,
    TriggerTypeOnVideoFinish,
    TriggerTypeOnSoundFinish,
    TriggerTypePinch
} TriggerType;

typedef enum
{
    Button = 1,
    Image,
    Video,
    Text,
    Sound,
    SaveContact,
    SaveEvent,
    Carousal,
    Model,
    
} AssetType;

@protocol NodeActionDelegate <NSObject>   //define delegate protocol
-(void)openViewController:(UIViewController *)vc;
-(void)pushonViewController:(UIViewController *)vc;
-(void)dismissViewController;
-(void)goToSceneNumber:(int)sceneIndex;
@end //end protocol

@interface NodeAction : NSObject <EKEventEditViewDelegate>
@property ActionType actionType;
@property TriggerType triggerType;
@property AssetType assetType;

@property (nonatomic, retain) NSString *objectUUID;
@property (nonatomic, retain) NSString *paramValue;
@property BOOL isActionApplied;
@property (nonatomic, retain) NSDictionary *paramDictionary;
@property (nonatomic, retain) NSDictionary *descriptionBoxDict;

@property UIImage *imageToBeEnlarge;
@property (nonatomic, retain) id<NodeActionDelegate> nodeActionDelegate;

-(void)triggerDescriptionBoxAction:(NSDictionary *)actionDict;

-(void)callPhoneNumber;
-(void)openURL;
-(void)sendEmail;
-(void)loadWhatsApp;
-(void)loadViberApp;
-(void)loadFBMessenger;
-(void)saveContact;
-(void)goToScene;
-(void)enlargeImage;
-(void)showCarousal;
-(void)saveEvent;
-(void)load360Video;
-(void)showHostMessage;
-(void)showDescriptionBox;

@end
