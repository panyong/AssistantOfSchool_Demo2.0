//
//  StudentInfo.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "StudentInfo.h"

@implementation StudentInfo

/*+(id)alloc{
    return [self alloc];
}*/
-(StudentInfo*)initWithEmail:(NSString*)email pwd:(NSString*)pwd name:(NSString*)name andNo:(NSString*)no andMajor:(NSString*)major andGrade:(NSString*)grade andSem:(NSString*)sem andTime:(NSString*)time andWeek:(NSInteger)week;{
    self = [super init];
    if (self) {
        self.userEmail = email;
        self.userPwd =pwd;
        self.userName = name;
        self.userNo = no;
        self.major = major;
        self.grade = grade;
        self.semester = sem;
        self.timeOfBegin = time;
        self.weekCount = week;
    }
    
    
    return self;
}
@end
