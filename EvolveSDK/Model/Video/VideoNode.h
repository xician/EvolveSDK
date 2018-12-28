//
//  VideoNode.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import "Transform.h"
#import "Appearance.h"
#import "NodeAction.h"
#import "GlobalConstants.h"

@interface VideoNode : SCNNode 

@property (nonatomic) Transform *transf;
@property (nonatomic) Appearance *appearance;
@property (nonatomic) NodeAction *action;
@property (nonatomic) NSMutableArray *transitions;
@property BOOL isPlaying;
@property BOOL isPaused;

@property CGSize size;

@property (nonatomic) SKVideoNode *videoNode;
@property (nonatomic) AVPlayer *avPlayer;
-(VideoNode *)generateNode;
-(void)resizeCanvasScene:(CGSize)size;
-(SCNVector3)getWorldPositionForX:(float)posX andY:(float)posY;
-(void)playVideo;
-(void)videoTapped;
-(void)isVideoNode;
-(void)stopCurrentPlaying;
@end
