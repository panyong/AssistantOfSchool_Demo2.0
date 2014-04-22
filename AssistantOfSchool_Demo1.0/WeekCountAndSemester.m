//
//  WeekCountAndSemester.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-16.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "WeekCountAndSemester.h"

@interface WeekCountAndSemester ()

@end

@implementation WeekCountAndSemester{
    NSArray *semester;
    //NSArray *weekCount;
    
    NSString *selectedSemester;
    
    NSInteger weekCount;
    
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
    
    semester = [NSArray arrayWithObjects:@"第一学期",@"第二学期", nil];
    
    selectedSemester = @"第一学期";
    
    weekCount = 1;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.navigationItem.title = @"当前学期选择";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;//本选择器包含3列
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {//返回每一列所包含的元素个数
        return semester.count;
    }else
        return 23;
        
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{          //返回指定列和指定行的数据
    
    if (component == 0) {
        return [semester objectAtIndex:row];
    }
    return [NSString stringWithFormat:@"当前第%d周",row+1];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{//当滚轮被滚动时触发该事件
    
    if (component == 0) {
        selectedSemester = [semester objectAtIndex:row];
    }
    
    if (component == 1) {
        weekCount = row + 1;
    }
}


-(void)acceptVC:(SigninViewController*)tempVC{
    signinVC = tempVC;
}

- (IBAction)ok:(id)sender {
    signinVC.weeks.text = [NSString stringWithFormat:@"现在是%@第%d周",selectedSemester,weekCount];
    
    signinVC.semester = selectedSemester;
    
    signinVC.weekCount = weekCount;
    
    
    
    [self.navigationController popToViewController:signinVC animated:YES];
    
}

- (IBAction)cancle:(id)sender {
    [self.navigationController popToViewController:signinVC animated:YES];
}
@end
