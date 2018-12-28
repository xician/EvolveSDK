//
//  Button.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "ButtonNode.h"
#import "NodeAction.h"
#import "Transform.h"
#import "Appearance.h"

@interface ButtonManager : NSObject
@property (nonatomic, retain) NSMutableArray *buttons;
+(ButtonManager *)sharedInstance;
-(ButtonNode *)generateNewButtonWithTransform:(Transform *)buttonTransform appearance:(Appearance *)buttonAppearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;

@end
