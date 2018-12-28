//
//  DownloadManager.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 12/07/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VariableMnr.h"

@protocol DownloadMngrDelegate <NSObject>   //define delegate protocol

-(void)allContentsDownloadComplete;
-(void)scanningStart;

@end //end protocol

@interface DownloadMngrr : NSObject <NSURLSessionDelegate>

@property (nonatomic, retain) id<DownloadMngrDelegate> DownloadMngrDelegate;
+(DownloadMngrr *)getInstance;
-(UIImage *)getImageWithKey:(NSString *)key;

-(void)storeImage:(UIImage *)image forKey:(NSString *)key;
-(void)downloadImageFromURL:(NSString *)url;

-(void)downloadJSONContent:(NSString *)url;
-(void)downloadJSONContentForMarkerLess:(NSString *)url;

-(void)downloadImagesFromArrayOfURL:(NSArray *)urlArray;
-(void)invalidateDownload;

@end
