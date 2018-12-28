//
//  EventManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "EventNode.h"
#import "NodeAction.h"
#import "Transform.h"
#import "Appearance.h"

@interface EventManager : NSObject
+(EventManager *)sharedInstance;
-(EventNode *)generateNewEventWithTransform:(Transform *)transform appearance:(Appearance *)appearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;

@end
