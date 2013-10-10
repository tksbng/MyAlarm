//
//  ViewController.h
//  MyAlarm
//
//  Created by Takeshi Bingo on 2013/08/13.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "settingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <settingViewControllerDelegate,AVAudioPlayerDelegate>
{
    NSTimer *timer;
    //時計の各桁の数字を格納する変数
    int hoursecond;
    int hourfirst;
    int minutesecond;
    int minutefirst;
    int secondsecond;
    int secondfirst;
    //時計用イメージ
    UIImage *image0;
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    UIImage *image4;
    UIImage *image5;
    UIImage *image6;
    UIImage *image7;
    UIImage *image8;
    UIImage *image9;
    //時計表示用の画像パス
    NSString *aImagePath0;
    NSString *aImagePath1;
    NSString *aImagePath2;
    NSString *aImagePath3;
    NSString *aImagePath4;
    NSString *aImagePath5;
    NSString *aImagePath6;
    NSString *aImagePath7;
    NSString *aImagePath8;
    NSString *aImagePath9;
    //時計画像を格納する配列
    NSArray *imageArray;
    //時刻各桁表示用のImageView
    IBOutlet UIImageView *imageview_hour10;
    IBOutlet UIImageView *imageview_hour0;
    IBOutlet UIImageView *imageview_min0;
    IBOutlet UIImageView *imageview_min10;
    IBOutlet UIImageView *imageview_second0;
    IBOutlet UIImageView *imageview_second10;
    
    // Call DatePicker class
    settingViewController *datePickerController;
    //目覚まし時刻表示用ラベル
    IBOutlet UILabel *labelForDate;
    //目覚まし設定用ボタン
    IBOutlet UIButton *plusButton;
    
    NSString *alarmSound;
    NSDate *now;
    NSString *now_Str;
    int AlartFLG;

}

@property(nonatomic,retain)NSDate *dateForDate;

@property(nonatomic,retain)NSString *setDateStr;
@property(nonatomic,strong)AVAudioPlayer *player;

-(IBAction)plusClicked :(id)sender;

@end
