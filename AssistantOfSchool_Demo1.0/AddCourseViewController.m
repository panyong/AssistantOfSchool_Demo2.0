//
//  AddCourseViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-7.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "AddCourseViewController.h"
#import "MyDataPicker.h"
#import "MyDataPickerForWeek.h"
//#import "DatabseDao.h"
//#import "CourseInfo.h"
@interface AddCourseViewController ()

@end

@implementation AddCourseViewController{
    CourseViewController *tempVC;
    DatabseDao *database;
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
    self.navigationItem.title = @"添加课程";
    self.course = [[CourseInfo alloc] init];//实例化该对象
    [database createTableOfCourse];
    //database = [[DatabseDao alloc] init];
    //self.lessons.enabled = NO;
    //测试用,成功
    NSLog(@"%d节课",tempVC.countOfCourses);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectLesson:(id)sender {
    MyDataPicker *myDataPicker = [[MyDataPicker alloc] initWithNibName:@"MyDataPicker" bundle:nil];
    [myDataPicker acceptVC:self];
    //[self.view addSubview:myDataPicker.view];
    [self.navigationController pushViewController:myDataPicker animated:YES];
}

- (IBAction)selectWeek:(id)sender {
    MyDataPickerForWeek *myDataPickerForWeek = [[MyDataPickerForWeek alloc] initWithNibName:@"MyDataPickerForWeek" bundle:nil];
    [myDataPickerForWeek acceptVC:self];
    [self.navigationController pushViewController:myDataPickerForWeek animated:YES];
}
- (IBAction)okAdd:(id)sender {
    if ([self.courseName.text isEqualToString:@""] || [self.teacher.text isEqualToString:@""] ||[self.classroom.text isEqualToString:@""] || [self.weeks.text isEqualToString:@""] || [self.lessons.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:@"信息不能为空!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    }else{
        
        self.course.courseName = self.courseName.text;
        self.course.teacherName = self.teacher.text;
        self.course.classroom = self.classroom.text;
        //NSLog(@"不要点我啊!");
        //NSLog(@"第%d周,到%d周,第%d节,到%d节,周%d,状态:%d,课程名:%@,教师:%@,教室:%@",self.course.weekBegin,self.course.weekEnd,self.course.lessonBegin,self.course.lessonEnd,self.course.dayOfWeek,self.course.state,self.course.courseName,self.course.teacherName,self.course.classroom);
        //[self.course displayMe];
        
        //这里要先调用databasedao的插入数据方法，再调用courseview的刷新方法
       self.course.courseNo = tempVC.countOfCourses+1;
        
        if (![self hasTheSameCourse:self.course]) {
            NSString *sql = [NSString stringWithFormat:@"insert into Courses values(%d,%d,%d,%d,%d,%d,%d,\"%@\",\"%@\",\"%@\")",self.course.courseNo,self.course.weekBegin,self.course.weekEnd,self.course.lessonBegin,self.course.lessonEnd,self.course.dayOfWeek,self.course.state,self.course.courseName,self.course.teacherName,self.course.classroom];
            
            [database insertValues:sql];
            
            [tempVC updateCourseView];
            
            [self.navigationController popToViewController:tempVC animated:YES];
        }else{
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:@"该课程与现有课程冲突!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        
      
    }
    
    
    
}


//判断现有课程是否与添加的课程冲突   14.4.23修复BUG
-(BOOL)hasTheSameCourse:(CourseInfo*)course{
    NSMutableArray *courses = [database queryAllCourse];
    
    for (CourseInfo *tempCourse in courses) {
        
        if (tempCourse.state != 2) {
            if ( (course.dayOfWeek == tempCourse.dayOfWeek) && (course.state == tempCourse.state) && ( (course.lessonBegin >= tempCourse.lessonBegin && course.lessonBegin <= tempCourse.lessonEnd) || (course.lessonEnd >= tempCourse.lessonBegin && course.lessonEnd <= tempCourse.lessonEnd) ) ) {
                return YES;
                break;
            }
        } else {
            if ( (course.dayOfWeek == tempCourse.dayOfWeek) && ( (course.lessonBegin >= tempCourse.lessonBegin && course.lessonBegin <= tempCourse.lessonEnd) || (course.lessonEnd >= tempCourse.lessonBegin && course.lessonEnd <= tempCourse.lessonEnd))) {
                return YES;
                break;
            }
        }
       
    }
    
    return NO;
}

-(void)acceptDatabase:(DatabseDao*)temp{
    database = temp;
}
-(void)acceptCourseVC:(CourseViewController*)courseVC{
    tempVC = courseVC;
}

//当文本框获得焦点时调用，将当前编辑的文本框移到视图中键盘上方
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //键盘的尺寸
    CGFloat keyboardHeight = 216.0f;
    //如果文本框被键盘遮挡则调用下列语句
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height){
        
        //
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height - 5);
        
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
    [self.teacher resignFirstResponder];
    [self.classroom resignFirstResponder];

    return YES;
}



@end
