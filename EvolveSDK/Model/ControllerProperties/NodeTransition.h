//
//  NodeTransition.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>
#import "GlobalConstants.h"
#import <SceneKit/SceneKit.h>
typedef enum
{
    FadeIn = 1,
    SlideInFromLeft,
    SlideInFromRight,
    SlideInFromTop,
    SlideInFromBottom,
    ScaleUpWithFade,
    ScaleDownWithFade,
    FadeOut,
    SlideOutToLeft,
    SlideOutToRight,
    SlideOutToTop,
    SlideOutToBottom
} TransitionType;

@interface NodeTransition : NSObject

@property float length;
@property float delay;
@property bool isAlreadyInQ;
@property TransitionType transitionType;

-(void)executeTransitionForNode:(SCNNode *)node;

@end
