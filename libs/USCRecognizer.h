//
//  USCRecognizer.h
//  usc
//
//  Created by hejinlai on 12-11-3.
//  Copyright (c) 2012年 yunzhisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>


/*
     上传个性化数据支持的类型
 */
typedef enum
{
    kUSCPersonName = 1,
    kUSCAppName    = 2,
    kUSCSongName   = 3,
    
} USCUserDataType;


@protocol USCRecognizerDelegate <NSObject>

/*
     录音和识别成功启动后，回调该方法.
     为了防止前半部分语音被截断的现象，建议
     在此方法回调后，再提醒用户开始说话
 */
- (void)onStart;


/*
     部分识别结果回调，isLast表示是否是最后一次
 */
- (void)onResult:(NSString *)result isLast:(BOOL)isLast;


/*
     识别结束回调，error为nil表示成功，否则表示出现了错误
 */
- (void)onEnd:(NSError *)error;


/*
     说话停掉超时回调
 */
- (void)onVADTimeout;


/*
     说话时的音量大小
 */
- (void)onUpdateVolume:(double)volume;


/*
     上传个性化数据结果回调
 */
- (void)onUploadUserData:(NSError *)error;

/*
     录音数据
 */
- (void)onRecordingStop:(NSMutableData *)recordingDatas;

@end




@interface USCRecognizer : NSObject


@property (nonatomic, assign) id<USCRecognizerDelegate> delegate;


/*
     初始化
 */
- (id)initWithAppKey:(NSString *)appKey;


/*
     启动识别引擎
 */
- (void)start;


/*
     停止录音，并开始等待识别结束
 */
- (void)stop;


/*
      取消识别
 */
- (void)cancel;


/*
     上传个性化数据
 */
- (void)setUserData:(NSDictionary *)userData;


/*
     设置vad超时时间，单位ms
     frontTime：开始说话之前的停顿超时时间，默认3000ms
     backTime： 开始说话之后的停顿超时时间，默认1000ms
     
 */
- (void)setVadFrontTimeout:(int)frontTime BackTimeout:(int)backTime;

/*
     设置录音采样率，支持8000和16000，默认为16000
 */
- (void)setSampleRate:(int)rate;

/*
     设置识别参数
 */
- (BOOL)setEngine:(NSString *)engine;

/*
    获取session id
 */
- (NSString *)getSessionId;

/*
     版本号
 */
+ (NSString *)getVersion;


@end
