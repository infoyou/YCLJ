
#import <UIKit/UIKit.h>

@interface ZTLoaddingView : UIView

{
    @public
    int num;
    CGFloat angle;
    BOOL isShowLoadding;
    UIImageView * imageView;
    UILabel * label;
    CGFloat width;
    CGFloat x;
    CGFloat y,screenWidth,screenHeight;
    UIView * _parentView;
    NSString * _text;
    NSTimer * _timer;
    UIActivityIndicatorView * _activityView;
    UIView * view;
}

@property(retain,nonatomic)NSTimer * timer;
@property(copy,nonatomic) NSString * text;
@property(retain,nonatomic) UIActivityIndicatorView * activityView;

-(void)showLoaddingViewWithText:(NSString *) string;

-(void)dismissLoaddingView;

-(instancetype)initWithParentView:(UIView *) parentView;

+(id)initWithParentView:(UIView *) parentView;

-(BOOL)isShowing;

-(void)showLoaddingView;

-(void)showLoaddingViewWithStyle:(int)style;

-(void)showLoaddingViewWithText:(NSString * )text andStyle:(int)style;

@end
