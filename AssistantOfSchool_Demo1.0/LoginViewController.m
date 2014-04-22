//
//  LoginViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "LoginViewController.h"
#import "CourseViewController.h"
#import "SigninViewController.h"
#import "DatabseDao.h"
#import "StudentInfo.h"
@interface LoginViewController ()

@end

@implementation LoginViewController{
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
    database = [[DatabseDao alloc] init];
    self.navigationItem.title = @"用户登陆";
    [database openDatabse];
    //[database createTable];
    //[[[DatabseDao alloc] init]createTable];
    [self.uname setDelegate:self];
    [self.upwd setDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//登陆按钮事件响应
- (IBAction)login:(id)sender {
    NSString *uname = self.uname.text;
    NSString *upwd = self.upwd.text;
    
   
    
    if ([upwd isEqualToString:@""] || [uname isEqualToString:@""]) {//nil 和 @""不一样
        UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"用户名或密码不能为空!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [info show];
    }else{
        StudentInfo *stu = [database queryStuInfoByEmail:uname];
        if ([upwd isEqualToString:stu.userPwd]) {
            //验证成功，进入课程表视图  导航进入
            [database closeDB];
            CourseViewController *courseVC = [[CourseViewController alloc] initWithNibName:nil bundle:nil];
            [courseVC.navigationItem setHidesBackButton:YES animated:YES];//隐藏返回按钮
            [self.navigationController pushViewController:courseVC animated:YES];
            //[self presentViewController:courseVC animated:YES completion:nil];
        }else{
            UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [info show];
        }
    }
    
}

- (IBAction)signin:(id)sender {
    //用导航器跳转到注册视图
    SigninViewController *signinVC = [[SigninViewController alloc] initWithNibName:@"SigninViewController" bundle:nil];
    signinVC.database = database;
    [self.navigationController pushViewController:signinVC animated:YES ];
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
    [self.uname resignFirstResponder];
    [self.upwd resignFirstResponder];
    return YES;
}


@end
