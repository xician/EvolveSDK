//
//  NodeAction.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "NodeAction.h"
#import "VariableMnr.h"
#import "URLBrowserViewController.h"
#import "Video360ViewController.h"
#import "CarousalViewController.h"

@implementation NodeAction{
    EKEventStore *eventStore;
    
}
-(void)callPhoneNumber{
    NSString *numberToCall = self.paramValue;
    [self openURLWithString:[NSString stringWithFormat:@"tel://%@",numberToCall]];
}
-(void)openURL{
    NSString *url = self.paramValue;
    URLBrowserViewController *urlBrowserVC = [[URLBrowserViewController alloc] initWithNibName:@"URLBrowserViewController" bundle:nil];
    [urlBrowserVC setUrl:url];
    [urlBrowserVC setCampaignID:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]]];
    [urlBrowserVC setAssetUUID:self.objectUUID];
    
    [[[[[VariableMnr sharedInstance] evolveNavigationController] visibleViewController] navigationController] pushViewController:urlBrowserVC animated:true];

//    [self openURLWithString:url];

}
-(void)load360Video{
    NSString *url = self.paramValue;
    Video360ViewController *video360 = [[Video360ViewController alloc] initWithNibName:@"Video360ViewController" bundle:nil];
    [video360 setUrl:url];
    [video360 setCampaignID:[NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] scannedCode]]];
    [video360 setAssetUUID:self.objectUUID];
    
    [[[[[VariableMnr sharedInstance] evolveNavigationController] visibleViewController] navigationController] pushViewController:video360 animated:true];

}

-(void)openURLWithString:(NSString *)urlString{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url options:[[NSDictionary alloc] init] completionHandler:nil];

}
-(void)showHostMessage{
    [[VariableMnr sharedInstance] hostappMsgboxWithTitle:@"" message:self.paramValue andButton:@"Ok"];
    
}
-(void)sendEmail{
    
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    [composeVC setToRecipients:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:EMAIL_JSON_KEY]], nil]];
    [composeVC setSubject:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:SUBJECT_JSON_KEY]]];
    
    if([self.paramDictionary objectForKey:BODY_JSON_KEY]){
        [composeVC setMessageBody:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:BODY_JSON_KEY]] isHTML:true];
    }
    
    [composeVC setMailComposeDelegate:[VariableMnr sharedInstance]];
    [[[[[VariableMnr sharedInstance] evolveNavigationController] visibleViewController] navigationController] presentViewController:composeVC animated:true completion:nil];

//    [self.nodeActionDelegate openViewController:composeVC];
    
}

-(void)loadWhatsApp{
    [self openURLWithString:[NSString stringWithFormat:@"https://api.whatsapp.com/send?phone=%@",self.paramValue]];

}
-(void)loadViberApp{
    [self openURLWithString:[NSString stringWithFormat:@"viber://add?number=%@",self.paramValue]];
    
}
-(void)loadFBMessenger{
    [self openURLWithString:[NSString stringWithFormat:@"https://www.messenger.com/t/%@",self.paramValue]];
    
}

