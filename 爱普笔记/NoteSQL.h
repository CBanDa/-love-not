//
//  NoteSQL.h
//  爱普笔记本
//
//  Created by XieJunqiang on 13-11-28.
//  Copyright (c) 2013年 ldci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// 数据库
@interface NoteSQL : NSObject{
    sqlite3 *sql;
}

// 建库
- (BOOL)createDB;
// 建表
- (BOOL)createGroupTable :(NSString *)createsql;
// 增删改查:
- (BOOL)insertGroupTitle:(NSString *)Title andGroupID:(int)ID;
- (NSMutableArray *)selectGroupData;
- (BOOL)updateGroupTitle:(NSString *)title atID:(int)ID;
- (BOOL)deleteFromGroupTable:(int)ID;
// 增加数据
- (BOOL)insertNoteTitle:(NSString *)title noteText:(NSString *)noteText date:(NSString *)date noteID:(int)noteID noteGroupID:(int)noteGroupID;
// 取数
// 1.通过GroupID,只取标题,时间,ID
- (NSMutableArray *)selectNoteTitle:(int)GroupID;
// 2.通过GroupID,NoteID,取标题和内容
- (NSMutableArray *)selectNoteText:(int)GroupID :(int)NoteID;
- (BOOL)updateNoteTitle:(NSString *)title noteText:(NSString *)text date:(NSString *)date atGroupID:(int)GroupID atNoteID:(int)NoteID;
- (BOOL)deleteFromNoteTable:(int)GroupID :(int)NoteID;
- (BOOL)deleteAllFromNoteTable:(int)ID;
// 图片处理
- (BOOL)updateNoteImage:(NSString *)imageName GroupID:(int)groupID NoteID:(int)noteID;
- (NSMutableArray *)selectNoteImage:(int)GroupID :(int)NoteID;
// 处理提醒
- (BOOL)insertData:(NSString *)_time andMessage:(NSString *)_message andid:(int)_id;
- (NSMutableArray *)selectData;
- (BOOL)updateData:(NSString *)_time andMessage:(NSString *)_message andId:(int)_id;
- (BOOL)deleteData:(int)_id;
@end
