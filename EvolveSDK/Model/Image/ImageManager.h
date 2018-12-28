//
//  ImageManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageNode.h"

@interface ImageManager : NSObject
@property (nonatomic, retain) NSMutableArray *images;

+(ImageManager *)sharedInstance;
-(ImageNode *)generateNewImageWithTransform:(Transform *)imageTransform appearance:(Appearance *)imageAppearance action:(NodeAction *)action andTransitions:(NSMutableArray *)transitions;

@end
