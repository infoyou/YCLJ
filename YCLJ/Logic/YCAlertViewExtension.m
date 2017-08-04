
#import "YCAlertViewExtension.h"

@implementation YCAlertViewExtension

- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        //设置模板层背景色
        self.backgroundColor=[UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        
        _tipebackView = [[UIView alloc]initWithFrame:CGRectMake(30, (self.frame.size.height-150)/2, self.frame.size.width-40, 150)];
        _tipebackView.backgroundColor=[UIColor whiteColor];
        _tipebackView.layer.cornerRadius=5;
        [self addSubview:_tipebackView];
        
        
        _tipeLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, _tipebackView.frame.size.width-20, _tipebackView.frame.size.height-20)];
        _tipeLabel.textAlignment=NSTextAlignmentCenter;
        _tipeLabel.numberOfLines= 0;
        [_tipebackView addSubview:_tipeLabel];
        
        _cancelBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag=2000;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX_COLOR(@"0x333333") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = Font(15);
        [_cancelBtn addTarget:self action:@selector(btnClickSelector:) forControlEvents:UIControlEventTouchUpInside];
//        _cancelBtn.backgroundColor =[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [_tipebackView addSubview:_cancelBtn];
        
        
        _sureBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.tag=1000;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX_COLOR(@"0xDE3031") forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = Font(15);
        [_sureBtn addTarget:self action:@selector(btnClickSelector:) forControlEvents:UIControlEventTouchUpInside];
//        _sureBtn.backgroundColor=[UIColor colorWithRed:254/255.0 green:72/255.0 blue:68/255.0 alpha:1.0];
        [_tipebackView addSubview:_sureBtn];
    }
    return self;
}

//设置提示view的宽高
-(void)setbackviewframeWidth:(CGFloat)width Andheight:(CGFloat)height
{
    CGFloat tipeheight =(self.frame.size.height-height)/2;
    CGFloat tipewidth=(self.frame.size.width-width)/2;
    _tipebackView.frame=CGRectMake(tipewidth, tipeheight, width, height);
    _tipeLabel.frame=CGRectMake(10, 5, _tipebackView.frame.size.width-20, _tipebackView.frame.size.height-55);
    _cancelBtn.frame=CGRectMake(0, _tipebackView.frame.size.height-45, width/2, 45);
    _sureBtn.frame=CGRectMake(width/2, _tipebackView.frame.size.height-45, width/2, 45);
}

//设置提示语
-(void)settipeTitleStr:(NSString *)tipeStr fontSize:(CGFloat)fontSize
{
    _tipeLabel.font = Font(fontSize);
    _tipeLabel.text=tipeStr;
}

//按钮方法
-(void)btnClickSelector:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(clickBtnSelector:)]) {
        [self.delegate clickBtnSelector:btn];
    }
}
@end
