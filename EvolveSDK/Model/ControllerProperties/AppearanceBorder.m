//
//  AppearanceBorder.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 27/07/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "AppearanceBorder.h"

@implementation AppearanceBorder{
    BorderType iBorderType;
    UIColor *iBorderColor;
    float iDepth;
    SCNNode *iNode;
    float iNodeWidth;
    float iNodeHeight;
    int discreteInt;
    int isVideo;
    int yValue;
}

static AppearanceBorder *appeBorder;
+(AppearanceBorder *)sharedInstance{
    
    if(appeBorder != NULL){
        return appeBorder;
        
    }else{
        appeBorder = [[AppearanceBorder alloc] init];
        return appeBorder;
        
    }
    
}

-(void)applyBorderWithBorderType:(BorderType)borderType ofColor:(UIColor *)borderColor depth:(float)borderDepth andNode:(SCNNode *)node withNodeWidth:(float)nodeWidth borderOn:(BorderOn)parent andNodeHeight:(float)nodeHeight {
    iBorderType = borderType;
    iBorderColor = borderColor;
    iDepth = borderDepth;
    iNode = node;
    iNodeWidth = nodeWidth;
    iNodeHeight = nodeHeight;
    self.borderOn = parent;
    
    if(self.borderOn == BorderOnButton || self.borderOn == BorderOnVideo){
        discreteInt = -1;
        yValue = 1;
    }else{
        discreteInt = 1;
        yValue = -1;
    }
    
    if(self.borderOn == BorderOnImage){
        isVideo = 1;
    }else{
        isVideo = -1;
    }
    
    if(borderType == BavelBorderType){
        [self applyBavelBorderEffect];
    }else if(borderType == SquareBorderType){
        [self applySquareFlatBorder];
    }else if(borderType == RoundedBorderType){
        [self applyRoundedBorder];
    }else if(borderType == RoundedRaisedBorderType){
        [self applyRoundedRaisedBorder];
    }else if(borderType == SquareIndentedType){
        [self applySquareIndentedEffect];
    }else if(borderType == PolariodType){
        [self applyPolariodEffect];
    }else if(borderType == SquareRaised){
        [self applySquareRaisedBorder];
    }
    
}

-(void)applyBavelBorderEffect{
    SCNPlane *geomatryBorder;
    SCNPlane *geomatryBorderBG;
    geomatryBorder = [[SCNPlane alloc] init];
    [geomatryBorder setWidth:3];
    [geomatryBorder setHeight:2];
    
    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"bavelBorder.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    
    [geomatryBorder setMaterials:[[NSArray alloc] initWithObjects:borderMaterial, nil]];
    
    SCNNode *borderNode = [[SCNNode alloc] init];
    [borderNode setPosition:SCNVector3Make(0, 0, -0.001 * discreteInt)];
    [borderNode setGeometry:geomatryBorder];
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, 0, -0.002 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    
    [geomatryBorder setWidth:iNodeWidth + (iNodeWidth * iDepth)];
    [geomatryBorder setHeight:iNodeHeight + (iNodeHeight * iDepth)];
    
    [geomatryBorderBG setWidth:iNodeWidth + (iNodeWidth * iDepth)];
    [geomatryBorderBG setHeight:iNodeHeight + (iNodeHeight * iDepth)];
    
    [borderNode setName:@"borderNode"];
    [borderBGNode setName:@"borderBGNode"];
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderNode" recursively:true] with:borderNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
    }else{
        [iNode addChildNode:borderBGNode];
        [iNode addChildNode:borderNode];
    }
}

-(void)applySquareRaisedBorder{
    SCNPlane *geomatryBorderBG;
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, 0, -0.001 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    float value1 = iNodeWidth * iDepth;
    float value2 = iNodeHeight * iDepth;
    if(value1 > value2){
        value1 = value2;
    }
    [geomatryBorderBG setWidth:iNodeWidth + value1];
    [geomatryBorderBG setHeight:iNodeHeight + value2];
    [borderBGNode setName:@"borderBGNode"];
    
    SCNPlane *geomatryBorderBGShadeGray;
    geomatryBorderBGShadeGray = [[SCNPlane alloc] init];
    [geomatryBorderBGShadeGray setWidth:3];
    [geomatryBorderBGShadeGray setHeight:2];
    SKScene *sceneImgBG = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImgBG setBackgroundColor:[UIColor blackColor]];
    SCNMaterial *borderBGMaterialShadeGray = [[SCNMaterial alloc] init];
    [borderBGMaterialShadeGray setDoubleSided:true];
    [borderBGMaterialShadeGray.diffuse setContents:sceneImgBG];
    [geomatryBorderBGShadeGray setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterialShadeGray, nil]];
    SCNNode *borderBGNodeShadeGray = [[SCNNode alloc] init];
    [borderBGNodeShadeGray setPosition:SCNVector3Make((iNodeHeight * iDepth) * 0.1, (iNodeHeight * iDepth) * (0.1 * yValue), -0.0011 * discreteInt)];
    [borderBGNodeShadeGray setGeometry:geomatryBorderBGShadeGray];
    float value3 = iNodeWidth * iDepth;
    float value4 = iNodeHeight * iDepth ;
    
    if(value3 > value4){
        value3 = value4;
    }
    
    [geomatryBorderBGShadeGray setWidth:iNodeWidth + value3];
    [geomatryBorderBGShadeGray setHeight:iNodeHeight + value3];
    [borderBGNodeShadeGray setName:@"borderBGNode123"];
    [borderBGNodeShadeGray setOpacity:0.5];
    
    
