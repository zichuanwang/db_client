//
//  DBRecorderViewController.m
//  db_client
//
//  Created by Gabriel Yeah on 13-11-25.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#import "DBRecorderViewController.h"

@interface DBRecorderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation DBRecorderViewController

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
    
  _recognizer = [[USCRecognizer alloc] initWithAppKey:@"37x3hynayllfqtzhyo3gvc5z7lqydylo2gpfk4qt"];
  _recognizer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchRecordButton:(UIButton *)sender
{
  [self.recognizer start];
}

- (IBAction)didEndTouchRecordButton:(UIButton *)sender
{
  [self.recognizer stop];
}

- (IBAction)didClickPlayButton:(UIButton *)sender
{
  
}

- (void)onStart
{
  //录音初始化完成，关闭初始化动画
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast
{

}

- (void)onEnd:(NSError *)error
{
  
}

- (void)onUpdateVolume:(double)volume
{
  
}

- (void)onVADTimeout
{
  [self.recognizer stop];
  
}

- (void)onUploadUserData:(NSError *)error
{
  if (error) {
    // upload user data error
    NSLog(@"%@", error);
  }else{
    // upload user data success
    NSLog(@"Succeeded!");
  }
}

- (void)onRecordingStop:(NSMutableData *)recordingDatas
{
  
}

@end
