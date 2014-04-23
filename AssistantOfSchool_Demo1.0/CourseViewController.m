//
//  CourseViewController.m
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-6.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import "CourseViewController.h"
#import "AddCourseViewController.h"
#import "DatabseDao.h"
#import "DetailCourseViewController.h"
#import "StudentInfo.h"
#import "SearchedLessonsViewController.h"

@interface CourseViewController ()<UIScrollViewDelegate>

@end

@implementation CourseViewController

{
    UILabel *labelOfWeek[7];  //周一到周日的标签
    
    UILabel *labelOfLesson[12]; //1--12节课的标签
    
    UILabel *labelOfMon;  //表示当前月份的标签
    
    UILabel *labelOfCourse[12][7];  //总计84节课的按钮
    
    
    //课表的按钮的  长度、宽度
    CGFloat widthOfCourse;
    CGFloat heigthOfCourse;
    
    //滚动视图
    UIScrollView *scrollView;
    //数据库操作
    DatabseDao *courseDB;
    
    //当前月份
    int mon;
    
    //当前是单周？
    NSInteger state;
    
    //用户的实例
    StudentInfo *userInfo;
    
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
    
    //添加左侧按钮
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(signMe:)] animated:YES];
    
    //右侧按钮栏
    NSArray *leftBtns = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(settings:)], nil];
    
    //添加右侧按钮
    [self.navigationItem setRightBarButtonItems:leftBtns];
    
    widthOfCourse = (self.view.frame.size.width - 20) / 7;//课号栏宽20
    
    heigthOfCourse = (self.view.frame.size.height - 20  -30) / 8.75;//状态栏20，导航栏50，周几栏高30
    
    courseDB = [[DatabseDao alloc] init];
    
    [courseDB openDatabse];
    
    //[courseDB deleteCourseByNo:4];
    
    [self initStudentInfo];
    
    self.navigationItem.title = [NSString stringWithFormat:@"第%d周",userInfo.weekCount];
    
    if (userInfo.weekCount%2 != 0) {
        state = 0;  //单周
        
    }else
        state = 1;//双周
    
    //设置视图的边界
    [self.view setBounds:[[UIScreen mainScreen] bounds]];
    
    //实例化滚动视图ß
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height)];//状态栏20，导航栏50，周几栏高30
    
    scrollView.delegate = self;//设置滚动视图的委托对象
    
    [scrollView setShowsVerticalScrollIndicator:NO];//禁止显示滚动条
    
    [scrollView setBounces:NO];  //禁止滚动时反弹
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, heigthOfCourse*12.5);
    
    //获取当前时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    mon = [dateComponent month];
    
    //设置时间循环监听
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateWeek:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [self initView];
    
    [self updateCourseView];

}


#pragma mark - Shake

- (BOOL) canBecomeFirstResponder

{
    
    return YES;
    
}

- (void) viewDidAppear:(BOOL)animated

{
    
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
    
}

- (void) viewWillAppear:(BOOL)animated

{
    
    [self resignFirstResponder];
    
    [super viewWillAppear:animated];
    
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
    if (motion == UIEventSubtypeMotionShake) {
        
        [self searchLesson:nil];
    }
    
}

//蹭课
-(void)searchLesson:(id)sender{
    NSLog(@"蹭课");
    
    SearchedLessonsViewController *searchedLessonVC = [[SearchedLessonsViewController alloc] initWithNibName:@"SearchedLessonsViewController" bundle:nil];
    
    [searchedLessonVC acceptDatabase:courseDB andState:state];
    
    [self.navigationController pushViewController:searchedLessonVC animated:YES];
    
}

//签到
-(void)signMe:(id)sender{
    NSLog(@"签到");
}

//设置
-(void)settings:(id)sender{
    NSLog(@"设置");
}

-(void)initStudentInfo{
    userInfo = [courseDB queryUserInfo];
}

