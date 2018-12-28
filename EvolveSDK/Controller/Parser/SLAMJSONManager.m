//
//  SLAMJSONManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SLAMJSONManager.h"
#import "VariableMnr.h"
@implementation SLAMJSONManager

//SLAMJSONManager Variable for Singleton Design Pattern.
static SLAMJSONManager *slamJsonM;
int currentActionSceneSLAM;
AVPlayer *playerSLAM;
// Static mathod to get the shared instance of SLAMJSONManager Node Class.
+(SLAMJSONManager *)sharedInstance{
    if(slamJsonM != NULL){
        return slamJsonM;
        
    }else{
        slamJsonM = [[SLAMJSONManager alloc] init];
        slamJsonM.scenes = [[NSMutableArray alloc] init];
        return slamJsonM;
    }
}

+(void)clearAllValues{
    for (SceneNode *n in [slamJsonM scenes]) {
        [[SceneManager sharedInstance] cleanNodes:n];
    }
    [[slamJsonM scenes] removeAllObjects];
    slamJsonM = nil;
}

-(void)setMarkerFromImageURL:(NSString *)urlString{
    //    ARReferenceImage *refImg = [[ARReferenceImage alloc] initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]] CGImage] orientation:kCGImagePropertyOrientationUp physicalWidth:100];
    
}

