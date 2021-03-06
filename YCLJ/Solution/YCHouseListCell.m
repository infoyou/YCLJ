//
//  YCHouseListCell.m
//
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import "YCHouseListCell.h"
#import "YCHouseObject.h"
#import "YCHouseModel.h"
#import "YCOwnerModel.h"
#import "ZTCommonUtils.h"
#import "YCAppManager.h"

@interface YCHouseListCell()
{
    UIImageView *imgUpload;
    UILabel *labTitle;
    UIImageView *imgDelete;
    UIButton *btnDel;
    UILabel *labDate;
    UILabel *labCopySolution;
    UIButton *btnCopySolution;
    UIView *viSplitLine;
}

@end

@implementation YCHouseListCell

- (void)setOwnerModel:(YCOwnerModel *)ownerModel
{
    _ownerModel = ownerModel;
}

- (void)setHouseObject:(YCHouseObject *)houseObject
{
    
    _houseObject = houseObject;
    
    [self initCellData];
    
    [self drawCellFrame];
}

+ (NSString *)cellID
{
    
    return @"YCHouseListCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 0, upload
        imgUpload = [[UIImageView alloc] init];
        imgUpload.image = GetImageByName(@"ycWarning");
        [self.contentView addSubview:imgUpload];
        
        // 1, type
        labTitle = [[UILabel alloc] init];
        [self.contentView addSubview:labTitle];
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.font = kHouse_Type_Font;
        labTitle.textColor = HEX_COLOR(@"0x333333");
        
        // 2, delete img
        imgDelete = [[UIImageView alloc] init];
        imgDelete.image = GetImageByName(@"ycDelete");
        [self.contentView addSubview:imgDelete];
        
        // 3, delete btn
        btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDel addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnDel];
        
        // 4, author
        labDate = [[UILabel alloc] init];
        [self.contentView addSubview:labDate];
        labDate.textAlignment = NSTextAlignmentCenter;
        labDate.font = kHouse_Date_Font;
        labDate.textColor = HEX_COLOR(@"0x333333");
        
        // 5, Copy Solution
        labCopySolution = [[UILabel alloc] init];
        [self.contentView addSubview:labCopySolution];
        labCopySolution.textAlignment = NSTextAlignmentRight;
        labCopySolution.font = kHouse_Copy_Font;
        labCopySolution.textColor = HEX_COLOR(@"0x5E91E5");
        labCopySolution.text = @"生成拆改图";
        
        // 6, copy btn
        btnCopySolution = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCopySolution addTarget:self action:@selector(doCopySolution) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnCopySolution];
        
        // 7, split line
        viSplitLine = [[UIView alloc] init];
        [self.contentView addSubview:viSplitLine];
        viSplitLine.backgroundColor = HEX_COLOR(@"0xE8E8E8");
    }
    
    return self;
}

- (void)initCellData
{
    
    YCHouseModel *houseModel = _houseObject.houseModel;
    
    // 0, warning
    imgUpload.hidden = YES;
    
    // 1, title
    if (houseModel.type > 0) {
        
        labTitle.text = @"拆改图";
        imgDelete.hidden = NO;
        labCopySolution.hidden = YES;
        btnDel.hidden = NO;
    } else {
        
        labTitle.text = @"原始图";
        imgDelete.hidden = YES;
        labCopySolution.hidden = NO;
        btnDel.hidden = YES;
    }
    
    // 拆改图 颜色 处理
    labCopySolution.textColor = HEX_COLOR(@"0x5E91E5");
    
    NSInteger state = [_ownerModel.state integerValue];
    if (state == 1) {
        // 爱福窝
        labCopySolution.textColor = [UIColor grayColor];
    } else {
        // 科创绘制
        if (_ownerModel.houseArray.count > 1) {
            
            if (_houseObject.houseModel.type == 0) {
                
                labCopySolution.textColor = [UIColor grayColor];
            }
        }
    }
    
    // 2, date
    if (![houseModel.updateDate isEqualToString:@""]) {
        labDate.text = [NSString stringWithFormat:@"修改时间 %@", houseModel.updateDate];
    } else {
        labDate.text = [NSString stringWithFormat:@"修改时间 %@", houseModel.creatDate];
    }
    
}

- (void)drawCellFrame
{
    imgUpload.frame = _houseObject.imgUploadF;
    labTitle.frame = _houseObject.labTitleF;
    imgDelete.frame = _houseObject.imgDeleteF;
    btnDel.frame = _houseObject.btnDeleteF;
    labDate.frame = _houseObject.labDateF;
    labCopySolution.frame = _houseObject.labCopySolutionF;
    btnCopySolution.frame = _houseObject.btnCopySolutionF;
    viSplitLine.frame = _houseObject.viSplitLineF;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)doDelete
{
    if (_delegate != nil) {
        [_delegate handleDel:self houseModel:_houseObject.houseModel];
    }
}

- (void)doCopySolution
{
    NSInteger state = [_houseObject.houseModel.state integerValue];
    if (state == 1)
    {
        [[YCAppManager instance] showWithText:AFW_Data_Txt];
        return;
    }
    
    if (_delegate != nil) {
        
        [_delegate handleCopy:_houseObject.houseModel];
    }
}

@end
