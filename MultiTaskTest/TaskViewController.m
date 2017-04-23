//
//  TaskViewController.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 20.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"
#import "CurrentTaskViewController.h"
#import "CoreDataManager.h"

@interface TaskViewController ()

@property (weak, nonatomic) IBOutlet UILabel *noTasksLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<Task *> *taskArray;

@end

@implementation TaskViewController

#pragma mark - Lifi Cicle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskArray = [NSMutableArray arrayWithArray:[[CoreDataManager sharedManeger] getTasks]];
    [self.tableView reloadData];
    self.noTasksLabel.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.taskArray.count == 0) {
        self.tableView.hidden = YES;
        self.noTasksLabel.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noTasksLabel.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    [cell initCellWithTask:self.taskArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        AddTaskViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addTaskID"];
        [addVC initWithTask:self.taskArray[indexPath.row]];
        addVC.delegate = self;
        [self presentViewController:addVC animated:YES completion:nil];
    } else {
        CurrentTaskViewController *currentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"currentTaskID"];
        [currentVC initWithTask:self.taskArray[indexPath.row]];
        [self.navigationController pushViewController:currentVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [[CoreDataManager sharedManeger] deleteTask:self.taskArray[indexPath.row]];
        
        [self.taskArray removeObjectAtIndex:indexPath.row];
        [tableView endUpdates];
        
        if (self.taskArray.count == 0) {
            self.tableView.hidden = YES;
            self.noTasksLabel.hidden = NO;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editListOfTasks:)];
        }
    } 
}

#pragma mark - TaskDelegate

- (void)addTask:(Task *)task {
    [self.taskArray addObject:task];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.taskArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    [[CoreDataManager sharedManeger] addTask:task];
}

- (void)editTask:(Task *)task {
    for (Task *searchTask in self.taskArray) {
        if (searchTask.idTask == task.idTask) {
            [searchTask copyFromTask:task];
        }
    }
    [[CoreDataManager sharedManeger] editTask:task];
    [self.tableView reloadData];
}

#pragma mark - Actions

-(IBAction)editListOfTasks:(id)sender {
    if (self.taskArray.count != 0) {
        if (self.tableView.editing) {
            [self.tableView setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editListOfTasks:)];
        } else {
            [self.tableView setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editListOfTasks:)];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Just try to add some tasks" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)addNewTask:(id)sender {
    AddTaskViewController* addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addTaskID"];
    addVC.delegate = self;
    [self presentViewController:addVC animated:YES completion:nil];
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
