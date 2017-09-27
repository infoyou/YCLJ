//
//  ZTRootViewController.h
//  Pods
//
//  Created by Adam on 2017/6/15.
//
//

#import <UIKit/UIKit.h>
#import "ZTCommonUtils.h"
#import "ZTHttpTool.h"
#import "YCHeader.h"
#import "YCAppManager.h"

#import "ZTLoaddingView.h"
#import "ZTToastView.h"

@interface ZTRootViewController : UIViewController
{
    ZTLoaddingView * Loadding;
}

- (void)popToRootView;

#pragma mark - loading msg
- (void)showLoadingMsg:(NSString *)msg;
- (void)closeLoadingMsg;

- (void)showWithText:(NSString *)msg;

@end
