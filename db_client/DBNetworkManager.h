//
//  DBNetworkManager.h
//  db_client
//
//  Created by 王 紫川 on 13-11-26.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBNetworkManager : NSObject

+ (void)uploadAudio:(NSData *)audioData completeSemantic:(NSString *)semantic;

@end
