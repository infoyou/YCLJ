
#import <UIKit/UIKit.h>

typedef void(^SelectedTypeHandle)(NSString * type);

@interface YCHouseTypeChoiceView : UIView

@property(nonatomic, copy) SelectedTypeHandle selectedBlock;

@end
