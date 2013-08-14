//
//  settingViewController.h
//  MyAlarm
//
//  Created by Takeshi Bingo on 2013/08/13.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class settingViewController;

@protocol settingViewControllerDelegate

-(void)didSaveButtonClicked:(settingViewController *)controller selectedDate:(NSDate *)selectedDate pickerName:(NSString *)pickerName;
-(void)didCancelButtonClicked:(settingViewController *)controller pickerName:(NSString *)pickerName;
-(void)didRefreshButtonClicked:(settingViewController *)controller pickerName:(NSString *)pickerName;

@end



@interface settingViewController : UIViewController{
    //時刻設定用ピッカー
    IBOutlet UIDatePicker *picker;
    //saveボタン
    IBOutlet UIBarItem *saveButton;
    //キャンセルボタン
    IBOutlet UIBarItem *cancelButton;
    //リフレッシュボタン
    IBOutlet UIBarItem *refreshButton;
}

-(IBAction)saveButtonCliked:(id)sender;
-(IBAction)cancelButtonCliked:(id)sender;
-(IBAction)refreshButtonCliked:(id)sender;

@property(nonatomic,assign)id<settingViewControllerDelegate> delegate;

@property(nonatomic,retain)NSString *pickerName;

@property(nonatomic,retain)NSDate *dispDate;

@end
