//
//  SoundNode.h
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

@interface SoundNode : SCNNode
@property CGSize size;

@property (nonatomic) Transform *transf;
@property (nonatomic) Appearance *appearance;
@property (nonatomic) NodeAction *action;
@property (nonatomic) NSMutableArray *transitions;
@property (nonatomic) SCNAudioPlayer *soundNode;
@property (nonatomic) AVPlayer *avPlayer;
-(SoundNode *)generateNode;
-(void)playSound;
-(void)resizeCanvasScene:(CGSize)size;
-(void)isSoundNode;
@end
