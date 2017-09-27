//
//  YCHouseListViewController.h
//  Pods
//
//  Created by Adam on 2017/6/16.
//
//

#import <UIKit/UIKit.h>
#import "ZTBaseTableViewController.h"

typedef void (^shareBlock) (NSString *url);
typedef void (^sendBlock)(NSString *flag);

@interface YCHouseListViewController : ZTBaseTableViewController

@property (nonatomic, copy) void (^draw3DBlock)(UIViewController * drawVC);
@property (nonatomic, copy) void (^shareBlock)(NSString *url);
@property (nonatomic, copy) void (^sendBlock)(NSString *flag);

@end
