//
//  EvolveNavigationViewController.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 06/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "EvolveNavigationViewController.h"
#import "MainViewController.h"
@interface EvolveNavigationViewController ()

@end

@implementation EvolveNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
    -(void)initializeNavigationController{
        
        MainViewController *mainVC;
            mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        
            self.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:mainVC leftViewController:nil rightViewController:nil];
        
        
        self.sideMenuController.leftViewWidth = 280.0;
        self.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
        
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