-(void)showEventDetailBeforeGeneration{
    eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    if([self.paramDictionary objectForKey:@"title"]){
        [event setTitle:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"title"]]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    if([self.paramDictionary objectForKey:@"startdate"] && [self.paramDictionary objectForKey:@"starttime"]){
        NSDate *capturedStartDate = [dateFormatter dateFromString: [NSString stringWithFormat:@"%@ %@",[self.paramDictionary objectForKey:@"startdate"],[self.paramDictionary objectForKey:@"starttime"]]];
        [event setStartDate:capturedStartDate];
        
    }
    
    if([self.paramDictionary objectForKey:@"enddate"] && [self.paramDictionary objectForKey:@"endtime"]){
        NSDate *capturedStartDate = [dateFormatter dateFromString: [NSString stringWithFormat:@"%@ %@",[self.paramDictionary objectForKey:@"enddate"],[self.paramDictionary objectForKey:@"endtime"]]];
        [event setEndDate:capturedStartDate];
        
    }
    
    if([self.paramDictionary objectForKey:@"url"]){
        [event setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"url"]]]];
    }
    
    if([self.paramDictionary objectForKey:@"location"]){
        [event setLocation:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"location"]]];
    }
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    EKEventEditViewController *eventVC = [[EKEventEditViewController alloc] init];
    [eventVC setEvent:event];
    [eventVC setEventStore:eventStore];
    [eventVC setEditViewDelegate:self];
    [self.nodeActionDelegate openViewController:eventVC];
    
}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    [self.nodeActionDelegate dismissViewController];

}
-(void)saveEvent{
    [[[VariableMnr sharedInstance] saveEventLblVM] setText:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"title"]]]];
    
    float widthPopup = 200;
    
    [[[VariableMnr sharedInstance] eventViewVM] setFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height/2)-(widthPopup/2), widthPopup, widthPopup)];
    
    
    PopupView *pop = [PopupView popupViewWithContentView:[[VariableMnr sharedInstance] eventViewVM] showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeDarkBlur shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:true];
    
    
    [pop show];
    
    [pop setDidFinishDismissingCompletion:^{
        
    EKEventStore *es = [[EKEventStore alloc] init];

    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    BOOL needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);
    
    if (needsToRequestAccessToEventStore) {
        [es requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                [self showEventDetailBeforeGeneration];
            } else {
                // Denied
            }
        }];
    } else {
        BOOL granted = (authorizationStatus == EKAuthorizationStatusAuthorized);
        if (granted) {
            // Access granted
            [self showEventDetailBeforeGeneration];
        } else {
            // Denied
        }
    }

    }];
    
}
-(void)saveContact{
    
    
    [[[VariableMnr sharedInstance] saveContactLblVM] setText:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"firstname"]],[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"lastname"]]]];
    
    float widthPopup = 200;
    
    [[[VariableMnr sharedInstance] contactViewVM] setFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height/2)-(widthPopup/2), widthPopup, widthPopup)];
        
    
    PopupView *pop = [PopupView popupViewWithContentView:[[VariableMnr sharedInstance] contactViewVM] showType:PopupViewShowTypeBounceIn dismissType:PopupViewDismissTypeBounceOut maskType:PopupViewMaskTypeDarkBlur shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:true];
        
    
    [pop show];
        
    [pop setDidFinishDismissingCompletion:^{
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        if([self.paramDictionary objectForKey:@"image"]){
            contact.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"image"]]]];
        }
        
        
        if([self.paramDictionary objectForKey:@"firstname"]){
            contact.givenName = [NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"firstname"]];
        }
        if([self.paramDictionary objectForKey:@"companyname"]){
            contact.organizationName = [NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"companyname"]];
        }
        
        if([self.paramDictionary objectForKey:@"lastname"]){
            contact.familyName = [NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"lastname"]];
        }
        
        if([self.paramDictionary objectForKey:@"contacttype"]){
            if([[NSString stringWithFormat:@"%@",[self.paramDictionary objectForKey:@"contacttype"]] isEqualToString:@"person"]){
                [contact setContactType:CNContactTypePerson];
            }else{
                [contact setContactType:CNContactTypeOrganization];
            }
        }
        
        if([self.paramDictionary objectForKey:@"emails"]){
            NSArray *emailAddresses = [[NSArray alloc] initWithArray:[self.paramDictionary objectForKey:@"emails"]];
            NSMutableArray *emails = [[NSMutableArray alloc] init];
            for (NSDictionary *email in emailAddresses) {
                NSString *emailLbl = [NSString stringWithFormat:@"%@",[email objectForKey:@"label"]];
                NSString *emailAddress = [NSString stringWithFormat:@"%@",[email objectForKey:@"email"]];
                [emails addObject:[[CNLabeledValue alloc] initWithLabel:emailLbl value:emailAddress]];
                
            }
            [contact setEmailAddresses:emails];
            
        }
        
        if([self.paramDictionary objectForKey:@"postaladdress"]){
            NSArray *postalAddresses = [[NSArray alloc] initWithArray:[self.paramDictionary objectForKey:@"postaladdress"]];
            NSMutableArray *pAddr = [[NSMutableArray alloc] init];
            for (NSDictionary *pAddress in postalAddresses) {
                
                CNMutablePostalAddress *postalAddress = [[CNMutablePostalAddress alloc] init];
                [postalAddress setCity:[NSString stringWithFormat:@"%@",[pAddress objectForKey:@"city"]]];
                [postalAddress setCountry:[NSString stringWithFormat:@"%@",[pAddress objectForKey:@"country"]]];
                [postalAddress setState:[NSString stringWithFormat:@"%@",[pAddress objectForKey:@"state"]]];
                [postalAddress setStreet:[NSString stringWithFormat:@"%@",[pAddress objectForKey:@"street"]]];
                [pAddr addObject:[[CNLabeledValue alloc] initWithLabel:[NSString stringWithFormat:@"%@",[pAddress objectForKey:@"city"]] value:postalAddress]];
                
            }
            [contact setPostalAddresses:pAddr];
        }
        
        if([self.paramDictionary objectForKey:@"socialprofiles"]){
            NSArray *socialInformation = [[NSArray alloc] initWithArray:[self.paramDictionary objectForKey:@"socialprofiles"]];
            NSMutableArray *socials = [[NSMutableArray alloc] init];
            for (NSDictionary *sProfile in socialInformation) {
                
                
                NSString *socialProfileServiceName;
                if([[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"service"]] isEqualToString:@"facebook"]){
                    socialProfileServiceName = CNSocialProfileServiceFacebook;
                }else if([[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"service"]] isEqualToString:@"twitter"]){
                    socialProfileServiceName = CNSocialProfileServiceTwitter;
                }else if([[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"service"]] isEqualToString:@"linkedin"]){
                    socialProfileServiceName = CNSocialProfileServiceLinkedIn;
                }else{
                    socialProfileServiceName = [NSString stringWithFormat:@"%@",[sProfile objectForKey:@"service"]];
                }
                
                CNSocialProfile *socialP = [[CNSocialProfile alloc]
                                            initWithUrlString:[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"url"]]
                                            username:[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"username"]]
                                            userIdentifier:[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"username"]]
                                            service:socialProfileServiceName];
                
                [socials addObject:[[CNLabeledValue alloc] initWithLabel:[NSString stringWithFormat:@"%@",[sProfile objectForKey:@"service"]] value:socialP]];
                
                
            }
            [contact setSocialProfiles:socials];
            
        }
        
        if([self.paramDictionary objectForKey:@"phonenumber"]){
            NSArray *phoneNumbers = [[NSArray alloc] initWithArray:[self.paramDictionary objectForKey:@"phonenumber"]];
            NSMutableArray *numberToBeStore = [[NSMutableArray alloc] init];
            for (NSDictionary *number in phoneNumbers) {
                [numberToBeStore addObject:[[CNLabeledValue alloc] initWithLabel:[NSString stringWithFormat:@"%@",[number objectForKey:@"label"]] value:[[CNPhoneNumber alloc] initWithStringValue:[NSString stringWithFormat:@"%@",[number objectForKey:@"number"]]]]];
                
            }
            [contact setPhoneNumbers:numberToBeStore];
        }
        if([self.paramDictionary objectForKey:@"website"]){
            NSArray *urlAddresses = [[NSArray alloc] initWithArray:[self.paramDictionary objectForKey:@"website"]];
            NSMutableArray *urlToBeSave = [[NSMutableArray alloc] init];
            for (NSDictionary *url in urlAddresses) {
                [urlToBeSave addObject:[[CNLabeledValue alloc] initWithLabel:[NSString stringWithFormat:@"%@",[url objectForKey:@"label"]] value:[NSString stringWithFormat:@"%@",[url objectForKey:@"url"]]]];
                
            }
            [contact setUrlAddresses:urlToBeSave];
        }
        
        CNContactViewController *contactVC = [CNContactViewController viewControllerForUnknownContact:contact];
        [contactVC setDelegate:self];
        CNContactStore *conStore = [[CNContactStore alloc] init];
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if(status == CNAuthorizationStatusNotDetermined){
            [conStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted){
                    [contactVC setContactStore:conStore];
                    [self.nodeActionDelegate pushonViewController:contactVC];
                }
            }];
        }else if(status == CNAuthorizationStatusAuthorized){
            
            [contactVC setContactStore:conStore];
            [[[[[VariableMnr sharedInstance] evolveNavigationController] visibleViewController] navigationController] pushViewController:contactVC animated:true];
//            [self.nodeActionDelegate pushonViewController:contactVC];
            
        }else if(status == CNAuthorizationStatusDenied){
            
            NSLog(@"Permission Denied");
            
        }
    }];


}

