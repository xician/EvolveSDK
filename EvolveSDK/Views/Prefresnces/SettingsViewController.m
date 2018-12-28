//
//  SettingsViewController.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 08/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SettingsViewController.h"
#import "VariableMnr.h"
#import "SettingsTableViewCell.h"
#import "URLBrowserViewController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    NSMutableArray *arr;
    BOOL isRecentRecords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showRecentCodeNavigationBar];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    if([self.codesType isEqualToString:@"settings"]){
        isRecentRecords = true;
        arr = [self fetchSettingsMenuItems];
        [[VariableMnr sharedInstance] Google_TrackingScreen:SCREENNAME_SETTINGS];
    }else{
        isRecentRecords = false;
        arr = [self fetchSupportMenuItems];
        [[VariableMnr sharedInstance] Google_TrackingScreen:SCREENNAME_SUPPORT];
        
    }
    [self.tblView reloadData];

}
-(NSMutableArray *)fetchSettingsMenuItems{
    arr = [[NSMutableArray alloc] init];

//    [arr addObject:@"Change age group"];
    [arr addObject:@"Privacy Policy"];
    [arr addObject:@"Terms of Use"];
//    [arr addObject:@"Version Information"];
    return arr;
}
-(NSMutableArray *)fetchSupportMenuItems{
    arr = [[NSMutableArray alloc] init];

    [arr addObject:@"Visit Support"];
    [arr addObject:@"Visit EvolveAR Website"];
//    [arr addObject:@"Contact Support"];
    return arr;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showRecentCodeNavigationBar{
    NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
    

    if([self.codesType isEqualToString:@"settings"]){
        [self.navigationItem setTitle:SCREENNAME_SETTINGS];
    }else{
        [self.navigationItem setTitle:SCREENNAME_SUPPORT];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[SceneManager colorFromHexString:THEME_COLOR]}];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.codesType isEqualToString:@"settings"]){
        if(indexPath.row == -1){

        }else if(indexPath.row == 0){
            [self openBrowserWithURL:@"http://clientsites.cressettech.com/eis/privacy-policy.php"];

        }else if(indexPath.row == 1){
            [self openBrowserWithURL:@"https://help.evolvear.io/"];

        }else{
            [self openBrowserWithURL:@"https://help.evolvear.io/"];

        }
    }else{
        if(indexPath.row == 0){
            [self openBrowserWithURL:@"https://help.evolvear.io/"];
            
        }else if(indexPath.row == 1){
            [self openBrowserWithURL:@"https://www.evolvear.io"];
            
        }else{
            [self openBrowserWithURL:@"https://www.evolvear.io"];
            
        }
    }
}

-(void)openBrowserWithURL:(NSString *)url{
    URLBrowserViewController *urlBrowserVC = [[URLBrowserViewController alloc] initWithNibName:@"URLBrowserViewController" bundle:nil];
    [urlBrowserVC setUrl:url];
    [[[[[VariableMnr sharedInstance] evolveNavigationController] visibleViewController] navigationController] pushViewController:urlBrowserVC animated:true];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
    
    [cell.campaignLbl setText:[NSString stringWithFormat:@"%@", [arr objectAtIndex:indexPath.row]]];
    UIImage *imgThumb;
    if([self.codesType isEqualToString:@"settings"]){
        if(indexPath.row == -1){
            imgThumb = [UIImage imageNamed:@"ageGroupIcon"];
            
        }else if(indexPath.row == 0){
            imgThumb = [UIImage imageNamed:@"privacytermsIcon"];
            
        }else if(indexPath.row == 1){
            imgThumb = [UIImage imageNamed:@"privacytermsIcon"];

        }else{
            imgThumb = [UIImage imageNamed:@"versionIcon"];

        }
    }else{
        if(indexPath.row == 0){
            imgThumb = [UIImage imageNamed:@"webIcon"];
            
        }else if(indexPath.row == 1){
            imgThumb = [UIImage imageNamed:@"webIcon"];
            
        }else{
            imgThumb = [UIImage imageNamed:@"contactSupport"];
            
        }
    }

    [cell.campaignImgView setImage:imgThumb];
    [cell.campaignImgView.layer setCornerRadius:4];
    [cell.campaignImgView setClipsToBounds:true];
    
    return cell;
    
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
