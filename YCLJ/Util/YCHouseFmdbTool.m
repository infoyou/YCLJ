#import "YCHouseFmdbTool.h"
#import "YCHouseModel.h"
#import "YCOwnerModel.h"
#import "ZTCommonUtils.h"
#import "FMDB.h"
#import "YCAppManager.h"

#define  YC_HOUSE_SQLITE_NAME       @"YCLJ.sqlite"

@implementation YCHouseFmdbTool

static FMDatabase *_fmdb;

+ (void)initialize {
    
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:YC_HOUSE_SQLITE_NAME];
    
    DLog(@"filePath %@", filePath);
    
    _fmdb = [FMDatabase databaseWithPath:filePath];
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    // Woker
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Worker(id TEXT PRIMARY KEY, mobile TEXT NOT NULL, workId TEXT NOT NULL, workName TEXT);"];
    
    // Owner
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Owner(id TEXT PRIMARY KEY, name TEXT NOT NULL, mobile TEXT NOT NULL, address TEXT NOT NULL, area TEXT NOT NULL, style TEXT NOT NULL, type TEXT NOT NULL, city TEXT NOT NULL, workOrderId TEXT NOT NULL, createTime TEXT NOT NULL);"];
    
    // Solution
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Solution(id TEXT PRIMARY KEY, ownerId TEXT, houseId TEXT NOT NULL, lfFile TEXT, filePath TEXT, zipUrl TEXT, objUrl TEXT, creatDate TEXT NOT NULL, updateDate TEXT, type INTEGER NOT NULL, isUpload INTEGER NOT NULL, isDelete INTEGER NOT NULL);"];
}

#pragma mark - 工长
+ (BOOL)queryWorkerData:(NSString *)mobile {
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT workId, mobile, workName FROM Worker where mobile = '%@'", mobile];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    BOOL isExist = NO;
    
    while ([set next]) {
        
        [YCAppManager instance].workId = [set stringForColumn:@"workId"];
        [YCAppManager instance].workMobile = [set stringForColumn:@"mobile"];
        [YCAppManager instance].workName = [set stringForColumn:@"workName"];
        isExist = YES;
    }
    
    return isExist;
}

+ (void)insertWorker:(NSString *)workMobile
              workId:(NSString *)workId
            workName:(NSString *)workName
{
    
    NSString *currentTime = [ZTCommonUtils currentTimeInterval];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Worker(id, mobile, workId, workName) VALUES ('%@', '%@', '%@', '%@');", currentTime, workMobile, workId, workName];
    
    [_fmdb executeUpdate:insertSql];
    
    [YCAppManager instance].workId = workId;
    [YCAppManager instance].workMobile = workMobile;
    [YCAppManager instance].workName = workName;
}

#pragma mark - 业主
+ (NSString *)insertOwnerModel:(YCOwnerModel *)model {
    
    NSString *currentTime = [ZTCommonUtils currentTimeInterval];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Owner(id, name, mobile, address, area, city, type, style, workOrderId, createTime) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.mobile, model.name, model.mobile, model.address, model.area, model.city, model.type, model.style, model.workOrderId, currentTime];
    
    if ([_fmdb executeUpdate:insertSql]) {
        return currentTime;
    }
    
    return nil;
}

+ (NSString *)insertOwnerArrayModel:(NSArray *)modelArray
{
    
    NSTimeInterval currentTimeDouble = [ZTCommonUtils currentTimeIntervalDouble];
    NSInteger count = [modelArray count];
    
    for (NSInteger i=0; i<count; i++) {
        
        YCOwnerModel *model = modelArray[i];
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Owner(id, name, mobile, address, area, city, type, style, workOrderId, createTime) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.mobile, model.name, model.mobile, model.address, model.area, model.city, model.type, model.style, model.workOrderId, [ZTCommonUtils currentTimeInterval]];
        
        [_fmdb executeUpdate:insertSql];
    }
    
    NSLog(@"save owner use time: %f", [ZTCommonUtils currentTimeIntervalDouble] - currentTimeDouble);
    return nil;
}

+ (NSString *)insertOwnerHouseArrayModel:(NSArray *)modelArray
{
    
    NSTimeInterval currentTimeDouble = [ZTCommonUtils currentTimeIntervalDouble];
    
    NSInteger count = [modelArray count];
    for (NSInteger i=0; i<count; i++) {
        
        YCHouseModel *model = modelArray[i];
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Solution(id, ownerId, houseId, lfFile, filePath, creatDate, updateDate, type, isUpload, isDelete) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%zd', '%zd', '%zd');", model.houseId, model.ownerId, model.houseId, model.lfFile, model.zipFpath, model.creatDate, model.updateDate, model.type, model.isUpload, model.isDelete];
        
        [_fmdb executeUpdate:insertSql];
    }
    
    NSLog(@"save owner house use time: %f", [ZTCommonUtils currentTimeIntervalDouble] - currentTimeDouble);
    return nil;
}

+ (NSArray *)queryOwnerData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT id, name, mobile, address, area, workOrderId FROM Owner order by createTime desc;";
    }
    
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *ownerId = [set stringForColumn:@"id"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *mobile = [set stringForColumn:@"mobile"];
        NSString *address = [set stringForColumn:@"address"];
        NSString *area = [set stringForColumn:@"area"];
        NSString *workOrderId = [set stringForColumn:@"workOrderId"];
        
        // 解析json 参数
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        [userDict setObject:mobile forKey:@"ownerId"];
        [userDict setObject:name forKey:@"name"];
        [userDict setObject:mobile forKey:@"mobile"];
        [userDict setObject:address forKey:@"address"];
        [userDict setObject:area forKey:@"building_area"];
        [userDict setObject:workOrderId forKey:@"workOrderId"];
        
        YCOwnerModel *modal = [YCOwnerModel newWithDict:userDict];
        [array addObject:modal];
    }
    
    return array;
}

