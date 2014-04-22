//
//  LoginViewController.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-4.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *uname;
@property (weak, nonatomic) IBOutlet UITextField *upwd;

- (IBAction)login:(id)sender;
- (IBAction)signin:(id)sender;
@end
