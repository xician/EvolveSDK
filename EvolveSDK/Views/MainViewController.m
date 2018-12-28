//
//  MainViewController.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 24/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "MainViewController.h"
#import <PopupKit/PopupView.h>
#import <UIView_Shimmer/UIView+Shimmer.h>
#import "SLAMViewController.h"
#import "MarkerBase/MarkerBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController{
    
    SLAMViewController *slamVC;
    MarkerBaseViewController *markerVC;

    PopupView *pop;
    NSArray *carouselImagesArray;
    UIBlurEffect *blurEffect;
    UIVisualEffectView *blurEffectView;
    UIImage *capturedImage;
}
bool flag;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[VariableMnr sharedInstance] setScannedCode:@""];
    [[VariableMnr sharedInstance] setCampaignTitle:@""];
    [self.notificationView.layer setCornerRadius:5];
    [[VariableMnr sharedInstance] setNotificationView:self.notificationView];
    
    [[VariableMnr sharedInstance] setNavigationController:self.navigationController];
    [[VariableMnr sharedInstance] setNavItem:self.navigationItem];
    
    [[VariableMnr sharedInstance] setNotificationTitle:self.notificationTitle];
    [[VariableMnr sharedInstance] setNotificationImageView:self.notificationImageView];
    [[VariableMnr sharedInstance] setNotificationDescription:self.notificationDescription];

    [self.navigationController.navigationBar setTintColor:[SceneManager colorFromHexString:THEME_COLOR]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[VariableMnr sharedInstance] showSearchingVisionCodeProgress];
    
    [[VariableMnr sharedInstance] setCurrentScreenName:SCREENNAME_VISIONCODE_SCANNER];

//    self.navController = [[UINavigationController alloc] initWithRootViewController:targetVC];
    [self.navController.navigationItem setHidesBackButton:true];
    [self.navController setNavigationBarHidden:true];
    [self addChildViewController:self.navController];
    [self.mainCanvasView addSubview:self.navController.view];
    [self.navController.navigationBar setTranslucent:true];
    
    [self.navController didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopup) name:SHOWPOPUP_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEnlargeImage) name:ENLARGEIMAGE_ACTION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarouselImagesWithArray) name:SHOWCAROUSEL_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDownloadContentsNavigationBar) name:SHOWNOTIFICATION_CONTENT_ICONS object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    flag = true;
    
    [[VariableMnr sharedInstance] setDownloadContentPorgressView:self.contentDownloadingView];
    [[VariableMnr sharedInstance] setSearchingVisionCodeProgressView:self.searchingVisionCodeView];
    [[VariableMnr sharedInstance] setProgressViewBar:self.contentDownloadingProgressView];
    [self.campaignIDTextFieldBGView setHidden:false];

    [self.carouselView setType:iCarouselTypeRotary];
    
    [self.campaignIDTextField.layer setCornerRadius:5];
    [self.goButton.layer setCornerRadius:5];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.campaignIDTextField.leftView = paddingView;
    self.campaignIDTextField.leftViewMode = UITextFieldViewModeAlways;

//    NSString *pathForFile = [[NSBundle mainBundle] pathForResource: @"animated" ofType: @"gif"];
//    NSData *dataOfGif = [NSData dataWithContentsOfFile: pathForFile];
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:dataOfGif];
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//    imageView.animatedImage = image;
    
//    imageView.frame = CGRectMake(0.0, 0.0, 150.0, 150.0);
//    [self.searchingVisionCodeView addSubview:imageView];
    
    UILabel *borderForGif = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [borderForGif.layer setCornerRadius:75];
    [borderForGif.layer setBorderWidth:5];
    [borderForGif.layer setBorderColor:[[SceneManager colorFromHexString:GRAY_COLOR] CGColor]];
    [borderForGif setBackgroundColor:[UIColor clearColor]];
    
    [self.searchingVisionCodeView addSubview:borderForGif];
    
    
    if([[[VariableMnr sharedInstance] selectedCode] length] > 3){
        NSString *code = [[VariableMnr sharedInstance] selectedCode];
        [[VariableMnr sharedInstance] setSelectedCode:@""];
        [self codeScanned:[NSString stringWithFormat:@"%@",code]];
        
    }

    [self codeScanned:@"21000086"];

//    Do any additional setup after loading the view from its nib.
    
}


    -(void)showDownloadContentsNavigationBar{
        NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
        
        
        UIBarButtonItem *lightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lightIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(flashlight)];
        
        
        UIBarButtonItem *captureButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"captureIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(captureImage)];
        if([defaultJSON length] == 0){
            UIBarButtonItem *addToFavourite;
            if([[VariableMnr sharedInstance] isFavouriteCode:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]] withTitle:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]]){
                addToFavourite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"inFavourite"] style:UIBarButtonItemStylePlain target:self action:@selector(unFavourite)];
                
            }else{
                addToFavourite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addToFavourite"] style:UIBarButtonItemStylePlain target:self action:@selector(addToFavourite)];
            }
            [self.navigationItem setRightBarButtonItems:@[captureButton ,addToFavourite, lightButton] animated:true];

        }else{
            [self.navigationItem setRightBarButtonItems:@[captureButton, lightButton] animated:true];

        }

        
        

        
    }