-(void)actionNodeCallingParamSet:(NodeAction *)actionNode{
    
    if(actionNode == NULL){
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
    
    //    if([actionNode paramValue] != nil){
    //        [param setObject:[actionNode paramValue] forKey:EVENT_ACTION_VALUE];
    //    }else if([actionNode paramDictionary] != nil){
    //        [param setObject:[actionNode paramDictionary] forKey:EVENT_ACTION_VALUE];
    //    }else{
    //        [param setObject:@"" forKey:EVENT_ACTION_VALUE];
    //    }
    
    [param setObject:[actionNode objectUUID] forKey:UUID_JSON_KEY];
    
    if(actionNode.triggerType == TriggerTypeTap){
        [param setObject:TAP_TRIGGER_KEY forKey:EVENT_TRIGGER_TYPE];
    }else if(actionNode.triggerType == TriggerTypeOnVideoFinish){
        [param setObject:ONVIDEOFINISH_TRIGGER_KEY forKey:EVENT_TRIGGER_TYPE];
    }else if(actionNode.triggerType == TriggerTypeOnVideoFinish){
        [param setObject:ONSOUNDFINISH_TRIGGER_KEY forKey:EVENT_TRIGGER_TYPE];
    }else if(actionNode.triggerType == TriggerTypePinch){
        [param setObject:PINCH_TRIGGER_KEY forKey:EVENT_TRIGGER_TYPE];
    }
    
    if(actionNode.assetType == Button){
        [param setObject:EVENT_ASSET_BUTTON forKey:EVENT_ASSET_TYPE];
    }else if(actionNode.assetType == Image){
        [param setObject:EVENT_ASSET_IMAGE forKey:EVENT_ASSET_TYPE];
    }else if(actionNode.assetType == Video){
        [param setObject:EVENT_ASSET_Video forKey:EVENT_ASSET_TYPE];
        [param setObject:EVENT_TRIGGER_FINISH forKey:EVENT_TRIGGER_TYPE];
    }else if(actionNode.assetType == Text){
        [param setObject:EVENT_ASSET_Text forKey:EVENT_ASSET_TYPE];
    }else if(actionNode.assetType == SaveContact){
        [param setObject:EVENT_ASSET_Contact forKey:EVENT_ASSET_TYPE];
    }else if(actionNode.assetType == SaveEvent){
        [param setObject:EVENT_ASSET_EVENT forKey:EVENT_ASSET_TYPE];
    }
    
    if(actionNode.actionType == ActionTypeCall){
        [param setObject:CALL_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [actionNode callPhoneNumber];
        
    }else if(actionNode.actionType == ActionTypeURL){
        [param setObject:URL_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode openURL];
    }else if(actionNode.actionType == ActionType360Video){
        [param setObject:VIDEO360_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode load360Video];
    }else if(actionNode.actionType == ActionScalling){
        [param setObject:SCALLING_ACTION_KEY forKey:EVENT_ACTION_TYPE];
    }else if(actionNode.actionType == ActionTypeHostMessage){
        [param setObject:HOSTMESSAGE_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [actionNode showHostMessage];
    }else if(actionNode.actionType == ActionTypeWhatsApp){
        [param setObject:WHATSAPP_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode loadWhatsApp];
    }else if(actionNode.actionType == ActionTypeViberApp){
        [param setObject:VIBERAPP_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode loadViberApp];
    }else if(actionNode.actionType == ActionTypeEmail){
        [param setObject:EMAIL_JSON_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode sendEmail];
    }else if(actionNode.actionType == ActionTypeSaveContact){
        [param setObject:SAVECONTACT_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode saveContact];
    }else if(actionNode.actionType == ActionTypeEnlargeImage){
        [param setObject:ENLARGEIMAGE_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode enlargeImage];
    }else if(actionNode.actionType == ActionTypeSaveEvent){
        [param setObject:SAVEEVENT_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode saveEvent];
    }else if(actionNode.actionType == ActionTypeGoToScene){
        [param setObject:GOTOSCENE_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode goToScene];
    }else if(actionNode.actionType == ActionTypePlayAudio){
        [param setObject:AUDIOPLAY_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",actionNode.paramValue]] options:nil];
        AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
        playerSLAM = [AVPlayer playerWithPlayerItem:anItem];
        [playerSLAM addObserver:self forKeyPath:@"status" options:0 context:nil];
        [playerSLAM play];
        
    }else if(actionNode.actionType == ActionTypeCarousel){
        [param setObject:CAROUSEL_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        
        [actionNode showCarousal];
    }
    
    flurypost(EVENT_ACTION_TRIGGER, param, false, false);
    NSString *json = [NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param]];
    NSString *action = [NSString stringWithFormat:@"%@",[param objectForKey:EVENT_ACTION_TYPE]];
    googlepost(EVENT_ACTION_TRIGGER, action, json,0);
    
}
-(void)actionTriggerForModel:(Model3D *)node{
    [self actionNodeCallingParamSet:node.action];
}
-(void)actionTriggerForButtonNode:(ButtonNode *)node{
    
    [self actionNodeCallingParamSet:node.buttonAction];
    
}
-(void)actionTriggerForContactNode:(ContactNode *)node{
    [self actionNodeCallingParamSet:node.action];
}
-(void)actionTriggerForEventNode:(EventNode *)node{
    [self actionNodeCallingParamSet:node.action];
}
-(void)actionTriggerForImageNode:(ImageNode *)node{
    [self actionNodeCallingParamSet:node.buttonAction];
    [[VariableMnr sharedInstance] setEnlargeImage:[node.appearance backgroundImage]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == playerSLAM && [keyPath isEqualToString:@"status"]) {
        if (playerSLAM.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (playerSLAM.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayer Ready to Play");
        } else if (playerSLAM.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}
-(void)actionOnNode:(VideoNode *)node{
    __weak VideoNode *nod = node;
    if([node.action isActionApplied] != true){
        if(node.action.triggerType == TriggerTypeOnVideoFinish){
            [node.avPlayer addBoundaryTimeObserverForTimes:[[NSArray alloc] initWithObjects:[NSValue valueWithCMTime:node.avPlayer.currentItem.duration], nil] queue:NULL usingBlock:^{
                
                if(nod.action.actionType == ActionTypeReplayVideo){
                    [nod.avPlayer seekToTime:kCMTimeZero];
                    [nod.avPlayer play];
                    
                }else{
                    
                    [self actionNodeCallingParamSet:nod.action];
                    
                }
                
            }];
            [node.action setIsActionApplied:true];
        }
    }
}

-(void)actionOnSoundNode:(SoundNode *)node{
    __weak SoundNode *nod = node;
    if([node.action isActionApplied] != true){
        if(node.action.triggerType == TriggerTypeOnSoundFinish){
            [node.avPlayer addBoundaryTimeObserverForTimes:[[NSArray alloc] initWithObjects:[NSValue valueWithCMTime:node.avPlayer.currentItem.duration], nil] queue:NULL usingBlock:^{
                
                if(nod.action.actionType == ActionTypeReplayVideo){
                    [nod.avPlayer seekToTime:kCMTimeZero];
                    [nod.avPlayer play];
                    
                }else{
                    
                    [self actionNodeCallingParamSet:nod.action];
                    
                }
                
            }];
            [node.action setIsActionApplied:true];
        }
    }
}

-(void)createScenesFromJSON:(NSData *)jsonData{
    currentActionSceneSLAM = 0;
    NSData* data = jsonData;
    if(data == nil){
        return;
    }
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(array == nil || error != nil){
        [[VariableMnr sharedInstance] msgboxWithTitle:TITLE_ALERT message:MESSAGE_SERVER_JSON_NOTFOUND andButton:@"Ok"];
        
        return;
    }

    if([array count] <= 0){
        [[VariableMnr sharedInstance] msgboxWithTitle:TITLE_ALERT message:MESSAGE_CODE_NOTFOUND andButton:@"Ok"];
        return;
    }
    
    SceneManager *sceneManager = [SceneManager sharedInstance];
    
    [self.scenes removeAllObjects];
    for (NSDictionary *sceneJson in [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] objectAtIndex:0] objectForKey:SCENES_JSON_KEY]) {
        
        SceneNode *scene = [sceneManager generateNewScene];
        
        NSArray *objects = [[NSArray alloc] initWithArray:[sceneJson objectForKey:MODEL_JSON_KEY]];
        for (NSDictionary *object in objects) {
            
            NSLog(@"%@",[object objectForKey:ASSET_JSON_KEY]);
            // Button
            Appearance *appearance;
            Transform *transform;
            NodeAction *action;
            NSMutableArray *transitions;
            if([object objectForKey:TRANSFORM_JSON_KEY]){
                transform = [self generateTransformFromDict:[object objectForKey:TRANSFORM_JSON_KEY]];
            }else{
                transform = [[Transform alloc] init];
            }
            
            if([object objectForKey:APPEARANCE_JSON_KEY]){
                appearance = [self generteAppearanceFromDict:[object objectForKey:APPEARANCE_JSON_KEY]];
            }else{
                appearance = [[Appearance alloc] init];
            }
            
            if([[[NSArray alloc] initWithArray:[object objectForKey:ACTIONS_JSON_KEY]] count] > 0){
                action = [self generateActionFromDict:[[[NSArray alloc] initWithArray:[object objectForKey:ACTIONS_JSON_KEY]] objectAtIndex:0]];
                [action setImageToBeEnlarge:appearance.backgroundImage];
            }else{
                action = [[NodeAction alloc] init];
            }
            [action setObjectUUID:[NSString stringWithFormat:@"%@",[object objectForKey:UUID_JSON_KEY]]];
            
            if([[[NSArray alloc] initWithArray:[object objectForKey:TRANSITION_JSON_KEY]] count] > 0){
                transitions = [self generateTransitionFromDict:[[NSArray alloc] initWithArray:[object objectForKey:TRANSITION_JSON_KEY]]];
            }else{
                transitions = [[NSMutableArray alloc] init];
            }
            
            if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Button] ||
               [[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Text]){
                if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Button]){
                    [action setAssetType:Button];
                }else{
                    [action setAssetType:Text];
                }
                ButtonNode *btn = [[ButtonManager sharedInstance] generateNewButtonWithTransform:transform appearance:appearance Action:action andTransition:transitions];
                
                [scene addNewButton:btn];
                btn = nil;
            }else if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Image]){
                [action setAssetType:Image];
                ImageNode *img =[[ImageManager sharedInstance] generateNewImageWithTransform:transform appearance:appearance action:action andTransitions:transitions];
                
                [scene addNewImage:img];
                img = nil;
            }else if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Video]){
                [action setAssetType:Video];
                VideoNode *vdo = [[VideoManager sharedInstance] generateNewVideoWithTransform:transform appearance:appearance action:action andTransition:transitions];
                
                [scene addNewVideo:vdo];
                vdo = nil;
            }else if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Contact]){
                [action setAssetType:SaveContact];
                ContactNode *cntct = [[ContactManager sharedInstance] generateNewContactWithTransform:transform appearance:appearance Action:action andTransition:transitions];
                
                [scene addNewContact:cntct];
                cntct = nil;
                
            }else if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Event]){
                [action setAssetType:SaveEvent];
                EventNode *evnt = [[EventManager sharedInstance] generateNewEventWithTransform:transform appearance:appearance Action:action andTransition:transitions];
                
                [scene addNewEvent:evnt];
                evnt = nil;
                
            }else if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Sound]){
                [action setAssetType:Sound];
                
                SoundNode *snd = [[SoundManager sharedInstance] generateNewSoundWithTransform:transform appearance:appearance Action:action andTransition:transitions];
                [scene addNewSound:snd];
                snd = nil;
                
            }else if([[NSString stringWithFormat:@"%@",[object objectForKey:ASSET_JSON_KEY]] isEqualToString:NODE_TYPE_Model]){
                Model3D *mdl = [[Model3DManager sharedInstance] generateNewModelWithTransform:transform appearance:appearance action:action andTransition:transitions];
                
                [scene addNewModel:mdl];
                mdl = nil;
                
            }
            transform = nil;
            appearance = nil;
            action = nil;
            transitions = nil;
            
        }
        
        //scene
        [self.scenes addObject:scene];
        
    }
    
}
-(SceneNode *)fetchCurrentScene{
    if([self.scenes count] > 0){
        return [self.scenes objectAtIndex:currentActionSceneSLAM];
    }else{
        [[DownloadMngrr getInstance] invalidateDownload];
        return nil;
    }
}
-(void)openViewController:(UIViewController *)vc{
    [self.SLAMJSONManagerDelegate openViewController:vc];
}
-(void)pushonViewController:(UIViewController *)vc{
    [self.SLAMJSONManagerDelegate pushonViewController:vc];
}

