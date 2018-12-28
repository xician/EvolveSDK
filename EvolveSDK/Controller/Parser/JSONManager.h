//
//  JSONManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneManager.h"
#import "ButtonManager.h"
#import "VideoManager.h"
#import "EventManager.h"
#import "ContactManager.h"
#import "SoundManager.h"
#import "ImageManager.h"

#import "NodeAction.h"
#import "NodeTransition.h"
#import <AVFoundation/AVFoundation.h>
#import "Model3DManager.h"

@protocol JSONManagerDelegate <NSObject>   //define delegate protocol
-(void)openViewController:(UIViewController *)vc;
-(void)pushonViewController:(UIViewController *)vc;
-(void)dismissViewController;
-(void)resetSceneCanvas;
@end //end protocol

@interface JSONManager : NSObject <NodeActionDelegate>
@property (nonatomic, retain) SCNNode *mainCanvasNode;
@property (nonatomic, retain) NSMutableArray *scenes;
@property (nonatomic, retain) id<JSONManagerDelegate> jsonManagerDelegate;

@property (nonatomic, retain) NSString *markerImageURL;
+(JSONManager *)sharedInstance;
+(void)clearAllValues;
-(void)createScenesFromJSON:(NSData *)jsonData;
-(SceneNode *)fetchCurrentScene;
-(void)actionTriggerForButtonNode:(ButtonNode *)node;
-(void)actionTriggerForImageNode:(ImageNode *)node;
-(void)actionTriggerForContactNode:(ContactNode *)node;
-(void)actionTriggerForEventNode:(EventNode *)node;
-(void)actionOnNode:(VideoNode *)node;
-(void)actionTriggerForModel:(Model3D *)node;
-(void)actionOnSoundNode:(SoundNode *)node;
-(BOOL)isPinchTargetAvailablForModel:(Model3D *)node;
-(void)showPopup;
-(void)stopAllMedias;
-(void)setMarkerFromImageURL:(NSString *)urlString;
@end
