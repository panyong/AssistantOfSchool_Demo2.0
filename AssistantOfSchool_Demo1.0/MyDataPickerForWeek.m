//
//  MyDataPickerForWeek.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-8.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "MyDataPickerForWeek.h"

@interface MyDataPickerForWeek ()

@end

@implementation MyDataPickerForWeek{
    NSArray *state;
    NSString *selectedState;
    NSInteger selectedWeekBegin;
    NSInteger selectedWeekEnd;
    AddCourseViewController *addVC;
    
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
    self.navigationItem.title = @"选择周数";
    state = [[NSArray alloc] initWithObjects:@"单周",@"双周",@"全周", nil];
    selectedState = @"单周";
    selectedWeekBegin = 1;
    selectedWeekEnd =1;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;//本选择器包含3列
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {//返回每一列所包含的元素个数
        return state.count;
    }else if(component == 1){
        if ([selectedState isEqualToString:@"全周"]) {
            return 20;
        }else
             return 10;
    }else{
        if ([selectedState isEqualToString:@"全周"]) {
            return 20 - selectedWeekBegin + 1;
        }else
            return (20 - selectedWeekBegin)/2 + 1;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{          //返回指定列和指定行的数据
    
    if (component == 0) {
        return [state objectAtIndex:row];
    }
    
    if (component == 1) {
        if ([selectedState isEqualToString:@"单周"]) {
            return [NSString stringWithFormat:@"%d",1+2*row];
        }
        if ([selectedState isEqualToString:@"双周"]) {
            return [NSString stringWithFormat:@"%d",2+2*row];
        }
        return [NSString stringWithFormat:@"%d",1+row];
    }
    
    
    if ([selectedState isEqualToString:@"全周"]) {
        return [NSString stringWithFormat:@"%d",selectedWeekBegin+row];
    }
    
    return [NSString stringWithFormat:@"%d",selectedWeekBegin+2*row];
    
    
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{//当滚轮被滚动时触发该事件
    
    if (component == 0) {
        selectedState = [state objectAtIndex:row];
        if ([selectedState isEqualToString:@"双周"]) {
            selectedWeekBegin = 2;
        }
        [_picker reloadComponent:1];
        [_picker reloadComponent:2];//测试  不知可行否
    }
    
    if (component == 1) {
        if ([selectedState isEqualToString:@"单周"]) {
            selectedWeekBegin =  1+2*row;
            //NSLog(@"%d",selectedWeekBegin);
        }
        if ([selectedState isEqualToString:@"双周"]) {
            selectedWeekBegin =  2+2*row;
            //NSLog(@"%d",selectedWeekBegin);
        }
        if ([selectedState isEqualToString:@"全周"]) {
            selectedWeekBegin =  1+row;
            //NSLog(@"%d",selectedWeekBegin);
        }
        
        [_picker reloadComponent:2];
    }
    if (component == 2) {
        if ([selectedState isEqualToString:@"全周"]) {
            selectedWeekEnd = selectedWeekBegin + row;
        }else{
            selectedWeekEnd = selectedWeekBegin + 2*row;
        }
    }
    
    
}


-(void)acceptVC:(AddCourseViewController*)vc{
    addVC = vc;
}


- (IBAction)ok:(id)sender {
    addVC.weeks.text = [NSString stringWithFormat:@"%@ 第%d周到%d周",selectedState,selectedWeekBegin,selectedWeekEnd];
    
    NSLog(@"%d,%d,%d",[state indexOfObject:selectedState],selectedWeekBegin,selectedWeekEnd);
    
    addVC.course.state = [state indexOfObject:selectedState];
    addVC.course.weekBegin = selectedWeekBegin;
    addVC.course.weekEnd = selectedWeekEnd;
    
    [self.navigationController popToViewController:addVC animated:YES];
    
    
}

- (IBAction)cancle:(id)sender {
    [self.navigationController popToViewController:addVC animated:YES];
}
@end