- (void)dismissViewController {
    [self.SLAMJSONManagerDelegate dismissViewController];
    
}
-(void)goToSceneNumber:(int)sceneIndex{
    
}
-(NSMutableArray *)generateTransitionFromDict:(NSArray *)transitionArray{
    NSMutableArray *transitions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *transitionDict in transitionArray) {
        NodeTransition *transition = [[NodeTransition alloc] init];
        [transition setIsAlreadyInQ:false];
        if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:FADEIN_TRANSITION_KEY]){
            [transition setTransitionType:FadeIn];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEINFROMLEFT_TRANSITION_KEY]){
            [transition setTransitionType:SlideInFromLeft];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeIn];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
            
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEINFROMRIGHT_TRANSITION_KEY]){
            [transition setTransitionType:SlideInFromRight];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeIn];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEINFROMTOP_TRANSITION_KEY]){
            [transition setTransitionType:SlideInFromTop];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeIn];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEINFROMBOTTOM_TRANSITION_KEY]){
            [transition setTransitionType:SlideInFromBottom];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeIn];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SCALEUPWITHFADE_TRANSITION_KEY]){
            [transition setTransitionType:ScaleUpWithFade];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeIn];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SCALEDOWNWITHFADE_TRANSITION_KEY]){
            [transition setTransitionType:ScaleDownWithFade];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeOut];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEOUTFROMLEFT_TRANSITION_KEY]){
            [transition setTransitionType:SlideOutToLeft];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeOut];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEOUTFROMRIGHT_TRANSITION_KEY]){
            [transition setTransitionType:SlideOutToRight];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeOut];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEOUTFROMTOP_TRANSITION_KEY]){
            [transition setTransitionType:SlideOutToTop];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeOut];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SLIDEOUTFROMBOTTOM_TRANSITION_KEY]){
            [transition setTransitionType:SlideOutToBottom];
            NodeTransition *subTransition = [[NodeTransition alloc] init];
            [subTransition setTransitionType:FadeOut];
            [subTransition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
            [subTransition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
            [transitions addObject:subTransition];
        }else if([[NSString stringWithFormat:@"%@",[transitionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:FADEOUT_TRANSITION_KEY]){
            [transition setTransitionType:FadeOut];
        }
        
        [transition setLength:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:LENGTH_JSON_KEY]] floatValue]];
        [transition setDelay:[[NSString stringWithFormat:@"%@",[transitionDict objectForKey:DELAY_JSON_KEY]] floatValue]];
        
        [transitions addObject:transition];
        
    }
    
    
    return transitions;
}
-(NodeAction *)generateActionFromDict:(NSDictionary *)actionDictionary{
    NodeAction *actionN = [[NodeAction alloc] init];
    
    if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TRIGGER_JSON_KEY]] isEqualToString:TAP_TRIGGER_KEY]){
        [actionN setTriggerType:TriggerTypeTap];
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TRIGGER_JSON_KEY]] isEqualToString:ONVIDEOFINISH_TRIGGER_KEY]){
        [actionN setTriggerType:TriggerTypeOnVideoFinish];
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TRIGGER_JSON_KEY]] isEqualToString:ONSOUNDFINISH_TRIGGER_KEY]){
        [actionN setTriggerType:TriggerTypeOnSoundFinish];
    }
    if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:CALL_ACTION_KEY]){
        [actionN setActionType:ActionTypeCall];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:DESCRIPTIONBOX_ACTION_KEY]){
        [actionN setActionType:ActionDescriptionBox];
        [actionN setDescriptionBoxDict:[[NSDictionary alloc] initWithDictionary:[actionDictionary objectForKey:VALUE_JSON_KEY]]];

    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:URL_ACTION_KEY]){
        [actionN setActionType:ActionTypeURL];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:VIDEO360_ACTION_KEY]){
        [actionN setActionType:ActionType360Video];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:GOTOSCENE_ACTION_KEY]){
        [actionN setActionType:ActionTypeGoToScene];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:REPLAYVIDEO_ACTION_KEY]){
        [actionN setActionType:ActionTypeReplayVideo];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:AUDIOPLAY_ACTION_KEY]){
        [actionN setActionType:ActionTypePlayAudio];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:WHATSAPP_ACTION_KEY]){
        [actionN setActionType:ActionTypeWhatsApp];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:VIBERAPP_ACTION_KEY]){
        [actionN setActionType:ActionTypeViberApp];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:FBMESSENGER_ACTION_KEY]){
        [actionN setActionType:ActionTypeFBMessengerApp];
        [actionN setParamValue:[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:COMPOSE_EMAIL_ACTION_KEY]){
        [actionN setActionType:ActionTypeEmail];
        [actionN setParamDictionary:[[NSDictionary alloc] initWithDictionary:[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:SAVECONTACT_ACTION_KEY]){
        [actionN setActionType:ActionTypeSaveContact];
        [actionN setParamDictionary:[[NSDictionary alloc] initWithDictionary:[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:SAVEEVENT_ACTION_KEY]){
        [actionN setActionType:ActionTypeSaveEvent];
        [actionN setParamDictionary:[[NSDictionary alloc] initWithDictionary:[[actionDictionary objectForKey:VALUE_JSON_KEY] objectAtIndex:0]]];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:ENLARGEIMAGE_ACTION_KEY]){
        [actionN setActionType:ActionTypeEnlargeImage];
        
        
    }else if([[NSString stringWithFormat:@"%@",[actionDictionary objectForKey:TYPE_JSON_KEY]] isEqualToString:CAROUSEL_ACTION_KEY]){
        [actionN setActionType:ActionTypeCarousel];
        [actionN setParamDictionary:[[NSDictionary alloc] initWithDictionary:[actionDictionary objectForKey:VALUE_JSON_KEY]]];
        
    }
    
    [actionN setNodeActionDelegate:self];
    return actionN;
    
}

-(Transform *)generateTransformFromDict:(NSDictionary *)transformDictionary{
    
    Transform *transform = [[Transform alloc] init];
    if([transformDictionary objectForKey:POSX_JSON_KEY]){
        [transform setPosX:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:POSX_JSON_KEY]] floatValue]];
    }
    if([transformDictionary objectForKey:POSY_JSON_KEY]){
        [transform setPosY:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:POSY_JSON_KEY]] floatValue]];
    }
    if([transformDictionary objectForKey:POSZ_JSON_KEY]){
        [transform setPosZ:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:POSZ_JSON_KEY]] floatValue]];
    }
    
    
    if([transformDictionary objectForKey:ROTATE_X_JSON_KEY]){
        [transform setRotationX:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:ROTATE_X_JSON_KEY]] floatValue]];
    }
    if([transformDictionary objectForKey:ROTATE_Y_JSON_KEY]){
        [transform setRotationY:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:ROTATE_Y_JSON_KEY]] floatValue]];
    }
    if([transformDictionary objectForKey:ROTATE_Z_JSON_KEY]){
        [transform setRotationZ:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:ROTATE_Z_JSON_KEY]] floatValue]];
    }
    
    if([transformDictionary objectForKey:SCALEX_JSON_KEY]){
        [transform setScaleX:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:SCALEX_JSON_KEY]] floatValue]];
    }
    if([transformDictionary objectForKey:SCALEY_JSON_KEY]){
        [transform setScaleY:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:SCALEY_JSON_KEY]] floatValue]];
    }
    if([transformDictionary objectForKey:SCALEZ_JSON_KEY]){
        [transform setScaleZ:[[NSString stringWithFormat:@"%@",[transformDictionary objectForKey:SCALEZ_JSON_KEY]] floatValue]];
    }
    
    
    return transform;
    
}
-(Appearance *)generteAppearanceFromDict:(NSDictionary *)appearanceDictionary{
    NSString *st;
    Appearance *appearance = [[Appearance alloc] init];
    if([appearanceDictionary objectForKey:TITLE_JSON_KEY]){
        [appearance setTitle:[appearanceDictionary objectForKey:TITLE_JSON_KEY]];
    }
    if([appearanceDictionary objectForKey:OBJECT_JSON_KEY]){
        GLTFSceneSource *gl = [[GLTFSceneSource alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [appearanceDictionary objectForKey:OBJECT_JSON_KEY]]] options:nil];
        [appearance setGSceneSource:gl];
        gl = nil;
        
    }
    if([appearanceDictionary objectForKey:OBJECT_OFF_JSON_KEY]){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", [appearanceDictionary objectForKey:OBJECT_OFF_JSON_KEY]] ofType:@"glb"];
        
        if(filePath != NULL){
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            [appearance setGSceneSource:[[GLTFSceneSource alloc] initWithData:data options:nil]];
            filePath = nil;
            data = nil;

        }
    }
    if([appearanceDictionary objectForKey:THUMBNAIL_OFF_JSON_KEY]){
        UIImage *im = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [appearanceDictionary objectForKey:THUMBNAIL_OFF_JSON_KEY]]];
        
        [appearance setThumbnail:im];
        im = nil;
        
        
    }
    if([appearanceDictionary objectForKey:THUMBNAIL_JSON_KEY]){
        st = [NSString stringWithFormat:@"%@", [appearanceDictionary objectForKey:THUMBNAIL_JSON_KEY]];
        
        UIImage *im;
        if([st length] > 0){
            im = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:st]]];
        }else{
            im = [UIImage imageNamed:@"applicationPlaceHolder"];
        }
        [appearance setThumbnail:im];
        im = nil;
        
        
    }
    if([appearanceDictionary objectForKey:TITLE_JSON_KEY]){
        st = [NSString stringWithFormat:@"%@", [appearanceDictionary objectForKey:TITLE_JSON_KEY]];
        
        [appearance setTitle:st];
        
    }
    if([appearanceDictionary objectForKey:DESCRIPTION_JSON_KEY]){
        st = [appearanceDictionary objectForKey:DESCRIPTION_JSON_KEY];
    }
    if([appearanceDictionary objectForKey:BACKGROUND_JSON_KEY]){
        [appearance setBackgroundColor:[SceneManager colorFromHexString:[appearanceDictionary objectForKey:BACKGROUND_JSON_KEY]]];
    }
    if([appearanceDictionary objectForKey:SOUNDURL_JSON_KEY]){
        st = [appearanceDictionary objectForKey:SOUNDURL_JSON_KEY];
        
        [appearance setAudioURL:st];
        
    }
    if([appearanceDictionary objectForKey:ROTATION_JSON_KEY]){
        st = [appearanceDictionary objectForKey:ROTATION_JSON_KEY];
        
        [appearance setRotationY:st];
        
    }
    if([appearanceDictionary objectForKey:TEXTCOLOR_JSON_KEY]){
        [appearance setTextColor:[SceneManager colorFromHexString:[appearanceDictionary objectForKey:TEXTCOLOR_JSON_KEY]]];
    }
    if([appearanceDictionary objectForKey:BORDER_JSON_KEY]){
        [appearance setIsBorderEnabled:true];
        
        NSDictionary *borderDict = [appearanceDictionary objectForKey:BORDER_JSON_KEY];
        
        [appearance setBorderColor:[SceneManager colorFromHexString:[borderDict objectForKey:BACKGROUND_JSON_KEY]]];
        
        if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:BAVEL_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:BavelBorderType];
        }else if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SQUARE_FLAT_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:SquareBorderType];
        }else if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:ROUNDED_CORNER_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:RoundedBorderType];
        }else if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:ROUNDED_RAISED_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:RoundedRaisedBorderType];
        }else if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SQUARE_INDENTED_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:SquareIndentedType];
        }else if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:POLARIOD_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:PolariodType];
        }else if([[NSString stringWithFormat:@"%@",[borderDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SQUARE_RAISED_BORDER_TYPE_JSON_KEY]){
            [appearance setBorderType:SquareRaised];
        }
        st = [borderDict objectForKey:DEPTH_JSON_KEY];
        [appearance setBorderDepth:([st floatValue] / 100.0)];
        
    }
    
    if([appearanceDictionary objectForKey:BACKGROUND_JSON_KEY]){
        UIImage *im = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[appearanceDictionary objectForKey:BACKGROUND_JSON_KEY]]]]];
        
        [appearance setBackgroundImage:im];
        st = [appearanceDictionary objectForKey:BACKGROUND_JSON_KEY];
        
        [appearance setBackgroundImageURL:st];
        
    }if([appearanceDictionary objectForKey:VIDEOURL_JSON_KEY]){
        st = [appearanceDictionary objectForKey:VIDEOURL_JSON_KEY];
        [appearance setVideoURL:st];
    }
    
    st = nil;
    return appearance;
    
}
-(void)showPopup{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPopup" object:nil];
    
}
@end
