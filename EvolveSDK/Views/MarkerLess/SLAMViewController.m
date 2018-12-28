//
//  SLAMViewController.m
//  ARKitImageRecognition
//
//  Created by Zeeshan on 01/08/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "SLAMViewController.h"
#import "Plane.h"
#import "VariableMnr.h"
#import "GlobalConstants.h"
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ThumbnailCollectionViewCell.h"
#import "CustomActionButton.h"
@interface SLAMViewController ()
@property (nonatomic, retain) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) SLAMJSONManager *jsonManager;
@property (nonatomic, retain) NSData *jsonData;
@property CGPoint oldPosition;
@property SCNVector3 oldModelPosition;
@property SCNVector3 oldModelRotation;
@property (nonatomic, retain) SCNNode *mainNode;
@property BOOL flagModelPlaced;
@property CGPoint touchPanValue;
@property (nonatomic, retain) LOTAnimationView *lotAnim;
@property (nonatomic, retain) Model3D *selectedNode;
@property BOOL isDraggingEnabled;
@property BOOL isMenuOpen;
@property float memoryUsed;
@property (nonatomic, retain) NSMutableArray *planAnchors;
@property (nonatomic, retain) NodeAction *actionSelectedModel;
@property (nonatomic, retain) NSMutableArray *actionButtons;


@end

@implementation SLAMViewController{
    
}
static SLAMViewController *slamVC;
+(SLAMViewController *)sharedInstance{
    if(slamVC != NULL){
        for (ARAnchor *anc in slamVC.planAnchors) {
            [slamVC.sceneView.session removeAnchor:anc];
        }
        ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
        configuration.planeDetection = ARPlaneDetectionNone;
        [slamVC.sceneView.session runWithConfiguration:configuration];
        [slamVC.sceneView setDebugOptions:SCNDebugOptionNone];
        if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
        [slamVC.animView setHidden:true];
        return slamVC;
        
    }else{
        slamVC = [SLAMViewController alloc];
        slamVC.planAnchors = [[NSMutableArray alloc] init];
        return slamVC;
        
    }
}
-(void)setupSLAMUIContents{
    _isMenuOpen = false;
    _memoryUsed = 0;
    _isDraggingEnabled = true;
    _flagModelPlaced = false;
    _sceneView.delegate = self;
    _sceneView.session.delegate = self;
    [[VariableMnr sharedInstance] setSlamJsonManager:[SLAMJSONManager sharedInstance]];
    _jsonManager  = [SLAMJSONManager sharedInstance];
    [self.navigationController setTitle:@"ML"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeModelButtonPressed) name:@"placeModelButtonPressed" object:nil];
    
    [self.thumbnailSlider registerNib:[UINib nibWithNibName:@"ThumbnailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbnailCollectionViewCell"];
    [self.thumbnailSlider setAllowsSelection:true];
    [_lotAnim setAnimationSpeed:2.0];
    [_lotAnim setFrame:CGRectMake((self.animView.frame.size.width * -1.5) + 25, (self.animView.frame.size.width * -1.5) + 25, self.animView.frame.size.width * 3, self.animView.frame.size.width * 3)];
    
    [self.animButtonView.layer setCornerRadius:self.animButtonView.frame.size.width/2];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SHOWNOTIFICATION_CONTENT_ICONS object:nil]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidemenu) name:@"hidemenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showmenu) name:@"showmenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuButton) name:@"thumbnailMenuClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDescriptionBoxForModel) name:SHOWDESCRIPTIONPOPUP_NOTIFICATION_KEY object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lotAnim = [LOTAnimationView animationNamed:@"menuButton1"];
    [self.animButtonView addSubview:_lotAnim];
    _actionButtons = [[NSMutableArray alloc] init];
    
    //    [[VariableManager sharedInstance] googleAnalyticsReportWithCategory:@"Code Scanned" name:@"Successfully" label:@"2399000" andValue:@"2399000"];
    
}
-(void)hidemenu{
    [self.animView setHidden:true];
}
-(void)showmenu{
    [self.animView setHidden:false];
}
-(void)showCloseButton{
    _isMenuOpen = true;
    [_lotAnim setProgressWithFrame:[NSNumber numberWithFloat:0]];
    [_lotAnim playFromFrame:[NSNumber numberWithFloat:0] toFrame:[NSNumber numberWithFloat:50] withCompletion:nil];
    [self.menuButtonBottomSpace setConstant:170];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
    
}

