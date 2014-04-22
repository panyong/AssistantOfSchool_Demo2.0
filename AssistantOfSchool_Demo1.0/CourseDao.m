//
//  CourseDao.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-7.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "CourseDao.h"
#import "CourseInfo.h"
@implementation CourseDao{
    CourseInfo *courses[15];//测试用 课程表
}


//从服务器获取该学生本学期的课程，然后初始化课程表，并添加到本地数据库
-(void)getCoursesFromServer{
    //一下代码为没有数据库和服务器的情况下测试代码
}


//从本地数据库删除一个指定的课程
-(void)delCourse:(CourseInfo*)ci{
    
}

//增加一个课程，并写入本地数据库
-(void)addCourse:(CourseInfo*)ci{
    
}



@end
