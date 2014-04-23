//
//  DetailCourseViewController.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-7.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabseDao.h"
#import "CourseViewController.h"
#import <EventKit/EventKit.h>
@interface DetailCourseViewController : UIViewController<UITextFieldDelegate>

@property EKEventStore *store;

@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *teacherName;
@property (weak, nonatomic) IBOutlet UITextField *classroom;
@property (weak, nonatomic) IBOutlet UITextField *weekBenginAndEnd;
@property (weak, nonatomic) IBOutlet UITextField *lessonBeginAndEnd;
@property (weak, nonatomic) IBOutlet UIButton *addEventBtn;
@property (weak, nonatomic) IBOutlet UITextField *homework;
- (IBAction)addEvent:(id)sender;


-(void)acceptCourseVC:(CourseViewController*)tempVC;
- (IBAction)goBack:(id)sender;

- (IBAction)deleteCourse:(id)sender;

-(void)acceptDatabase:(DatabseDao*)tempDao;
-(void)acceptCourseName:(NSString*)name andClassroom:(NSString*)room;
@end
