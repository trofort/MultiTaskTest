//
//  AppDelegate.h
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 20.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

