//
//  EvolveSDKController.m
//  EvolveSDK
//
//  Created by Cresset Admin on 28/12/2018.
//  Copyright © 2018 EvolveAR. All rights reserved.
//

#import "EvolveSDKController.h"
#import "Views/MainViewController.h"
@implementation EvolveSDKController
-(void)loadView:(UINavigationController *)navigationController{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle bundleForClass:[MainViewController self]]];
    [navigationController pushViewController:mainVC animated:true];
}

@end