-(void)updateWeek:(id)sender{
    //获取当前时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    mon = [dateComponent month];//更新月份
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateOfBegin = [formatter dateFromString:userInfo.timeOfBegin];
    
    NSTimeInterval timeInterval = -[dateOfBegin timeIntervalSinceNow];
    
    NSInteger intervalOfWeek = 1+(timeInterval/60/60/24/7);

    //更新当前周
    if (userInfo.weekCount != intervalOfWeek) {
        [courseDB updateUserInfo:intervalOfWeek];
        
        if (intervalOfWeek%2 != 0) {
            state = 0;  //单周
            
        }else
            state = 1;//双周
        
        [self initStudentInfo];
        
        [self initView];
        
        [self updateCourseView];
    }
    
   //NSLog(@"开学时间%@",userInfo.timeOfBegin);
    
   // NSLog(@"时差%f秒",timeInterval);
    
    //NSLog(@"时差%d周",intervalOfWeek);
}

- (void)didReceiveMemoryWarningv
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//根据数据库中的课程信息绘制课程按钮
-(void)updateCourseView{
    //[self initView];
    //[self removeAllCourse];
    NSMutableArray *courses = [courseDB queryAllCourse];
    _countOfCourses = courses.count ;
    CourseInfo *tempCourse;
    //先测试 ，成功
    NSLog(@"%d节课",_countOfCourses);
    
    for (int i = 0; i < _countOfCourses; i++) {
        tempCourse = [courses objectAtIndex:i];
         NSLog(@"i = %d,编号：%d,第%d周,到%d周,第%d节,到%d节,周%d,状态:%d,课程名:%@,教师:%@,教室:%@",i,tempCourse.courseNo,tempCourse.weekBegin,tempCourse.weekEnd,tempCourse.lessonBegin,tempCourse.lessonEnd,tempCourse.dayOfWeek,tempCourse.state,tempCourse.courseName,tempCourse.teacherName,tempCourse.classroom);
        if (tempCourse.state == state || tempCourse.state == 2) {
            [self drawCourse:tempCourse];
        }
        
        
    }
        
    
}



//根据传进来的课程绘制课程按钮
-(void)drawCourse:(CourseInfo*)course{
    
    CGPoint pointOfCourse;
    
    CGSize sizeOfCourse;
    
    NSLog(@"drawcourse被执行了");
    
    pointOfCourse.x = 20 + widthOfCourse * (course.dayOfWeek - 1);
    
    pointOfCourse.y = heigthOfCourse * (course.lessonBegin - 1);
    
    sizeOfCourse.width = widthOfCourse;
    
    sizeOfCourse.height = heigthOfCourse * (1 + course.lessonEnd - course.lessonBegin);
    
    UIButton *courseButton = [[UIButton alloc] initWithFrame:CGRectMake(pointOfCourse.x, pointOfCourse.y, sizeOfCourse.width, sizeOfCourse.height)];
    
    [courseButton setTitle:[NSString stringWithFormat:@"%@|%@",course.courseName,course.classroom] forState:UIControlStateNormal];     //设置按钮的标题和状态
    
    [courseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置按钮的颜色
    
    [courseButton.titleLabel setAdjustsFontSizeToFitWidth:YES];//设置字体大小自适应
    
    courseButton.titleLabel.lineBreakMode = 0;//设置label自动换行，这样文字就可以正常显示了
    
    [courseButton addTarget:self action:@selector(detailView:) forControlEvents:UIControlEventTouchUpInside];//给按钮添加事件响应
    
    [courseButton setBackgroundColor:[UIColor purpleColor]];
    //[courseButton]还差文本颜色，文本自动换行
    
    [scrollView addSubview:courseButton];
    
}


//详细课程
-(void)detailView:(UIButton*)btn{
    
    DetailCourseViewController *detailVC = [[DetailCourseViewController alloc] initWithNibName:@"DetailCourseViewController" bundle:nil];
    
    [detailVC acceptDatabase:courseDB];
    
    //分解字符串
    NSString *tempStr = btn.titleLabel.text;
    
    NSRange rang = [tempStr rangeOfString:@"|"];
    
    NSString *str1 = [tempStr substringToIndex:rang.location];
    
    NSString *str2 = [tempStr substringFromIndex:rang.location+1];
    
    //NSLog(@"课程名：%@,教室：%@",str1,str2);
    
    
    [detailVC acceptCourseVC:self];
    
    [detailVC acceptCourseName:str1 andClassroom:str2];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [btn removeFromSuperview];
    
}
//初始化视图布局
-(void)initView{
    
    
    [self initLessonNo];
    
    [self initWeek];
    
    
    
    UILabel *month = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+46, 30, 20)];
    
    month.text = [NSString stringWithFormat:@"%d月",mon];
    
    month.textAlignment = NSTextAlignmentLeft;
    
    month.font = [UIFont systemFontOfSize:10];
    
    [self.view addSubview:month];
    [self initCourse];
    
}

