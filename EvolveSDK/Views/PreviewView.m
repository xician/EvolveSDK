//
//  PreviewView.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 09/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "PreviewView.h"

@implementation PreviewView{
    AVCaptureSession *captureSession;
    AVCapturePhotoOutput *stillImageOutput;
    NSError *error;
}
-(void)generatePreview{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
