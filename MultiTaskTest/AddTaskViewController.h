//
//  AddTaskViewController.h
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 21.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface AddTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id<TaskDelegate> delegate;

-(void)initWithTask:(Task *)task;

@end
