//
//  ZTRootViewController.m
//  Pods
//
//  Created by Adam on 2017/6/15.
//
//

#import "ZTRootViewController.h"
#import <lfsqSDK/PhotoManager.h>

@interface ZTRootViewController ()

@end

@implementation ZTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [[YCAppManager instance] setHengping:YES];
    [[PhotoManager getInstance] isHengping];
    
    [self setNewOrientation:YES];
    
    NSLog(@"viewDidLoad");
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    [[YCAppManager instance] setHengping:NO];

    [self setNewOrientation:NO];
    
    NSLog(@"viewDidDisappear");
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

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
//{
//    return UIStatusBarAnimationSlide;
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

@end