-(void)goToScene{
    [self.nodeActionDelegate goToSceneNumber:[self.paramValue intValue]];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    [self.nodeActionDelegate dismissViewController];
}
-(void)enlargeImage{
    [[VariableMnr sharedInstance] setEnlargeImage:self.imageToBeEnlarge];
    [[NSNotificationCenter defaultCenter] postNotificationName:ENLARGEIMAGE_ACTION_KEY object:nil];
    
}
-(void)showDescriptionBox{
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SHOWDESCRIPTIONPOPUP_NOTIFICATION_KEY object:nil]];
    
}

-(void)triggerDescriptionBoxAction:(NSDictionary *)actionDict{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
    [param setObject:TAP_TRIGGER_KEY forKey:EVENT_TRIGGER_TYPE];
    [param setObject:_objectUUID forKey:UUID_JSON_KEY];

    NodeAction *action = [[NodeAction alloc] init];
    if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:CALL_ACTION_KEY]){
        [action setActionType:ActionTypeCall];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:URL_ACTION_KEY]){
        [action setActionType:ActionTypeURL];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:VIDEO360_ACTION_KEY]){
        [action setActionType:ActionType360Video];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:HOSTMESSAGE_ACTION_KEY]){
        [action setActionType:ActionTypeHostMessage];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:GOTOSCENE_ACTION_KEY]){
        [action setActionType:ActionTypeGoToScene];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:REPLAYVIDEO_ACTION_KEY]){
        [action setActionType:ActionTypeReplayVideo];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:AUDIOPLAY_ACTION_KEY]){
        [action setActionType:ActionTypePlayAudio];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:WHATSAPP_ACTION_KEY]){
        [action setActionType:ActionTypeWhatsApp];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:VIBERAPP_ACTION_KEY]){
        [action setActionType:ActionTypeViberApp];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:FBMESSENGER_ACTION_KEY]){
        [action setActionType:ActionTypeFBMessengerApp];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:COMPOSE_EMAIL_ACTION_KEY]){
        [action setActionType:ActionTypeEmail];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SAVECONTACT_ACTION_KEY]){
        [action setActionType:ActionTypeSaveContact];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:SAVEEVENT_ACTION_KEY]){
        [action setActionType:ActionTypeSaveEvent];
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:ENLARGEIMAGE_ACTION_KEY]){
        [action setActionType:ActionTypeEnlargeImage];
        
        
    }else if([[NSString stringWithFormat:@"%@",[actionDict objectForKey:TYPE_JSON_KEY]] isEqualToString:CAROUSEL_ACTION_KEY]){
        [action setActionType:ActionTypeCarousel];
        
    }
    
    ActionType type = action.actionType;
    if(type == ActionTypeCall){
        [param setObject:CALL_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [action setParamValue:[actionDict objectForKey:VALUE_JSON_KEY]];
        [action callPhoneNumber];
    }else if(type == ActionTypeURL){
        [param setObject:URL_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self openURL];
    }else if(type == ActionType360Video){
        [param setObject:VIDEO360_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self load360Video];
    }else if(type == ActionTypeHostMessage){
        [param setObject:HOSTMESSAGE_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self showHostMessage];
    }else if(type == ActionTypeWhatsApp){
        [param setObject:WHATSAPP_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self loadWhatsApp];
    }else if(type == ActionTypeViberApp){
        [param setObject:VIBERAPP_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self loadViberApp];
    }else if(type == ActionTypeEmail){
        [param setObject:EMAIL_JSON_KEY forKey:EVENT_ACTION_TYPE];
        [self sendEmail];
    }else if(type == ActionTypeSaveContact){
        [param setObject:SAVECONTACT_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self saveContact];
    }else if(type == ActionTypeEnlargeImage){
        [param setObject:ENLARGEIMAGE_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self enlargeImage];
    }else if(type == ActionTypeSaveEvent){
        [param setObject:SAVEEVENT_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self saveEvent];
    }else if(type == ActionTypeGoToScene){
        [param setObject:GOTOSCENE_ACTION_KEY forKey:EVENT_ACTION_TYPE];
        [self goToScene];
    }
    
    flurypost(EVENT_ACTION_TRIGGER, param, false, false);
    NSString *json = [NSString stringWithFormat:@"%@",[[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param]];
    NSString *actionStr = [NSString stringWithFormat:@"%@",[param objectForKey:EVENT_ACTION_TYPE]];
    googlepost(EVENT_ACTION_TRIGGER, actionStr, json,0);
    
}
-(void)showCarousal{
    CarousalViewController *carousal = [[CarousalViewController alloc] initWithNibName:@"CarousalViewController" bundle:nil];
    [carousal setCarousalImages:[NSMutableArray arrayWithArray:[self.paramDictionary objectForKey:CAROUSELIMAGES_JSON_KEY]]];
    [[[VariableMnr sharedInstance] navigationController] pushViewController:carousal animated:true];
//    [[[[[[VariableMnr sharedInstance] getAppDelegate] evolveNavigationController] visibleViewController] navigationController] pushViewController:carousal animated:true];

//    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setImagesArrayCarousel:[NSArray arrayWithArray:[self.paramDictionary objectForKey:CAROUSELIMAGES_JSON_KEY]]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWCAROUSEL_NOTIFICATION_KEY object:nil];
    
}
@end
