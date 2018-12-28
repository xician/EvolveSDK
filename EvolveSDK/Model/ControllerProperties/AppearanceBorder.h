//
//  AppearanceBorder.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 27/07/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appearance.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

typedef enum
{
    BorderOnButton = 1,
    BorderOnVideo,
    BorderOnImage,
    BorderOnText,
    BorderOnSound,
    BorderOnContact,
    BorderOnEvent
    
} BorderOn;

@interface AppearanceBorder : NSObject
@property BorderOn borderOn;
+(AppearanceBorder *)sharedInstance;
-(void)applyBorderWithBorderType:(BorderType)borderType ofColor:(UIColor *)borderColor depth:(float)borderDepth andNode:(SCNNode *)node withNodeWidth:(float)nodeWidth borderOn:(BorderOn)parent andNodeHeight:(float)nodeHeight;

@end
