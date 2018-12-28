//
//  VideoManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoNode.h"

@interface VideoManager : NSObject
@property (nonatomic, retain) NSMutableArray *videos;

+(VideoManager *)sharedInstance;
-(VideoNode *)generateNewVideoWithTransform:(Transform *)videoTransform appearance:(Appearance *)videoAppearance action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;

@end
