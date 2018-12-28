//
//  VariableManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/07/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "VariableMnr.h"
#import "Appearance.h"
@implementation VariableMnr
NSThread *animationProgressThread;
static VariableMnr *variableMngr;
static ARWorldTrackingConfiguration *configuration;
static SCNScene *mainScene;

    BOOL animating;
// Static mathod to get the shared instance of Button Node Class.
+(VariableMnr *)sharedInstance{
    if(variableMngr != NULL){
        return variableMngr;
    }else{
        variableMngr = [[VariableMnr alloc] init];
        animationProgressThread = [[NSThread alloc] init];
        return variableMngr;
    }
}

+(ARWorldTrackingConfiguration *)getConfiguration{
    if(configuration != NULL){
        return configuration;
    }else{
        configuration = [ARWorldTrackingConfiguration new];
        
        return configuration;
    }
}
+(SCNScene *)getMainScene{
    if(mainScene != NULL){
        return mainScene;
    }else{
        mainScene = [SCNScene new];
        
        return mainScene;
    }
}
-(void)showSearchingVisionCodeProgress{
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            animating = false;
            [self.downloadContentPorgressView setHidden:true];
            [self.searchingVisionCodeProgressView setHidden:false];

        });
    });

}

-(void)showTrackingCover{
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.trackingCoverView setHidden:false];
            
        });
    });
    
}
-(void)hideTrackingCover{
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.trackingCoverView setHidden:true];
            
        });
    });
    
}
    -(void)animationProgressView{
        [UIView animateWithDuration:0.25 animations:^{
            [self.progressViewBar setValue:0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:^{
                [self.progressViewBar setValue:100];
            } completion:^(BOOL finished) {
                if(animating){
                    [self performSelector:@selector(animationProgressView) withObject:nil afterDelay:0.1];
//                    [self performSelectorOnMainThread:@selector(animationProgressView) withObject:nil waitUntilDone:false];
                }
            }];
        }];

    }
    
    -(void)animationRotationProgressView{
        [self.progressViewBar setProgressRotationAngle:90];

        [UIView animateWithDuration:2.0 animations:^{
            
        } completion:^(BOOL finished) {
            if(animating){
                [self.progressViewBar setProgressRotationAngle:0];
                [self performSelectorOnMainThread:@selector(animationRotationProgressView) withObject:nil waitUntilDone:false];
            }
        }];
    }
    
-(void)showDownloadingContentProgress{
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI

            [self.downloadContentPorgressView setHidden:false];
            [self.searchingVisionCodeProgressView setHidden:true];
            animating = true;
//            [self animationProgressView];
            [self performSelector:@selector(animationProgressView) withObject:nil afterDelay:0.1];

//            [self performSelectorOnMainThread:@selector(animationProgressView) withObject:nil waitUntilDone:false];
            
            
        });
    });

}

-(void)hideProgressView{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            [self.downloadContentPorgressView setHidden:true];
            [self.searchingVisionCodeProgressView setHidden:true];
            animating = false;

        });
    });

}
    
-(NSString *)generateKeyFromURL:(NSString *)url{
    NSString *str = [[[url stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    str = [NSString stringWithFormat:@"ss%@",str];
    
    return str;
    
}

-(void)msgboxWithTitle:(NSString *)title message:(NSString *)message andButton:(NSString *)button{ UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert]; UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    [alert dismissViewControllerAnimated:true completion:^{
    }];
    
    }];
    
}

-(void)hostappMsgboxWithTitle:(NSString *)title message:(NSString *)message andButton:(NSString *)button{ UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert]; UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    [alert dismissViewControllerAnimated:true completion:nil];
}];
    
    
}

    
-(float)getZOrder{
    self.zOrder = self.zOrder + 0.001;
    return self.zOrder;
}

    


-(void)saveRecentVisionCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:RECENTVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
        
    }
    NSString *strin = [NSString stringWithFormat:@"{\"campaignId\":\"%@\",\"campaignTitle\":\"%@\"}",visionCode,campaignTitle];

    int cnt = (int)[arr count];

    if(cnt >= 50){
        for(int i=49;i<cnt;i++){
            if(![self isFavouriteCode:visionCode withTitle:campaignTitle]){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@imgthumbnail",visionCode]];
            }
            [arr removeObjectAtIndex:i];
        }
    }
    [arr removeObject:strin];
    [arr insertObject:strin atIndex:0];
    
//    [arr addObject:strin];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:RECENTVISION_CODES_KEYS];
    
}

