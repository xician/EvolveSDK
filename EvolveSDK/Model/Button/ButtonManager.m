//
//  ButtonManager.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ButtonManager.h"

@implementation ButtonManager

//Button Variable for Singleton Design Pattern.
static ButtonManager *btn;

// Static mathod to get the shared instance of Button Node Class.
+(ButtonManager *)sharedInstance{
    if(btn != NULL){
        return btn;
    }else{
        btn = [[ButtonManager alloc] init];
        btn.buttons = [[NSMutableArray alloc] init];
        
        return btn;
    }
}

-(ButtonNode *)generateNewButtonWithTransform:(Transform *)buttonTransform appearance:(Appearance *)buttonAppearance Action:(NodeAction *)action andTransition:(NSMutableArray *)transitions{
    
    ButtonNode *buttonNode = [[ButtonNode alloc] init];
    [buttonNode setTransf:buttonTransform];
    [buttonNode setAppearance:buttonAppearance];
    [buttonNode setButtonAction:action];
    [buttonNode setTransitions:transitions];
    return [buttonNode generateNode];
}

@end
