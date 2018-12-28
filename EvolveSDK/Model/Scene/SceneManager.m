//
//  SceneManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SceneManager.h"

@implementation SceneManager

//Scene Variable for Singleton Design Pattern.
static SceneManager *scnM;

// Static mathod to get the shared instance of Scene Node Class.
+(SceneManager *)sharedInstance{
    
    if(scnM != NULL){
        return scnM;
        
    }else{
        scnM = [[SceneManager alloc] init];
        return scnM;
        
    }
}
-(void)cleanNodes:(SceneNode *)scnNd{
    
    [scnNd.buttons removeAllObjects];
    [scnNd.images removeAllObjects];
    [scnNd.videos removeAllObjects];
    [scnNd.models removeAllObjects];
    [scnNd.contacts removeAllObjects];
    [scnNd.events removeAllObjects];
    [scnNd.sounds removeAllObjects];
    scnNd.buttons = nil;
    scnNd.images = nil;
    scnNd.videos = nil;
    scnNd.models = nil;
    scnNd.contacts = nil;
    scnNd.events = nil;
    scnNd.sounds = nil;
    scnNd = nil;
    
}

-(SceneNode *)generateNewScene{
    
    SceneNode *sceneNode = [[SceneNode alloc] init];
    sceneNode.buttons = [[NSMutableArray alloc] init];
    sceneNode.images = [[NSMutableArray alloc] init];
    sceneNode.videos = [[NSMutableArray alloc] init];
    sceneNode.models = [[NSMutableArray alloc] init];
    sceneNode.contacts = [[NSMutableArray alloc] init];
    sceneNode.events = [[NSMutableArray alloc] init];
    sceneNode.sounds = [[NSMutableArray alloc] init];
    [sceneNode setIsScenePulled:false];
    return sceneNode;
    
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if(hexString.length <= 0){
        return nil;
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(UIImage *)imageResize :(UIImage*)img
{
    
    CGFloat scale = [[UIScreen mainScreen]scale];
    if(img.size.width > img.size.height){
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200,(img.size.height/img.size.width)*200), NO, scale);
        [img drawInRect:CGRectMake(0,0,200,(img.size.height/img.size.width)*200)];

    }else{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200,(img.size.width/img.size.height)*200), NO, scale);
        [img drawInRect:CGRectMake(0,0,200,(img.size.height/img.size.width)*200)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end
