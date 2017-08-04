
#import <UIKit/UIKit.h>

@class YCPopViewExtension;

@protocol YCAlertviewExtensionDelegate <NSObject>

-(void)clickBtnSelector:(UIButton *)btn;

@end
@interface YCPopViewExtension : UIView

@property(nonatomic,strong) UIImageView *closeImg;
@property(nonatomic,strong) UIButton *closeBtn;

//取消按钮
@property(nonatomic,strong) UIButton *cancelBtn;
//确定按钮
@property(nonatomic,strong) UIButton *sureBtn;
//提示view
@property(nonatomic,strong) UILabel *tipeLabel;

//提示view
@property(nonatomic,strong) UIView *tipebackView;
@property(nonatomic,assign) id<YCAlertviewExtensionDelegate>delegate;


//设置提示view的宽高
-(void)setbackviewframeWidth:(CGFloat)width Andheight:(CGFloat)height;

//设置提示语
-(void)settipeTitleStr:(NSString *)tipeStr fontSize:(CGFloat)fontSize;

@end
