//
//  LFUnityViewController.m
//
//
//  Created by lreson on 2017/4/25.
//  Copyright © 2017 KC. All rights reserved.
//

#import "LFUnityViewController.h"

#ifdef isU3D
#import "ARManager.h"
#endif

@interface LFUnityViewController ()

#ifdef isU3D
/** AR操作的管理者 */
@property (nonatomic, strong) ARManager *armanager;
#endif

@end

@implementation LFUnityViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
#ifdef isU3D
    [self initData];
    [self loadUnity];
    [self loadButton];
    [self showUnity];
#endif
    // Do any additional setup after loading the view.
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - private method

#ifdef isU3D
-(void)initData{
    self.view.backgroundColor = [UIColor whiteColor];
    _armanager = [UIApplication sharedApplication].delegate).armanager;
}

-(void)loadButton{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 80, 44)];
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"返回" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setTitleColor:[UIColor colorWithRed:4/255.0 green:172/255.0 blue:247/255.0 alpha:1] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn addTarget:self action:@selector(hideUnityWindow) forControlEvents:UIControlEventTouchUpInside];
    
    [_armanager addSubview:btn];
}

-(void)loadUnity{
    [_armanager startUnity];
}

-(void)showUnity{
    [_armanager showUnityWindow];
}

#pragma mark - touch method
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideUnityWindow{
    
//    [_armanager UnitySendMessage:<#(const char *)#> method:method msg:@""];
    
    
    [_armanager exitUnity];
    [self.navigationController popViewControllerAnimated:YES];
}


#endif


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
