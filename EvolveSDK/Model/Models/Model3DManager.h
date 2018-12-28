//
//  Model3DManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 02/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model3D.h"
@interface Model3DManager : NSObject
@property (nonatomic, retain) NSMutableArray *Model3Ds;

+(Model3DManager *)sharedInstance;
-(Model3D *)generateNewModelWithTransform:(Transform *)videoTransform appearance:(Appearance *)videoAppearance action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;

@end
