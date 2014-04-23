//
//  AddCourseViewController.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-7.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInfo.h"
#import "CourseViewController.h"
#import "DatabseDao.h"
@interface AddCourseViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *teacher;
@property (weak, nonatomic) IBOutlet UITextField *classroom;
@property (weak, nonatomic) IBOutlet UITextField *lessons;
@property (weak, nonatomic) IBOutlet UITextField *weeks;
@property CourseInfo *course;

- (IBAction)selectLesson:(id)sender;
- (IBAction)selectWeek:(id)sender;

- (IBAction)okAdd:(id)sender;


-(void)acceptCourseVC:(CourseViewController*)courseVC;
-(void)acceptDatabase:(DatabseDao*)temp;
@end