-(void)removeRecentVisionCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:RECENTVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
        
    }
    NSString *strin = [NSString stringWithFormat:@"{\"campaignId\":\"%@\",\"campaignTitle\":\"%@\"}",visionCode,campaignTitle];
    
    [arr removeObject:strin];
    
    if(![self isFavouriteCode:visionCode withTitle:campaignTitle]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@imgthumbnail",visionCode]];
    }
    
    //    [arr addObject:strin];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:RECENTVISION_CODES_KEYS];
    
}

-(NSArray *)getRecentVisionCode{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:RECENTVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
        
    }
    return arr;
}

-(void)saveFavouriteVisionCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle{
    if([[NSString stringWithFormat:@"%@",visionCode] length] <= 0 ||
       [[NSString stringWithFormat:@"%@",campaignTitle] length] <= 0){
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:FAVOURITEVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
        
    }
    NSString *strin = [NSString stringWithFormat:@"{\"campaignId\":\"%@\",\"campaignTitle\":\"%@\"}",visionCode,campaignTitle];
    
    int cnt = (int)[arr count];
    
    if(cnt >= 50){
        for(int i=49;i<cnt;i++){
            [arr removeObjectAtIndex:i];
        }
    }
    [arr removeObject:strin];
    [arr insertObject:strin atIndex:0];
    
    //    [arr addObject:strin];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:FAVOURITEVISION_CODES_KEYS];
}
-(NSArray *)getFavouriteVisionCode{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:FAVOURITEVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
        
    }
    return arr;

}
-(BOOL)isFavouriteCode:(NSString *)visionCode withTitle:(NSString *)campaignTitle{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:FAVOURITEVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
    }
    
    NSString *strin = [NSString stringWithFormat:@"{\"campaignId\":\"%@\",\"campaignTitle\":\"%@\"}",visionCode,campaignTitle];
    return [arr containsObject:strin];
}

-(void)unFavourite:(NSString *)visionCode withTitle:(NSString *)campaignTitle{
    if([[NSString stringWithFormat:@"%@",visionCode] length] <= 0 ||
       [[NSString stringWithFormat:@"%@",campaignTitle] length] <= 0){
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:FAVOURITEVISION_CODES_KEYS]];
    if(arr == nil){
        arr = [[NSMutableArray alloc] init];
    }
    
    NSString *strin = [NSString stringWithFormat:@"{\"campaignId\":\"%@\",\"campaignTitle\":\"%@\"}",visionCode,campaignTitle];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@imgthumbnail",visionCode]];

    [arr removeObject:strin];
    
    //    [arr addObject:strin];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:FAVOURITEVISION_CODES_KEYS];
    
    
}


-(void)showNotificationView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [self.notificationView setAlpha:1];
        }];


    });
    
}
-(void)hideNotificationView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [self.notificationView setAlpha:0];
        }];
        

    });
    
}

-(NSString*) jsonStringWithPrettyPrint:(NSDictionary *) dict {
    NSError *error;
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSString *string = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:UUID_JSON_KEY]];
    
    [mutDict setObject:string forKey:EVENT_DEVICEID];
    [mutDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:EVENT_LANGUAGE]] forKey:EVENT_LANGUAGE];
    [mutDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:EVENT_LATITUDE]] forKey:EVENT_LATITUDE];
    [mutDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:EVENT_LONGITUDE]] forKey:EVENT_LONGITUDE];
    [mutDict setObject:@"" forKey:EVENT_GENDER];
    [mutDict setObject:@"" forKey:EVENT_BIRTHYEAR];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutDict
                                                       options:NSJSONWritingSortedKeys
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"%s: error: %@", __func__, error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
}

-(void)showNotification:(UIImage *)campaignImage withTitle:(NSString *)title andDescription:(NSString *)description{
    [self.notificationImageView setImage:campaignImage];
    [self.notificationTitle setText:title];
    [self.notificationDescription setText:description];
    
}

