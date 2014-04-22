//
//  MyDataPickerForMajorViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-16.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "MyDataPickerForMajorViewController.h"

@interface MyDataPickerForMajorViewController ()

@end

@implementation MyDataPickerForMajorViewController{
    
    NSDictionary *majors;
    
    NSArray *college;
    
    NSArray *grade;
    
    NSString *selectedCollege;
    
    NSString *selectedMajor;
    
    NSString *selectedGrade;
    
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
    college = [NSArray arrayWithObjects:@"计算机科学与技术学院",@"电子信息与工程学院", nil];
    
    majors = [[NSDictionary alloc] initWithObjectsAndKeys:[NSArray arrayWithObjects:@"计算机科学与技术",@"软件工程",@"信息安全",@"计算机科学与技术(电企方向)",nil], @"计算机科学与技术学院",
              [NSArray arrayWithObjects:@"电子科学与技术",@"电子信息与工程",@"通信工程",@"光电信息工程",nil], @"电子信息与工程学院",nil];
    
    grade = [NSArray arrayWithObjects:@"大一",@"大二",@"大三",@"大四", nil];
    
    selectedCollege = @"计算机科学与技术学院";
    
    selectedMajor = @"计算机科学与技术";
    
    selectedGrade = @"大一";
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [self.navigationItem setTitle:@"专业信息选择"];
    //[self.picker ]
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//设置每列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat tempWidth = self.view.frame.size.width / 7;
    if (component == 2) {
        return tempWidth-5;
    }else
        return tempWidth*3 -5;
}

//设置字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        //[pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//委托要求实现的方法，返回pickerview要显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;//本选择器包含3列，学院，专业，年级
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {//返回每一列所包含的元素个数
        
        return college.count;
        
    }else if(component == 1){
        
        return [[majors objectForKey:selectedCollege] count];
        
    }else{
        
        return 4;
        
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{          //返回指定列和指定行的数据
    
    if (component == 0) {
        
        return [college objectAtIndex:row];
        
    }
    
    if (component == 1) {
        
        return [[majors objectForKey:selectedCollege] objectAtIndex:row];
        
    }
    
    return [grade objectAtIndex:row];
    
    
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{//当滚轮被滚动时触发该事件
    
    if (component == 0) {
        
        selectedCollege = [college objectAtIndex:row];
        
        [_picker reloadComponent:1];
    }
    
    if (component == 1) {
        
        selectedMajor = [[majors objectForKey:selectedCollege] objectAtIndex:row];
        
    }
    if (component == 2) {
        
        selectedGrade = [grade objectAtIndex:row];
        
    }
    
     NSLog(@"%@%@专业%@",selectedCollege,selectedMajor,selectedGrade);
}


-(void)acceptVC:(SigninViewController*)tempVC{
    
    signinVC = tempVC;
}

- (IBAction)ok:(id)sender {
    
    signinVC.majorAndGrade.text = [NSString stringWithFormat:@"%@专业%@",selectedMajor,selectedGrade];
    
    signinVC.major = selectedMajor;
    
    signinVC.grade = selectedGrade;
    
    
    [self.navigationController popToViewController:signinVC animated:YES];
    //NSLog(@"%@%@专业%@",selectedCollege,selectedMajor,selectedGrade);
}

- (IBAction)cancle:(id)sender {
    [self.navigationController popToViewController:signinVC animated:YES];
}
@end
