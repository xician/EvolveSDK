//
//  VideoManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "VideoManager.h"

@implementation VideoManager
//Button Variable for Singleton Design Pattern.
static VideoManager *vdo;

// Static mathod to get the shared instance of Button Node Class.
+(VideoManager *)sharedInstance{
    if(vdo != NULL){
        return vdo;
    }else{
        vdo = [[VideoManager alloc] init];
        vdo.videos = [[NSMutableArray alloc] init];
        
        return vdo;
    }
}

-(VideoNode *)generateNewVideoWithTransform:(Transform *)videoTransform appearance:(Appearance *)videoAppearance action:(NodeAction *)action andTransition:(NSMutableArray *)transitions{
    
    VideoNode *videoNode = [[VideoNode alloc] init];
    [videoNode setTransf:videoTransform];
    [videoNode setAppearance:videoAppearance];
    [videoNode setAction:action];
    [videoNode setTransitions:transitions];
    return [videoNode generateNode];
}

@end