-(NSString *)fetchBaseURL{
    
    return @"https://beta.evolvear.io/evolve-invo/evolve_invoapp/api/%@/aaaaaa/";
//    return @"http://manulife.evolvear.io/manulife-ar/api/%@/aaaaaa/";
    
}
-(void)showInitialPopupTutorialMarkerBase:(UIView *)view{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200,200)];
            
            [containingView.layer setCornerRadius:8];
            [containingView setClipsToBounds:true];
            
            UILabel *lblBG = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  containingView.frame.size.width,  containingView.frame.size.height)];
            [lblBG setBackgroundColor:[SceneManager colorFromHexString:NAVIGATIONBAR_BACKGROUND_COLOR]];
            [lblBG setAlpha:0.7];
            [containingView addSubview:lblBG];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, containingView.frame.size.height - 50, containingView.frame.size.width, 30)];
            [title setTextColor:[UIColor whiteColor]];
            [title setFont:[UIFont fontWithName:@"AvenirLT85Heavy" size:16]];
            [title setText:@"Find Tracker Image"];
            [title setTextAlignment:NSTextAlignmentCenter];
            [containingView addSubview:title];
            lblBG = nil;
            title = nil;
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupMarkerBase"]];
            [imgView setContentMode:UIViewContentModeScaleAspectFit];
            [imgView setFrame:CGRectMake(containingView.frame.size.width/2 - 40, 30, 80, 80)];
            [containingView addSubview:imgView];
            imgView = nil;
            if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
                [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
            [[VariableMnr sharedInstance] setThumbnailSheetPopup:[PopupView popupViewWithContentView:containingView showType:PopupViewShowTypeFadeIn dismissType:PopupViewDismissTypeFadeOut maskType:PopupViewMaskTypeNone shouldDismissOnBackgroundTouch:false shouldDismissOnContentTouch:true]];
            
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] showAtCenter:CGPointMake(view.frame.size.width/2, view.frame.size.height/2) inView:view];
            
        });
    });
    
}
-(void)showInitialPopupTutorialMarkerLess:(UIView *)view{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            
            [containingView.layer setCornerRadius:8];
            [containingView setClipsToBounds:true];
            
            UILabel *lblBG = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  containingView.frame.size.width,  containingView.frame.size.height)];
            [lblBG setBackgroundColor:[SceneManager colorFromHexString:NAVIGATIONBAR_BACKGROUND_COLOR]];
            [lblBG setAlpha:0.7];
            [containingView addSubview:lblBG];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, containingView.frame.size.height - 50, containingView.frame.size.width, 30)];
            [title setTextColor:[UIColor whiteColor]];
            [title setFont:[UIFont fontWithName:@"AvenirLT85Heavy" size:16]];
            [title setText:@"Find Plane Ground"];
            [title setTextAlignment:NSTextAlignmentCenter];
            [containingView addSubview:title];
            lblBG = nil;
            title = nil;
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupMarkerLess"]];
            [imgView setContentMode:UIViewContentModeScaleAspectFit];
            [imgView setFrame:CGRectMake(containingView.frame.size.width/2 - 40, 30, 80, 80)];
            [containingView addSubview:imgView];
            imgView = nil;
            if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
                [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
            [[VariableMnr sharedInstance] setThumbnailSheetPopup:[PopupView popupViewWithContentView:containingView showType:PopupViewShowTypeFadeIn dismissType:PopupViewDismissTypeFadeOut maskType:PopupViewMaskTypeNone shouldDismissOnBackgroundTouch:false shouldDismissOnContentTouch:true]];
            
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] showAtCenter:CGPointMake(view.frame.size.width/2, view.frame.size.height/2) inView:view];
            
        });
    });
    
}

-(Model3D *)fetchSelectableNode:(SCNNode *)node{
    Model3D *nn = (Model3D *)node;
    
    if([nn respondsToSelector:@selector(placeSelectionNode)]){
        return (Model3D *)node;
    }else{
        if(node.parentNode){
            return [self fetchSelectableNode:node.parentNode];
        }
        return NULL;
        
    }
    
}
-(SCNNode *)rotatedNodeWithVector:(SCNVector3)vector andNode:(SCNNode *)node{
    SCNNode *nodeForRotateX = [[SCNNode alloc] init];
    [nodeForRotateX setScale:SCNVector3Make(1, 1, 1)];
    [nodeForRotateX setPosition:SCNVector3Make(0, 0, 0)];
    
    SCNNode *nodeForRotateY = [[SCNNode alloc] init];
    [nodeForRotateY setScale:SCNVector3Make(1, 1, 1)];
    [nodeForRotateY setPosition:SCNVector3Make(0, 0, 0)];
    [nodeForRotateY addChildNode:nodeForRotateX];
    
    SCNNode *nodeForRotateZ = [[SCNNode alloc] init];
    [nodeForRotateZ setScale:SCNVector3Make(1, 1, 1)];
    [nodeForRotateZ setPosition:SCNVector3Make(0, 0, 0)];
    [nodeForRotateZ addChildNode:nodeForRotateY];
    [nodeForRotateX addChildNode:node];
    [nodeForRotateX setEulerAngles:SCNVector3Make(vector.x, 0, 0)];
    [nodeForRotateY setEulerAngles:SCNVector3Make(0, vector.y, 0)];
    [nodeForRotateZ setEulerAngles:SCNVector3Make(0,0, vector.z)];
    return nodeForRotateZ;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    [self.evolveNavigationController dismissViewControllerAnimated:true completion:nil];
}
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [self.evolveNavigationController dismissViewControllerAnimated:true completion:nil];
    
}
@end
