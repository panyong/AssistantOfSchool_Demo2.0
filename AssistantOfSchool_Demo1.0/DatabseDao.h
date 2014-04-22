//
//  DatabseDao.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-6.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class StudentInfo;
#import "StudentInfo.h"
#import "sqlite3.h"
#import "CourseInfo.h"
@interface DatabseDao : NSObject
@property sqlite3 *studentDB;
@property NSString *databasePath;

-(BOOL)openDatabse;
-(void)closeDB;

-(BOOL)createTable;

-(BOOL)insertValues:(NSString*)sql;

-(StudentInfo*)queryStuInfoByEmail:(NSString*)email;

-(BOOL)createTableOfCourse;

-(NSMutableArray*)queryAllCourse;

-(void)deleteCourseByNo:(NSInteger)no;

-(CourseInfo*)queryCourseByName:(NSString*)name andClassroom:(NSString*)classroom;

-(StudentInfo*)queryUserInfo;

-(void)deleteUserInfo;

-(void)updateUserInfo:(NSInteger)newWeek;
@end
