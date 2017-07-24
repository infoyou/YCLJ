#import "UserModel.h"

@implementation UserModel

+ (instancetype)newWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init])
    {
        if (dict != nil) {
            
            
            self.userId = (NSString *)dict[@"userId"] ? (NSString *)dict[@"userId"]:@"";
            self.name = (NSString *)dict[@"name"] ? (NSString *)dict[@"name"]:@"";
            self.mobile = (NSString *)dict[@"mobile"] ? (NSString *)dict[@"mobile"]:@"";
            self.address = (NSString *)dict[@"address"] ? (NSString *)dict[@"address"]:@"";
            self.area = (NSString *)dict[@"area"] ? (NSString *)dict[@"area"]:@"";
        }
    }
    
    return self;
}

@end
