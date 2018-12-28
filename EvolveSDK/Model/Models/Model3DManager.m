//
//  Model3DManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 02/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "Model3DManager.h"

@implementation Model3DManager
static Model3DManager *modelManager;

// Static mathod to get the shared instance of Button Node Class.
+(Model3DManager *)sharedInstance{
    if(modelManager != NULL){
        return modelManager;
    }else{
        modelManager = [[Model3DManager alloc] init];
        modelManager.Model3Ds = [[NSMutableArray alloc] init];
        
        return modelManager;
    }
}

-(Model3D *)generateNewModelWithTransform:(Transform *)videoTransform appearance:(Appearance *)videoAppearance action:(NodeAction *)action andTransition:(NSMutableArray *)transitions{
    Model3D *model;
        model = [[Model3D alloc] init];
    [model setTransf:videoTransform];
    [model setAppearance:videoAppearance];
    [model setAction:action];
    [model setTransitions:transitions];
    return [model generateNode];
    
}

@end
