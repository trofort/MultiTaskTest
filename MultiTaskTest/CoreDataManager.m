//
//  CoreDataManager.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 23.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "Task.h"

@implementation CoreDataManager

+(CoreDataManager *)sharedManeger {
     static CoreDataManager *sharedCoreDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCoreDataManager = [[CoreDataManager alloc] init];
    });
    return sharedCoreDataManager;
}

-(NSManagedObjectContext *)getContext {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
}

-(void)saveContext {
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
}

-(NSArray *)getTasks {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TaskModel"];
    NSError *error = nil;
    NSArray *results = [[self getContext] executeFetchRequest:request error:&error];
    
    NSMutableArray<Task *> *taskArray = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *object in results) {
        [taskArray addObject:[[Task alloc] initWithManagedObject:object]];
    }
    return taskArray;
}

-(void)addTask:(Task *)task {
    NSManagedObject *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"TaskModel" inManagedObjectContext:[self getContext]];
    [newTask setValue:@(task.idTask) forKey:@"id"];
    [newTask setValue:task.title forKey:@"title"];
    [newTask setValue:task.startDate forKey:@"startDate"];
    [newTask setValue:task.finishDate forKey:@"finishDate"];
    [newTask setValue:task.estimatedTime forKey:@"estimatedTime"];
    [newTask setValue:@(task.percent) forKey:@"percent"];
    
    switch (task.state) {
        case TaskStateNew:
            [newTask setValue:@(0) forKey:@"state"];
            break;
        case TaskStateInProgress:
            [newTask setValue:@(1) forKey:@"state"];
            break;
        default:
            [newTask setValue:@(2) forKey:@"state"];
            break;
    }
    [newTask setValue:task.descriptionTask forKey:@"descriptionTask"];
    
    [self saveContext];
}

-(void)editTask:(Task *)task {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TaskModel"];
    NSError *error = nil;
    NSArray *results = [[self getContext] executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in results) {
        if ([[object valueForKey:@"id"] integerValue] == task.idTask) {
            [object setValue:task.title forKey:@"title"];
            [object setValue:task.startDate forKey:@"startDate"];
            [object setValue:task.finishDate forKey:@"finishDate"];
            [object setValue:task.estimatedTime forKey:@"estimatedTime"];
            [object setValue:@(task.percent) forKey:@"percent"];
            
            switch (task.state) {
                case TaskStateNew:
                    [object setValue:@(0) forKey:@"state"];
                    break;
                case TaskStateInProgress:
                    [object setValue:@(1) forKey:@"state"];
                    break;
                default:
                    [object setValue:@(2) forKey:@"state"];
                    break;
            }
            [object setValue:task.descriptionTask forKey:@"descriptionTask"];
        }
    }
    
    [self saveContext];
}

-(void)deleteTask:(Task *)task {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TaskModel"];
    NSError *error = nil;
    NSArray *results = [[self getContext] executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in results) {
        if ([[object valueForKey:@"id"] integerValue] == task.idTask) {
            [[self getContext] deleteObject:object];
        }
    }
    [self saveContext];
}

@end
