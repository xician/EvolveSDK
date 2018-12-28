//
//  Appearance.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
#import <GLTFSceneKit/GLTFSceneKit-Swift.h>

typedef enum
{
    BavelBorderType = 1,
    SquareBorderType,
    RoundedBorderType,
    RoundedRaisedBorderType,
    SquareIndentedType,
    PolariodType,
    SquareRaised,
    
} BorderType;

@interface Appearance : NSObject

@property UIImage *thumbnail;
@property (nonatomic, retain) GLTFSceneSource *gSceneSource;

@property (nonatomic, retain) NSString *title;
@property UIColor *backgroundColor;
@property UIImage *backgroundImage;
@property NSString *backgroundImageURL;
@property NSString *thumbnailImage;
@property UIColor *textColor;

@property NSString *videoURL;
@property NSString *audioURL;
@property NSString *rotationY;
@property NSString *rotationX;
@property NSString *rotationZ;

@property BOOL isBorderEnabled;
@property UIColor *borderColor;
@property BorderType borderType;
@property float borderDepth;

@property BOOL isLoopVideo;
@property BOOL isPlayOnStart;


@end
