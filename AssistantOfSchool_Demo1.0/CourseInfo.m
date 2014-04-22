//
//  CourseInfo.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "CourseInfo.h"

@implementation CourseInfo


//构造函数
-(id)initWithCourseNo:(NSInteger)no weekBegin:(NSInteger)wb weekEnd:(NSInteger) we lessonBegin:(NSInteger)lb lessonEnd:(NSInteger)le dayOfWeek:(NSInteger)dow state:(NSInteger)state courseName:(NSString*)cn teacherName:(NSString*)tn classroom:(NSString*)cs{
    
    self = [super init];
    if (self) {
        self.courseNo = no;
        self.weekBegin = wb;
        self.weekEnd = we;
        self.lessonBegin = lb;
        self.lessonEnd = le;
        self.dayOfWeek = dow;
        self.state =state;
        self.courseName = cn;
        self.teacherName = tn;
        self.classroom = cs;
    }
    
    return self;
}

-(void)displayMe{
    NSLog(@"第%d周,到%d周,第%d节,到%d节,周%d,状态:%d,课程名:%@,教师:%@,教室:%@",self.weekBegin,self.weekEnd,self.lessonBegin,self.lessonEnd,self.dayOfWeek,self.state,self.courseName,self.teacherName,self.classroom);
}
@end
