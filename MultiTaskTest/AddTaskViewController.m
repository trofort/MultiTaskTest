//
//  AddTaskViewController.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 21.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "AddTaskViewController.h"
#import "UITextField+isEmpty.h"
#import "UIColor+MainColor.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *estimtedTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *finishDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *percentTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak ,nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *finishDatePicker;
@property (strong, nonatomic) Task* localTask;

@property (strong, nonatomic) NSArray *arrayOfStatus;
@property (assign, nonatomic) TaskStateType selectedStatus;

@end

@implementation AddTaskViewController

#pragma mark - Life Cicle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfStatus = [NSArray arrayWithObjects:@"New", @"In progress", @"Done", nil];
    [self customize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.titleTextField becomeFirstResponder];
}

#pragma mark - initWithTask

-(void)initWithTask:(Task *)task {
    self.localTask = task;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter a description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter a description";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.heightDescriptionTextView.constant = [textView sizeThatFits:textView.frame.size].height;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.startDateTextField]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        self.startDateTextField.text = [formatter stringFromDate:[[NSDate alloc] init]];
    }
    
    if ([textField isEqual:self.finishDateTextField]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        self.finishDateTextField.text = [formatter stringFromDate:[[NSDate alloc] init]];
    }
    
    if ([textField isEqual:self.statusTextField]) {
        self.selectedStatus = TaskStateNew;
        self.statusTextField.text = @"New";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.percentTextField]) {
        if ([textField.text integerValue] > 100) {
            textField.text = @"100";
        }
        
        if ([textField.text integerValue] < 0) {
            textField.text = @"0";
        }
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.arrayOfStatus.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.arrayOfStatus[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.statusTextField.text = self.arrayOfStatus[row];
    
    switch (row) {
        case 0:
            self.selectedStatus = TaskStateNew;
            break;
        case 1:
            self.selectedStatus = TaskStateInProgress;
            break;
        default:
            self.selectedStatus = TaskStateDone;
            break;
    }
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveTask:(id)sender {
    if (![self.titleTextField isEmpty] && ![self.estimtedTimeTextField isEmpty] && ![self.startDateTextField isEmpty] && ![self.finishDateTextField isEmpty] && ![self.percentTextField isEmpty] && ![self.descriptionTextView.text isEqualToString:@""]) {
        if (self.localTask) {
            Task *changes = [[Task alloc] initWithTitle:self.titleTextField.text andDescription:self.descriptionTextView.text andStartDate:self.startDateTextField.text andFinishDate:self.finishDateTextField.text andState:self.selectedStatus andPercent:[self.percentTextField.text integerValue] andEstimatedTime:self.estimtedTimeTextField.text];
            [self.localTask copyFromTask:changes];
            [self.delegate editTask:self.localTask];
        } else {
            [self.delegate addTask:[[Task alloc] initWithTitle:self.titleTextField.text andDescription:self.descriptionTextView.text andStartDate:self.startDateTextField.text andFinishDate:self.finishDateTextField.text andState:self.selectedStatus andPercent:[self.percentTextField.text integerValue] andEstimatedTime:self.estimtedTimeTextField.text]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, fill in all the fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - DatePickerAction

- (void) chooseEstimateTime:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.estimtedTimeTextField.text = [formatter stringFromDate:datePicker.date];
}

- (void) chooseStartDate:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    self.startDateTextField.text = [formatter stringFromDate:datePicker.date];
    self.finishDatePicker.minimumDate = datePicker.date;
}

- (void) chooseFinishDate:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    self.finishDateTextField.text = [formatter stringFromDate:datePicker.date];
    self.startDatePicker.maximumDate = datePicker.date;
}


#pragma mark - Customize View Controller

-(void)customize {
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.layer.borderWidth = 0.5;
    self.descriptionTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.heightDescriptionTextView.constant = [self.descriptionTextView sizeThatFits:self.descriptionTextView.frame.size].height;
    
    UIDatePicker *timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.minuteInterval = 30;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    timePicker.date = [formatter dateFromString:@"00:00"];
    [timePicker addTarget:self action:@selector(chooseEstimateTime:) forControlEvents:UIControlEventValueChanged];
    self.estimtedTimeTextField.inputView = timePicker;
    
    UIDatePicker *startDatePicker = [[UIDatePicker alloc] init];
    startDatePicker.datePickerMode = UIDatePickerModeDate;
    [startDatePicker addTarget:self action:@selector(chooseStartDate:) forControlEvents:UIControlEventValueChanged];
    self.startDateTextField.inputView = startDatePicker;
    self.startDatePicker = startDatePicker;
    
    UIDatePicker *finishDatePicker = [[UIDatePicker alloc] init];
    finishDatePicker.datePickerMode = UIDatePickerModeDate;
    [finishDatePicker addTarget:self action:@selector(chooseFinishDate:) forControlEvents:UIControlEventValueChanged];
    self.finishDateTextField.inputView = finishDatePicker;
    self.finishDatePicker = finishDatePicker;
    
    UIPickerView *statusPickerView = [[UIPickerView alloc] init];
    statusPickerView.delegate = self;
    statusPickerView.dataSource = self;
    self.statusTextField.inputView = statusPickerView;
    
    if (self.localTask) {
        self.titleTextField.text = self.localTask.title;
        self.descriptionTextView.text = self.localTask.descriptionTask;
        self.estimtedTimeTextField.text = self.localTask.estimatedTime;
        self.startDateTextField.text = self.localTask.startDate;
        self.finishDateTextField.text = self.localTask.finishDate;
        self.percentTextField.text = [NSString stringWithFormat:@"%ld", (long) self.localTask.percent];
        
        switch (self.localTask.state) {
            case TaskStateNew:
                self.statusTextField.text = @"New";
                break;
            case TaskStateInProgress:
                self.statusTextField.text = @"In progress";
                break;
            default:
                self.statusTextField.text = @"Done";
                break;
        }
        
        self.descriptionTextView.textColor = [UIColor blackColor];
    }
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
