//
//  MarkerBaseViewController.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 01/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "MarkerBaseViewController.h"
#import "Plane.h"
#import "VariableMnr.h"
#import "GlobalConstants.h"
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ThumbnailCollectionViewCell.h"
#import "CustomActionButton.h"

@interface MarkerBaseViewController ()
@property (nonatomic, retain) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) JSONManager *jsonManager;
@property (nonatomic, retain) NSData *jsonData;
@property (nonatomic, retain) SCNNode *mainNode;
@property (nonatomic, retain) Model3D *selectedNode;
@property (nonatomic, retain) ARImageTrackingConfiguration *configuration;
@property float memoryUsed;
@property (nonatomic, retain) MFMailComposeViewController *composeVC;
@property (nonatomic, retain)IBOutlet UIVisualEffectView *blurView;
@property (nonatomic, retain) SCNNode *button;
@property (nonatomic, retain) SCNPlane *buttonGeometry;
@property (nonatomic, retain) SCNMaterial *buttonMaterial;
@property (nonatomic, retain) ARReferenceImage *referenceImage;
@property (nonatomic, retain) SCNNode *imageCanvas;
@property (nonatomic, retain) SCNPlane *imageGeometry;
@property (nonatomic, retain) SCNMaterial *imageMaterial;
@property (nonatomic, retain) SCNNode *canvasNode;
@property (nonatomic, retain) SKVideoNode *videoNode;
@property BOOL isMainNodeOnCamera;
@property BOOL isMaybeVisible;
@property BOOL isAdjusted;
@property (nonatomic, retain) NSArray *fetchedJsonData;
@property BOOL isCampaignViewedForFirstTime;
@property BOOL isLightAdded;
@property float maximumTransitionTime;
@property (nonatomic, retain) ARSession *session;
@property (nonatomic, retain) NodeAction *actionSelectedModel;
@property CGFloat lastScaleValue;

@property int lastCurrentScene;

@end

@implementation MarkerBaseViewController{
}

static MarkerBaseViewController *mVC;
+(MarkerBaseViewController *)sharedInstance{
    if(mVC != NULL){
        
        ARReferenceImage *referenceImages = [[ARReferenceImage alloc] initWithCGImage:[[UIImage imageNamed:@"applicationplaceholdericon.png"] CGImage] orientation:kCGImagePropertyOrientationUp physicalWidth:0.5];
        
        mVC.configuration = [ARImageTrackingConfiguration new];
        [mVC.configuration setTrackingImages:[[NSSet alloc] initWithObjects:referenceImages, nil]];

        if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
        return mVC;
        
    }else{
        mVC = [MarkerBaseViewController alloc];
        mVC.memoryUsed = 0;
        return mVC;
        
    }
}
/// Convenience accessor for the session owned by ARSCNView.
-(ARSession *)getSession{
    return _sceneView.session;
}
-(void)refreshJSON{
    
        for (SceneNode *scen in [self.jsonManager scenes]) {
            for (Model3D *mdl in scen.models) {
                [mdl setIsPlaced:false];
            }
        }
        
    
    
    self.configuration = VariableMnr.sharedInstance.imageConfiguration;
    [self.configuration setLightEstimationEnabled:true];
    [[self getSession] runWithConfiguration:self.configuration options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
    
}
-(void)setupSLAMUIContents{
    _memoryUsed = 0;
    [self.navigationController setTitle:@"M"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiateSetup];
    _isARAlreadyLoaded = false;
    self.isLightAdded = false;
    _maximumTransitionTime = 0;
    _lastScaleValue = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDescriptionBoxForModel) name:SHOWDESCRIPTIONPOPUP_MARKERBASE_NOTIFICATION_KEY object:nil];
}
-(void)showDescriptionBoxForModel{
    [self initiateDescriptionBox:_actionSelectedModel];
    
}

