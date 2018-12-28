//
//  SceneManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneNode.h"

@interface SceneManager : NSObject

+(SceneManager *)sharedInstance;
-(SceneNode *)generateNewScene;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+(UIImage *)imageResize :(UIImage*)img;
-(void)cleanNodes:(SceneNode *)scnNd;
@end
