//
//  DBNetworkManager.m
//  db_client
//
//  Created by 王 紫川 on 13-11-26.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#import "DBNetworkManager.h"
#import "AFNetworking.h"

@implementation DBNetworkManager

+ (void)uploadAudio:(NSData *)audioData completeSemantic:(NSString *)semantic {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"audio" : @{@"complete_semantic" : semantic}};
    [manager POST:@"http://10.0.1.16:3000/audio/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:audioData name:@"audio_file" fileName:@"audio_file_name.pcm" mimeType:@"audio/pcm"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

@end