-(void)showShareSheet{
    NSArray *activityItems = [NSArray arrayWithObjects:SHARE_STRING,capturedImage,SHARE_URL, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
-(void)saveCapturedImage{
    UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);
    
}
-(void)captureImage{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"hidemenu" object:nil]];

    UIView *viewToBeCapture = [[[self.navController viewControllers] objectAtIndex:0] view];
    
    UIImage *img = [self renderImageFromView:viewToBeCapture withRect:CGRectMake(0, 0, viewToBeCapture.bounds.size.width, viewToBeCapture.bounds.size.height)];
    
    capturedImage = img;
    [self.enlargeImage setImage:img];
    [self.enlargeImageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height)];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"showmenu" object:nil]];

    pop = [PopupView popupViewWithContentView:self.enlargeImageView showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeDarkBlur shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:true];
    
    [pop show];
    UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);

    NSLog(@"Done");
}
    -(void)flashlight{
        
        AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
        {
            BOOL success = [flashLight lockForConfiguration:nil];
            if (success)
            {
                if ([flashLight isTorchActive]) {
                    [flashLight setTorchMode:AVCaptureTorchModeOff];
                } else {
                    [flashLight setTorchMode:AVCaptureTorchModeOn];
                }
                [flashLight unlockForConfiguration];
            }
        }
    }
    
    -(void)keyboardShow:(NSNotification*)notification{
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        [self.campaignIDTextFieldBG setBackgroundColor:[UIColor blackColor]];
        [self.campaignIDTextFieldBG setAlpha:0.6];
        [self.campaignIDTextViewBottom setConstant:keyboardFrameBeginRect.size.height];
        
        [self.searchingVisionCodeView setAlpha:0.0];
        [self.contentDownloadingView setAlpha:0.0];
    }
    -(void)keyboardHide:(NSNotification*)notification{
        [self.campaignIDTextFieldBG setBackgroundColor:[SceneManager colorFromHexString:NAVIGATIONBAR_BACKGROUND_COLOR]];
        [self.campaignIDTextFieldBG setAlpha:1];

        [self.campaignIDTextViewBottom setConstant:0];
        [self.searchingVisionCodeView setAlpha:1.0];
        [self.contentDownloadingView setAlpha:1.0];

    }
    -(void)dismissKeyboard{
        [self.campaignIDTextField setText:@""];
        [self.view endEditing:true];
        
    }
    
    -(void)navigationButtonsForScanner{
        NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
        
    }
    
    -(void)navigationButtonsForVisionCode{
        NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
        
    }
-(IBAction)goButtonPressed:(id)sender{
    if(self.campaignIDTextField.text.length > 0){
        // Validation
        if([[self.campaignIDTextField.text substringToIndex:1] intValue] > 2 ||
           [[self.campaignIDTextField.text substringToIndex:1] intValue] < 1 ||
           [self.campaignIDTextField.text length] != 8){
            [self.campaignIDTextField setTextColor:[UIColor redColor]];
        }else{
            [self.campaignIDTextField setTextColor:[UIColor blackColor]];
        }
        if([self.campaignIDTextField.text isEqualToString:@"300a0000"]){

        }else if(self.campaignIDTextField.text.length == 8){
            NSString *typedCode = [self.campaignIDTextField.text substringToIndex:8];
            
            [self codeScanned:typedCode];
            
            // Event Post to Flurry
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:typedCode forKey:EVENT_CAMPAIGN_ID];
            [param setObject:EVENT_VISIONCODE_TYPED forKey:EVENT_ACTION_TYPE];
            
            flurypost(EVENT_ACTION_TRIGGER, param, false, false);
            NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
            googlepost(EVENT_ACTION_TRIGGER, @"", json, 0);
            
            ////
            
            NSLog(@"%@",typedCode);
            [self.view endEditing:true];
            
        }
    }
}

    -(IBAction)typedCodeChanged:(id)sender{
        if(self.campaignIDTextField.text.length > 0){
        // Validation
        if([[self.campaignIDTextField.text substringToIndex:1] intValue] > 2 ||
           [[self.campaignIDTextField.text substringToIndex:1] intValue] < 1 ||
           [self.campaignIDTextField.text length] != 8){
            [self.campaignIDTextField setTextColor:[UIColor redColor]];
        }else{
            [self.campaignIDTextField setTextColor:[UIColor blackColor]];
        }
        
        
        }
    }
    