-(void)showMenuButton{
    _isMenuOpen = false;
    [self.animView setHidden:false];
    [_lotAnim setProgressWithFrame:[NSNumber numberWithFloat:50]];
    [_lotAnim playFromFrame:[NSNumber numberWithFloat:50] toFrame:[NSNumber numberWithFloat:100] withCompletion:nil];
    [self.menuButtonBottomSpace setConstant:20];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
-(IBAction)menuButtonPressed:(id)sender{
    if(_isMenuOpen){
        [self showMenuButton];
        
        
    }else{
        [self showCloseButton];
        [self showBottomMenu];
        
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self setupSLAMUIContents];
    [self codeScannedWithID:[[VariableMnr sharedInstance] scannedCode]];
    [self removeAllPreviousModels];
    
}

-(void)codeScannedWithID:(NSString *)primaryCapeignID{
    
    DownloadMngrr *dManager = [DownloadMngrr getInstance];
    [dManager setDownloadMngrDelegate:self];
    [dManager downloadJSONContentForMarkerLess:[NSString stringWithFormat:[[VariableMnr sharedInstance] fetchBaseURL],primaryCapeignID]];
    
}

-(void)jsonDownloadCompleteWithData:(NSData *)jsonData{
    [_jsonManager createScenesFromJSON:jsonData];
    [self downloadAllThumbnails];
    
}
-(void)downloadAllThumbnails{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (SceneNode *scn in [_jsonManager scenes]) {
        NSMutableArray *models = scn.models;
        for (Model3D *modelNode in models) {
            [imageArray addObject:[NSString stringWithFormat:@"%@",[modelNode.appearance thumbnailImage]]];
        }
    }
    
    DownloadMngrr *dManager = [DownloadMngrr getInstance];
    [dManager downloadImagesFromArrayOfURL:imageArray];
    
}

-(void)downloadComplete{
    
    
}

-(void)allContentsDownloadComplete{
    [[VariableMnr sharedInstance] hideProgressView];
    
    [self setupScene];
    [self setupSession];

    [[VariableMnr sharedInstance] showInitialPopupTutorialMarkerLess:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupScene {
    // Setup the ARSCNViewDelegate - this gives us callbacks to handle new
    // geometry creation
    _sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    _sceneView.showsStatistics = NO;
    _sceneView.autoenablesDefaultLighting = YES;
    
    // Turn on debug options to show the world origin and also render all
    // of the feature points ARKit is tracking
    _sceneView.debugOptions =
    ARSCNDebugOptionShowFeaturePoints;
    
    SCNScene *scene = [SCNScene new];
    _sceneView.scene = scene;
    
    
    
}
-(void)planeDrag:(UIPanGestureRecognizer *)recognizer{
    if(_selectedNode == NULL){
        return;
    }
    CGPoint tapPoint = [recognizer locationInView:_sceneView];
    if(recognizer.state == UIGestureRecognizerStateBegan){
        _touchPanValue.x = tapPoint.x;
        _touchPanValue.y = tapPoint.y;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentStateValue = [recognizer locationInView:_sceneView];
        
        float valX = currentStateValue.x - _touchPanValue.x;
        float valY = currentStateValue.y - _touchPanValue.y;
        if(_isDraggingEnabled){
            [_selectedNode setPosition:SCNVector3Make(_selectedNode.position.x + (valX/350), _selectedNode.position.y, _selectedNode.position.z + (valY/350))];
            
        }else{
            [_selectedNode setEulerAngles:SCNVector3Make(_selectedNode.eulerAngles.x, _selectedNode.eulerAngles.y + (valX/150), _selectedNode.eulerAngles.z)];
            
        }
        
        _touchPanValue = currentStateValue;
        
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
    }
}
-(void)initiateDescriptionBox:(NodeAction *)actionNd{
    
    NSArray *actionButtons = [actionNd.descriptionBoxDict objectForKey:ACTIONBUTTONS_JSON_KEY];
    
    float actionbuttonYValue = self.descriptionScrollV.frame.origin.y + (self.descriptionScrollV.frame.size.height + 8);
    
    if(actionButtons){
        for (NSDictionary *actionDict in actionButtons) {
            
            NSString *actionTitle;
            
            if([actionDict objectForKey:ACTIONBUTTON_TITLE_JSON_KEY]){
                actionTitle = [actionDict objectForKey:ACTIONBUTTON_TITLE_JSON_KEY];
            }else{
                actionTitle = @"Done";
            }
            
            CustomActionButton *btnAction = [[CustomActionButton alloc] initWithFrame:CGRectMake(self.descriptionScrollV.frame.origin.x, actionbuttonYValue, self.descriptionScrollV.frame.size.width,40)];
            [btnAction setTitle:actionTitle forState:UIControlStateNormal];
            [btnAction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btnAction setActionND:actionNd];
            
            [btnAction.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            [btnAction.layer setCornerRadius:4];
            [btnAction.layer setBorderWidth:1.0];
            
            for (NSDictionary *dic in [actionDict objectForKey:ACTIONS_JSON_KEY]) {
                [btnAction setCustomData:dic];
                [btnAction addTarget:self action:@selector(descriptionBoxActionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            actionbuttonYValue = actionbuttonYValue + 38;
            [self.descriptionBoxView addSubview:btnAction];
            [_actionButtons addObject:btnAction];
            
        }
    }
    
    [self.descriptionBoxView setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 20, actionbuttonYValue + 10)];
    [self.descriptionBoxView setClipsToBounds:true];
    [self.descriptionBoxView.layer setCornerRadius:4];
    
    
    [[VariableMnr sharedInstance] setThumbnailSheetPopup:[PopupView popupViewWithContentView:self.descriptionBoxView showType:PopupViewShowTypeSlideInFromBottom dismissType:PopupViewDismissTypeSlideOutToBottom maskType:PopupViewMaskTypeNone shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:false]];
    
    UIView *mView = [[[VariableMnr sharedInstance] navigationController] parentViewController].view;
    
    [[[VariableMnr sharedInstance] thumbnailSheetPopup] setWillStartDismissingCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"thumbnailMenuClose" object:nil]];
    }];
    
    [[[VariableMnr sharedInstance] thumbnailSheetPopup] showAtCenter:CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height - ((self.descriptionBoxView.frame.size.height/2) + 10)) inView:mView];
}
-(IBAction)descriptionBoxActionButtonPressed:(id)sender{
    CustomActionButton *customButton = (CustomActionButton *)sender;
    NSDictionary *dic = [customButton customData];
    NodeAction *ndAction = [customButton actionND];
    [ndAction triggerDescriptionBoxAction:dic];
    
}
-(void)showDescriptionBoxForModel{
    [self initiateDescriptionBox:_actionSelectedModel];
    
}
-(void)setDescriptionBoxValues:(NodeAction *)actionNd{
    
    for (CustomActionButton *btn in _actionButtons) {
        [btn removeFromSuperview];
    }
    [_actionButtons removeAllObjects];
    NSString *titleStr;
    NSString *descriptionStr;
    NSString *priceStr;
    
    if([actionNd.descriptionBoxDict objectForKey:TITLE_JSON_KEY]){
        titleStr = [actionNd.descriptionBoxDict objectForKey:TITLE_JSON_KEY];
    }else{
        titleStr = @"";
    }
    if([actionNd.descriptionBoxDict objectForKey:DESCRIPTION_JSON_KEY]){
        descriptionStr = [actionNd.descriptionBoxDict objectForKey:DESCRIPTION_JSON_KEY];
        
    }else{
        descriptionStr = @"";
    }
    
    if([actionNd.descriptionBoxDict objectForKey:PRICE_JSON_KEY]){
        priceStr = [actionNd.descriptionBoxDict objectForKey:PRICE_JSON_KEY];
        
    }else{
        priceStr = @"";
    }
    
    [self.boxTitleLbl setText:titleStr];
    [self.boxDescriptionLbl setText:descriptionStr];
    [self.boxDescriptionPrice setText:priceStr];
}

-(void)planeHit:(UITapGestureRecognizer *)recognizer{
    
    CGPoint tapPoint = [recognizer locationInView:_sceneView];
    NSArray *hits = [_sceneView hitTest:tapPoint options:nil];
    if([hits count] > 0){
        SCNHitTestResult *result = [hits objectAtIndex:0];
        _selectedNode = [[VariableMnr sharedInstance] fetchSelectableNode:result.node];
        _actionSelectedModel = _selectedNode.action;
        if(_actionSelectedModel.descriptionBoxDict != nil){
            [self setDescriptionBoxValues:_actionSelectedModel];
        }
        [_jsonManager actionTriggerForModel:_selectedNode];
        
        [self ModelSelected];
        
    }else{
        _selectedNode = NULL;
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SHOWNOTIFICATION_CONTENT_ICONS object:nil]];
    }
}

