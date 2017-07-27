
#import <UIKit/UIKit.h>

typedef void(^SelectedCityHandle)(NSString * province, NSString * city, NSString * area);

@interface YCHouseCityChoiceView : UIView

@property(nonatomic, copy) SelectedCityHandle selectedBlock;

@end
