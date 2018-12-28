//
//  NodeTransition.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "NodeTransition.h"
#import "ImageNode.h"
#import "VideoNode.h"
#import "ButtonNode.h"
@implementation NodeTransition{
    float initialScale;
}

-(void)executeTransitionForNode:(SCNNode *)node{
    if(self.transitionType == FadeIn){
        [node setOpacity:0.0];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            SCNAction *action = [SCNAction fadeOpacityTo:1.0 duration:self.length];
            [node runAction:action];
        });
        
    }else if(self.transitionType == FadeOut){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            SCNAction *action = [SCNAction fadeOpacityTo:0.0 duration:self.length];
            [node runAction:action];
        });

    }else if (self.transitionType == SlideInFromLeft){
        SCNVector3 initialPositionFromLeft = node.position;
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                imgn.transf.posX = imgn.transf.posX - 40;
                [imgn resizeCanvasScene:imgn.size];
                
                NSLog(@"Transition: %u",self.transitionType);
                SCNAction *action = [SCNAction moveTo:initialPositionFromLeft duration:self.length];
                [node runAction:action completionHandler:^{
                    imgn.transf.posX = imgn.transf.posX + 40;
                    [imgn resizeCanvasScene:imgn.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                vdon.transf.posX = vdon.transf.posX - 40;
                [vdon resizeCanvasScene:vdon.size];
                
                NSLog(@"Transition: %u",self.transitionType);
                SCNAction *action = [SCNAction moveTo:initialPositionFromLeft duration:self.length];
                [node runAction:action completionHandler:^{
                    vdon.transf.posX = vdon.transf.posX + 40;
                    [vdon resizeCanvasScene:vdon.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                btnn.transf.posX = btnn.transf.posX - 40;
                [btnn resizeCanvasScene:btnn.size];
                
                NSLog(@"Transition: %u",self.transitionType);
                SCNAction *action = [SCNAction moveTo:initialPositionFromLeft duration:self.length];
                [node runAction:action completionHandler:^{
                    btnn.transf.posX = btnn.transf.posX + 40;
                    [btnn resizeCanvasScene:btnn.size];
                    
                }];
                
            });
        }


        
    }else if (self.transitionType == SlideInFromRight){
        SCNVector3 initialPositionFromRight = node.position;
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                imgn.transf.posX = imgn.transf.posX + 40;
                [imgn resizeCanvasScene:imgn.size];
                
                NSLog(@"Transition: %u",self.transitionType);
                SCNAction *action = [SCNAction moveTo:initialPositionFromRight duration:self.length];
                [node runAction:action completionHandler:^{
                    imgn.transf.posX = imgn.transf.posX - 40;
                    [imgn resizeCanvasScene:imgn.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                vdon.transf.posX = vdon.transf.posX + 40;
                [vdon resizeCanvasScene:vdon.size];
                
                NSLog(@"Transition: %u",self.transitionType);
                SCNAction *action = [SCNAction moveTo:initialPositionFromRight duration:self.length];
                [node runAction:action completionHandler:^{
                    vdon.transf.posX = vdon.transf.posX - 40;
                    [vdon resizeCanvasScene:vdon.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                btnn.transf.posX = btnn.transf.posX + 40;
                [btnn resizeCanvasScene:btnn.size];
                
                NSLog(@"Transition: %u",self.transitionType);
                SCNAction *action = [SCNAction moveTo:initialPositionFromRight duration:self.length];
                [node runAction:action completionHandler:^{
                    btnn.transf.posX = btnn.transf.posX - 40;
                    [btnn resizeCanvasScene:btnn.size];
                    
                }];
                
            });
        }
        
    }else if (self.transitionType == SlideInFromTop){
        SCNVector3 initialPositionFromTop = node.position;
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                imgn.transf.posY = imgn.transf.posY + 40;
                [imgn resizeCanvasScene:imgn.size];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionFromTop duration:self.length];
                [node runAction:action completionHandler:^{
                    imgn.transf.posY = imgn.transf.posY - 40;
                    [imgn resizeCanvasScene:imgn.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                vdon.transf.posY = vdon.transf.posY + 40;
                [vdon resizeCanvasScene:vdon.size];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionFromTop duration:self.length];
                [node runAction:action completionHandler:^{
                    vdon.transf.posY = vdon.transf.posY - 40;
                    [vdon resizeCanvasScene:vdon.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                btnn.transf.posY = btnn.transf.posY + 40;
                [btnn resizeCanvasScene:btnn.size];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionFromTop duration:self.length];
                [node runAction:action completionHandler:^{
                    btnn.transf.posY = btnn.transf.posY - 40;
                    [btnn resizeCanvasScene:btnn.size];
                    
                }];
                
            });
        }
        
    }else if (self.transitionType == SlideInFromBottom){
        SCNVector3 initialPositionFromBottom = node.position;
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                imgn.transf.posY = imgn.transf.posY - 40;
                [imgn resizeCanvasScene:imgn.size];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionFromBottom duration:self.length];
                [node runAction:action completionHandler:^{
                    imgn.transf.posY = imgn.transf.posY + 40;
                    [imgn resizeCanvasScene:imgn.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                vdon.transf.posY = vdon.transf.posY - 40;
                [vdon resizeCanvasScene:vdon.size];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionFromBottom duration:self.length];
                [node runAction:action completionHandler:^{
                    vdon.transf.posY = vdon.transf.posY + 40;
                    [vdon resizeCanvasScene:vdon.size];
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                btnn.transf.posY = btnn.transf.posY - 40;
                [btnn resizeCanvasScene:btnn.size];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionFromBottom duration:self.length];
                [node runAction:action completionHandler:^{
                    btnn.transf.posY = btnn.transf.posY + 40;
                    [btnn resizeCanvasScene:btnn.size];
                    
                }];
                
            });
        }
        
    }else if (self.transitionType == SlideOutToTop){
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToTop = [imgn getWorldPositionForX:imgn.transf.posX andY:imgn.transf.posY-70];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToTop duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToTop = [vdon getWorldPositionForX:vdon.transf.posX andY:vdon.transf.posY-70];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToTop duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToTop = [btnn getWorldPositionForX:btnn.transf.posX andY:btnn.transf.posY-70];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToTop duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }
        
    }else if (self.transitionType == SlideOutToBottom){
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToBottom = [imgn getWorldPositionForX:imgn.transf.posX andY:imgn.transf.posY+70];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToBottom duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToBottom = [vdon getWorldPositionForX:vdon.transf.posX andY:vdon.transf.posY+70];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToBottom duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToBottom = [btnn getWorldPositionForX:btnn.transf.posX andY:btnn.transf.posY+70];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToBottom duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }
        
    }else if (self.transitionType == SlideOutToLeft){
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToLeft = [imgn getWorldPositionForX:imgn.transf.posX-70 andY:imgn.transf.posY];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToLeft duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }else if([node isKindOfClass:VideoNode.class]){
            VideoNode *vdon = (VideoNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToLeft = [vdon getWorldPositionForX:vdon.transf.posX-70 andY:vdon.transf.posY];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToLeft duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToLeft = [btnn getWorldPositionForX:btnn.transf.posX-70 andY:btnn.transf.posY];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToLeft duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
                
            });
        }
        
    }else if (self.transitionType == SlideOutToRight){
        if([node isKindOfClass:ImageNode.class]){
            ImageNode *imgn = (ImageNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToRight = [imgn getWorldPositionForX:imgn.transf.posX+70 andY:imgn.transf.posY];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToRight duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
            });
        }else if([node isKindOfClass:[VideoNode class]]){
            VideoNode *vdon = (VideoNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToRight = [vdon getWorldPositionForX:vdon.transf.posX+70 andY:vdon.transf.posY];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToRight duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
            });
        }else if([node isKindOfClass:ButtonNode.class]){
            ButtonNode *btnn = (ButtonNode *)node;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                SCNVector3 initialPositionToRight = [btnn getWorldPositionForX:btnn.transf.posX+70 andY:btnn.transf.posY];
                NSLog(@"Transition: %u",self.transitionType);
                
                SCNAction *action = [SCNAction moveTo:initialPositionToRight duration:self.length];
                [node runAction:action completionHandler:^{
                    
                }];
            });
        }
        
    }else if (self.transitionType == ScaleDownWithFade){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"Transition: %u",self.transitionType);

            SCNAction *action = [SCNAction scaleTo:0.0 duration:self.length];
            [node runAction:action completionHandler:^{
                
            }];
            
        });
    }else if (self.transitionType == ScaleUpWithFade){

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [node setScale:SCNVector3Make(0, 0, 0)];

            NSLog(@"Transition: %u",self.transitionType);

            SCNAction *action = [SCNAction scaleTo:1.0 duration:self.length];
            [node runAction:action completionHandler:^{
                
            }];
            
        });
    }
    
}

@end
