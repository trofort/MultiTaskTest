//
//  Task.h
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 20.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@protocol TaskDelegate <NSObject>
@optional
-(void)addTask:(Task *_Nullable)task;
-(void)editTask:(Task *_Nullable)task;
@end

typedef NS_ENUM(NSInteger, TaskStateType) {
    TaskStateNew,
    TaskStateInProgress,
    TaskStateDone,
};

//NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject

@property (assign, nonatomic) NSInteger idTask;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *finishDate;
@property (assign, nonatomic) TaskStateType state;
@property (assign, nonatomic) NSInteger percent;
@property (strong, nonatomic) NSString *descriptionTask;
@property (strong, nonatomic) NSString *estimatedTime;

-(Task *)initWithTitle:(NSString *)title andDescription:(NSString *)description andStartDate:(NSString *)startDate andFinishDate:(NSString *)finishDate andState:(TaskStateType)state andPercent:(NSInteger)percent andEstimatedTime:(NSString *)estimtedTime;

-(Task *)initWithManagedObject:(NSManagedObject *)managedObject;

-(void)copyFromTask:(Task *)task;

@end

//NS_ASSUME_NONNULL_END
//
//#import "Task+CoreDataProperties.h"
