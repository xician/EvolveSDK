//
//  VideoNode.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 13/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "VideoNode.h"
#import "VariableMnr.h"
#import "AppearanceBorder.h"
@implementation VideoNode{
    SKScene *sceneVdo;
    SCNPlane *geomatryVdo;
    float posY;
    BOOL noteViewedYet;
    BOOL notPlayedYet;
    SCNNode *imgNode;
    AVPlayerItem *currentVideoItem;
    BOOL isEventPosted;
}

-(VideoNode *)generateNode{
    noteViewedYet = true;
    notPlayedYet = true;
    isEventPosted = false;
    _isPaused = false;
    imgNode = [[SCNNode alloc] init];
    if(self.appearance.videoURL != NULL){
        currentVideoItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.appearance.videoURL]];
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:currentVideoItem];
        [self.avPlayer setAllowsExternalPlayback:true];
        if([self.appearance isLoopVideo]){
            [self.avPlayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.avPlayer currentItem]];
        }
        
    self.videoNode = [[SKVideoNode alloc] initWithAVPlayer:self.avPlayer];
        [self.videoNode setSize:CGSizeMake(400, 400)];
        [self.videoNode setPosition:CGPointMake(200, 200)];
    sceneVdo = [[SKScene alloc] initWithSize:CGSizeMake(400, 400)];
    [sceneVdo setBackgroundColor:[UIColor blackColor]];
    [sceneVdo addChild:self.videoNode];
    geomatryVdo = [[SCNPlane alloc] init];
        [geomatryVdo setWidth:1];
        [geomatryVdo setHeight:1];

    [geomatryVdo.firstMaterial.diffuse setContents:sceneVdo];
    [geomatryVdo.firstMaterial setDoubleSided:true];
    posY = [VariableMnr.sharedInstance getZOrder] + ([self.transf posZ] / 100);

    [self setGeometry:geomatryVdo];
    [self setEulerAngles:SCNVector3Make((M_PI/-2)+[self.transf rotationX], M_PI-[[self.appearance rotationY] floatValue]+[self.transf rotationY], M_PI+[self.transf rotationZ])];
