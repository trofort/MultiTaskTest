//
//  TaskTableViewCell.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 20.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - initWithTask

-(void)initCellWithTask:(Task *)task {
    self.titleLabel.text = task.title;
    self.dateLabel.text = task.startDate;
    self.completeLabel.text = [NSString stringWithFormat: @"Complete: %ld%%", (long)task.percent];
    self.descriptionLabel.text = task.descriptionTask;
    
    if (task.state == TaskStateNew) {
        self.statusLabel.textColor = [UIColor blueColor];
        self.statusLabel.text = @"New";
    } else if (task.state == TaskStateInProgress) {
        self.statusLabel.textColor = [UIColor orangeColor];
        self.statusLabel.text = @"In progress";
    } else {
        self.statusLabel.textColor = [UIColor greenColor];
        self.statusLabel.text = @"Done";
    }
    
    self.completeProgressView.progress = ((CGFloat)task.percent) / 100;
    
    if (task.percent <= 10) {
        self.completeProgressView.progressTintColor = [UIColor redColor];
    } else if (task.percent <= 70) {
        self.completeProgressView.progressTintColor = [UIColor yellowColor];
    } else {
        self.completeProgressView.progressTintColor = [UIColor greenColor];
    }
}

@end
