//
//  DatabseDao.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-6.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "DatabseDao.h"
//#import "StudentInfo.h"
@implementation DatabseDao

//获取文件路径
-(NSString*)getDatabasePath{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathName = [path objectAtIndex:0];
    return [pathName stringByAppendingPathComponent:@"studentDB.sqlite3"];
}

//打开数据库
-(BOOL)openDatabse{
    if (sqlite3_open([[self getDatabasePath] UTF8String], &_studentDB) != SQLITE_OK) {
        
        sqlite3_close(_studentDB);
        NSLog(@"打开数据库失败");
        return NO;
        
    } else {
        NSLog(@"打开数据库成功");
        return  YES;
    }
}

//关闭数据库
-(void)closeDB{
    sqlite3_close(_studentDB);
}
//创建Student表
-(BOOL)createTable{
    
    char *errMsg;
    
    NSString *createSql =  [NSString stringWithFormat:@"create table if not exists UserInfo(userEmail text primary key,userPwd text,userName text,userNo text,major text,grade text,semester text,timeOfBegin text,weekCount integer)"];
        
    if (sqlite3_exec(_studentDB, [createSql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        
        sqlite3_close(_studentDB);
        
        NSLog(@"创建表失败:%s",errMsg);
        
        return NO;
        
    } else {
        
        NSLog(@"创建表成功");
        
        return YES;
        
    }
    
}


//创建Course表
-(BOOL)createTableOfCourse{
    char *errMsg;
    NSString *createSql = [NSString stringWithFormat:@"create table if not exists Courses(courseNo integer primary key,weekBegin integer,weekEnd integer,lessonBegin integer,lessonEnd integer,dayOfWeek integer,state integer,courseName text,teacherName text,classroom text)"];
    
    if (sqlite3_exec(_studentDB, [createSql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        sqlite3_close(_studentDB);
        NSLog(@"创建表失败:%s",errMsg);
        return NO;
    } else {
        NSLog(@"创建表成功");
        return YES;
    }

}

//插入数据
-(BOOL)insertValues:(NSString*)sql{
    sqlite3_stmt *statement;
    
    const char *insertSql = [sql UTF8String];
    
    if(sqlite3_prepare_v2(_studentDB, insertSql, -1, &statement, NULL) != SQLITE_OK){
        NSLog(@"插入数据失败");
        return NO;
        
    }
    
    int success=sqlite3_step(statement);
    sqlite3_finalize(statement);
    if(success==SQLITE_ERROR)
    {
        NSLog(@"插入失败");
        return NO;
    }
    NSLog(@"插入一个数据成功");
    return YES;
}

//删除用户信息
-(void)deleteUserInfo{
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"delete from UserInfo"];
    const char *query_stmt = [querySql UTF8String];
    if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_step(statement);
        NSLog(@"删除数据成功");
    } else {
        
        NSLog(@"命令行出问题了");
    }
    sqlite3_finalize(statement);
}

//修改用户信息
-(void)updateUserInfo:(NSInteger)newWeek{
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"update UserInfo set weekCount = %d",newWeek];
    const char *query_stmt = [querySql UTF8String];
    if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_step(statement);
        NSLog(@"删除数据成功");
    } else {
        
        NSLog(@"命令行出问题了");
    }
    sqlite3_finalize(statement);
}


//通过用户注册邮箱查询用户信息
-(StudentInfo*)queryStuInfoByEmail:(NSString*)email{
    StudentInfo* stu;
    NSString *uEmail,*uPwd,*uName,*uNo;
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"select * from UserInfo where userEmail = \"%@\"",email];
    const char *query_stmt = [querySql UTF8String];
        if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                uEmail = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                uPwd = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                uName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                uNo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            }
                
        } else {
            
            NSLog(@"命令行出问题了");
        }
        sqlite3_finalize(statement);
    stu = [[StudentInfo alloc] initWithEmail:uEmail pwd:uPwd name:uName andNo:uNo andMajor:nil andGrade:nil andSem:nil andTime:nil andWeek:1];
    return stu;
    
}

