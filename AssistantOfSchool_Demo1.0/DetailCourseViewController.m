//
//  DetailCourseViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-7.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "DetailCourseViewController.h"
//#import "DatabseDao.h"
#import "CourseInfo.h"

@interface DetailCourseViewController ()

@end

@implementation DetailCourseViewController{
    DatabseDao *database;
    CourseInfo *course;
    CourseViewController *courseVC;
    NSString *cName;
    NSString *cRoom;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *arry = [NSArray arrayWithObjects:@"单周",@"双周",@"全周",nil];
    NSArray *arry2 = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.title = @"详细视图";
    course = [database queryCourseByName:cName andClassroom:cRoom];
    self.courseName.text = course.courseName;
    self.teacherName.text = course.teacherName;
    self.classroom.text = course.classroom;
    
    self.weekBenginAndEnd.text = [NSString stringWithFormat:@"第%d周到%d周",course.weekBegin,course.weekEnd];
    self.lessonBeginAndEnd.text = [[NSString alloc] initWithFormat:@"%@ %@第%d节到%d节",[arry objectAtIndex:course.state],[arry2 objectAtIndex:course.dayOfWeek-1],course.lessonBegin,course.lessonEnd];
    
    //初始化store并请求授权
    self.store = [[EKEventStore alloc] init];
    [self requestCalendarAccess];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)accessGrantedForCalendar
{
    // Update the UI with the above events
    [self.addEventBtn setEnabled:YES];
}

// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self accessGrantedForCalendar];
             });
         }
     }];
}

- (IBAction)goBack:(id)sender {
    [courseVC updateCourseView];
    [self.navigationController popToViewController:courseVC animated:YES];
}

//删除课程
- (IBAction)deleteCourse:(id)sender {
    [database deleteCourseByNo:course.courseNo];
    [courseVC updateCourseView];
    [self.navigationController popToViewController:courseVC animated:YES];
}



//将作业添加到日历提醒
- (IBAction)addEvent:(id)sender {
    //初始化事件
    EKEvent *workEvent = [EKEvent eventWithEventStore:self.store];
    
    //初始化开始时间设置作业的5天后进行事件提醒
    NSDate *statrtDate = [[NSDate alloc] init];//[NSDate dateWithTimeIntervalSinceNow:5*24*60*60];
    
    //初始化结束时间，开始时间后的1分钟
    NSDate *endDate = [[NSDate alloc] init];//[NSDate dateWithTimeIntervalSinceNow:5*24*60*60 + 60];
    
    //设置提醒的标题和内容
    [workEvent setTitle:@"赶紧做作业了!"];
    
    [workEvent setNotes:self.homework.text];
    
    //设置事件的开始和结束时间
    [workEvent setStartDate:statrtDate];
    
    [workEvent setEndDate:endDate];
    
    [workEvent setAllDay:YES];
    
    //添加到日历中
    EKCalendar *calendar = [self.store defaultCalendarForNewEvents];
    
    [workEvent setCalendar:calendar];
    
    NSError *err = nil;
    
    [self.store saveEvent:workEvent span:EKSpanThisEvent error:&err];
    
    if (err == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"event create success." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"event create failed." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)acceptCourseVC:(CourseViewController*)tempVC{
    courseVC = tempVC;
}
-(void)acceptDatabase:(DatabseDao*)tempDao{
    database = tempDao;
}
-(void)acceptCourseName:(NSString*)name andClassroom:(NSString*)room{
    cName = name;
    cRoom = room;
}





//当文本框获得焦点时调用，将当前编辑的文本框移到视图中键盘上方
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //键盘的尺寸
    CGFloat keyboardHeight = 216.0f;
    //如果文本框被键盘遮挡则调用下列语句
    if (self.view.frame.size.height - keyboardHeight  - 80<= textField.frame.origin.y + textField.frame.size.height){
        
        //
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height - 5 - 80);
        
        [UIView beginAnimations:@"ScollView" context:nil];//设置动画
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//设置动画曲线
        [UIView setAnimationDuration:0.275f];//设置动画时间
        //重新绘制视图框架
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];//提交动画
        
    }
}

//文本框失去焦点后
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.courseName resignFirstResponder];
    [self.teacherName resignFirstResponder];
    [self.classroom resignFirstResponder];
    [self.weekBenginAndEnd resignFirstResponder];
    [self.lessonBeginAndEnd resignFirstResponder];
    [self.homework resignFirstResponder];
    return YES;
}

@end
