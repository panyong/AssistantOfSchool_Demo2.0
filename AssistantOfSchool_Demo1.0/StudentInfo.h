//
//  StudentInfo.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentInfo : NSObject
@property NSString *userEmail;
@property NSString *userPwd;
@property NSString *userName;
@property NSString *userNo;
@property NSString *major;
@property NSString *grade;
@property NSString *semester;
@property NSString *timeOfBegin;
@property NSInteger weekCount;
//+(id)alloc;
-(StudentInfo*)initWithEmail:(NSString*)email pwd:(NSString*)pwd name:(NSString*)name andNo:(NSString*)no andMajor:(NSString*)major andGrade:(NSString*)grade andSem:(NSString*)sem andTime:(NSString*)time andWeek:(NSInteger)week;
@end
