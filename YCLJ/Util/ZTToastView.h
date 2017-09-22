
#import <UIKit/UIKit.h>

@interface ZTToastView : UILabel

{
    @public
    CGFloat screenWidth,screenHeight;
    int _corner;
    int _duration;
}

@property(assign,nonatomic)int corner;
@property(assign,nonatomic)int duration;


-(void)showToastViewWithText:(NSString *)text andDuration:(int)duration andParentView:(UIView *)parentView;

-(void)showToastViewWithText:(NSString *)text andParentView:(UIView *)parentView;

-(void)showToastViewWithText:(NSString *)text andDuration:(int)duration andCorner:(int)corner andParentView:(UIView *)parentView;

+(void)showToastViewWithText:(NSString *)text andDuration:(int)duration andParentView:(UIView *)parentView;

+(void)showToastViewWithText:(NSString *)text andParentView:(UIView *)parentView;

+(void)showToastViewWithText:(NSString *)text andDuration:(int)duration andCorner:(int)corner andParentView:(UIView *)parentView;

-(void)setBackgroundWithColor:(UIColor *)color;

@end