//    SCNPlane *geomatryBorderBGShadeColor;
//    geomatryBorderBGShadeColor = [[SCNPlane alloc] init];
//    [geomatryBorderBGShadeColor setWidth:3];
//    [geomatryBorderBGShadeColor setHeight:2];
//    SKScene *sceneImgBGColor = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
//    [sceneImgBGColor setBackgroundColor:iBorderColor];
//    SCNMaterial *borderBGMaterialColor = [[SCNMaterial alloc] init];
//    [borderBGMaterialColor setDoubleSided:true];
//    [borderBGMaterialColor.diffuse setContents:sceneImgBGColor];
//    [geomatryBorderBGShadeColor setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterialColor, nil]];
//    SCNNode *borderBGNodeColor = [[SCNNode alloc] init];
//    [borderBGNodeColor setPosition:SCNVector3Make(0, (iNodeHeight * iDepth) * 0.2, -0.0012 * discreteInt)];
//    [borderBGNodeColor setGeometry:geomatryBorderBGShadeColor];
//    float value5 = iNodeWidth * iDepth;
//    float value6 = iNodeHeight * iDepth ;
//
//    if(value5 > value6){
//        value5 = value6;
//    }
//
//    [geomatryBorderBGShadeColor setWidth:iNodeWidth + value5];
//    [geomatryBorderBGShadeColor setHeight:iNodeHeight + value6];
//    [borderBGNodeColor setName:@"borderBGNode123Color"];
    
    
    
    
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode123" recursively:true] with:borderBGNodeShadeGray];
//        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode123Color" recursively:true] with:borderBGNodeColor];
    }else{
        [iNode addChildNode:borderBGNode];
        [iNode addChildNode:borderBGNodeShadeGray];
//        [iNode addChildNode:borderBGNodeColor];
    }
}

-(void)applySquareFlatBorder{
    SCNPlane *geomatryBorderBG;

    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"bavelBorder.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, 0, -0.001 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    float value1 = iNodeWidth * iDepth;
    float value2 = iNodeHeight * iDepth;
    
    if(value1 > value2){
        value1 = value2;
    }
    [geomatryBorderBG setWidth:iNodeWidth + value1];
    [geomatryBorderBG setHeight:iNodeHeight + value1];
    
    [borderBGNode setName:@"borderBGNode"];
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
    }else{
        [iNode addChildNode:borderBGNode];
    }
}

-(void)applyRoundedRaisedBorder{
    SCNPlane *geomatryBorderBG;
    
    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"bavelBorder.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    [geomatryBorderBG setCornerRadius:iNodeWidth*0.1];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, 0, -0.001 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    
    float value1 = iNodeWidth * iDepth;
    float value2 = iNodeHeight * iDepth;
    
    if(value1 > value2){
        value1 = value2;
    }
    [geomatryBorderBG setWidth:iNodeWidth + value1];
    [geomatryBorderBG setHeight:iNodeHeight + value1];

    [borderBGNode setName:@"borderBGNode"];
    
    SCNPlane *geomatryBorderBGShadeGray;
    geomatryBorderBGShadeGray = [[SCNPlane alloc] init];
    [geomatryBorderBGShadeGray setWidth:3];
    [geomatryBorderBGShadeGray setHeight:2];
    [geomatryBorderBGShadeGray setCornerRadius:iNodeWidth*0.1];

    SKScene *sceneImgBG = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImgBG setBackgroundColor:[UIColor blackColor]];
    SCNMaterial *borderBGMaterialShadeGray = [[SCNMaterial alloc] init];
    [borderBGMaterialShadeGray setDoubleSided:true];
    [borderBGMaterialShadeGray.diffuse setContents:sceneImgBG];
    [geomatryBorderBGShadeGray setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterialShadeGray, nil]];
    SCNNode *borderBGNodeShadeGray = [[SCNNode alloc] init];
    [borderBGNodeShadeGray setPosition:SCNVector3Make((iNodeHeight * iDepth) * 0.1, (iNodeHeight * iDepth) * (0.1 * yValue), -0.0011 * discreteInt)];
    [borderBGNodeShadeGray setGeometry:geomatryBorderBGShadeGray];
    float value3 = iNodeWidth * iDepth;
    float value4 = iNodeHeight * iDepth ;
    
    if(value3 > value4){
        value3 = value4;
    }
    
    [geomatryBorderBGShadeGray setWidth:iNodeWidth + value3];
    [geomatryBorderBGShadeGray setHeight:iNodeHeight + value3];
    [borderBGNodeShadeGray setName:@"borderBGNode123"];
    [borderBGNodeShadeGray setOpacity:0.5];
    
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode123" recursively:true] with:borderBGNodeShadeGray];
    }else{
        [iNode addChildNode:borderBGNode];
        [iNode addChildNode:borderBGNodeShadeGray];
    }
}

