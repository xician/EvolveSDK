//
//  Model3D.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 02/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import "Transform.h"
#import "Appearance.h"
#import "NodeAction.h"
#import "GlobalConstants.h"
#import <GLTFSceneKit/GLTFSceneKit-Swift.h>

@interface Model3D : SCNNode
@property (nonatomic) SCNNode *modelNode;
@property (nonatomic) Transform *transf;
@property (nonatomic) Appearance *appearance;
@property (nonatomic) NodeAction *action;
@property (nonatomic) NSMutableArray *transitions;
@property (nonatomic) SCNScene *model;

@property BOOL isPlaced;
-(Model3D *)generateNode;
-(void)placeModelOnGround:(SCNVector3)position withSize:(CGSize)size;
-(void)placeSelectionNode;
-(void)isModel3D;
-(void)setModelRotationX:(SCNVector3)vector;
-(void)setModelRotationY:(SCNVector3)vector;
-(void)setModelRotationZ:(SCNVector3)vector;

@end
