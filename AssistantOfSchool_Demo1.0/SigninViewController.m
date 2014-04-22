//
//  SigninViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "SigninViewController.h"
#import "MyDataPickerForMajorViewController.h"
#import "WeekCountAndSemester.h"
#import "MyDatePicker.h"
//#import "DatabseDao.h"
@interface SigninViewController ()

@end

@implementation SigninViewController

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
    //[[[DatabseDao alloc] init]openDatabse];
    //[[[DatabseDao alloc] init]createTable];
    [_database createTable];
    
    //[_database deleteUserInfo];
    
    self.navigationItem.title = @"用户注册";
    [self.uEmail setDelegate:self];
    [self.uName setDelegate:self];
    [self.uPwd setDelegate:self];
    [self.uPwd2 setDelegate:self];
    [self.uStuNo setDelegate:self];
    
    [self.majorAndGrade setAdjustsFontSizeToFitWidth:YES];//设置字体自动适应
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signin:(id)sender {
    
    NSString *userEmail = self.uEmail.text;
    NSString *stuNo = self.uStuNo.text;
    NSString *pwd = self.uPwd.text;
    NSString *pwd2 = self.uPwd2.text;
    NSString *userName = self.uName.text;
    NSString *major = self.major;
    NSString *grade = self.grade;
    NSString *semester = self.semester;
    self.timeOfBegin = self.time.text;
    NSString *timeOfBegin = self.time.text;
    NSInteger weekCount = self.weekCount;
    //NSString
    
    if (![pwd isEqualToString:pwd2]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次密码不相同" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        
        [error show];
        
    }else if([pwd isEqualToString:@""] || [userEmail isEqualToString:@""] || [userName isEqualToString:@""] || [stuNo isEqualToString:@""] || [self.majorAndGrade.text isEqualToString:@""] || [self.weeks.text isEqualToString:@""] || [self.time.text isEqualToString:@""]){
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"错误" message:@"信息不可为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        
        [error show];
        
    } else{
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into UserInfo values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d)",userEmail,pwd,userName,stuNo,major,grade,semester,timeOfBegin,weekCount];
        
        //NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into StudentInfo values(%@,%@,%@,%@)",userEmail,pwd,userName,stuNo];
        
        if ([_database insertValues:insertSql]) {
            
            UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"注册成功，快去登陆吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            
            [info show];
            
        } else {
            
            UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"错误" message:@"注册失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            
            [info show];
            
        }
    }

    NSLog(@"%@%@%@%@%@%@%@%@%d",userEmail,pwd,userName,stuNo,self.major,self.grade,self.semester,timeOfBegin,self.weekCount);
    
}

- (IBAction)addMG:(id)sender {
    MyDataPickerForMajorViewController *myDataPicker1 = [[MyDataPickerForMajorViewController alloc] initWithNibName:@"MyDataPickerForMajorViewController" bundle:nil];
    
    [myDataPicker1 acceptVC:self];
    
    [self.navigationController pushViewController:myDataPicker1 animated:YES];
}

- (IBAction)setSemesterAndWeek:(id)sender {
    
    WeekCountAndSemester *ws = [[WeekCountAndSemester alloc] initWithNibName:@"WeekCountAndSemester" bundle:nil];
    
    [ws acceptVC:self];
    
    [self.navigationController pushViewController:ws animated:YES];
}

- (IBAction)addTime:(id)sender {
    
    MyDatePicker *datePicker = [[MyDatePicker alloc] initWithNibName:@"MyDatePicker" bundle:nil];
    
    [datePicker acceptVC:self];
    
    [self.navigationController pushViewController:datePicker animated:YES];
    
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
    [self.uName resignFirstResponder];
    [self.uEmail resignFirstResponder];
    [self.uPwd resignFirstResponder];
    [self.uPwd2 resignFirstResponder];
    [self.uStuNo resignFirstResponder];
    return YES;
}



@end
