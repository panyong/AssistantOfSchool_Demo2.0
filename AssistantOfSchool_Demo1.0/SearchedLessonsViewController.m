//
//  SearchedLessonsViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-23.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "SearchedLessonsViewController.h"

@interface SearchedLessonsViewController (){
    
}

@end

@implementation SearchedLessonsViewController{
    
    DatabseDao *database;//声明数据库实例
    
    NSMutableArray *lessonsArray;//存储从数据库中读出来的课程
    
    NSInteger MyWeekDay;//现在周几
    
    NSInteger lessonCount;//第几节课
    
    NSInteger state;//单周？
    
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
    
    [self.navigationItem setTitle:@"蹭课"];
    
    lessonsArray = [[NSMutableArray alloc] init];
    //获取当前时间，周几，第几节课
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    //CGFloat minuteNow = [dateComponent minute];
    
    NSInteger hourNow = [dateComponent hour];
    
    if (hourNow > 13) {
        lessonCount = [dateComponent hour] - 8;//现在是第几节课
    } else {
        lessonCount = [dateComponent hour] - 7;//现在是第几节课
    }
    
    
    MyWeekDay = ([dateComponent weekday]+6)%7;//第一天是周日，所以要 +6mod7
    
    //NSLog(@"第%d节课,今天周%d",lessonCount,MyWeekDay);
    
    
    //获取数据库中所有的课程，其实应该是在服务器端实现并传回当前时间的其他课程，这里还要进行筛选
    NSMutableArray *tempArray = [database queryAllCourse];
    
    //将符合条件（今天、上课时间在现在后面）的课程取出
    for (CourseInfo *course in tempArray) {
        
        if (course.dayOfWeek == MyWeekDay && course.lessonBegin >= lessonCount && (course.state == state || course.state == 2)) {
            
            [lessonsArray addObject:course];
            
            //NSLog(@"可蹭课程 第%d周,到%d周,第%d节,到%d节,周%d,状态:%d,课程名:%@,教师:%@,教室:%@",course.weekBegin,course.weekEnd,course.lessonBegin,course.lessonEnd,course.dayOfWeek,course.state,course.courseName,course.teacherName,course.classroom);
            
        }
    }
    
}



//返回表中的cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lessonsArray count];
}


//返回实例化的表格
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentify = @"MyCell";//Cell的标识
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];//初始化cell,复用
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    
    //设置要显示的字符串
    NSString *info = [NSString stringWithFormat:@"课程名称:%@ 教室:%@,第%d节到%d节",
                      [[lessonsArray objectAtIndex: indexPath.row] courseName],
                      [[lessonsArray objectAtIndex:indexPath.row] classroom],
                      [[lessonsArray objectAtIndex:indexPath.row] lessonBegin],
                      [[lessonsArray objectAtIndex:indexPath.row] lessonEnd]];
    
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
    if (lessonsArray.count != 0) {
        [cell.textLabel setText:info];
        self.infoLabel.text = [NSString stringWithFormat:@"今天可蹭课程数:%d",lessonsArray.count];
    } else {
        //[cell.textLabel setText:@""];
        self.infoLabel.text = @"抱歉，今天已无课可蹭";
    }
    
    
    
    return cell;
}


//接收传进来的database实例
-(void)acceptDatabase:(DatabseDao*)tempDB andState:(NSInteger)tempState{
    
    database = tempDB;
    
    state = tempState;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
