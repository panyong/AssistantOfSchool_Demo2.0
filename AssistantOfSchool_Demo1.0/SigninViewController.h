//
//  SigninViewController.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "DatabseDao.h"
@interface SigninViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *uEmail;
@property (weak, nonatomic) IBOutlet UITextField *uPwd;
@property (weak, nonatomic) IBOutlet UITextField *uPwd2;
@property (weak, nonatomic) IBOutlet UITextField *uName;
@property (weak, nonatomic) IBOutlet UITextField *uStuNo;
@property (weak, nonatomic) IBOutlet UITextField *majorAndGrade;
@property (weak, nonatomic) IBOutlet UITextField *weeks;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak,nonatomic) NSString *major;
@property (weak,nonatomic) NSString *grade;
@property (weak,nonatomic) NSString *semester;
@property (weak,nonatomic) NSString *timeOfBegin;
@property  NSInteger weekCount;

@property DatabseDao *database;
- (IBAction)signin:(id)sender;
- (IBAction)addMG:(id)sender;
- (IBAction)setSemesterAndWeek:(id)sender;
- (IBAction)addTime:(id)sender;


@end
