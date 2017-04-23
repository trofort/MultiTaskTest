//
//  CurrentTaskViewController.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 21.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "CurrentTaskViewController.h"

@interface CurrentTaskViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDate;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *percentProgressView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTimeLabel;

@property(strong, nonatomic) Task *localTask;

@end

@implementation CurrentTaskViewController

#pragma mark - Life Cicle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initWithTask

-(void)initWithTask:(Task *)task {
    self.localTask = task;
}

#pragma mark - Customize View Controller

- (void)customize {
    self.titleLabel.text = self.localTask.title;
    self.dueDate.text = [NSString stringWithFormat:@"%@-%@", self.localTask.startDate, self.localTask.finishDate];
    self.percentLabel.text = [NSString stringWithFormat:@"Complete:%ld%%", (long)self.localTask.percent];
    self.percentProgressView.progress = ((CGFloat)self.localTask.percent) / 100;
    
    if (self.localTask.percent <= 10) {
        self.percentProgressView.progressTintColor = [UIColor redColor];
    } else if (self.localTask.percent <= 70) {
        self.percentProgressView.progressTintColor = [UIColor yellowColor];
    } else {
        self.percentProgressView.progressTintColor = [UIColor greenColor];
    }
    
    if (self.localTask.state == TaskStateNew) {
        self.statusLabel.textColor = [UIColor blueColor];
        self.statusLabel.text = @"New";
    } else if (self.localTask.state == TaskStateInProgress) {
        self.statusLabel.textColor = [UIColor orangeColor];
        self.statusLabel.text = @"In progress";
    } else {
        self.statusLabel.textColor = [UIColor greenColor];
        self.statusLabel.text = @"Done";
    }
    
    self.estimatedTimeLabel.text = [NSString stringWithFormat:@"Estimated time: %@", self.localTask.estimatedTime];
    
    self.descriptionLabel.text = self.localTask.descriptionTask;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
