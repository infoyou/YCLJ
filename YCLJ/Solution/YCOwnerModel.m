#import "YCOwnerModel.h"

@implementation YCOwnerModel

+ (instancetype)newWithDict:(NSDictionary *)dict
{
    
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init])
    {
        if (dict != nil) {
            
            self.ownerId = (NSString *)dict[@"ownerId"] ? (NSString *)dict[@"ownerId"]:@"";
            self.name = (NSString *)dict[@"owner_name"] ? (NSString *)dict[@"owner_name"]:@"";
            self.mobile = (NSString *)dict[@"owner_mobile"] ? (NSString *)dict[@"owner_mobile"]:@"";
            self.address = (NSString *)dict[@"address"] ? (NSString *)dict[@"address"]:@"";
            self.area = (NSString *)dict[@"area"] ? (NSString *)dict[@"area"]:@"";
            self.city = (NSString *)dict[@"district"] ? (NSString *)dict[@"district"]:@"";
            self.style = (NSString *)dict[@"is_new"] ? (NSString *)dict[@"is_new"]:@"";
            self.type = (NSString *)dict[@"house_type"] ? (NSString *)dict[@"house_type"]:@"";
            
            self.createTime = (NSString *)dict[@"complete_time"] ? (NSString *)dict[@"complete_time"]:@"";
            self.workOrderId = (NSString *)dict[@"work_order_id"] ? (NSString *)dict[@"work_order_id"]:@"";
        }
    }
    
    return self;
}

- (instancetype)initWithDictFromYC:(NSDictionary *)dict
{
    
    if (self = [super init])
    {
        if (dict != nil) {
            
            
            self.ownerId = (NSString *)dict[@"ownerId"] ? (NSString *)dict[@"ownerId"]:@"";
            self.name = (NSString *)dict[@"name"] ? (NSString *)dict[@"name"]:@"";
            self.mobile = (NSString *)dict[@"mobile"] ? (NSString *)dict[@"mobile"]:@"";
            self.address = (NSString *)dict[@"address"] ? (NSString *)dict[@"address"]:@"";
            self.area = (NSString *)dict[@"area"] ? (NSString *)dict[@"area"]:@"";
            
            self.city = (NSString *)dict[@"city"] ? (NSString *)dict[@"city"]:@"";
            self.style = (NSString *)dict[@"style"] ? (NSString *)dict[@"style"]:@"";
            self.type = (NSString *)dict[@"type"] ? (NSString *)dict[@"type"]:@"";
        }
    }
    
    return self;
}

@end
