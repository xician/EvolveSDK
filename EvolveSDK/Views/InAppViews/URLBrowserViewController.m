//
//  URLBrowserViewController.m
//  ARKitImageRecognition
//
//  Created by Cresset Admin on 11/10/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "URLBrowserViewController.h"

@interface URLBrowserViewController ()

@end

@implementation URLBrowserViewController{
    WKWebView *wkWeb;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setTintColor:[SceneManager colorFromHexString:THEME_COLOR]];
    [self showSearchingVisionCodeNavigationBar];
    [[VariableMnr sharedInstance] Google_TrackingScreen:SCREENNAME_URLBROWSER];
    
    if(self.assetUUID){
        if([self.assetUUID length] > 0){
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[[VariableMnr sharedInstance] scannedCode] forKey:EVENT_CAMPAIGN_ID];
            [param setObject:self.assetUUID forKey:EVENT_ASSET_ID];
            [param setObject:self.url forKey:URL_ACTION_KEY];
            
            flurypost(SCREENNAME_URLBROWSER, param, false, false);
            NSString *json = [[VariableMnr sharedInstance] jsonStringWithPrettyPrint:param];
            googlepost(SCREENNAME_URLBROWSER, SCREENNAME_URLBROWSER, json, 0);

            
        }
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
    if([self.url containsString:@"//www.youtube.com/embed/"]){
        self.url = [[self.url stringByReplacingOccurrencesOfString:@"https://www.youtube.com/embed/" withString:@""] stringByReplacingOccurrencesOfString:@"?autoplay=1" withString:@""];
        [self.playerView setHidden:false];
        [self.webView setHidden:true];
        [self.playerView setDelegate:self];
        [self.playerView loadWithVideoId:self.url];
        
    }else{
        wkWeb = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webView.frame.size.width, self.webView.frame.size.height)];
        
        [self.webView addSubview:wkWeb];
        
        [wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        [wkWeb setAllowsBackForwardNavigationGestures:true];
        
        [wkWeb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [self.webView setHidden:false];
        [self.playerView setHidden:true];

    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context{
    if(wkWeb.estimatedProgress > 0.98){
        [self.webViewProgress setHidden:true];
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }
    if([keyPath isEqualToString:@"estimatedProgress"]){
        [self.webViewProgress setProgress:wkWeb.estimatedProgress];
    }
    NSLog(@"estimatedProgress %f",wkWeb.estimatedProgress);
}
- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    [playerView playVideo];
}
-(void)showSearchingVisionCodeNavigationBar{
    NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    
    [self.navigationItem setRightBarButtonItems:@[closeButton] animated:true];
    
    
}
-(void)closeView{
    [self.navigationController popViewControllerAnimated:true];
    
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
