#import "YCOwnerModel.h"

@implementation YCOwnerModel

+ (instancetype)newWithDict:(NSDictionary *)dict
{
    
    return [[self alloc] initWithDict:dict];
}

+ (instancetype)newWithUserDict:(NSDictionary *)dict
{
    
    return [[self alloc] initWithDictFromUserList:dict];
}

/**
 * 工长下面的业主列表接口
 */
- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init])
    {
        if (dict != nil) {
            
            self.ownerId = (NSString *)dict[@"ownerId"] ? (NSString *)dict[@"ownerId"]:@"";
            self.name = (NSString *)dict[@"name"] ? (NSString *)dict[@"name"]:@"";
            self.mobile = (NSString *)dict[@"mobile"] ? (NSString *)dict[@"mobile"]:@"";
            self.address = (NSString *)dict[@"address"] ? (NSString *)dict[@"address"]:@"";
            self.area = (NSString *)dict[@"building_area"] ? (NSString *)dict[@"building_area"]:@"";
            self.city = (NSString *)dict[@"district"] ? (NSString *)dict[@"district"]:@"";
            self.style = (NSString *)dict[@"is_new"] ? (NSString *)dict[@"is_new"]:@"";
            self.type = (NSString *)dict[@"house_type"] ? (NSString *)dict[@"house_type"]:@"";
            self.state = (NSString *)dict[@"state"] ? (NSString *)dict[@"state"]:@"";
            
            self.createTime = (NSString *)dict[@"create_time"] ? (NSString *)dict[@"create_time"]:@"";
            self.workOrderId = (NSString *)dict[@"work_order_id"] ? (NSString *)dict[@"work_order_id"]:@"";
            self.houseId = (NSString *)dict[@"house_num"] ? (NSString *)dict[@"house_num"]:@"";
        }
    }
    
    return self;
}

/**
 * 用户列表接口
 */
- (instancetype)initWithDictFromUserList:(NSDictionary *)dict
{
    
    if (self = [super init])
    {
        if (dict != nil) {
            
            self.ownerId = (NSString *)dict[@"work_order_id"] ? (NSString *)dict[@"work_order_id"]:@"";
            self.name = (NSString *)dict[@"owner_name"] ? (NSString *)dict[@"owner_name"]:@"";
            self.mobile = (NSString *)dict[@"owner_mobile"] ? (NSString *)dict[@"owner_mobile"]:@"";
            self.address = (NSString *)dict[@"address"] ? (NSString *)dict[@"address"]:@"";
            self.area = (NSString *)dict[@"area"] ? (NSString *)dict[@"area"]:@"";
            self.city = (NSString *)dict[@"district"] ? (NSString *)dict[@"district"]:@"";
            self.style = (NSString *)dict[@"is_new"] ? (NSString *)dict[@"is_new"]:@"";
            self.type = (NSString *)dict[@"house_type"] ? (NSString *)dict[@"house_type"]:@"";
            
            self.createTime = (NSString *)dict[@"create_time"] ? (NSString *)dict[@"create_time"]:@"";
            self.workOrderId = (NSString *)dict[@"work_order_id"] ? (NSString *)dict[@"work_order_id"]:@"";
            self.houseId = (NSString *)dict[@"house_num"] ? (NSString *)dict[@"house_num"]:@"";
        }
    }
    
    return self;
}

@end
