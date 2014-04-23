//
//  SearchedLessonsViewController.h
//  AssistantOfSchool_Demo1.0
//
//  Created by PY on 14-4-23.
//  Copyright (c) 2014年 shiep.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabseDao.h"

@interface SearchedLessonsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableViewOfSL;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


-(void)acceptDatabase:(DatabseDao*)tempDB andState:(NSInteger)tempState;
@end
