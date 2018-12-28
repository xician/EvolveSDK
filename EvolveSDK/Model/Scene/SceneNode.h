//
//  SceneNode.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonNode.h"
#import "ImageNode.h"
#import "VideoNode.h"
#import "Model3D.h"
#import "SoundNode.h"
#import "ContactNode.h"
#import "EventNode.h"
@interface SceneNode : NSObject

@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *videos;
@property (nonatomic, retain) NSMutableArray *models;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSMutableArray *events;
@property (nonatomic, retain) NSMutableArray *sounds;
@property BOOL isScenePulled;

-(void)addNewButton:(ButtonNode *)button;
-(void)addNewImage:(ImageNode *)image;
-(void)addNewVideo:(VideoNode *)video;
-(void)addNewModel:(Model3D *)model3D;
-(void)addNewContact:(ContactNode *)contact;
-(void)addNewEvent:(EventNode *)event;
-(void)addNewSound:(SoundNode *)sound;

@end