-(void)applyRoundedBorder{
    SCNPlane *geomatryBorderBG;
    
    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"bavelBorder.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    [geomatryBorderBG setCornerRadius:iNodeWidth*0.1];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, 0, -0.001 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    
    float value1 = iNodeWidth * iDepth;
    float value2 = iNodeHeight * iDepth;
    
    if(value1 > value2){
        value1 = value2;
    }
    [geomatryBorderBG setWidth:iNodeWidth + value1];
    [geomatryBorderBG setHeight:iNodeHeight + value1];
    
    [borderBGNode setName:@"borderBGNode"];
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
    }else{
        [iNode addChildNode:borderBGNode];
    }
}

-(void)applySquareIndentedEffect{
    
    SCNPlane *geomatryBorder;
    SCNPlane *geomatryBorderBG;
    geomatryBorder = [[SCNPlane alloc] init];
    [geomatryBorder setWidth:3];
    [geomatryBorder setHeight:2];
    
    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"boxInnerShadow.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    [geomatryBorder setMaterials:[[NSArray alloc] initWithObjects:borderMaterial, nil]];
    
    SCNNode *borderNode = [[SCNNode alloc] init];
    [borderNode setPosition:SCNVector3Make(0, 0, 0.001 * discreteInt)];
    [borderNode setGeometry:geomatryBorder];
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, 0, -0.001 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    
    [geomatryBorder setWidth:iNodeWidth];
    [geomatryBorder setHeight:iNodeHeight];
    
    float value1 = iNodeWidth * iDepth;
    float value2 = iNodeHeight * iDepth;
    
    if(value1 > value2){
        value1 = value2;
    }
    [geomatryBorderBG setWidth:iNodeWidth + value1];
    [geomatryBorderBG setHeight:iNodeHeight + value1];
    
    [borderNode setName:@"borderNode"];
    [borderBGNode setName:@"borderBGNode"];
    
    
    
    SCNPlane *geomatryBorderBGShadeGray;
    geomatryBorderBGShadeGray = [[SCNPlane alloc] init];
    [geomatryBorderBGShadeGray setWidth:3];
    [geomatryBorderBGShadeGray setHeight:2];
    SKScene *sceneImgBG = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImgBG setBackgroundColor:[UIColor blackColor]];
    SCNMaterial *borderBGMaterialShadeGray = [[SCNMaterial alloc] init];
    [borderBGMaterialShadeGray setDoubleSided:true];
    [borderBGMaterialShadeGray.diffuse setContents:sceneImgBG];
    [geomatryBorderBGShadeGray setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterialShadeGray, nil]];
    SCNNode *borderBGNodeShadeGray = [[SCNNode alloc] init];
    [borderBGNodeShadeGray setPosition:SCNVector3Make((iNodeHeight * iDepth) * 0.1, (iNodeHeight * iDepth) * (0.1 * yValue), -0.0011 * discreteInt)];
    [borderBGNodeShadeGray setGeometry:geomatryBorderBGShadeGray];
    float value3 = iNodeWidth * iDepth;
    float value4 = iNodeHeight * iDepth ;
    
    if(value3 > value4){
        value3 = value4;
    }
    
    [geomatryBorderBGShadeGray setWidth:iNodeWidth + value3];
    [geomatryBorderBGShadeGray setHeight:iNodeHeight + value3];
    [borderBGNodeShadeGray setName:@"borderBGNode123"];
    [borderBGNodeShadeGray setOpacity:0.5];
    
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderNode" recursively:true] with:borderNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode123" recursively:true] with:borderBGNodeShadeGray];
    }else{
        [iNode addChildNode:borderNode];
        [iNode addChildNode:borderBGNode];
        [iNode addChildNode:borderBGNodeShadeGray];
    }
    
}