//        [self setEulerAngles:SCNVector3Make(([self.transf rotationX] - 4.7124) * (-1), [self.transf rotationZ], [self.transf rotationY])];

    }
    return self;
    
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero completionHandler:nil];
    
}
-(void)resizeCanvasScene:(CGSize)size{
    
    self.size = size;
    
    [sceneVdo setSize:CGSizeMake(size.width * 800, 112.3333333333/size.height)];
    [self.videoNode setSize:CGSizeMake(sceneVdo.size.width, sceneVdo.size.height)];

    [self.videoNode setPosition:CGPointMake(sceneVdo.size.width/2, sceneVdo.size.height/2)];
    
    float markerWidth = [[VariableMnr sharedInstance] campaignScaleX];
    float calculatedWidth = (self.transf.scaleX/markerWidth) * size.width;
    float markerHeight = [[VariableMnr sharedInstance] campaignScaleY];
    float calculatedHeight = (self.transf.scaleY/markerHeight) * size.height;
    
    if([self.appearance isBorderEnabled]){
        [[AppearanceBorder sharedInstance] applyBorderWithBorderType:[self.appearance borderType] ofColor:[self.appearance borderColor] depth:[self.appearance borderDepth] andNode:self withNodeWidth:geomatryVdo.width borderOn:BorderOnVideo andNodeHeight:geomatryVdo.height];
        
    }
    
    float pX = (size.width/2)*(self.transf.posX/(markerWidth/2));
    float pY = (size.height/2)*(self.transf.posY/(markerHeight/2));
    float pZ = (size.height/2)*(self.transf.posZ/(markerHeight/2));
    
    [self setPosition:SCNVector3Make(pX,pZ * (-1), pY*(-1))];
    [self setScale:SCNVector3Make(calculatedWidth, calculatedHeight, 0.01)];
    
    if(noteViewedYet){
        noteViewedYet = false;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
        [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
        [param setObject:NODE_TYPE_Video forKey:EVENT_ASSET_TYPE];

        [param setObject:EVENT_ASSET_VIEW forKey:EVENT_ACTION_TYPE];
        flurypost(EVENT_ACTION_TRIGGER, param, false, false);
        
        NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
        googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);
    }
}
-(void)stopCurrentPlaying{
    self.isPlaying = false;
    notPlayedYet = false;
    [self placePlayPauseButton];

}
-(void)playVideo{

    
        if([self.appearance isPlayOnStart]){
            if(!_isPaused){
                self.isPlaying = true;
                notPlayedYet = true;
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
                [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
                [param setObject:EVENT_PLAY_VIDEO forKey:EVENT_ASSET_TYPE];
                
                [param setObject:NODE_TYPE_Video forKey:EVENT_ASSET_TYPE];
                [param setObject:EVENT_PLAY_VIDEO forKey:EVENT_ACTION_TYPE];
                if(!isEventPosted){
                    isEventPosted = true;
                    flurypost(EVENT_ACTION_TRIGGER, param, false, false);
                    NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
                    googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);

                }

            }
        }else{
            if(notPlayedYet){
                self.isPlaying = false;
                notPlayedYet = false;
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
                [param setObject:[self.action objectUUID] forKey:EVENT_ASSET_ID];
                [param setObject:NODE_TYPE_Video forKey:EVENT_ASSET_TYPE];
                [param setObject:EVENT_PLAY_VIDEO forKey:EVENT_ACTION_TYPE];
                if(!isEventPosted){
                    isEventPosted = true;
                    flurypost(EVENT_ACTION_TRIGGER, param, false, false);
                    NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
                    googlepost(EVENT_ACTION_TRIGGER, NODE_TYPE_Contact, json, 0);

                }

            }
        }
        
    
    [self placePlayPauseButton];

}
-(SCNVector3)getWorldPositionForX:(float)posX andY:(float)posY{
    SCNVector3 position = SCNVector3Make((self.size.width * (posX/100)),0, (self.size.height * (posY/100)));
    return position;
}
-(void)placePlayPauseButton{
    
    SCNPlane *geomatryImg = [[SCNPlane alloc] init];
    [geomatryImg setWidth:0.25];
    [geomatryImg setHeight:0.25];
    
    SCNMaterial *imgMaterial = [[SCNMaterial alloc] init];
    [imgMaterial setDoubleSided:true];
    if(self.isPlaying){
        [imgMaterial.diffuse setContents:[UIImage imageNamed:@"videoPauseIcon"]];
        [self performSelector:@selector(hideButton) withObject:nil afterDelay:3.0];
        [self.avPlayer play];
        NSLog(@"zeeshan video Played");
    }else{
        [imgMaterial.diffuse setContents:[UIImage imageNamed:@"videoPlayIcon"]];
        [self.avPlayer pause];
        NSLog(@"zeeshan video paused");

    }
    
    [geomatryImg setMaterials:[[NSArray alloc] initWithObjects:imgMaterial, nil]];
    [imgNode setGeometry:geomatryImg];
    [imgNode setPosition:SCNVector3Make(0, 0, -0.1)];
    [imgNode setEulerAngles:SCNVector3Make(0,0,0)];
    [self addChildNode:imgNode];
    
}

-(void)hideButton{
    [UIView animateWithDuration:3.0 animations:^{
        if(self->_isPlaying){
            [self->imgNode setOpacity:0.0];
        }
    }];
}

-(void)videoTapped{
    _isPaused = true;
    if(self.isPlaying){
        NSLog(@"playing");
        self.isPlaying = false;
        [self.avPlayer pause];
    }else{
        self.isPlaying = true;
        NSLog(@"pause");
        [self.avPlayer play];
        
    }
    [imgNode setOpacity:1.0];
    [self placePlayPauseButton];
}
-(void)isVideoNode{
    
}
@end
