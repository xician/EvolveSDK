//
//  ImageManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager
//Button Variable for Singleton Design Pattern.
static ImageManager *img;

// Static mathod to get the shared instance of Button Node Class.
+(ImageManager *)sharedInstance{
    if(img != NULL){
        return img;
    }else{
        img = [[ImageManager alloc] init];
        img.images = [[NSMutableArray alloc] init];
        
        return img;
    }
}

-(ImageNode *)generateNewImageWithTransform:(Transform *)imageTransform appearance:(Appearance *)imageAppearance action:(NodeAction *)action andTransitions:(NSMutableArray *)transitions{
    
    ImageNode *imageNode = [[ImageNode alloc] init];
    [imageNode setTransf:imageTransform];
    [imageNode setAppearance:imageAppearance];
    [imageNode setButtonAction:action];
    [imageNode setTransitions:transitions];
    return [imageNode generateNode];
}

@end