-(void)showPopup{
    if(flag){
        flag = false;
    pop = [PopupView popupViewWithContentView:self.pdfViewer showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeNone shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:false];
    [pop show];
    }

}
-(void)initializeUIContent{
    [[VariableMnr sharedInstance] setContactViewVM:self.contactView];
    [[VariableMnr sharedInstance] setSaveContactLblVM:self.saveContactLbl];
    [[VariableMnr sharedInstance] setEventViewVM:self.eventView];
    [[VariableMnr sharedInstance] setSaveEventLblVM:self.saveEventLbl];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    JSONManager *js = [JSONManager sharedInstance];
    [js stopAllMedias];
    
    [self initializeUIContent];

}
-(void)showEnlargeImage{
    
    [self.enlargeImage setImage:[[VariableMnr sharedInstance] enlargeImage]];
    [self.enlargeImageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    [[VariableMnr sharedInstance] setOnScreenPopup:[PopupView popupViewWithContentView:self.enlargeImageView showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeDarkBlur shouldDismissOnBackgroundTouch:false shouldDismissOnContentTouch:true]];
    
    [[[VariableMnr sharedInstance] onScreenPopup] showAtCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2) inView:self.view];
    
}


-(void)showEventSaveView:(NSDictionary *)eventDictionary{
    
    [self.saveEventLbl setText:[NSString stringWithFormat:@"%@",[eventDictionary objectForKey:@"title"]]];
    
    [self.eventView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    pop = [PopupView popupViewWithContentView:self.eventView showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeDarkBlur shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:true];
    [pop show];

}

-(void)showCarouselImagesWithArray{

    carouselImagesArray = [[VariableMnr sharedInstance] imagesArrayCarousel];
    
    [self.carouselView.layer setCornerRadius:4.0];
    [self.carouselView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.9, [[UIScreen mainScreen] bounds].size.height * 0.5)];
    pop = [PopupView popupViewWithContentView:self.carouselView showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeDarkBlur shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:false];
    [self.carouselView reloadData];
    [pop show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [carouselImagesArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        NSDictionary *dict = [carouselImagesArray objectAtIndex:index];
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        
        ((UIImageView *)view).image = [[DownloadMngrr getInstance] getImageWithKey:[[VariableMnr sharedInstance] generateKeyFromURL:[NSString stringWithFormat:@"%@",[dict objectForKey:CAROUSEL_URLIMAGE_JSON_KEY]]]];
        
        view.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    else
    {
    }
    
    
    return view;
}

-(void)sceneCreatedWithInitializedConfiguration{
    [self.campaignIDTextFieldBGView setHidden:true];
    [self.navController.view setFrame:CGRectMake(0, 0, self.mainCanvasView.frame.size.width, self.mainCanvasView.frame.size.height)];

    if([ARConfiguration isSupported]){
        JSONManager *js = [JSONManager sharedInstance];
        js.scenes = nil;
        js = nil;

        [JSONManager clearAllValues];
        markerVC = [[MarkerBaseViewController sharedInstance] initWithNibName:@"MarkerBaseViewController" bundle:nil];
        [markerVC setIsARAlreadyLoaded:false];
        [self.navController setViewControllers:@[markerVC]];

    }
    
//    [self.campaignIDTextFieldBGView setHidden:true];
//        vc = [[ViewController alloc] initWithNibName:@"MainView" bundle:nil];
//
//    JSONManager *js = [JSONManager sharedInstance];
//    js.scenes = nil;
//    js = nil;
//
//    [JSONManager clearAllValues];
//
//
//    [self.navController.view setFrame:CGRectMake(0, 0, self.mainCanvasView.frame.size.width, self.mainCanvasView.frame.size.height)];
//
//    [self.navController setViewControllers:[[NSArray alloc] initWithObjects:vc, nil]];
    
}
    
-(void)createdSLAMWithInitializedConfiguration{
    [self.campaignIDTextFieldBGView setHidden:true];
    [self.navController.view setFrame:CGRectMake(0, 0, self.mainCanvasView.frame.size.width, self.mainCanvasView.frame.size.height)];
    
    if([ARConfiguration isSupported]){
        SLAMJSONManager *js = [SLAMJSONManager sharedInstance];
        js.scenes = nil;
        js = nil;

        [SLAMJSONManager clearAllValues];
        slamVC = [[SLAMViewController sharedInstance] initWithNibName:@"SLAMViewController" bundle:nil];
        [self.navController setViewControllers:@[slamVC]];

    }
}

-(void)addToFavourite{
    [[VariableMnr sharedInstance] saveFavouriteVisionCode:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]] withTitle:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]];
    [self showDownloadContentsNavigationBar];
    
}

-(void)unFavourite{
    [[VariableMnr sharedInstance] unFavourite:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]] withTitle:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] campaignTitle]]];
    [self showDownloadContentsNavigationBar];
}

-(void)codeScanned:(NSString *)code{
    
    [[VariableMnr sharedInstance] showDownloadingContentProgress];
    [VariableMnr.sharedInstance setScannedCode:code];
    
    NSLog(@"%@",code);
    [self.campaignIDTextField setText:@""];

    int startWith = [[code substringToIndex:1] intValue];
    if(startWith == 2){
        [self sceneCreatedWithInitializedConfiguration];
    }else if(startWith == 1){
        [self createdSLAMWithInitializedConfiguration];
    }

}
    
-(IBAction)placeModelButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"placeModelButtonPressed" object:nil];
}
-(UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)frame {
    // Create a new context the size of the frame
    UIGraphicsBeginImageContextWithOptions(frame.size, false, [[UIScreen mainScreen] scale]);
    CGRect rec = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
