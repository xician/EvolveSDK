//
//  ContactManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ContactManager.h"

@implementation ContactManager

//Button Variable for Singleton Design Pattern.
static ContactManager *contact;

// Static mathod to get the shared instance of Button Node Class.
+(ContactManager *)sharedInstance{
    if(contact != NULL){
        return contact;
    }else{
        contact = [[ContactManager alloc] init];
        
        return contact;
    }
}

-(ContactNode *)generateNewContactWithTransform:(Transform *)transform appearance:(Appearance *)appearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;{
    
    ContactNode *contactNode = [[ContactNode alloc] init];
    [contactNode setTransf:transform];
    [contactNode setAppearance:appearance];
    [contactNode setAction:action];
    [contactNode setTransitions:transitions];
    return [contactNode generateNode];
}

@end
