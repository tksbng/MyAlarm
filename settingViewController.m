//
//  settingViewController.m
//  MyAlarm
//
//  Created by Takeshi Bingo on 2013/08/13.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "settingViewController.h"

@interface settingViewController ()

@end

@implementation settingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    picker.datePickerMode = UIDatePickerModeTime;
}

-(IBAction)saveButtonCliked:(id)sender {
    [self.delegate didSaveButtonClicked:self selectedDate:picker.date pickerName:self.pickerName];
}

-(IBAction)cancelButtonCliked:(id)sender {
    [self.delegate didCancelButtonClicked:self pickerName:self.pickerName];
    
}
-(IBAction)refreshButtonCliked:(id)sender   {
    [self.delegate didRefreshButtonClicked:self pickerName:self.pickerName];
}

-(void)viewDidAppear:(BOOL)animated {
    if(self.dispDate != nil){
        [picker setDate:self.dispDate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