-(void)initiateDescriptionBox:(NodeAction *)actionNd{
    [self.descriptionBoxView.layer setCornerRadius:4];
    
    [[VariableMnr sharedInstance] setThumbnailSheetPopup:[PopupView popupViewWithContentView:self.descriptionBoxView showType:PopupViewShowTypeSlideInFromBottom dismissType:PopupViewDismissTypeSlideOutToBottom maskType:PopupViewMaskTypeNone shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:false]];
    
    UIView *mView = [[[VariableMnr sharedInstance] navigationController] parentViewController].view;
    
    [[[VariableMnr sharedInstance] thumbnailSheetPopup] setWillStartDismissingCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"thumbnailMenuClose" object:nil]];
    }];
    
    [[[VariableMnr sharedInstance] thumbnailSheetPopup] showAtCenter:CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height - ((self.descriptionBoxView.frame.size.height/2) + 10)) inView:mView];
    
}

-(void)initiateSetup{
    _isCampaignViewedForFirstTime = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshJSON) name:REFRESH_ARSCENE_NOTIFICATION_KEY object:nil];
    [_sceneView setDelegate:self];
    [_sceneView.session setDelegate:self];
    _isMainNodeOnCamera = false;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapRec:)];
    
    UIPinchGestureRecognizer *pinchTap = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchRec:)];
    
    [[VariableMnr sharedInstance] setJsonManager:[JSONManager sharedInstance]];
    _jsonManager  = [JSONManager sharedInstance];
    if(_jsonManager != nil){
        [_jsonManager setJsonManagerDelegate:self];
        
    }
    
    [_sceneView addGestureRecognizer:tap];
    [_sceneView addGestureRecognizer:pinchTap];

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
    [[VariableMnr sharedInstance] postFlurryEvent:SCREENNAME_MARKERBASE withParameter:param isTimedEvent:true isCurrentlyStarted:true];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setupSLAMUIContents];
    
    if(_isARAlreadyLoaded){
        [self refreshJSON];
        return;
    }else{
        [self resetTracking];
        
    }
    _isARAlreadyLoaded = true;
    [[VariableMnr sharedInstance] Google_TrackingScreen:SCREENNAME_MARKERBASE];
    [[VariableMnr sharedInstance] hideTrackingCover];
    [[DownloadMngrr getInstance] setDownloadMngrDelegate:self];
    [[DownloadMngrr getInstance] downloadJSONContent:[NSString stringWithFormat:[[VariableMnr sharedInstance] fetchBaseURL],[[VariableMnr sharedInstance] scannedCode]]];
    
}
-(void)resetTracking{
    ARReferenceImage *referenceImage = [[ARReferenceImage alloc] initWithCGImage:[[UIImage imageNamed:@"applicationplaceholdericon.png"] CGImage] orientation:kCGImagePropertyOrientationUp physicalWidth:0.5];
    
    self.configuration = [[ARImageTrackingConfiguration alloc] init];
    [self.configuration setTrackingImages:[[NSSet alloc] initWithObjects:referenceImage, nil]];
    [[self getSession] runWithConfiguration:self.configuration options:ARSessionRunOptionRemoveExistingAnchors];
    
}
-(void)handlePinchRec:(UIPinchGestureRecognizer *)rec{
    CGPoint location = [rec locationInView:_sceneView];
    NSArray *hits = [_sceneView hitTest:location options:nil];
    
    SCNHitTestResult *result = nil;
    if(hits.count > 0){
        result = [hits objectAtIndex:0];
    }
    if(rec.state == UIGestureRecognizerStateBegan){

        _lastScaleValue = [rec scale];
        
    }
    if(rec.state == UIGestureRecognizerStateChanged){
        if(result)
        if(result.node != nil){
            Model3D *nn = [VariableMnr.sharedInstance fetchSelectableNode:result.node];
            if(nn != NULL){
                if([_jsonManager isPinchTargetAvailablForModel:nn]){
                    float newScaleValue = 0;
                    if(_lastScaleValue > [rec scale]){
                        newScaleValue = ((_lastScaleValue - [rec scale]) * -1) * 0.001;
                        NSLog(@"xician ali scale -%f",(_lastScaleValue - [rec scale]));
                    }else{
                        newScaleValue = ([rec scale] - _lastScaleValue) * 0.001;

                        NSLog(@"xician ali scale %f",([rec scale] - _lastScaleValue));
                    }
                    
                    [nn setScale:SCNVector3Make(nn.scale.x + newScaleValue, nn.scale.y + newScaleValue, nn.scale.z + newScaleValue)];
                    
                    _lastScaleValue = [rec scale];
                }
            }
        }

        

    }
}
-(void)handleTapRec:(UITapGestureRecognizer *)rec{
    if(rec.state == UIGestureRecognizerStateEnded){
        CGPoint location = [rec locationInView:_sceneView];
        NSArray *hits = [_sceneView hitTest:location options:nil];
        if([hits count] > 0){
            SCNHitTestResult *result = [hits objectAtIndex:0];
            if([((ButtonNode *)result.node) respondsToSelector:@selector(isButtonNode)]){
                [_jsonManager actionTriggerForButtonNode:(ButtonNode *)result.node];
            }else if([((ContactNode *)result.node) respondsToSelector:@selector(isContactNode)]){
                [_jsonManager actionTriggerForContactNode:(ContactNode *)result.node];
            }else if([((ImageNode *)result.node) respondsToSelector:@selector(isImageNode)]){
                [_jsonManager actionTriggerForImageNode:(ImageNode *)result.node];
            }else if([((Model3D *)result.node) respondsToSelector:@selector(isModel3D)]){
                [_jsonManager actionTriggerForModel:(Model3D *)result.node];
            }else if([((EventNode *)result.node) respondsToSelector:@selector(isEventNode)]){
                [_jsonManager actionTriggerForEventNode:(EventNode *)result.node];
            }else if([((VideoNode *)result.node) respondsToSelector:@selector(isVideoNode)]){
                [_jsonManager actionOnNode:(VideoNode *)result.node];
                VideoNode *nd = (VideoNode *)result.node;
                [nd videoTapped];
            }else if([((VideoNode *)result.node.parentNode) respondsToSelector:@selector(isVideoNode)]){
                [_jsonManager actionOnNode:(VideoNode *)result.node.parentNode];
                VideoNode *nd = (VideoNode *)result.node.parentNode;
                [nd videoTapped];
            }else if([((SoundNode *)result.node) respondsToSelector:@selector(isSoundNode)]){
                [_jsonManager actionOnSoundNode:(SoundNode *)result.node];
            }else if(result.node != nil){
                Model3D *nn = [VariableMnr.sharedInstance fetchSelectableNode:result.node];
                [_jsonManager actionTriggerForModel:nn];
            }

        }
        
        
    }

}
-(void)openViewController:(UIViewController *)vc{
    
    [self presentViewController:vc animated:true completion:nil];
}
-(void)pushonViewController:(UIViewController *)vc{
    [[[VariableMnr sharedInstance] evolveNavigationController] pushViewController:vc animated:true];

}
-(void)dismissViewController{
    [self dismissViewController];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    [_composeVC dismissViewControllerAnimated:true completion:nil];
    
}

