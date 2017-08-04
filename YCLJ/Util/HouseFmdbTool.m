
#import "FMDB.h"
#import "HouseFmdbTool.h"
#import "YCHouseModel.h"
#import "YCOwnerModel.h"
#import "ZTCommonUtils.h"

#define  YC_HOUSE_SQLITE_NAME       @"YC.sqlite"

@implementation HouseFmdbTool

static FMDatabase *_fmdb;

+ (void)initialize {
    
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:YC_HOUSE_SQLITE_NAME];
    
    DLog(@"filePath %@", filePath);
    
    _fmdb = [FMDatabase databaseWithPath:filePath];
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    // Woker
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Worker(id TEXT PRIMARY KEY, mobile TEXT NOT NULL, work_id TEXT NOT NULL);"];
    
    // Owner
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Owner(id TEXT PRIMARY KEY, name TEXT NOT NULL, mobile TEXT NOT NULL, address TEXT NOT NULL, area TEXT NOT NULL, style TEXT NOT NULL, type TEXT NOT NULL, city TEXT NOT NULL);"];
    
    // Solution
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Solution(id TEXT PRIMARY KEY, userId TEXT NOT NULL, houseId TEXT NOT NULL, solutionId TEXT NULL, filePath TEXT NOT NULL, zipUrl TEXT, creatDate TEXT NOT NULL, updateDate TEXT, type INTEGER NOT NULL, isUpload INTEGER NOT NULL, isDelete INTEGER NOT NULL);"];
}

#pragma mark - 工长
+ (BOOL)queryWorkerData:(NSString *)mobile {
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM Worker where mobile = '%@'", mobile];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    BOOL isExist = NO;
    
    while ([set next]) {
        
        isExist = YES;
    }
    
    return isExist;
}

+ (NSString *)insertWorker:(NSString *)workMobile
                    workId:(NSString *)workId
{
    
    NSString *currentTime = [ZTCommonUtils currentTimeInterval];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Worker(id, mobile, work_id) VALUES ('%@', '%@', '%@');", currentTime, workMobile, workId];
    
    if ([_fmdb executeUpdate:insertSql]) {
        return currentTime;
    }
    
    return nil;
}

#pragma mark - 业主
+ (NSString *)insertOwnerModel:(YCOwnerModel *)model {
    
    NSString *currentTime = [ZTCommonUtils currentTimeInterval];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Owner(id, name, mobile, address, area, city, type, style) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", currentTime, model.name, model.mobile, model.address, model.area, model.city, model.type, model.style];
    
    if ([_fmdb executeUpdate:insertSql]) {
        return currentTime;
    }
    
    return nil;
}

#pragma mark - 户型方案
+ (BOOL)insertSolutionModel:(YCHouseModel *)model userId:(NSString *)userId {
    
    NSString *currentTime = [ZTCommonUtils currentTimeInterval];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Solution(id, userId, houseId, solutionId, filePath, creatDate, updateDate, type, isUpload, isDelete) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%zd', '%zd', '%zd');", [ZTCommonUtils currentTimeInterval], userId, model.houseId, model.no, model.zipFpath, currentTime, @"", model.type, model.isUpload, model.isDelete];
    
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryOwnerData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM Owner order by id desc;";
    }
    
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *userId = [set stringForColumn:@"id"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *mobile = [set stringForColumn:@"mobile"];
        NSString *address = [set stringForColumn:@"address"];
        NSString *area = [set stringForColumn:@"area"];
        
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        [userDict setObject:userId forKey:@"userId"];
        [userDict setObject:name forKey:@"name"];
        [userDict setObject:mobile forKey:@"mobile"];
        [userDict setObject:address forKey:@"address"];
        [userDict setObject:area forKey:@"area"];
        
        YCOwnerModel *modal = [YCOwnerModel newWithDict:userDict type:0];
        [array addObject:modal];
    }
    
    return array;
}

+ (void)firstUse
{
    [self deleteData:@"DELETE FROM Worker"];
    [self deleteData:@"DELETE FROM Owner"];
    [self deleteData:@"DELETE FROM Solution"];
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM Owner";
    }
    
    return [_fmdb executeUpdate:deleteSql];
}

+ (NSDictionary *)queryOwnerSolutionNumber
{
    NSString *querySql = @"SELECT userId, count(houseId) as number FROM solution where isDelete != 1 group by userId";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *userId = [set stringForColumn:@"userId"];
        NSInteger number = [set intForColumn:@"number"];
        
        [dict setObject:[NSNumber numberWithInteger:number] forKey:userId];
    }
    
    return dict;
}

#pragma mark - Solution
+ (NSDictionary *)querySolutionData:(NSString *)querySql
{
    if (querySql == nil) {
        querySql = @"SELECT * FROM Solution where isDelete != 1;";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *userId = [set stringForColumn:@"userId"];
        NSInteger type = [set intForColumn:@"type"];
        NSString *houseId = [set stringForColumn:@"houseId"];
        NSString *zipFpath = [set stringForColumn:@"filePath"];
        NSString *creatDate = [set stringForColumn:@"creatDate"];
        NSString *updateDate = [set stringForColumn:@"updateDate"];
        NSInteger isUpload = [set intForColumn:@"isUpload"];
        NSInteger isDelete = [set intForColumn:@"isDelete"];
        
        NSMutableDictionary *houseDict = [NSMutableDictionary dictionary];
        [houseDict setObject:userId forKey:@"userId"];
        [houseDict setObject:houseId forKey:@"houseId"];
        [houseDict setObject:zipFpath forKey:@"zipFpath"];
        [houseDict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
        [houseDict setObject:[NSNumber numberWithInteger:isUpload] forKey:@"isUpload"];
        [houseDict setObject:[NSNumber numberWithInteger:isDelete] forKey:@"isDelete"];
        [houseDict setObject:creatDate forKey:@"creatDate"];
        [houseDict setObject:updateDate forKey:@"updateDate"];
        
        NSString *key = [NSString stringWithFormat:@"%@%ld", userId, type];
        YCHouseModel *modal = [YCHouseModel newWithDict:houseDict];
        
        [dict setObject:modal forKey:key];
    }
    
    return dict;
}

#pragma mark - common
+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql != nil) {
        
        return [_fmdb executeUpdate:modifySql];
    }
    
    return NO;
}

@end
