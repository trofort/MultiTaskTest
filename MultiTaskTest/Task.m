//
//  Task.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 20.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "Task.h"

@implementation Task

-(Task *)initWithTitle:(NSString *)title andDescription:(NSString *)description andStartDate:(NSString *)startDate andFinishDate:(NSString *)finishDate andState:(TaskStateType)state andPercent:(NSInteger)percent andEstimatedTime:(NSString *)estimtedTime {
    self.title = title;
    self.idTask = (NSInteger)[[[NSDate alloc] init] timeIntervalSince1970];
    
    self.descriptionTask = description;
    self.startDate = startDate;
    self.finishDate = finishDate;
    self.state = state;
    
    if (percent > 100) {
        self.percent = 100;
    } else {
        self.percent = percent;
    }
    self.estimatedTime = estimtedTime;
    return self;
}

-(Task *)initWithManagedObject:(NSManagedObject *)managedObject {
    self.idTask = [[managedObject valueForKey:@"id"] integerValue];
    self.title = [managedObject valueForKey:@"title"];
    self.descriptionTask = [managedObject valueForKey:@"descriptionTask"];
    self.startDate = [managedObject valueForKey:@"startDate"];
    self.finishDate = [managedObject valueForKey:@"finishDate"];
    
    NSInteger stateIndex = [[managedObject valueForKey:@"state"] integerValue];
    switch (stateIndex) {
        case 0:
            self.state = TaskStateNew;
            break;
        case 1:
            self.state = TaskStateInProgress;
            break;
        default:
            self.state = TaskStateDone;
            break;
    }
    
    self.percent = [[managedObject valueForKey:@"percent"] integerValue];
    self.estimatedTime = [managedObject valueForKey:@"estimatedTime"];
    return self;
}

-(void)copyFromTask:(Task *)task {
    self.title = task.title;
    self.descriptionTask = task.descriptionTask;
    self.startDate = task.startDate;
    self.finishDate = task.finishDate;
    self.state = task.state;
    self.estimatedTime = task.estimatedTime;
    self.percent = task.percent;
}

@end
