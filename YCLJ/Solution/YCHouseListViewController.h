//
//  YCHouseListViewController.h
//  Pods
//
//  Created by Adam on 2017/6/16.
//
//

#import <UIKit/UIKit.h>
#import "ZTBaseTableViewController.h"

@interface YCHouseListViewController : ZTBaseTableViewController

@property(nonatomic,copy) void(^shareEventBlock)();
@property(nonatomic,copy) void(^sendEventBlock)();

@end
