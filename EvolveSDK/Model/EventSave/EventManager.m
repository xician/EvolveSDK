//
//  EventManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager

//Button Variable for Singleton Design Pattern.
static EventManager *event;

// Static mathod to get the shared instance of Button Node Class.
+(EventManager *)sharedInstance{
    if(event != NULL){
        return event;
        
    }else{
        event = [[EventManager alloc] init];
        
        return event;
    }
}
                
-(EventNode *)generateNewEventWithTransform:(Transform *)transform appearance:(Appearance *)appearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions;{
    
    EventNode *eventNode = [[EventNode alloc] init];
    [eventNode setTransf:transform];
    [eventNode setAppearance:appearance];
    [eventNode setAction:action];
    [eventNode setTransitions:transitions];
    return [eventNode generateNode];
}

@end
