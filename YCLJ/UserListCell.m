
#import "UserListCell.h"
#import "UserModel.h"

@interface UserListCell()
{
    UILabel *labTitle;
    UIImageView *imgExhibit;
    UILabel *labDate;
    UIImageView *imgHeadset;
    UIView *viSplitLine;
}

@end

@implementation UserListCell

- (void)setUserModel:(UserModel *)userModel
{
    
    _userModel = userModel;
    
    [self initCellData];

    [self drawCellFrame];
}

+ (NSString *)cellID
{
    
    return @"UserListCell";
}

+ (CGFloat)cellHeight
{
    
    return kCell_Height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 1, title
        labTitle = [[UILabel alloc] init];
        [self.contentView addSubview:labTitle];
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.font = kUser_Name_Font;
        labTitle.textColor = HEX_COLOR(@"0x666666");
        labTitle.textAlignment = NSTextAlignmentLeft;
        
        // 2, exhibit image
        imgExhibit = [[UIImageView alloc] init];
        [self.contentView addSubview:imgExhibit];
        
        // 3, headset
        imgHeadset = [[UIImageView alloc] init];
        [self.contentView addSubview:imgHeadset];
        
        // 4, date
        labDate = [[UILabel alloc] init];
        [self.contentView addSubview:labDate];
        labDate.textAlignment = NSTextAlignmentCenter;
        labDate.font = kUser_Date_Font;
        labDate.textColor = HEX_COLOR(@"0x999999");
        labDate.textAlignment = NSTextAlignmentLeft;
        
        // 5, split line
        viSplitLine = [[UIView alloc] init];
        [self.contentView addSubview:viSplitLine];
        viSplitLine.backgroundColor = HEX_COLOR(@"0x666666");
        
    }
    
    return self;
}

- (void)drawCellFrame
{
    
    labTitle.frame = CGRectMake(20, 14, YC_SCREEN_WIDTH/3, 22);
    labDate.frame = CGRectMake(YC_SCREEN_WIDTH/2-20, 14, YC_SCREEN_WIDTH/3, 22);
    viSplitLine.frame = CGRectMake(0, kCell_Height-0.5, YC_SCREEN_WIDTH, 0.5f);
}

- (void)initCellData
{
    
    // 1, title
    labTitle.text = [NSString stringWithFormat:@"%@ %@",_userModel.name, _userModel.address];
    
    // 2, date
    labDate.text = [CommonUtils curDateString];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
