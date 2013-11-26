//
//  pcmplayer.h
//  db_client
//
//  Created by 王 紫川 on 13-11-26.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#ifndef db_client_pcmplayer_h
#define db_client_pcmplayer_h

void *loadpcm(const char *filename, unsigned long *len);

int playbuffer(void *pcm, unsigned long len);

void AQBufferCallback(void *in, AudioQueueRef inQ, AudioQueueBufferRef outQB);

#endif
