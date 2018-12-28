//
//  CustomActionButton.h
//  ARKitImageRecognition
//
//  Created by Cresset Admin on 15/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeAction.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomActionButton : UIButton

@property (nonatomic, retain) NSDictionary *customData;
@property (nonatomic, retain) NodeAction *actionND;

@end

NS_ASSUME_NONNULL_END