-(void)resetSceneCanvas{
    [[VariableMnr sharedInstance] hideProgressView];
    
    self.configuration = [[VariableMnr sharedInstance] imageConfiguration];
    [[self getSession] runWithConfiguration:self.configuration options:ARSessionRunOptionRemoveExistingAnchors];

    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SHOWNOTIFICATION_CONTENT_ICONS object:nil]];
    [[VariableMnr sharedInstance] showNotificationView];
}

-(void)addNodesToAR:(SCNNode *)canvasNode{
    
//    _memoryUsed = [ViewController GetMemory];
    if(_memoryUsed < 800){
    
    if([_jsonManager fetchCurrentScene] == nil){
        return;
    }
    
    if(_isCampaignViewedForFirstTime){
        _isCampaignViewedForFirstTime = false;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[VariableMnr.sharedInstance scannedCode] forKey:EVENT_CAMPAIGN_ID];
        
        [param setObject:EVENT_CAMPAIGNVIEWED forKey:EVENT_ACTION_TYPE];
        
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, @"", json, 0);
        
    }
    
    if([_jsonManager fetchCurrentScene].contacts.count > 0){
        for (ContactNode *contactN in [[_jsonManager fetchCurrentScene] contacts]) {
            [contactN resizeCanvasScene:_referenceImage.physicalSize];
            for (NodeTransition *transition in [contactN transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:contactN];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;
                    
                }
            }
            [canvasNode addChildNode:contactN];
        }
    }
    
    if([_jsonManager fetchCurrentScene].buttons.count > 0){
        for (ButtonNode *button in [[_jsonManager fetchCurrentScene] buttons]) {
            [button resizeCanvasScene:_referenceImage.physicalSize];
            for (NodeTransition *transition in [button transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:button];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;

                }
            }
            [canvasNode addChildNode:button];
        }
    }
    
    if([_jsonManager fetchCurrentScene].events.count > 0){
        for (EventNode *event in [[_jsonManager fetchCurrentScene] events]) {
            [event resizeCanvasScene:_referenceImage.physicalSize];
            for (NodeTransition *transition in [event transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:event];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;

                }
            }
            [canvasNode addChildNode:event];
        }
    }
    
    if([_jsonManager fetchCurrentScene].images.count > 0){
        for (ImageNode *image in [[_jsonManager fetchCurrentScene] images]) {
            [image resizeCanvasScene:_referenceImage.physicalSize];
            for (NodeTransition *transition in [image transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:image];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;

                }
            }
            [canvasNode addChildNode:image];
        }
    }
    
    if([_jsonManager fetchCurrentScene].sounds.count > 0){
        for (SoundNode *sound in [[_jsonManager fetchCurrentScene] sounds]) {
            [sound resizeCanvasScene:_referenceImage.physicalSize];
            [sound playSound];
            [self.jsonManager actionOnSoundNode:sound];
            for (NodeTransition *transition in [sound transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:sound];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;

                }
            }
            [canvasNode addChildNode:sound];
        }
    }

    if([_jsonManager fetchCurrentScene].videos.count > 0){
        for (VideoNode *video in [[_jsonManager fetchCurrentScene] videos]) {
            
            [video resizeCanvasScene:_referenceImage.physicalSize];
            [video playVideo];
            [self.jsonManager actionOnNode:video];
            
            for (NodeTransition *transition in [video transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:video];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;

                }
            }
            [canvasNode addChildNode:video];
        }
    }
    
    if([_jsonManager fetchCurrentScene].models.count > 0){
        for (Model3D *model in [[_jsonManager fetchCurrentScene] models]) {
            NSLog(@"refresh Json model placed %@",model.parentNode);
            for (NodeTransition *transition in [model transitions]) {
                if(![transition isAlreadyInQ]){
                    [transition executeTransitionForNode:model];
                    [transition setIsAlreadyInQ:true];
                    _maximumTransitionTime = (([transition delay] + [transition length]) > _maximumTransitionTime)?([transition delay] + [transition length]):_maximumTransitionTime;
                    
                }
            }
            if(![model parentNode]){
                [model setIsPlaced:true];
                [model placeModelOnGround:SCNVector3Make(model.transf.posX, model.transf.posY, model.transf.posZ) withSize:_referenceImage.physicalSize];
                [canvasNode addChildNode:model];
//                [self setAnimationRepeatCount:model];
            }

        }
    }
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your device maximum memory limit exceeds, please RESET your campaign now." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:true completion:nil];
        }];
        
        [alertController addAction:action];
        [alertController addAction:actionCancel];
        if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
        [self presentViewController:alertController animated:true completion:nil];
    }
    [self performSelector:@selector(makeScenePulled) withObject:nil afterDelay:_maximumTransitionTime + 1];
    NSLog(@"Zeeshan maximum %f",_maximumTransitionTime);
}
-(void)makeScenePulled{
    
    for (SceneNode *scene in _jsonManager.scenes) {
        
        for (ButtonNode *nde in scene.buttons) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }

        for (ImageNode *nde in scene.images) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }

        for (VideoNode *nde in scene.videos) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }
        for (Model3D *nde in scene.models) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }
        
        for (ContactNode *nde in scene.contacts) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }
        
        for (EventNode *nde in scene.events) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }
        
        for (SoundNode *nde in scene.sounds) {
            [nde.transf setPosX:[nde.transf posXOriginal]];
            [nde.transf setPosY:[nde.transf posYOriginal]];
            [nde.transf setPosZ:[nde.transf posZOriginal]];
            [nde.transf setScaleX:[nde.transf scaleXOriginal]];
            [nde.transf setScaleY:[nde.transf scaleYOriginal]];
            [nde.transf setScaleZ:[nde.transf scaleZOriginal]];
        }

    }
    
    NSLog(@"Zeeshan maximum true");
    
}
-(void)setAnimationRepeatCount:(SCNNode *)mainNode{
    for (SCNNode *csc in [mainNode childNodes]) {
        for (NSString *keyS in [csc animationKeys]) {
            SCNAnimationPlayer *anim = [csc animationPlayerForKey:keyS];
            [[anim animation] setRepeatCount:1];
        }
        [self setAnimationRepeatCount:csc];
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    ARImageAnchor *imageAnchor;
    if (![anchor isKindOfClass:[ARImageAnchor class]]) {
        return;
    }else{
        imageAnchor = (ARImageAnchor *)anchor;
    }
    
    _referenceImage = [imageAnchor referenceImage];
    [[VariableMnr sharedInstance] hideNotificationView];
    
    if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil){
        [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
    }
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            if(self.mainNode != nil){
                for (SCNNode *chNode in [self.mainNode childNodes]) {
                    if(![chNode respondsToSelector:@selector(isModel3D)]){
                        [chNode removeFromParentNode];
                    }else{
                        if(![(Model3D *)chNode isPlaced])
                            [chNode removeFromParentNode];
                    }
                    
                }
                
            }
            self.mainNode = [[SCNNode alloc] init];
            self.canvasNode = node;
            self.jsonManager.mainCanvasNode = node;
            [self addNodesToAR:self.mainNode];
            [self.mainNode setEulerAngles:SCNVector3Make(0, 0, 0)];
            [self.mainNode setPosition:SCNVector3Make(0, 0, 0)];
            [self.mainNode setScale:SCNVector3Make(1, 1, 1)];
            [node addChildNode:self.mainNode];
            [self setIsLightAdded:false];
            for (SCNNode *nnn in node.childNodes) {
                if([nnn.light intensity] > 100){
                    [self setIsLightAdded:true];
                }
            }
            if(!self.isLightAdded){
                [self setIsLightAdded:true];
                    NSLog(@"hello zeeshan");
                SCNNode *lightNode2 = [[SCNNode alloc] init];
                [lightNode2 setLight:[[SCNLight alloc] init]];
                [lightNode2.light setIntensity:600];
                [lightNode2.light setType:SCNLightTypeDirectional];
                [lightNode2.light setColor:[UIColor whiteColor]];
                [lightNode2 setCastsShadow:false];
                [lightNode2 setScale:SCNVector3Make(1, 1, 1)];
                [lightNode2 setPosition:SCNVector3Make(0, 0, 5)];
                [lightNode2 setEulerAngles:SCNVector3Make(3.1416, 0, 0)];
                [node addChildNode:lightNode2];
                SCNNode *lightNode3 = [[SCNNode alloc] init];
                [lightNode3 setLight:[[SCNLight alloc] init]];
                [lightNode3.light setIntensity:600];
                [lightNode3.light setType:SCNLightTypeDirectional];
                [lightNode3.light setColor:[UIColor whiteColor]];
                [lightNode3 setCastsShadow:false];
                [lightNode3 setScale:SCNVector3Make(1, 1, 1)];
                [lightNode3 setPosition:SCNVector3Make(5, 5, -5)];
                [lightNode3 setEulerAngles:SCNVector3Make(-0.7854, 0.7854, 0)];
                [node addChildNode:lightNode3];
                SCNNode *lightNode = [[SCNNode alloc] init];
                [lightNode setLight:[[SCNLight alloc] init]];
                [lightNode.light setIntensity:500];
                [lightNode.light setType:SCNLightTypeDirectional];
                [lightNode.light setColor:[UIColor whiteColor]];
                [lightNode setCastsShadow:false];
                [lightNode setScale:SCNVector3Make(1, 1, 1)];
                [lightNode setPosition:SCNVector3Make(-5, 5, -5)];
                [lightNode setEulerAngles:SCNVector3Make(-0.7854, -0.7854, 0)];
                [node addChildNode:lightNode];
                
            }
            
            
        });
    });
}

