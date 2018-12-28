//
//  Model3D.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 02/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "Model3D.h"
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
//#import "GLTFSceneKitLoader-Swift.h"
#import "VariableMnr.h"

@implementation Model3D{
    BOOL noteViewedYet;
    SCNNode *nodeForRotateX;
    SCNNode *nodeForRotateY;
    SCNNode *nodeForRotateZ;
}

-(Model3D *)generateNode{
    noteViewedYet = true;
    [self setIsPlaced:false];
    self.modelNode = [[SCNNode alloc] init];
    
    [self setPosition:SCNVector3Make([self.transf posX], [self.transf posZ], [self.transf posY])];
    float scale = [self.transf scaleX];
    scale = (scale < [self.transf scaleY])?[self.transf scaleY]:scale;
    scale = (scale < [self.transf scaleZ])?[self.transf scaleZ]:scale;
    [self setScale:SCNVector3Make(scale,scale,scale)];
    [self setEulerAngles:SCNVector3Make(0,0,0)];
    
//    [self.modelNode setEulerAngles:SCNVector3Make((([self.transf rotationX] + 4.7124) * (-1)), [self.transf rotationY], [self.transf rotationZ])];
    [self.modelNode setEulerAngles:SCNVector3Make(0,[self.transf rotationZ],0)];

    [self addChildNode:self.modelNode];
    
    return self;
    
}

-(void)setModelRotationX:(SCNVector3)vector{
    [self.modelNode setEulerAngles:vector];
}
-(void)setModelRotationY:(SCNVector3)vector{
    [self.modelNode setEulerAngles:vector];
}
-(void)setModelRotationZ:(SCNVector3)vector{
    [self.modelNode setEulerAngles:vector];
}

-(void)placeSelectionNode{
    
}



-(void)placeModelOnGround:(SCNVector3)position withSize:(CGSize)size{
    
    GLTFSceneSource *gSceneSource = [self.appearance gSceneSource];
    
    self.model = [gSceneSource sceneWithOptions:nil error:nil];
    gSceneSource = nil;
    
    [self.modelNode addChildNode:[self.model rootNode]];
    [self.modelNode setCastsShadow:true];
    
    
    float calculatedX = position.x * (size.width/2);
    float calculatedY = position.y * (size.height/2);
    
    [self setPosition:SCNVector3Make(calculatedX, position.z*(-0.03), calculatedY*(-1))];
    
    if(noteViewedYet){
        noteViewedYet = false;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
        [param setObject:NODE_TYPE_Model forKey:EVENT_ASSET_TYPE];
        [param setObject:EVENT_ASSET_VIEW forKey:EVENT_ACTION_TYPE];
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);
    }

}

-(void)isModel3D{
    
}
@end
