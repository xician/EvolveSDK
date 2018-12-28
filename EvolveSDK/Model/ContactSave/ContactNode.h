//
//  ContactNode.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "Transform.h"
#import "Appearance.h"
#import "NodeAction.h"
#import "GlobalConstants.h"
#import <AVFoundation/AVFoundation.h>

@interface ContactNode : SCNNode

@property int nodeInde;
@property (nonatomic) SCNNode *textNode;

@property (nonatomic) ButtonNodeType *buttonActionType;
@property (nonatomic) Transform *transf;
@property (nonatomic) Appearance *appearance;
@property (nonatomic) NodeAction *action;
@property (nonatomic) NSMutableArray *transitions;
@property CGSize size;

-(ContactNode *)generateNode;
-(void)resizeCanvasScene:(CGSize)size;
-(SCNVector3)getWorldPositionForX:(float)posX andY:(float)posY;
-(void)isContactNode;
@end
