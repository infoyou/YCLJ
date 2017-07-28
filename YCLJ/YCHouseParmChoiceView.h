
#import <UIKit/UIKit.h>

typedef void(^SelectedTypeHandle)(NSString * type, NSString * typeValue);

@interface YCHouseParmChoiceView : UIView

@property (nonatomic, copy) SelectedTypeHandle selectedBlock;

- (void)loadData:(NSString *)plistResource strTitle:(NSString *)strTitle;

@end
