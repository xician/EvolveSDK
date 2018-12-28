//
//  DownloadManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 12/07/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "DownloadMngrr.h"

@implementation DownloadMngrr

    static DownloadMngrr *downloadManger;
    NSMutableDictionary *downloadedImages;
    JSONManager *jsonManager;
    SLAMJSONManager *slamJsonManager;

    NSString *markerURL;
    NSArray *imageArray;
    NSURLSession *defaultSession;
    
+(DownloadMngrr *)getInstance{
    if(downloadManger != NULL){
        return downloadManger;
    }else{
        downloadManger = [[DownloadMngrr alloc] init];
        downloadedImages = [[NSMutableDictionary alloc] init];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
        return downloadManger;
        
    }
}
-(void)invalidateDownload{
    [defaultSession invalidateAndCancel];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];

}

-(UIImage *)getImageWithKey:(NSString *)key{
    return [downloadedImages objectForKey:key];
}

-(void)storeImage:(UIImage *)image forKey:(NSString *)key{
    if(image != nil){
        [downloadedImages setObject:image forKey:key];
    }
}

-(void)downloadImageFromURL:(NSString *)url{
    if(url.length == 0){
            [self storeImage:[UIImage imageNamed:@"applicationPlaceHolder"] forKey:[[VariableMnr sharedInstance] generateKeyFromURL:url]];
            if([url isEqualToString:markerURL]){
                
                UIImage *thumbnailMarker = [SceneManager imageResize:[UIImage imageNamed:@"applicationPlaceHolder"]];
                [[[VariableMnr sharedInstance] notificationImageView] setImage:thumbnailMarker];
                NSData *pngImageData = UIImagePNGRepresentation(thumbnailMarker);
                [[NSUserDefaults standardUserDefaults] setObject:pngImageData forKey:[NSString stringWithFormat:@"%@imgthumbnail",[[VariableMnr sharedInstance] scannedCode]]];
                
                [[VariableMnr sharedInstance] saveRecentVisionCode:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]] withTitle:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]];
                [[[VariableMnr sharedInstance] notificationTitle] setText:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]];
                
                [[[VariableMnr sharedInstance] notificationDescription] setText:@"Vision Code Invalid/Not Found."];
                
            }
            [self downloadComplete];
    }else{
    
    NSURLSessionDownloadTask *downloadPhotoTask = [defaultSession
                                                   downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       if(error){
                                                           [[VariableMnr sharedInstance] msgboxWithTitle:@"Connection lost" message:@"Please check your internet connection and retry." andButton:@"Ok"];
                                                           
                                                       }else{
                                                           NSLog(@"done");
                                                           if(response != nil){
                                                               [self storeImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:location]] forKey:[[VariableMnr sharedInstance] generateKeyFromURL:url]];
                                                               if([url isEqualToString:markerURL]){
                                                               
                                                                   UIImage *thumbnailMarker = [SceneManager imageResize:[UIImage imageWithData:[NSData dataWithContentsOfURL:location]]];
                                                                   [[[VariableMnr sharedInstance] notificationImageView] setImage:thumbnailMarker];
                                                                   NSData *pngImageData = UIImagePNGRepresentation(thumbnailMarker);
                                                                   [[NSUserDefaults standardUserDefaults] setObject:pngImageData forKey:[NSString stringWithFormat:@"%@imgthumbnail",[[VariableMnr sharedInstance] scannedCode]]];
                                                               
                                                                   [[VariableMnr sharedInstance] saveRecentVisionCode:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]] withTitle:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]];
                                                                   [[[VariableMnr sharedInstance] notificationTitle] setText:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]];
                                                                   [[[VariableMnr sharedInstance] notificationDescription] setText:@"Please find Tracker Image."];


                                                               }
                                                               
                                                               [self downloadComplete];
                                                           }
                                                       }
                                                   }];
    
        [downloadPhotoTask resume];
    }
    
}

- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

-(void)downloadImagesFromArrayOfURL:(NSArray *)urlArray{
    
    imageArray = urlArray;
    [self downloadingImages:0];

}

-(void)downloadingImages:(int)index{
    if([imageArray count] <= index){
        
        [[VariableMnr sharedInstance] hideProgressView];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:EVENT_CAMPAIGNDOWNLOADED forKey:EVENT_ACTION_TYPE];
        
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, @"", json, 0);
        
        [self.DownloadMngrDelegate allContentsDownloadComplete];

    }else{
        NSString *string = [NSString stringWithFormat:@"%@",[imageArray objectAtIndex:index]];
        
        NSURLSessionDownloadTask *downloadPhotoTask = [defaultSession
                                                   downloadTaskWithURL:[NSURL URLWithString:string] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       if(error){
                                                           [[VariableMnr sharedInstance] msgboxWithTitle:@"Connection lost" message:@"Please check your internet connection and retry." andButton:@"Ok"];
                                                       }else{
                                                       NSLog(@"done");
                                                       [self storeImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:location]] forKey:[[VariableMnr sharedInstance] generateKeyFromURL:[imageArray objectAtIndex:index]]];
                                                       [self downloadingImages:(index+1)];
                                                       }
                                                   }];
        
        [downloadPhotoTask resume];
        
    }

}

