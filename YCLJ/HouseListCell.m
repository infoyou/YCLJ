//
//  HouseListCell.m
//  
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import "HouseListCell.h"
#import "HouseObject.h"
#import "HouseModel.h"

@interface HouseListCell()
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

@implementation HouseListCell

- (void)setHouseObject:(HouseObject *)houseObject
{
    
    _houseObject = houseObject;
    
    [self initCellData];
    
    [self drawCellFrame];
}

+ (NSString *)cellID
{
    
    return @"HouseListCell";
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
        
        // 6, delete btn
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
    
    HouseModel *houseModel = _houseObject.houseModel;
    
    // 0, warning
    if (houseModel.isUpload > 0) {
        imgUpload.hidden = YES;
    } else {
        imgUpload.hidden = NO;
    }
    
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
    
    // 2, author
    if (![houseModel.updateDate isEqualToString:@""]) {
        labDate.text = @"修改日期";
    } else {
        labDate.text = @"新建日期";
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
    ShowAlertWithTwoButton(self, @"", @"确认删除吗？", @"取消", @"确定");
}

- (void)doCopySolution
{
    if (_delegate != nil) {
        
        [_delegate handleCopy:_houseObject.houseModel];
    }
}

#pragma mark - alterview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0) {
        DLog(@"删除该cell");
        
        if (_delegate != nil) {
            
            [_delegate handleDel:self houseModel:_houseObject.houseModel];
        }
    }
}

@end
