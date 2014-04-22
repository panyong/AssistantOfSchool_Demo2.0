//
//  MyDataPicker.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-7.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "MyDataPicker.h"
@class AddCourseViewController;
@interface MyDataPicker ()

@end

@implementation MyDataPicker{
    NSArray *week;
    NSArray *lessonBegin;
    NSArray *lessonEnded;
    NSDictionary *lessonEnd;
    NSString *selectedLesson;
    NSString *weekStr;
    NSString *lessonBeginStr;
    NSString *lessonEndStr;
    AddCourseViewController *addCourseVC;
    NSInteger dayOfWeek;
    NSInteger firstLesson;
    NSInteger endLesson;
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
    self.navigationItem.title = @"选择节数";
    week = [[NSArray alloc] initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    
    lessonBegin = [[NSArray alloc] initWithObjects:@"第1节",@"第2节",@"第3节",@"第4节",@"第5节",@"第6节",@"第7节",@"第8节",@"第9节",@"第10节",@"第11节",@"第12节",nil];
    lessonEnded = [[NSArray alloc] initWithObjects:@"到1节",@"到2节",@"到3节",@"到4节",@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节",nil];
    lessonEnd = [[NSDictionary alloc] initWithObjectsAndKeys:
                 [NSArray arrayWithObjects:@"到1节",@"到2节",@"到3节",@"到4节",@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第1节",
                 [NSArray arrayWithObjects:@"到2节",@"到3节",@"到4节",@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第2节",
                 [NSArray arrayWithObjects:@"到3节",@"到4节",@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第3节",
                 [NSArray arrayWithObjects:@"到4节",@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第4节",
                 [NSArray arrayWithObjects:@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第5节",
                 [NSArray arrayWithObjects:@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第6节",
                 [NSArray arrayWithObjects:@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第7节",
                 [NSArray arrayWithObjects:@"到8节",@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第8节",
                 [NSArray arrayWithObjects:@"到9节",@"到10节",@"到11节",@"到12节", nil],@"第9节",
                 [NSArray arrayWithObjects:@"到10节",@"到11节",@"到12节", nil],@"第10节",
                 [NSArray arrayWithObjects:@"到11节",@"到12节", nil],@"第11节",
                 [NSArray arrayWithObjects:@"到12节", nil],@"第12节",nil];
    selectedLesson = @"第1节";
    
    
    //[self acceptVC:<#(AddCourseViewController *)#>
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;//本选择器包含3列
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {//返回每一列所包含的元素个数
        return week.count;
    }else if(component == 1){
        return 12;
    }else{
        return [[lessonEnd objectForKey:selectedLesson] count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{          //返回指定列和指定行的数据
    
    if (component == 0) {
        return [week objectAtIndex:row];
    }
    
    if (component == 1) {
        return [lessonBegin objectAtIndex:row];
    }
    
    return [[lessonEnd objectForKey:selectedLesson] objectAtIndex:row];
    
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        weekStr = [week objectAtIndex:row];
    }
    
    if (component == 1) {
        lessonBeginStr = [lessonBegin objectAtIndex:row];
        
        selectedLesson = [lessonBegin objectAtIndex:row];
        lessonEndStr = [[lessonEnd objectForKey:selectedLesson] objectAtIndex:0];
        [_picker reloadComponent:2];
    }
    if (component == 2) {
        lessonEndStr = [[lessonEnd objectForKey:selectedLesson] objectAtIndex:row];
    }
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ok:(id)sender {
    if (weekStr == nil) {
        weekStr = @"周一";
    }
    if (lessonBeginStr == nil) {
        lessonBeginStr = selectedLesson;
        
    }
    if (lessonEndStr == nil) {
        lessonEndStr = [[lessonEnd objectForKey:selectedLesson] objectAtIndex:0];
    }
    NSString *courseTime = [NSString stringWithFormat:@"%@ %@%@",weekStr,lessonBeginStr,lessonEndStr];
    addCourseVC.lessons.text = courseTime;
    
    dayOfWeek = [week indexOfObject:weekStr] + 1;
    firstLesson = [lessonBegin indexOfObject:lessonBeginStr] + 1;
    endLesson = [lessonEnded indexOfObject:lessonEndStr] + 1;
    NSLog(@"%d,%d,%d",dayOfWeek,firstLesson,endLesson);
    addCourseVC.course.dayOfWeek = dayOfWeek;
    addCourseVC.course.lessonBegin = firstLesson;
    addCourseVC.course.lessonEnd =endLesson;
    
    [self.navigationController popViewControllerAnimated:YES];//回到原视图
}

- (IBAction)cancle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)acceptVC:(AddCourseViewController*)acvc{
    addCourseVC = acvc;
}


@end
