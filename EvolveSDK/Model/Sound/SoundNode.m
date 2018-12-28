//
//  SoundNode.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SoundNode.h"
#import "DownloadMngrr.h"
#import "VariableMnr.h"

@implementation SoundNode
SKScene *sceneImg;
SCNPlane *geomatryImg;
SCNMaterial *imgMaterial;
float zOrder;
SCNAction *action;
bool alreadyPlayed;
BOOL noteViewedYetSound;

-(SoundNode *)generateNode{
    noteViewedYetSound = true;
    self.avPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.appearance.audioURL]];
    
    alreadyPlayed = false;
    
    geomatryImg = [[SCNPlane alloc] init];
    [geomatryImg setWidth:1];
    [geomatryImg setHeight:1];
    
    imgMaterial = [[SCNMaterial alloc] init];
    [imgMaterial setDoubleSided:true];
    [imgMaterial.diffuse setContents:[self.appearance backgroundImage]];
    
    [geomatryImg setMaterials:[[NSArray alloc] initWithObjects:imgMaterial, nil]];
    zOrder = [VariableMnr.sharedInstance getZOrder] + ([self.transf posZ] / 100);
    [self setGeometry:geomatryImg];
    [self setPosition:SCNVector3Make(0, 0, 0)];
//    [self setEulerAngles:SCNVector3Make((M_PI/-2)+[self.transf rotationX], 0-[self.transf rotationY], 0+[self.transf rotationZ])];
    [self setEulerAngles:SCNVector3Make(([self.transf rotationX] - 4.7124) * (-1), [self.transf rotationZ], [self.transf rotationY])];

    
    return self;
    
}
-(void)playSound{
    if(!alreadyPlayed){
        [self.avPlayer play];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
        [param setObject:NODE_TYPE_Sound forKey:EVENT_ASSET_TYPE];
        [param setObject:EVENT_PLAY_AUDIO forKey:EVENT_ACTION_TYPE];
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);

    }

}

-(void)resizeCanvasScene:(CGSize)size{
    self.size = size;
    [sceneImg setSize:CGSizeMake(size.width * 100, size.height * 100)];
    
    float markerWidth = [[VariableMnr sharedInstance] campaignScaleX];
    float calculatedWidth = (self.transf.scaleX/markerWidth) * size.width;
    float markerHeight = [[VariableMnr sharedInstance] campaignScaleY];
    float calculatedHeight = (self.transf.scaleY/markerHeight) * size.height;
    
    [geomatryImg setWidth:calculatedWidth];
    [geomatryImg setHeight:calculatedHeight];
    
    if([self.appearance isBorderEnabled]){
        [geomatryImg setWidth:(geomatryImg.width - (geomatryImg.width * self.appearance.borderDepth))];
        [geomatryImg setHeight:(geomatryImg.height - (geomatryImg.height * self.appearance.borderDepth))];
        
    }
    
    float pX = (size.width/2)*(self.transf.posX/(markerWidth/2));
    float pY = (size.height/2)*(self.transf.posY/(markerHeight/2));
    float pZ = (size.height/2)*(self.transf.posZ/(markerHeight/2));
    
    [self setPosition:SCNVector3Make(pX,pZ * (-1), pY*(-1))];
    if(noteViewedYetSound){
        noteViewedYetSound = false;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
        [param setObject:NODE_TYPE_Sound forKey:EVENT_ASSET_TYPE];
        
        [param setObject:EVENT_ASSET_VIEW forKey:EVENT_ACTION_TYPE];
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);
    }

    
    
}
-(void)isSoundNode{
    
}
@end
