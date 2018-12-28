//
//  Transform.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transform : NSObject

@property float posX;
@property float posY;
@property float posZ;

@property float posXOriginal;
@property float posYOriginal;
@property float posZOriginal;

@property float scaleX;
@property float scaleY;
@property float scaleZ;

@property float scaleXOriginal;
@property float scaleYOriginal;
@property float scaleZOriginal;

@property float rotationX;
@property float rotationY;
@property float rotationZ;

@end