-(void)scanningStart{
    [self resetSceneCanvas];
    
}
-(void)codeScannedWithID:(NSString *)primaryCapeignID{
    DownloadMngrr *dManager = [DownloadMngrr getInstance];
    [dManager setDownloadMngrDelegate:self];
    [dManager downloadJSONContentForMarkerLess:[NSString stringWithFormat:[[VariableMnr sharedInstance] fetchBaseURL],primaryCapeignID]];
}

-(void)jsonDownloadCompleteWithData:(NSData *)jsonData{
    [_jsonManager createScenesFromJSON:jsonData];
    [self downloadAllThumbnails];
}

-(void)downloadAllThumbnails{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (SceneNode *scn in [_jsonManager scenes]) {
        NSMutableArray *models = scn.models;
        for (Model3D *modelNode in models) {
            [imageArray addObject:[NSString stringWithFormat:@"%@",[modelNode.appearance thumbnailImage]]];
        }
    }
    
    DownloadMngrr *dManager = [DownloadMngrr getInstance];
    [dManager downloadImagesFromArrayOfURL:imageArray];
    
}

-(void)downloadComplete{
    
    
}

-(void)allContentsDownloadComplete{
    [[VariableMnr sharedInstance] hideProgressView];
    
    [[VariableMnr sharedInstance] showInitialPopupTutorialMarkerBase:self.view];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication.sharedApplication setIdleTimerDisabled:true];

}
-(void)viewDidDisappear:(BOOL)animated{
    [_sceneView.session pause];
}

