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

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) AVAudioPlayer *player;

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

- (IBAction)didTouchRecordButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.recognizer start];
    } else {
        [self.recognizer stop];
    }
}

- (IBAction)didClickPlayButton:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        void *pcm = (void *)malloc(self.data.length);
        [self.data getBytes:pcm];
        playbuffer(pcm, self.data.length);
        free(pcm);
    });
}

- (void)onStart
{
    //录音初始化完成，关闭初始化动画
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast {
    if (result && result.length > 0) {
        self.resultLabel.text = result;
        [DBNetworkManager uploadAudio:self.data completeSemantic:result];
    } else {
        // upload user data success
        self.resultLabel.text = @"Something went wrong!";
    }
}

- (void)onEnd:(NSError *)error
{
    
}

- (void)onUpdateVolume:(double)volume {
    
}

- (void)onVADTimeout {
    self.recordButton.selected = NO;
    [self.recognizer stop];
}

- (void)onRecordingStop:(NSMutableData *)recordingDatas {
    self.data = recordingDatas;
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
		NSLog(@"not init");
	}
	else if(kAudioSessionAlreadyInitialized)
	{
		NSLog(@"not init");
	}
	else if(kAudioSessionInitializationError)
	{
		NSLog(@"not init");
	}
	else if(kAudioSessionUnsupportedPropertyError)
	{
		NSLog(@"not init");
	}
	else if(kAudioSessionBadPropertySizeError)
	{
		NSLog(@"not init");
	}
	else if(kAudioSessionBadPropertySizeError)
	{
		NSLog(@"not init");
	}
	
	if(error!=kAudioServicesNoError)
	{
		NSLog(@"error");
	}
}


@end
