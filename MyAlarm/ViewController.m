//
//  ViewController.m
//  MyAlarm
//
//  Created by Takeshi Bingo on 2013/08/13.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(time:) userInfo:nil repeats:YES];
    alarmSound = [[NSBundle mainBundle] pathForResource:@"koukaon1" ofType:@"wav"];

}
//プラスボタンが押されたときに呼ばれるメソッド
-(IBAction)plusClicked:(id)sender{
    //settingViewControllerを呼び出す
    datePickerController = [[settingViewController alloc] init];
    //pickerの名前を指定する
    datePickerController.pickerName = @"pickerOfDate";
    //取得する時刻のデリゲート
    datePickerController.dispDate = (self.dateForDate != nil)?self.dateForDate:[NSDate date];
    //設定画面をデリゲート
    datePickerController.delegate = self;
    //設定画面をモーダルとして呼び出す
    [self showModal:datePickerController.view];
}

//設定画面を呼び出すメソッド
-(void)showModal:(UIView*) modalView {
    UIWindow* mainWindow = (((AppDelegate*)[UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    modalView.center = offScreenCenter;
    [mainWindow addSubview:modalView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    modalView.center = middleCenter;
    [UIView commitAnimations];
}

//設定画面を隠すメソッド
-(void)hideModal:(UIView*) modalView {
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    [UIView beginAnimations:nil context:(__bridge void *)(modalView)];
    [UIView setAnimationDuration:0.3];
    //デリゲートを設定
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter ;
    [UIView commitAnimations];
}

//設定画面が隠された時に呼ばれるメソッド
-(void)hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIView* modalView = (__bridge UIView *)context;
    //メイン画面からモーダル画面をリムーブする
    [modalView removeFromSuperview];
}

//saveボタンが押された時に呼び出されるメソッド
-(void)didSaveButtonClicked:(settingViewController *)controller selectedDate:(NSDate *)selectedDate pickerName:(NSString *)pickerName {
    //設定画面を隠す
    [self hideModal:datePickerController.view];
    datePickerController = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    if([pickerName isEqualToString:@"pickerOfDate"]){
        //デリゲートを設定
        self.dateForDate = selectedDate;
        labelForDate.text = [formatter stringFromDate:self.dateForDate];
        AlartFLG = 0;
    }
}
//Cancelボタンがクリックされたときに呼ばれるメソッド
-(void)didCancelButtonClicked:(settingViewController *)controller pickerName:(NSString *)pickerName {
    //モーダルを隠すメソッドを呼ぶ
    [self hideModal:datePickerController.view];
    datePickerController = nil;
}
//リフレッシュボタンが押された時に呼ばれるメソッド
-(void)didRefreshButtonClicked:(settingViewController *)controller pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    datePickerController = nil;
    if ([pickerName isEqualToString:@"pickerOfDate"]) {
        self.dateForDate = nil;
        labelForDate.text = @"";
    }
}

//日付の使い方　確認
-(void)time:(NSTimer *)timer {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
    NSDateComponents *components = [cal components:unitFlags fromDate:[NSDate date]];
    now = [NSDate date];
    
    NSDateFormatter* nowTimeFormatter = [[NSDateFormatter alloc] init];
    [nowTimeFormatter setDateFormat:@"HH:mm"];
    now_Str = [nowTimeFormatter stringFromDate:now];
    
    
    int hour = [components hour];
    int minute = [components minute];
    int second = [components second];
    NSLog(@"時刻は%d:%d:%d",hour,minute,second);
    
    if(hour >9){
        hoursecond = hour/10;
        hourfirst = hour - (floor(hour/10)*10);
    } else {
        hoursecond = 0;
        hourfirst = hour;
    }
    //「分」の一桁目と二桁目を分解
    if (minute>9) {
        minutesecond = minute/10;
        minutefirst = minute - (floor(minute/10)*10);
    } else {
        minutesecond = 0;
        minutefirst = minute;
    }
    
    //「秒」の一桁目と二桁目を分解
    if (second>9) {
        secondsecond = second/10;
        secondfirst = second - (floor(second/10)*10);
    } else {
        secondsecond = 0;
        secondfirst = second;
        
    }
    //目覚まし判定用
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:mm"];
    _setDateStr = [formatter stringFromDate:self.dateForDate];
    
    if([_setDateStr isEqualToString:now_Str]){
        if (AlartFLG < 1) {
            //アラートを出す（アラーム停止）
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"ALARM" message:@"It's Time!!!" delegate:self cancelButtonTitle:@"STOP" otherButtonTitles:nil, nil];
            [alertView show];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@",alarmSound];
            NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
            NSError *error = nil;
            //サウンド再生用のプレイヤーを作成する
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
            
            if (error != nil) {
                NSLog(@"AVAudioPlayerのイニシャライズでエラー(%@)",[error localizedDescription]);
                return  ;
            }
            //自分自身をデリゲートに設定
            [_player setDelegate:self];
            [_player play];
        }
        AlartFLG = AlartFLG + 1;
    }
    
    [self draw];
}
-(void)draw {
    //指定した画像をロードしてパスを作成する
    aImagePath0 = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"png"];
    aImagePath1 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    aImagePath2 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
    aImagePath3 = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"];
    aImagePath4 = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"];
    aImagePath5 = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"png"];
    aImagePath6 = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"png"];
    aImagePath7 = [[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"];
    aImagePath8 = [[NSBundle mainBundle] pathForResource:@"8" ofType:@"png"];
    aImagePath9 = [[NSBundle mainBundle] pathForResource:@"9" ofType:@"png"];
    //UIImageにパスから画像を読み込む
    image0 = [UIImage imageWithContentsOfFile:aImagePath0];
    image1 = [UIImage imageWithContentsOfFile:aImagePath1];
    image2 = [UIImage imageWithContentsOfFile:aImagePath2];
    image3 = [UIImage imageWithContentsOfFile:aImagePath3];
    image4 = [UIImage imageWithContentsOfFile:aImagePath4];
    image5 = [UIImage imageWithContentsOfFile:aImagePath5];
    image6 = [UIImage imageWithContentsOfFile:aImagePath6];
    image7 = [UIImage imageWithContentsOfFile:aImagePath7];
    image8 = [UIImage imageWithContentsOfFile:aImagePath8];
    image9 = [UIImage imageWithContentsOfFile:aImagePath9];
    //配列を生成して、画像を格納する
    imageArray =[NSArray arrayWithObjects:image0,image1,image2,image3,image4,image5,image6,image7,image8,image9, nil];
    //各時刻に対応した画像を配列から呼び出す
    [imageview_hour10 setImage:[imageArray objectAtIndex:hoursecond]];
    [imageview_hour0 setImage:[imageArray objectAtIndex:hourfirst]];
    [imageview_min10 setImage:[imageArray objectAtIndex:minutesecond]];
    [imageview_min0 setImage:[imageArray objectAtIndex:minutefirst]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
