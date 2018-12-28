//
//  SoundManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager
//Button Variable for Singleton Design Pattern.
static SoundManager *sound;

// Static mathod to get the shared instance of Button Node Class.
+(SoundManager *)sharedInstance{
    if(sound != NULL){
        return sound;
    }else{
        sound = [[SoundManager alloc] init];
        sound.sounds = [[NSMutableArray alloc] init];
        
        return sound;
    }
}

-(SoundNode *)generateNewSoundWithTransform:(Transform *)transform appearance:(Appearance *)appearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions{
    
    SoundNode *sound = [[SoundNode alloc] init];
    [sound setTransf:transform];
    [sound setAppearance:appearance];
    [sound setAction:action];
    [sound setTransitions:transitions];
    return [sound generateNode];
}

@end