-(IBAction)descriptionBoxActionButtonPressed:(id)sender{
    CustomActionButton *customButton = (CustomActionButton *)sender;
    NSDictionary *dic = [customButton customData];
    NodeAction *ndAction = [customButton actionND];
    [ndAction triggerDescriptionBoxAction:dic];
    
}


-(IBAction)dismissDescriptionBox:(id)sender{
    if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
        [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
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

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _jsonManager.scenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ThumbnailCollectionViewCell";
    
    ThumbnailCollectionViewCell *thumbnail = (ThumbnailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Model3D *model = [[[_jsonManager.scenes objectAtIndex:indexPath.row] models] objectAtIndex:0];
    
    [thumbnail.thumbnailImg setImage:model.appearance.thumbnail];
    
    thumbnail.thumbnailImg.layer.masksToBounds = NO;
    thumbnail.thumbnailImg.layer.shadowOffset = CGSizeMake(2, 2);
    thumbnail.thumbnailImg.layer.shadowOpacity = 0.4;
    
    [thumbnail.titleLbl setText:[NSString stringWithFormat:@"%@",[model.appearance title]]];
    [thumbnail.descriptionLbl setText:[NSString stringWithFormat:@"%@",model.appearance.description]];
    
    if(model.isPlaced){
        [thumbnail.selectionBGImg setHidden:false];
        [thumbnail.selectionBGLbl setHidden:false];
        
    }else{
        [thumbnail.selectionBGImg setHidden:true];
        [thumbnail.selectionBGLbl setHidden:true];
        
    }
    thumbnail.selectionBGImg.layer.masksToBounds = NO;
    thumbnail.selectionBGImg.layer.shadowOffset = CGSizeMake(2, 2);
    thumbnail.selectionBGImg.layer.shadowOpacity = 0.4;
    return thumbnail;
    
}

@end