//初始化课号栏
-(void)initLessonNo{
    for (int i = 0; i < 12; i++) {
        
        labelOfLesson[i] = [[UILabel alloc] initWithFrame:CGRectMake(0, heigthOfCourse*i, 20, heigthOfCourse)];//设置其左上角坐标和尺寸
        
        [labelOfLesson[i] setBackgroundColor:[UIColor clearColor]]; //设置文本框的背景颜色
        
        labelOfLesson[i].layer.borderWidth = 0.5;  //设置label的边框宽度
        
        labelOfLesson[i].layer.borderColor = [UIColor lightGrayColor].CGColor; //设置label的边框颜色
        
        labelOfLesson[i].text = [NSString stringWithFormat:@"%d",i+1];
        
        labelOfLesson[i].textAlignment = NSTextAlignmentCenter;//文字居中对齐
        
        [scrollView addSubview:labelOfLesson[i]];   //将课号栏添加到滚动视图上
    }
}


//初始化周几栏
-(void)initWeek{
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"周一", @"周二",@"周三",@"周四",@"周五",@"周六",@"周日",nil];
    
    for (int i = 0; i < 7; i++) {
        
        labelOfWeek[i] = [[UILabel alloc] initWithFrame:CGRectMake(20 + i*widthOfCourse, 20+45, widthOfCourse, 30)];
        
        labelOfWeek[i].backgroundColor = [UIColor clearColor]; //设置周几栏的背景颜色
        
        labelOfWeek[i].layer.borderWidth = 0.5;//设置周几栏的边框宽度
        
        labelOfWeek[i].layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        labelOfWeek[i].text = [array objectAtIndex:i];
        
        labelOfWeek[i].textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:labelOfWeek[i]];
    }
}

//初始化课程栏
-(void)initCourse{
    UITapGestureRecognizer *courseGes[12][7];
    
    for (int i = 0; i < 12; i++) {
        
        for (int j = 0; j < 7; j++) {
            
            labelOfCourse[i][j] = [[UILabel alloc] initWithFrame:CGRectMake(20+widthOfCourse*j, heigthOfCourse*i, widthOfCourse, heigthOfCourse)];
            
            labelOfCourse[i][j].backgroundColor = [UIColor clearColor];
            labelOfCourse[i][j].layer.borderWidth = 0.5;
            
            labelOfCourse[i][j].layer.borderColor = [UIColor lightGrayColor].CGColor;
            [scrollView addSubview:labelOfCourse[i][j]];
            
            courseGes[i][j] = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCourse:)];
            
            [labelOfCourse[i][j] addGestureRecognizer:courseGes[i][j]];
            
            labelOfCourse[i][j].userInteractionEnabled = YES;
        }
    }
    
}



//增加课程
-(void)addCourse:(id)sender{
    AddCourseViewController *addCourseVC = [[AddCourseViewController alloc] initWithNibName:@"AddCourseViewController" bundle:nil];
    [addCourseVC acceptCourseVC:self];
    [addCourseVC acceptDatabase:courseDB];
    [self.navigationController pushViewController:addCourseVC animated:YES];
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
    // any offset changes
    //NSLog(@"%f",scrollView1.contentOffset.y);//这里我们输出 scrollView的纵向 偏移量
}
// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewWillBeginDragging");
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@"scrollViewDidEndDragging willDecelerate");
}
// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewWillBeginDecelerating");
}
// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidEndDecelerating");
}

@end
