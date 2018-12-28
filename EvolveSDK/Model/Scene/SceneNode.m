//
//  SceneNode.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SceneNode.h"

@implementation SceneNode

-(void)addNewButton:(SCNNode *)button{
    [self.buttons addObject:button];
}
-(void)addNewImage:(ImageNode *)image{
    [self.images addObject:image];
}
-(void)addNewVideo:(VideoNode *)video{
    [self.videos addObject:video];
}
-(void)addNewModel:(Model3D *)model3D{
    [self.models addObject:model3D];
}
-(void)addNewContact:(ContactNode *)contact{
    [self.contacts addObject:contact];
}
-(void)addNewEvent:(EventNode *)event{
    [self.events addObject:event];
}
-(void)addNewSound:(SoundNode *)sound{
    [self.sounds addObject:sound];
}



@end
