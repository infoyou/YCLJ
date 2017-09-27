
#import "Nonetwork.h"
#import "YCHeader.h"

@implementation Nonetwork

#pragma mark -- 重写init方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        // UI搭建
        [self viewLayoutpage];
    }
    return self;
}

//UI布局
-(void)viewLayoutpage
{
    //------- 背景 -------//
    self.Bagview=[[UIView alloc] init];
    UIColor *color = [UIColor whiteColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.1];
    self.Bagview.frame=CGRectMake(0, 0, YC_SCREEN_WIDTH, 0);
    [self addSubview:self.Bagview];
    //------- 内容区域 -------//
    self.Contarea=[[UIView alloc] init];
    self.Contarea.backgroundColor= HEX_COLOR(@"0xFFCBD8");
    self.Contarea.frame=CGRectMake(0, 0, YC_SCREEN_WIDTH, disHeight);
    [self.Bagview addSubview:self.Contarea];
    //------- 警告图标 ------//
    self.Warningicon=[[UIImageView alloc] init];
    self.Warningicon.frame=CGRectMake(15, 5, disWidth, disWidth);
    self.Warningicon.image=[UIImage imageNamed:@"internet"];
    [self.Contarea addSubview:self.Warningicon];
    //------- 内容区域 -------//
    self.Contentext=[[UILabel alloc] init];
    self.Contentext.frame=CGRectMake(CGRectGetMaxX(self.Warningicon.frame)+10, 0, YC_SCREEN_WIDTH-(disWidth+disWidth), disHeight);
    self.Contentext.numberOfLines=0;
    self.Contentext.font=[UIFont systemFontOfSize:Textadaptation(14)];
    [self.Contarea addSubview:self.Contentext];
    
    //------- 添加单击手势 -------//
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noContentViewDidTaped:)]];
}

//弹出视图
-(void)popupWarningview
{
    self.Contentext.text = self.Prompt;
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

#pragma mark -- 重写 settypeDisappear 方法
-(void)setTypeDisappear:(NSInteger)typeDisappear
{
    switch (typeDisappear) {
        case Automaticallydisappear:    //自动消失
            [self creatShowAnimation:0];
            break;
        case Clicktodisappear:          //点击消失
            [self creatShowAnimation:1];
            break;
        default:
            break;
    }
}

//动画效果
-(void)creatShowAnimation:(NSInteger)type
{
    [UIView animateWithDuration:0.6 animations:^{
        //动画执行时
        self.Bagview.frame=CGRectMake(0, 0, YC_SCREEN_WIDTH, disHeight);
        self.Contarea.frame=CGRectMake(0, 64, YC_SCREEN_WIDTH, disHeight);
    } completion:^(BOOL finished) {

        //动画结束后
        /*
         *@parameter 1,时间参照，从此刻开始计时
         *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
         */
        if (type==0) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self disappearAnimation];
            });
        }
    }];
}

// 无数据占位图点击
- (void)noContentViewDidTaped:(Nonetwork *)noContentView{
  
    [self disappearAnimation];
    
}

//消失动画
-(void)disappearAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        //动画执行时
        self.Bagview.frame=CGRectMake(0, 0, YC_SCREEN_WIDTH, 0);
        self.Contarea.frame=CGRectMake(0, 0, YC_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        //动画结束后
        [self removeFromSuperview];
    }];
    
    if (self.returnsAnEventBlock)
    {
        self.returnsAnEventBlock(); // 调用回调函数
    }
}

@end
