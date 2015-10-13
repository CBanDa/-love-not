//
//  NoteSQL.m
//  爱普笔记本
//
//  Created by XieJunqiang on 13-11-28.
//  Copyright (c) 2013年 ldci. All rights reserved.
//

#import "NoteSQL.h"

@implementation NoteSQL

// 建库
- (BOOL)createDB
{
    // 获取路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   
    NSString *path = [pathArray objectAtIndex:0];

    NSString *pathForSQL = [path  stringByAppendingPathComponent:@"mySQL.sql"];
    
    if (sqlite3_open([pathForSQL UTF8String], &sql) !=SQLITE_OK){
        sqlite3_close(sql);
        return NO;
    }
    return YES;
}

// 建立所有表

/*
    数据库表有三张
    1：GroupTable
    2：NoteTable
    3：RemindTable
*/
- (BOOL)createGroupTable :(NSString *)createsql
{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, [createsql UTF8String], -1, &stmt, nil) != SQLITE_OK)
        return NO;
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}


// 表1添加数据
- (BOOL)insertGroupTitle:(NSString *)Title andGroupID:(int)ID
{
    char *insertSQL = "insert into GroupTable (GroupTitle,GroupID) values (?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, insertSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_text(stmt, 1, [Title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 2, ID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 获取全部信息
- (NSMutableArray *)selectGroupData
{
    char *selectSQL = "select * from GroupTable";
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(sql, selectSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(stmt) == SQLITE_ROW){
        
        char *dbTitle = (char *)sqlite3_column_text(stmt, 0);
        NSString *title = [NSString stringWithCString:dbTitle encoding:NSUTF8StringEncoding];

        int ID = (int)sqlite3_column_int(stmt, 1);
        NSArray *arr = [NSArray arrayWithObjects:title,[NSString stringWithFormat:@"%i",ID], nil];

        [array addObject:arr];
    }
    sqlite3_finalize(stmt);
    return array;
}

// 表格的更新
- (BOOL)updateGroupTitle:(NSString *)title atID:(int)ID
{
    char *updateSQL = "update GroupTable set GroupTitle = ? where GroupID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, updateSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_text(stmt, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 2, ID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 根据id进行删除
- (BOOL)deleteFromGroupTable:(int)ID
{
    char *deleteSQL = "delete from GroupTable where GroupID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, deleteSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, ID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 数据的添加 （拓展：创建数据类）
- (BOOL)insertNoteTitle:(NSString *)title noteText:(NSString *)noteText date:(NSString *)date noteID:(int)noteID noteGroupID:(int)noteGroupID
{
    char *insertSQL = "insert into NoteTable (GroupID,NoteID,NoteTitle,NoteText,Date) values (?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, insertSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, noteGroupID);
    sqlite3_bind_int(stmt, 2, noteID);
    sqlite3_bind_text(stmt, 3, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [noteText UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [date UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 获取数据
- (NSMutableArray *)selectNoteTitle:(int)GroupID
{
    char *selectSQL = "select NoteTitle,Date,NoteID from NoteTable where GroupID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, selectSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, GroupID);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while (sqlite3_step(stmt) == SQLITE_ROW){
        char *dbTitle = (char *)sqlite3_column_text(stmt, 0);
        NSString *title = [NSString stringWithCString:dbTitle encoding:NSUTF8StringEncoding];
        char *dbDate = (char *)sqlite3_column_text(stmt, 1);
        NSString *date = [NSString stringWithCString:dbDate encoding:NSUTF8StringEncoding];
        int ID = (int)sqlite3_column_int(stmt, 2);
        NSArray *arr = [NSArray arrayWithObjects:title,date,[NSString stringWithFormat:@"%i",ID], nil];
        [array addObject:arr];
    }
    sqlite3_finalize(stmt);
    return array;
}

// 获取数据
- (NSMutableArray *)selectNoteText:(int)GroupID :(int)NoteID
{
    char *selectSQL = "select NoteTitle,NoteText from NoteTable where GroupID = ? and NoteID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, selectSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, GroupID);
    sqlite3_bind_int(stmt, 2, NoteID);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while (sqlite3_step(stmt) == SQLITE_ROW){
        char *dbTitle = (char*)sqlite3_column_text(stmt, 0);
        NSString *title = [NSString stringWithCString:dbTitle encoding:NSUTF8StringEncoding];
        char *dbText = (char*)sqlite3_column_text(stmt, 1);
        NSString *noteText = [NSString stringWithCString:dbText encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSArray arrayWithObjects:title,noteText, nil];
        [array addObject:arr];
    }
    sqlite3_finalize(stmt);
    return array;
}

// 更新
- (BOOL)updateNoteTitle:(NSString *)title noteText:(NSString *)text date:(NSString *)date atGroupID:(int)GroupID atNoteID:(int)NoteID
{
    char *updateSQL = "update NoteTable set NoteTitle = ?,NoteText = ?,date = ? where GroupID = ? and NoteID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, updateSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_text(stmt, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [text UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [date UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, GroupID);
    sqlite3_bind_int(stmt, 5, NoteID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 删除
- (BOOL)deleteFromNoteTable:(int)GroupID :(int)NoteID
{
    char *deleteSQL = "delete from NoteTable where GroupID = ? and NoteID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, deleteSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, GroupID);
    sqlite3_bind_int(stmt, 2, NoteID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 删除
- (BOOL)deleteAllFromNoteTable:(int)ID
{
    char *deleteSQL = "delete from NoteTable where GroupID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, deleteSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, ID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

// 图片处理
- (BOOL)updateNoteImage:(NSString *)imageName GroupID:(int)groupID NoteID:(int)noteID
{
    char *updateSQL = "update NoteTable set NoteImage = ? where GroupID = ? and NoteID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, updateSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_text(stmt, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 2, groupID);
    sqlite3_bind_int(stmt, 3, noteID);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

- (NSMutableArray *)selectNoteImage:(int)GroupID :(int)NoteID
{
    char *selectSQL = "select NoteImage from NoteTable where GroupID = ? and NoteID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, selectSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, GroupID);
    sqlite3_bind_int(stmt, 2, NoteID);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while (sqlite3_step(stmt) == SQLITE_ROW){
        char *dbImage = (char*)sqlite3_column_text(stmt, 0);
        NSString *image;
        if (dbImage == NULL) 
            break;
        else
            image = [NSString stringWithCString:dbImage encoding:NSUTF8StringEncoding];

        [array addObject:image];
    }
    sqlite3_finalize(stmt);
    return array;

}

// 提醒的增删改查
- (BOOL)insertData:(NSString *)_time andMessage:(NSString *)_message andid:(int)_id
{
    char *insertSQL = "insert into RemindTable (id,time,message) values (?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, insertSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, _id);
    sqlite3_bind_text(stmt, 2, [_time UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [_message UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

- (NSMutableArray *)selectData
{
    char *selectSQL = "select * from RemindTable";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, selectSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    while (sqlite3_step(stmt) == SQLITE_ROW){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
        
        int dbid = (int)sqlite3_column_int(stmt, 0);
        NSNumber *idnum = [NSNumber numberWithInt:dbid];
        [dic setObject:idnum forKey:@"id"];
        
        char *dbtime = (char*)sqlite3_column_text(stmt, 1);
        NSString *time;
        if (dbtime == NULL)
            time = @"";
        else
            time = [NSString stringWithCString:dbtime encoding:NSUTF8StringEncoding];
        [dic setObject:time forKey:@"time"];
        
        
        
        char *dbmessage = (char*)sqlite3_column_text(stmt, 2);
        NSString *message;
        if (dbmessage == NULL)
            message = @"";
        else
            message = [NSString stringWithCString:dbmessage encoding:NSUTF8StringEncoding];
        [dic setObject:message forKey:@"message"];
        
        [array addObject:dic];
    }
    sqlite3_finalize(stmt);
    return array;
}

- (BOOL)updateData:(NSString *)_time andMessage:(NSString *)_message andId:(int)_id
{
    char *updateSQL = "update RemindTable set time = ? , message = ? where id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, updateSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_text(stmt, 1, [_time UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [_message UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, _id);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

- (BOOL)deleteData:(int)_id
{
    char *deleteSQL = "delete from RemindTable where id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sql, deleteSQL, -1, &stmt, nil) != SQLITE_OK){
        return NO;
    }
    sqlite3_bind_int(stmt, 1, _id);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return YES;
}

@end

