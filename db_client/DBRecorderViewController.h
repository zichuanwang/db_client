//
//  DBRecorderViewController.h
//  db_client
//
//  Created by Gabriel Yeah on 13-11-25.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCRecognizer.h"
#import <AVFoundation/AVFoundation.h>

@interface DBRecorderViewController : UIViewController <USCRecognizerDelegate>

@property (strong, nonatomic) USCRecognizer *recognizer;

@end