//查询用户信息
-(StudentInfo*)queryUserInfo{
    StudentInfo* stu;
    NSString *uEmail,*uPwd,*uName,*uNo,*major,*grade,*sem,*timeOfBegin;
    NSInteger week;
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"select * from UserInfo"];
    const char *query_stmt = [querySql UTF8String];
    if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            uEmail = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            uPwd = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            uName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            uNo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            major = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            grade =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            sem = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
            timeOfBegin = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
            week = sqlite3_column_int(statement, 8);
            NSLog(@"%@%@%@%@%@%@%@%@%d",uEmail,uPwd,uName,uNo,major,grade,sem,timeOfBegin,week);
        }
        
    } else {
        
        NSLog(@"命令行出问题了");
    }
    sqlite3_finalize(statement);
    stu = [[StudentInfo alloc] initWithEmail:uEmail pwd:uPwd name:uName andNo:uNo andMajor:major andGrade:grade andSem:sem andTime:timeOfBegin andWeek:week];
    return stu;
    
}


//获取所有德课程信息,只有可变数组才能add,还可以通过数组中的count来确定下课数据的ID
-(NSMutableArray*)queryAllCourse{
    NSMutableArray *courseArray = [[NSMutableArray alloc]init];
    //
    sqlite3_stmt *statement;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from Courses"];
    const char *query_stmt = [querySql UTF8String];
    if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            CourseInfo* course = [[CourseInfo alloc] init];  //这个语句放在for循环外会出现添加的时同一个东西
            course.courseNo = sqlite3_column_int(statement, 0);
            course.weekBegin = sqlite3_column_int(statement, 1);
            course.weekEnd = sqlite3_column_int(statement, 2);
            course.lessonBegin = sqlite3_column_int(statement, 3);
            course.lessonEnd = sqlite3_column_int(statement, 4);
            course.dayOfWeek = sqlite3_column_int(statement, 5);
            course.state = sqlite3_column_int(statement, 6);
            
            course.courseName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
            course.teacherName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
            course.classroom = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 9)];
            
             NSLog(@"第%d周,到%d周,第%d节,到%d节,周%d,状态:%d,课程名:%@,教师:%@,教室:%@",course.weekBegin,course.weekEnd,course.lessonBegin,course.lessonEnd,course.dayOfWeek,course.state,course.courseName,course.teacherName,course.classroom);
            
            
            [courseArray addObject:course];
            
        }
        
    } else {
        
        NSLog(@"命令行出问题了");
    }
    sqlite3_finalize(statement);
    
    return courseArray;

}

//通过课程号来删除数据
-(void)deleteCourseByNo:(NSInteger)no{
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"delete from Courses where courseNo = %d",no];
    const char *query_stmt = [querySql UTF8String];
    if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_step(statement);
        NSLog(@"删除数据成功");
    } else {
        
        NSLog(@"命令行出问题了");
    }
    sqlite3_finalize(statement);
}

//通过课程名和教室来查询课程信息
-(CourseInfo*)queryCourseByName:(NSString*)name andClassroom:(NSString*)classroom{
    
    CourseInfo* course = [[CourseInfo alloc] init];
    sqlite3_stmt *statement;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from Courses where courseName = \"%@\" and classroom = \"%@\"",name,classroom];
    const char *query_stmt = [querySql UTF8String];
    if (sqlite3_prepare_v2(_studentDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            course.courseNo = sqlite3_column_int(statement, 0);
            course.weekBegin = sqlite3_column_int(statement, 1);
            course.weekEnd = sqlite3_column_int(statement, 2);
            course.lessonBegin = sqlite3_column_int(statement, 3);
            course.lessonEnd = sqlite3_column_int(statement, 4);
            course.dayOfWeek = sqlite3_column_int(statement, 5);
            course.state = sqlite3_column_int(statement, 6);
            
            course.courseName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
            course.teacherName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
            course.classroom = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 9)];
            
            NSLog(@"第%d周,到%d周,第%d节,到%d节,周%d,状态:%d,课程名:%@,教师:%@,教室:%@",course.weekBegin,course.weekEnd,course.lessonBegin,course.lessonEnd,course.dayOfWeek,course.state,course.courseName,course.teacherName,course.classroom);
            
        }
        
    } else {
        
        NSLog(@"命令行出问题了");
    }
    sqlite3_finalize(statement);
    
    return course;

}

@end
