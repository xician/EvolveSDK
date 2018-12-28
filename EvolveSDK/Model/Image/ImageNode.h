//
//  ImageNode.h
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
#import "NodeTransition.h"
@interface ImageNode : SCNNode
@property CGSize size;
@property (nonatomic) Transform *transf;
@property (nonatomic) Appearance *appearance;
@property (nonatomic) NodeAction *buttonAction;
@property (nonatomic) NSMutableArray *transitions;

-(ImageNode *)generateNode;
-(void)resizeCanvasScene:(CGSize)size;
-(SCNVector3)getWorldPositionForX:(float)posX andY:(float)posY;
-(void)isImageNode;
@end