-(void)applyPolariodEffect{
    SCNPlane *geomatryBorder;
    SCNPlane *geomatryBorderBG;
    geomatryBorder = [[SCNPlane alloc] init];
    [geomatryBorder setWidth:3];
    [geomatryBorder setHeight:2];
    
    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"boxInnerShadow.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    
    [geomatryBorder setMaterials:[[NSArray alloc] initWithObjects:borderMaterial, nil]];
    
    SCNNode *borderNode = [[SCNNode alloc] init];
    [borderNode setPosition:SCNVector3Make(0, 0, 0.001 * discreteInt)];
    [borderNode setGeometry:geomatryBorder];
//    iNodeWidth = 100;
//    iNodeHeight = 100;
    
    float value1 = iNodeWidth;
    float value2 = iNodeHeight;
//    iDepth = iDepth * 100;
    
    value2 = (value2 + (iNodeHeight * iDepth));
    
    value2 = value2 + (iNodeHeight * (iDepth * 0.5));
    value1 = value1 + (iNodeWidth * (iDepth * 0.5));
    
    float y = (value2 - value1) / (-3.82348952) ;
    
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, y * isVideo, -0.002 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    
    [geomatryBorder setWidth:iNodeWidth];
    [geomatryBorder setHeight:iNodeHeight];
    
    [geomatryBorderBG setWidth:value1];
    [geomatryBorderBG setHeight:value2];
    
    [borderNode setName:@"borderNode"];
    [borderBGNode setName:@"borderBGNode"];
    
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderNode" recursively:true] with:borderNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
    }else{
        [iNode addChildNode:borderNode];
        [iNode addChildNode:borderBGNode];
    }
}

-(void)applyPolariodEffectForImage{
    SCNPlane *geomatryBorder;
    SCNPlane *geomatryBorderBG;
    geomatryBorder = [[SCNPlane alloc] init];
    [geomatryBorder setWidth:3];
    [geomatryBorder setHeight:2];
    
    SCNMaterial *borderMaterial = [[SCNMaterial alloc] init];
    [borderMaterial setDoubleSided:true];
    [borderMaterial.diffuse setContents:@"boxInnerShadow.png"];
    
    geomatryBorderBG = [[SCNPlane alloc] init];
    [geomatryBorderBG setWidth:3];
    [geomatryBorderBG setHeight:2];
    
    SKScene *sceneImg = [[SKScene alloc] initWithSize:CGSizeMake(100, 50)];
    [sceneImg setBackgroundColor:iBorderColor];
    SCNMaterial *borderBGMaterial = [[SCNMaterial alloc] init];
    [borderBGMaterial setDoubleSided:true];
    [borderBGMaterial.diffuse setContents:sceneImg];
    [geomatryBorderBG setMaterials:[[NSArray alloc] initWithObjects:borderBGMaterial, nil]];
    
    [geomatryBorder setMaterials:[[NSArray alloc] initWithObjects:borderMaterial, nil]];
    
    SCNNode *borderNode = [[SCNNode alloc] init];
    [borderNode setPosition:SCNVector3Make(0, 0, 0.001 * discreteInt)];
    [borderNode setGeometry:geomatryBorder];
    
    float value1 = iNodeWidth * 0.10;
    float value2 = iNodeHeight * 0.10;
    value2 += (value2 + (iNodeHeight * iDepth));
    
    SCNNode *borderBGNode = [[SCNNode alloc] init];
    [borderBGNode setPosition:SCNVector3Make(0, ((iNodeHeight * iDepth) / -1) * isVideo, -0.002 * discreteInt)];
    [borderBGNode setGeometry:geomatryBorderBG];
    
    [geomatryBorder setWidth:iNodeWidth];
    [geomatryBorder setHeight:iNodeHeight];
    
    [geomatryBorderBG setWidth:iNodeWidth + value1];
    [geomatryBorderBG setHeight:iNodeHeight + value2];
    
    [borderNode setName:@"borderNode"];
    [borderBGNode setName:@"borderBGNode"];
    
    if([[iNode childNodes] count] > 1){
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderNode" recursively:true] with:borderNode];
        [iNode replaceChildNode:[iNode childNodeWithName:@"borderBGNode" recursively:true] with:borderBGNode];
    }else{
        [iNode addChildNode:borderNode];
        [iNode addChildNode:borderBGNode];
    }
}
@end
