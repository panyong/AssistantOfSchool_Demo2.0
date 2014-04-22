//
//  MyDatePicker.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-20.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "MyDatePicker.h"

@interface MyDatePicker ()

@end

@implementation MyDatePicker{
    SigninViewController *signinVC;
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
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [self.navigationItem setTitle:@"本学期开学日期"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)acceptVC:(SigninViewController*)tempVC{
    signinVC = tempVC;
}

- (IBAction)ok:(id)sender {
    
    NSDate *selectedDate = [self.picker date];//获取日期
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//初始化日期格式
    
    [formatter setDateFormat:@"yyyy-MM-dd"]; //设置日期格式
    
    NSString *strOfDate = [formatter stringFromDate:selectedDate]; //将日期转换为字符串
    
    NSLog(@"%@",strOfDate);
    
    signinVC.timeOfBegin = strOfDate;
    
    signinVC.time.text = strOfDate;
    
    NSLog(@"为空？%@",signinVC.timeOfBegin);
    
    [self.navigationController popToViewController:signinVC animated:YES];
    
}

- (IBAction)cancle:(id)sender {
    
    [self.navigationController popToViewController:signinVC animated:YES];
}
@end
