//
//  ZTRootViewController.m
//  Pods
//
//  Created by Adam on 2017/6/15.
//
//

#import "ZTRootViewController.h"

@interface ZTRootViewController ()

@end

@implementation ZTRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootView)];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    
//    [super viewDidDisappear:animated];

//
//    NSLog(@"viewDidDisappear");
//}

- (void)hengpingStart1
{
    
    [[YCAppManager instance] setHengping:YES];
    [self setNewOrientation:YES];
    
}

- (void)hengpingOver1
{

    [[YCAppManager instance] setHengping:NO];
    [self setNewOrientation:NO];

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

#pragma mark - Orientations

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    
//    return UIInterfaceOrientationLandscapeRight;
//}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

//-(BOOL)shouldAutorotate{
//    if ([EHZCommonUtil canRotateView]) {
//        return YES;
//    }
//    return NO;
//    //    return EHZRootNavigationController.topViewController.shouldAutorotate;
//}
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if ([EHZCommonUtil canRotateView]) {
//        return EHZRootNavigationController.topViewController.supportedInterfaceOrientations;;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//    
//}

- (void)setNewOrientation:(BOOL)fullscreen
{
    
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    } else {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
}

- (void)popToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
