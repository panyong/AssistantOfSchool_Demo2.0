//
//  CourseInfo.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#define QZ 0;
#define DZ 1;
#define SZ 2;


//fuck!  不能被直接赋值！不用这些了，烦！
//枚举体，确定课程是单周、双周还是全周
typedef enum{
    QUAN = 0,
    DAN = 1,
    SHUANG = 2
}CourseState;

//结构体，标识课程的上课时间
typedef struct{
    NSInteger weekBegin;
    NSInteger weekEnd;
    NSInteger lessonBegin;
    NSInteger lessonEnd;
    CourseState state;
}CourseTime;

#import <Foundation/Foundation.h>
//课程信息类 映射 课程信息表
@interface CourseInfo : NSObject
@property NSInteger courseNo;
@property NSInteger weekBegin;
@property NSInteger weekEnd;
@property NSInteger lessonBegin;
@property NSInteger lessonEnd;
@property NSInteger dayOfWeek;
@property NSInteger state;
@property NSString *courseName;
@property NSString *teacherName;
@property NSString *classroom;

-(id)initWithCourseNo:(NSInteger)no weekBegin:(NSInteger)wb weekEnd:(NSInteger) we lessonBegin:(NSInteger)lb lessonEnd:(NSInteger)le dayOfWeek:(NSInteger)dow state:(NSInteger)state courseName:(NSString*)cn teacherName:(NSString*)tn classroom:(NSString*)cs;

-(void)displayMe;

@end