#pragma mark - 户型方案
+ (BOOL)insertSolutionModel:(YCHouseModel *)model
{
    
    NSString *currentTimeStr = [ZTCommonUtils getCurrentTime];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Solution(id, houseId, lfFile, filePath, creatDate, updateDate, type, isUpload, isDelete) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%zd', '%zd', '%zd');", model.houseId, model.houseId, model.lfFile, model.zipFpath, currentTimeStr, @"", model.type, model.isUpload, model.isDelete];
    
    return [_fmdb executeUpdate:insertSql];
}

+ (BOOL)insertCopySolutionModel:(YCHouseModel *)model
                        ownerId:(NSString *)ownerId
{
    
    NSString *currentTimeStr = [ZTCommonUtils getCurrentTime];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Solution(id, ownerId, houseId, lfFile, filePath, creatDate, updateDate, type, isUpload, isDelete) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%zd', '%zd', '%zd');", model.houseId, ownerId, model.houseId, model.lfFile, model.zipFpath, currentTimeStr, @"", model.type, model.isUpload, model.isDelete];
    
    return [_fmdb executeUpdate:insertSql];
}

+ (BOOL)querySolutionData:(NSString *)houseId {
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT id FROM Solution where houseId = '%@'", houseId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    BOOL isExist = NO;
    
    while ([set next]) {
        
        isExist = YES;
    }
    
    return isExist;
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

+ (NSMutableDictionary *)queryOwnerSolutionNumber
{
    NSString *querySql = @"SELECT ownerId, count(houseId) as number FROM solution where isDelete != 1 group by ownerId";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *ownerId = [set stringForColumn:@"ownerId"];
        
        if (ownerId != nil) {
            NSInteger number = [set intForColumn:@"number"];
            
            [dict setObject:[NSNumber numberWithInteger:number] forKey:ownerId];
        }
    }
    
    return dict;
}

#pragma mark - Solution
+ (NSMutableDictionary *)queryAllSolutionData:(NSString *)querySql
{
    if (querySql == nil) {
        querySql = @"SELECT ownerId, type, houseId, filePath, creatDate, updateDate, isUpload, isDelete FROM Solution where isDelete != 1;";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *ownerId = [set stringForColumn:@"ownerId"];
        
        if (ownerId != nil) {
            
            NSInteger type = [set intForColumn:@"type"];
            NSString *houseId = [set stringForColumn:@"houseId"];
            NSString *zipFpath = [set stringForColumn:@"filePath"];
            NSString *creatDate = [set stringForColumn:@"creatDate"];
            NSString *updateDate = [set stringForColumn:@"updateDate"];
            NSInteger isUpload = [set intForColumn:@"isUpload"];
            NSInteger isDelete = [set intForColumn:@"isDelete"];
            
            // 解析json 参数
            NSMutableDictionary *houseDict = [NSMutableDictionary dictionary];
            [houseDict setObject:ownerId forKey:@"owner_mobile"];
            [houseDict setObject:houseId forKey:@"house_num"];
            [houseDict setObject:zipFpath forKey:@"pkg"];
            [houseDict setObject:[NSNumber numberWithInteger:type] forKey:@"is_copy"];
            [houseDict setObject:[NSNumber numberWithInteger:isUpload] forKey:@"isUpload"];
            [houseDict setObject:[NSNumber numberWithInteger:isDelete] forKey:@"isDelete"];
            [houseDict setObject:creatDate forKey:@"create_time"];
            [houseDict setObject:updateDate forKey:@"modify_time"];
            
            NSString *key = [NSString stringWithFormat:@"%@%ld", ownerId, type];
            YCHouseModel *modal = [YCHouseModel newWithDict:houseDict];
            
            [dict setObject:modal forKey:key];
        }
    }
    
    return dict;
}

+ (NSMutableDictionary *)queryOwnerSolutionData:(NSString *)houseId
{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT o.mobile, o.workOrderId, s.type FROM Solution s, Owner o where o.mobile = s.ownerId and isDelete != 1 and houseId = '%@';", houseId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *mobile = [set stringForColumn:@"mobile"];
        NSInteger type = [set intForColumn:@"type"];
        NSString *workOrderId = [set stringForColumn:@"workOrderId"];
        
        [paramDict setObject:mobile forKey:@"owner_mobile"];
        [paramDict setObject:[NSNumber numberWithInteger:type] forKey:@"is_copy"];
        [paramDict setObject:workOrderId forKey:@"work_order_id"];
    }
    
    return paramDict;
}

+ (BOOL)queryOwnerSolutionZipFile:(NSString *)houseId
{
    
    BOOL isExist = NO;
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT s.zipUrl FROM Solution s, Owner o where o.id = s.ownerId and isDelete != 1 and houseId = '%@';", houseId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *zipUrl = [set stringForColumn:@"zipUrl"];
        if (zipUrl.length > 1) {
            
            isExist = YES;
        } else {
            
            isExist = NO;
        }
    }
    
    return isExist;
}

+ (BOOL)queryOwnerSolutionObjFile:(NSString *)houseId
{
    
    BOOL isExist = NO;
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT s.objUrl FROM Solution s, Owner o where o.id = s.ownerId and isDelete != 1 and houseId = '%@';", houseId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *objUrl = [set stringForColumn:@"objUrl"];
        if (objUrl.length > 1) {
            
            isExist = YES;
        } else {
            
            isExist = NO;
        }
        
    }
    
    return isExist;
}

#pragma mark - common
+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql != nil) {
        
        return [_fmdb executeUpdate:modifySql];
    }
    
    return NO;
}

@end