-(IBAction)dismissDescriptionBox:(id)sender{
    if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
        [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
}

-(void)ModelSelected{
    _isDraggingEnabled = _isDraggingEnabled?false:true;
    [self showModelIconsOnNavigationBar:_selectedNode];
    
}

-(void)removeAllPreviousModels{
    NSArray *ar = [_mainNode childNodes];
    for (Model3D *model in ar) {
        NSLog(@"%f",model.transf.posX);
        [model setModel:nil];
        [model setModelNode:nil];
        [model setIsPlaced:false];
        [model removeFromParentNode];
        
    }
    
}
-(void)removeModel{
    
    NSArray *ar = [_mainNode childNodes];
    for (Model3D *model in ar) {
        NSLog(@"%f",model.transf.posX);
    }
    [_selectedNode setModel:nil];
    [_selectedNode setModelNode:nil];
    [_selectedNode setIsPlaced:false];
    [_selectedNode removeFromParentNode];
    _selectedNode = NULL;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SHOWNOTIFICATION_CONTENT_ICONS object:nil]];
    
}

-(void)showModelIconsOnNavigationBar:(Model3D *)selectedModel{
    UINavigationItem *navItem = [[VariableMnr sharedInstance] navItem];
    
    NSString *defaultJSON = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"defaultMarkerBaseJSONName"]];
    
    UIBarButtonItem *dragIcon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"markerlessIconDrag"] style:UIBarButtonItemStylePlain target:self action:@selector(ModelSelected)];
    
    UIBarButtonItem *rotateIcon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"markerlessIconRotate"] style:UIBarButtonItemStylePlain target:self action:@selector(ModelSelected)];
    
    if(_isDraggingEnabled){
        [dragIcon setImage:[UIImage imageNamed:@"markerlessIconDragSelected"]];
        [rotateIcon setImage:[UIImage imageNamed:@"markerlessIconRotate"]];
        [dragIcon setEnabled:false];
        [rotateIcon setEnabled:true];
        
    }else{
        [dragIcon setImage:[UIImage imageNamed:@"markerlessIconDrag"]];
        [rotateIcon setImage:[UIImage imageNamed:@"markerlessIconRotateSelected"]];
        [dragIcon setEnabled:true];
        [rotateIcon setEnabled:false];
        
    }
    
    UIBarButtonItem *removeIcon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(removeModel)];
    
    [navItem setRightBarButtonItems:@[removeIcon,dragIcon,rotateIcon] animated:true];
}

