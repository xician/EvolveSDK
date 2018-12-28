//
//  SoundManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundNode.h"

@interface SoundManager : NSObject
@property (nonatomic, retain) NSMutableArray *sounds;

+(SoundManager *)sharedInstance;
-(SoundNode *)generateNewSoundWithTransform:(Transform *)transform appearance:(Appearance *)appearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;


@end
