//
//  CoreDataManager.h
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 23.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Task.h"

@interface CoreDataManager : NSObject

+(CoreDataManager *)sharedManeger;

-(void)saveContext;

-(NSArray *)getTasks;
-(void)addTask:(Task *)task;
-(void)editTask:(Task *)task;
-(void)deleteTask:(Task *)task;

@end