-(void)downloadJSONContent:(NSString *)url{
        jsonManager = [[VariableMnr sharedInstance] jsonManager];
    NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
    if([defaultJSON length] > 2){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:defaultJSON ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self jsonDownloadCompleteWithData:data];
        return;
    }else if([url containsString:@"21000622"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"21000622" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self jsonDownloadCompleteWithData:data];
        return;
    }else if([url containsString:@"21000589"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"21000589" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self jsonDownloadCompleteWithData:data];
        return;
    }else if([url containsString:@"21000613"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"21000613" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self jsonDownloadCompleteWithData:data];
        return;
    }else if([url containsString:@"23000615"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"23000615" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self jsonDownloadCompleteWithData:data];
        return;
    }else if([url containsString:@"23000010"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"23000010" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self jsonDownloadCompleteWithData:data];
        return;
    }else{
        NSURLSessionDownloadTask *downloadPhotoTask = [defaultSession downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if(error){
                [[VariableMnr sharedInstance] msgboxWithTitle:@"Connection lost" message:@"Please check your internet connection and retry." andButton:@"Ok"];
                
            }else{
                NSLog(@"done");
                
                [self jsonDownloadCompleteWithData:[NSData dataWithContentsOfURL:location]];
            }
        }];
        [downloadPhotoTask resume];
    }
    
}

-(void)downloadJSONContentForMarkerLess:(NSString *)url{
    slamJsonManager = [[VariableMnr sharedInstance] slamJsonManager];
    NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultSLAMJSONName"]];
    if([defaultJSON length] > 2){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:defaultJSON ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self slamJsonDownloadCompleteWithData:data];
        return;
    }else if([url containsString:@"13000011"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"13000011" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self slamJsonDownloadCompleteWithData:data];
        return;
        
    }else{

        NSURLSessionDownloadTask *downloadPhotoTask = [defaultSession downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if(error){
                
                [[VariableMnr sharedInstance] msgboxWithTitle:@"Connection lost" message:@"Please check your internet connection and retry." andButton:@"Ok"];
                
            }else{
                
                NSLog(@"done");
                [[[NSThread alloc] initWithTarget:self selector:@selector(slamJsonDownloadCompleteWithData:) object:[NSData dataWithContentsOfURL:location]] start];
                
                
            }
        }];
        
        [downloadPhotoTask resume];
    }
    
}
-(void)downloadComplete{
    
    UIImage *markerImage = [[DownloadMngrr getInstance] getImageWithKey:[[VariableMnr sharedInstance] generateKeyFromURL:markerURL]];
    
    ARReferenceImage *refImage = [[ARReferenceImage alloc] initWithCGImage:[markerImage CGImage] orientation:kCGImagePropertyOrientationUp physicalWidth:0.5];
    [refImage setName:@"hello"];
    

        ARImageTrackingConfiguration *configuration;
        
        configuration = [[ARImageTrackingConfiguration alloc] init];
        NSMutableSet *set = [[NSMutableSet alloc] init];
        [[VariableMnr sharedInstance] setRefrenceImage:refImage];
        [set addObject:refImage];
        [configuration setTrackingImages:set];
        [[VariableMnr sharedInstance] setImageConfiguration:configuration];
    
    [self downloadCarouselImagesAllTogether];
    [self.DownloadMngrDelegate scanningStart];
    
}

-(void)downloadModelContentsAllTogether{
    NSMutableArray *objectArray = [[NSMutableArray alloc] init];

    for (SceneNode *scn in [slamJsonManager scenes]) {
        NSMutableArray *models = scn.models;
        for (Model3D *modelNode in models) {
            [objectArray addObject:[NSString stringWithFormat:@"%@",[modelNode.appearance backgroundImageURL]]];
            
        }
    }
    
    [self downloadImagesFromArrayOfURL:objectArray];
    
}





-(void)downloadCarouselImagesAllTogether{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (SceneNode *scn in [jsonManager scenes]) {
        NSMutableArray *images = scn.images;
        for (ImageNode *imageNode in images) {
            [imageArray addObject:[NSString stringWithFormat:@"%@",[imageNode.appearance backgroundImageURL]]];
            if([[imageNode buttonAction] actionType] == ActionTypeCarousel){
                NSArray *dictImage = [[NSArray alloc] initWithArray:[[[imageNode buttonAction] paramDictionary] objectForKey:CAROUSELIMAGES_JSON_KEY]];
                
                for (NSDictionary *dict in dictImage) {
                    [imageArray addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:CAROUSEL_URLIMAGE_JSON_KEY]]];
                }
            }
        }
    }
    [self downloadImagesFromArrayOfURL:imageArray];
}

-(void)slamJsonDownloadCompleteWithData:(NSData *)jsonData{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        [slamJsonManager createScenesFromJSON:jsonData];
        [self.DownloadMngrDelegate allContentsDownloadComplete];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            
        });
    });
}

-(void)jsonDownloadCompleteWithData:(NSData *)jsonData{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        [[[VariableMnr sharedInstance] notificationImageView] setImage:[[UIImage alloc] init]];
        [[[VariableMnr sharedInstance] notificationTitle] setText:@""];
        [[[VariableMnr sharedInstance] notificationDescription] setText:@""];
        [[VariableMnr sharedInstance] setLastDownloadJson:jsonData];
        
        [jsonManager createScenesFromJSON:jsonData];
        NSString *str = [jsonManager markerImageURL];
        markerURL = str;
        [self downloadImageFromURL:markerURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
        });
    });
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
}
@end
