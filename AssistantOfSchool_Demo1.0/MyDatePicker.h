//
//  MyDatePicker.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-20.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigninViewController.h"
@interface MyDatePicker : UIViewController
- (IBAction)ok:(id)sender;

- (IBAction)cancle:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;

-(void)acceptVC:(SigninViewController*)tempVC;
@end
