//
//  CarousalViewController.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 10/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "CarousalViewController.h"
#import "VariableMnr.h"
@interface CarousalViewController ()

@end

@implementation CarousalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pvOnboard setDelegate:self];
    [self.pvOnboard setDataSource:self];
    [self.pvOnboard setAlpha:0.0];
    [self showSearchingVisionCodeNavigationBar];

    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [self.pvOnboard reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.pvOnboard setAlpha:1.0];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfPagesInOneboardView:(nonnull PVOnboardView *)onboardView {
    return [self.carousalImages count];
}

- (nonnull UIView *)onboardView:(nonnull PVOnboardView *)onboardView viewForPageAtIndex:(NSInteger)index {
    
    UIView *view;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, self.view.frame.size.height-120)];
    
    [imgBack setImage:[[DownloadMngrr getInstance] getImageWithKey:[[VariableMnr sharedInstance] generateKeyFromURL:[NSString stringWithFormat:@"%@",[[self.carousalImages objectAtIndex:index] objectForKey:CAROUSEL_URLIMAGE_JSON_KEY]]]]];
    
    [imgBack setContentMode:UIViewContentModeScaleAspectFit];
    [imgBack setClipsToBounds:true];

    [imgBack setClipsToBounds:true];
    [view addSubview:imgBack];
    
    return view;
    
}
- (BOOL)onboardView:(nonnull PVOnboardView *)onboardView shouldHideRightActionButtonForPageAtIndex:(NSInteger)index{
    return false;
}

- (BOOL)onboardView:(nonnull PVOnboardView *)onboardView shouldHideLeftActionButtonForPageAtIndex:(NSInteger)index{
    if(index == 0){
        return true;
    }else{
        return false;
    }
}

- (nullable NSString *)onboardView:(nonnull PVOnboardView *)onboardView titleForRightActionButtonAtIndex:(NSInteger)index{
    if(index == ([self.carousalImages count] - 1)){
        return @"Finish";
    }else{
        return @"Next";
    }
}
- (nullable NSString *)onboardView:(nonnull PVOnboardView *)onboardView titleForLeftActionButtonAtIndex:(NSInteger)index{
    return @"Back";
}
- (void)onboardView:(nonnull PVOnboardView *)onboardView didTouchOnRightActionButtonAtIndex:(NSInteger)index{
    if(index == ([self.carousalImages count] - 1)){
        [self.navigationController popViewControllerAnimated:true];
    }else{
        // Next
        [self.pvOnboard scrollToNextPage:true];
    }
}

- (void)onboardView:(nonnull PVOnboardView *)onboardView didTouchOnLeftActionButtonAtIndex:(NSInteger)index{
    if(index > 0){
        // Back
        [self.pvOnboard scrollToPreviouslyPage:true];
    }
}
-(void)showSearchingVisionCodeNavigationBar{
    NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
    
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    
    [self.navigationItem setRightBarButtonItems:@[closeButton] animated:true];
    
    
}
-(void)closeView{
    [self.navigationController popViewControllerAnimated:true];
    
}

@end
