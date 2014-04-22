//
//  WeekCountAndSemester.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-16.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigninViewController.h"

@interface WeekCountAndSemester : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)ok:(id)sender;
- (IBAction)cancle:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

-(void)acceptVC:(SigninViewController*)tempVC;
@end
