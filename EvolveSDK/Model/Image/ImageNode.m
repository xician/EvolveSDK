//
//  ImageNode.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ImageNode.h"
#import "DownloadMngrr.h"
#import "VariableMnr.h"
#import "AppearanceBorder.h"

@implementation ImageNode{
    SKScene *sceneImg;
    SCNPlane *geomatryImg;
    SCNMaterial *imgMaterial;
    float zOrder;
    bool noteViewedYet;
    
}
-(ImageNode *)generateNode{
    
    
    noteViewedYet = true;
    geomatryImg = [[SCNPlane alloc] init];
    [geomatryImg setWidth:1];
    [geomatryImg setHeight:1];
//    [geomatryImg setLength:0.005];
    imgMaterial = [[SCNMaterial alloc] init];
    [imgMaterial setDoubleSided:true];
    [imgMaterial.diffuse setContents:[self.appearance backgroundImage]];
    
    [geomatryImg setMaterials:[[NSArray alloc] initWithObjects:imgMaterial, nil]];
    zOrder = [VariableMnr.sharedInstance getZOrder] + ([self.transf posZ] / 100);
    [self setGeometry:geomatryImg];
    [self setPosition:SCNVector3Make(0, 0, 0)];
//    [self setEulerAngles:SCNVector3Make((M_PI/-2)+[self.transf rotationX], [self.transf rotationY] * (-1), [self.transf rotationZ])];
    
    [self setEulerAngles:SCNVector3Make(([self.transf rotationX] - 4.7124) * (-1), [self.transf rotationZ], [self.transf rotationY])];

    
    return self;
    
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
        [[AppearanceBorder sharedInstance] applyBorderWithBorderType:[self.appearance borderType] ofColor:[self.appearance borderColor] depth:[self.appearance borderDepth] andNode:self withNodeWidth:geomatryImg.width borderOn:BorderOnImage andNodeHeight:geomatryImg.height];
        
    }
    
    float pX = (size.width/2)*(self.transf.posX/(markerWidth/2));
    float pY = (size.height/2)*(self.transf.posY/(markerHeight/2));
    float pZ = (size.height/2)*(self.transf.posZ/(markerHeight/2));

    [self setPosition:SCNVector3Make(pX,pZ * (-1), pY*(-1))];

    if(noteViewedYet){
        noteViewedYet = false;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:[self.buttonAction objectUUID] forKey:EVENT_ASSET_ID];
        [param setObject:NODE_TYPE_Image forKey:EVENT_ASSET_TYPE];

        [param setObject:EVENT_ASSET_VIEW forKey:EVENT_ACTION_TYPE];
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);
    }
    
    
}
-(SCNVector3)getWorldPositionForX:(float)posX andY:(float)posY{
    SCNVector3 position = SCNVector3Make((self.size.width * (posX/100)),0, (self.size.height * (posY/100)));
    return position;
}
-(void)isImageNode{
    
}
@end
