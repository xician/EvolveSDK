//
//  EventNode.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "EventNode.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>
#import "SceneManager.h"
#import "VariableMnr.h"
#import "AppearanceBorder.h"

@implementation EventNode{
    SCNPlane *geomatryBtn;
    SCNMaterial *btnMaterial;
    SKScene *sceneBtn;
    SCNText *labelNode;
    float widthOfTextNode;
    float posY;
    BOOL noteViewedYet;

}
-(EventNode *)generateNode{
    noteViewedYet = true;
    sceneBtn = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    if([self.appearance backgroundColor]){
        [sceneBtn setBackgroundColor:[self.appearance backgroundColor]];
    }else{
        [sceneBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    geomatryBtn = [[SCNPlane alloc] init];
    [geomatryBtn setWidth:1];
    [geomatryBtn setHeight:1];
    
    btnMaterial = [[SCNMaterial alloc] init];
    [btnMaterial setDoubleSided:true];
    
    [btnMaterial.diffuse setContents:[UIImage imageNamed:@"eventSaveBG.png"]];
    
    [geomatryBtn setMaterials:[[NSArray alloc] initWithObjects:btnMaterial, nil]];
    posY = [VariableMnr.sharedInstance getZOrder] + ([self.transf posZ] / 100);
    [self setGeometry:geomatryBtn];
    [self setPosition:SCNVector3Make(0, 0, 0)];
//    [self setEulerAngles:SCNVector3Make((M_PI/-2)+[self.transf rotationX], 0-[self.transf rotationY], 0+[self.transf rotationZ])];
    [self setEulerAngles:SCNVector3Make(([self.transf rotationX] - 4.7124) * (-1), [self.transf rotationZ], [self.transf rotationY])];

    /// Add text to button
    labelNode = [SCNText textWithString:[NSString stringWithFormat:@"%@",[self.action.paramDictionary objectForKey:@"title"]] extrusionDepth:0.1];
    SCNMaterial *frontMaterial = [SCNMaterial material];
    UIColor *textColor = [UIColor colorWithRed:81.0/255.0 green:156.0/255.0 blue:233.0/255.0 alpha:1.0];
    
    [frontMaterial.diffuse setContents:textColor];
    SCNMaterial *backMaterial = [SCNMaterial material];
    backMaterial.diffuse.contents = textColor;
    SCNMaterial *sideMaterial = [SCNMaterial material];
    sideMaterial.diffuse.contents = textColor;
    labelNode.materials = @[ frontMaterial, backMaterial, sideMaterial ];
    
    [labelNode setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    //  [labelNode setTruncationMode:kCATruncationStart];
    [labelNode setAlignmentMode:kCAAlignmentCenter];
    [labelNode setTruncationMode:kCATruncationMiddle];
    [labelNode setWrapped:true];
    self.textNode = [SCNNode nodeWithGeometry:labelNode];
    SCNVector3 v1 = SCNVector3Make(0, 0, 0);
    SCNVector3 v2 = SCNVector3Make(0, 0, 0);
    [self.textNode getBoundingBoxMin:&v1 max:&v2];
    widthOfTextNode = v2.x - v1.x;
    NSLog(@"width of text node; %f",widthOfTextNode);
    
    [self.textNode setScale:SCNVector3Make(0.724007808/widthOfTextNode,0.010,0.01)];
    [self.textNode setEulerAngles:SCNVector3Make(0, 0, 0)];
    
    [self addChildNode:self.textNode];
    
    return self;
}
-(void)resizeCanvasScene:(CGSize)size{
    
    self.size = size;
    [sceneBtn setSize:CGSizeMake(size.width * 100, size.height * 100)];
    
    float markerWidth = [[VariableMnr sharedInstance] campaignScaleX];
    float calculatedWidth = (self.transf.scaleX/markerWidth) * size.width;
    float markerHeight = [[VariableMnr sharedInstance] campaignScaleY];
    float calculatedHeight = (self.transf.scaleY/markerHeight) * size.height;
    
    [geomatryBtn setWidth:1];
    [geomatryBtn setHeight:1];
    
    if([self.appearance isBorderEnabled]){
        [geomatryBtn setWidth:(geomatryBtn.width - (geomatryBtn.width * self.appearance.borderDepth))];
        [geomatryBtn setHeight:(geomatryBtn.height - (geomatryBtn.height * self.appearance.borderDepth))];
        
        [[AppearanceBorder sharedInstance] applyBorderWithBorderType:[self.appearance borderType] ofColor:[self.appearance borderColor] depth:[self.appearance borderDepth] andNode:self withNodeWidth:geomatryBtn.width borderOn:BorderOnImage andNodeHeight:geomatryBtn.height];
    }
    
    float pX = (size.width/2)*(self.transf.posX/(markerWidth/2));
    float pY = (size.height/2)*(self.transf.posY/(markerHeight/2));
    float pZ = (size.height/2)*(self.transf.posZ/(markerHeight/2));
    
    [self setPosition:SCNVector3Make(pX,pZ * (-1), pY*(-1))];
    [self setScale:SCNVector3Make(calculatedWidth, calculatedHeight, 1)];
    //    [self.textNode setPosition:SCNVector3Make(-calculatedWidth, -calculatedHeight,0.0001)];
    
    //    float wx = calculatedWidth/56.2431992;
    //    float hx = calculatedHeight/14.235870875;
    
    //    [self.textNode setScale:SCNVector3Make(wx,hx,0.005)];
    
    [self.textNode setPosition:SCNVector3Make(geomatryBtn.width*-0.35, geomatryBtn.height*-0.12,0)];
    if(noteViewedYet){
        noteViewedYet = false;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
        [param setObject:NODE_TYPE_Event forKey:EVENT_ASSET_TYPE];
        [param setObject:EVENT_ASSET_VIEW forKey:EVENT_ACTION_TYPE];
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Event, json, 0);
    }

}
-(SCNVector3)getWorldPositionForX:(float)posX andY:(float)posY{
    SCNVector3 position = SCNVector3Make((self.size.width * (posX/100)),0, (self.size.height * (posY/100)));
    return position;
}
-(void)isEventNode{
    
}
@end
