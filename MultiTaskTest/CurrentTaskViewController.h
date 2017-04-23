//
//  CurrentTaskViewController.h
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 21.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface CurrentTaskViewController : UIViewController

-(void)initWithTask:(Task *)task;

@end