-(void)addModelToAR:(int)modelIndex atARPosition:(ARHitTestResult *)hitTestResult{
    if([[[[_jsonManager scenes] objectAtIndex:modelIndex] models] count] > 0){
        for (Model3D *model in [[[_jsonManager scenes] objectAtIndex:modelIndex] models]) {
            
            if(![model isPlaced]){
//                _memoryUsed = [ViewController GetMemory];
                NSLog(@"Memory used %f",_memoryUsed);
                [model setIsPlaced:true];
                [model placeModelOnGround:SCNVector3Make(0, 0, 0) withSize:CGSizeMake(0, 0)];
                _flagModelPlaced = true;
                [_mainNode addChildNode:model];
                [_sceneView setDebugOptions:SCNDebugOptionNone];
                [self.thumbnailView setHidden:true];

            }else{
                [model setIsPlaced:false];
                [model removeFromParentNode];
                
            }
            
        }
    }
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionNone;
    
    [configuration setAutoFocusEnabled:true];
    [self->_sceneView.session runWithConfiguration:configuration];

}
- (void)setupSession {
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [configuration setAutoFocusEnabled:true];
    [_sceneView.session runWithConfiguration:configuration];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    if(_planAnchors){
        [_planAnchors addObject:anchor];
    }else{
        _planAnchors = [[NSMutableArray alloc] init];
        [_planAnchors addObject:anchor];
    }
    if(!_flagModelPlaced){
        _flagModelPlaced = true;
        _mainNode = node;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(planeHit:)];
        UIPanGestureRecognizer *dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(planeDrag:)];
        NSLog(@"model placed");
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            // Perform long running process
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self.thumbnailView setHidden:false];
                [self.thumbnailView.layer setCornerRadius:8];
                [self->_sceneView addGestureRecognizer:tapRecognizer];
                [self->_sceneView addGestureRecognizer:dragRecognizer];
                
                [self showMenuButton];
                [self.animView setHidden:false];
                [self.thumbnailSlider reloadData];
                
                if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
                    [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
                
            });
        });
    }
    // Ground Detected
    
}
-(void)placeModel:(int)modelIndex{
    
    NSArray *arhitTestResult = [_sceneView hitTest:CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2) types:ARHitTestResultTypeFeaturePoint];
    
    if([arhitTestResult count] > 0){
        [self addModelToAR:modelIndex atARPosition:[arhitTestResult firstObject]];
        
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    //    [self.modelNode setEulerAngles:SCNVector3Make(0, 0, 0)];
    
}
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    // Nodes will be removed if planes multiple individual planes that are detected to all be
    // part of a larger plane are merged.
    //    [self.planes removeObjectForKey:anchor.identifier];
}
-(void)placeModelButtonPressed{
    if(self.currentModel != nil){
        [self.currentModel setPosition:SCNVector3Make(self.currentModel.position.x, 0, self.currentModel.position.z)];
        self.currentModel = nil;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _jsonManager.scenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ThumbnailCollectionViewCell";
    
    ThumbnailCollectionViewCell *thumbnail = (ThumbnailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Model3D *model = [[[_jsonManager.scenes objectAtIndex:indexPath.row] models] objectAtIndex:0];
    
    [thumbnail.thumbnailImg setImage:model.appearance.thumbnail];
    
    thumbnail.thumbnailImg.layer.masksToBounds = NO;
    thumbnail.thumbnailImg.layer.shadowOffset = CGSizeMake(2, 2);
    thumbnail.thumbnailImg.layer.shadowOpacity = 0.4;
    
    
    [thumbnail.titleLbl setText:[NSString stringWithFormat:@"%@",[model.appearance title]]];
    [thumbnail.descriptionLbl setText:[NSString stringWithFormat:@"%@",model.appearance.description]];
    
    if(model.isPlaced){
        [thumbnail.selectionBGImg setHidden:false];
        [thumbnail.selectionBGLbl setHidden:false];
        
    }else{
        [thumbnail.selectionBGImg setHidden:true];
        [thumbnail.selectionBGLbl setHidden:true];
        
    }
    thumbnail.selectionBGImg.layer.masksToBounds = NO;
    thumbnail.selectionBGImg.layer.shadowOffset = CGSizeMake(2, 2);
    thumbnail.selectionBGImg.layer.shadowOpacity = 0.4;
    return thumbnail;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if(_memoryUsed < 800){
        
        [self placeModel:(int)indexPath.row];
        if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
        [self showMenuButton];
        [self.thumbnailSlider reloadData];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your device maximum memory limit exceeds, please RESET your campaign now." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:true completion:nil];
        }];
        
        [alertController addAction:action];
        [alertController addAction:actionCancel];
        if([[VariableMnr sharedInstance] thumbnailSheetPopup] != nil)
            [[[VariableMnr sharedInstance] thumbnailSheetPopup] dismiss:true];
        [self presentViewController:alertController animated:true completion:nil];
        
    }
}

-(void)showBottomMenu{
    
    [self.thumbnailSlider reloadData];
    [self.thumbnailSlider setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 20, 152)];
    UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 20, 152)];
    [containingView addSubview:self.thumbnailSlider];
    [containingView setBackgroundColor:[UIColor whiteColor]];
    [self.thumbnailSlider setDelegate:self];
    [containingView setClipsToBounds:true];
    [containingView.layer setCornerRadius:12];
    
    [[VariableMnr sharedInstance] setThumbnailSheetPopup:[PopupView popupViewWithContentView:containingView showType:PopupViewShowTypeSlideInFromBottom dismissType:PopupViewDismissTypeSlideOutToBottom maskType:PopupViewMaskTypeNone shouldDismissOnBackgroundTouch:true shouldDismissOnContentTouch:false]];
    
    UIView *mView = [[[VariableMnr sharedInstance] navigationController] parentViewController].view;
        [[[VariableMnr sharedInstance] thumbnailSheetPopup] setWillStartDismissingCompletion:^{
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"thumbnailMenuClose" object:nil]];
    }];
    
    [[[VariableMnr sharedInstance] thumbnailSheetPopup] showAtCenter:CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height - (130/2) - 20) inView:mView];
    
}

@end
