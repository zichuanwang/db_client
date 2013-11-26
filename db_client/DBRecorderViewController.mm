//
//  DBRecorderViewController.m
//  db_client
//
//  Created by Gabriel Yeah on 13-11-25.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#import "DBRecorderViewController.h"
#include "pcmplayer.h"
#import "DBNetworkManager.h"

@interface DBRecorderViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playBarButton;
@property (strong, nonatomic) NSMutableData *audioData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

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
    
    [DBRecorderViewController openSpeaker:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didClickSegmentedControl:(UISegmentedControl *)sender {
    UITabBarController *tabBarController = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    tabBarController.selectedIndex = 1;
    sender.selectedSegmentIndex = 0;
}

- (IBAction)didTouchRecordButton:(UIBarButtonItem *)sender
{
    BOOL selected = [sender.title isEqualToString:@"Record"];
    sender.title = selected ? @"Finish" : @"Record";
    if (selected) {
        [self.recognizer start];
    } else {
        [self.recognizer stop];
    }
}

- (IBAction)didClickPlayButton:(UIBarButtonItem *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        void *pcm = (void *)malloc(self.audioData.length);
        [self.audioData getBytes:pcm];
        playbuffer(pcm, self.audioData.length);
        free(pcm);
    });
}

#pragma mark USCRecognizerDelegate

- (void)onStart
{
    //录音初始化完成，关闭初始化动画
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast {
    if (result && result.length > 0) {
        [DBNetworkManager uploadAudio:self.audioData completeSemantic:result];
    } else {
        // upload user data success
        // self.resultLabel.text = @"Something went wrong!";
    }
}

- (void)onEnd:(NSError *)error
{
    
}

- (void)onUploadUserData:(NSError *)error {
    
}

- (void)onUpdateVolume:(double)volume {
    
}

- (void)onVADTimeout {
    self.recordBarButton.title = @"Record";
    [self.recognizer stop];
}

- (void)onRecordingStop:(NSMutableData *)recordingDatas {
    self.audioData = recordingDatas;
}

+ (void)openSpeaker:(bool)bOpen {
    UInt32 route;
	OSStatus error;
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;    // 1
	
	error = AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                        // 2
                                     sizeof (sessionCategory),                                   // 3
                                     &sessionCategory                                            // 4
                                     );
	
	route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
	error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
	if(error == kAudioSessionNotInitialized)
	{
		NSLog(@"not init 1");
	}
	else if(kAudioSessionAlreadyInitialized)
	{
		NSLog(@"not init 2");
	}
	else if(kAudioSessionInitializationError)
	{
		NSLog(@"not init 3");
	}
	else if(kAudioSessionUnsupportedPropertyError)
	{
		NSLog(@"not init 4");
	}
	else if(kAudioSessionBadPropertySizeError)
	{
		NSLog(@"not init 5");
	}
	else if(kAudioSessionBadPropertySizeError)
	{
		NSLog(@"not init 6");
	}
	
	if(error!=kAudioServicesNoError)
	{
		NSLog(@"error 7");
	}
}


@end
