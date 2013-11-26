//
//  pcmplayer.c
//  db_client
//
//  Created by 王 紫川 on 13-11-26.
//  Copyright (c) 2013年 USC. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/stat.h>
#include <AudioToolbox/AudioQueue.h>

#define BYTES_PER_SAMPLE 2
#define SAMPLE_RATE 16000
typedef unsigned short sampleFrame;

#define FRAME_COUNT 735
#define AUDIO_BUFFERS 3

typedef struct AQCallbackStruct {
    AudioQueueRef queue;
    UInt32 frameCount;
    AudioQueueBufferRef mBuffers[AUDIO_BUFFERS];
    AudioStreamBasicDescription mDataFormat;
    UInt32 playPtr;
    UInt32 sampleLen;
    sampleFrame *pcmBuffer;
} AQCallbackStruct;

void *loadpcm(const char *filename, unsigned long *len) {
    FILE *file;
    struct stat s;
    void *pcm;
    
    if (stat(filename, &s))
        return NULL;
    *len = (unsigned long)s.st_size;
    pcm = (void *)malloc((unsigned long)s.st_size);
    if (!pcm)
        return NULL;
    file = fopen(filename, "rb");
    if (!file) {
        free(pcm);
        return NULL;
    }
    fread(pcm, (unsigned long)s.st_size, 1, file);
    fclose(file);
    return pcm;
}

void AQBufferCallback(void *in,
                      AudioQueueRef inQ,
                      AudioQueueBufferRef outQB) {
    AQCallbackStruct *aqc;
    short *coreAudioBuffer;
    short sample;
    int i;
    
    aqc = (AQCallbackStruct *) in;
    coreAudioBuffer = (short*) outQB->mAudioData;
    
    printf("Sync: %ld / %ld\n", aqc->playPtr, aqc->sampleLen);
    if (aqc->playPtr >= aqc->sampleLen) {
        AudioQueueDispose(aqc->queue, true);
        return;
    }
    
    if (aqc->frameCount > 0) {
        outQB->mAudioDataByteSize = 4 * aqc->frameCount;
        for(i=0; i<aqc->frameCount*2; i+=2) {
            if (aqc->playPtr > aqc->sampleLen)
                sample = 0;
            else
                sample = (aqc->pcmBuffer[aqc->playPtr]);
            coreAudioBuffer[i] =   sample;
            coreAudioBuffer[i+1] = sample;
            aqc->playPtr++;
        }
        AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
    }
}

int playbuffer(void *pcmbuffer, unsigned long len) {
    AQCallbackStruct aqc;
    UInt32 err, bufferSize;
    int i;
    
    aqc.mDataFormat.mSampleRate = SAMPLE_RATE;
    aqc.mDataFormat.mFormatID = kAudioFormatLinearPCM;
    aqc.mDataFormat.mFormatFlags =
    kLinearPCMFormatFlagIsSignedInteger
    | kAudioFormatFlagIsPacked;
    aqc.mDataFormat.mBytesPerPacket = 4;
    aqc.mDataFormat.mFramesPerPacket = 1;
    aqc.mDataFormat.mBytesPerFrame = 4;
    aqc.mDataFormat.mChannelsPerFrame = 2;
    aqc.mDataFormat.mBitsPerChannel = 16;
    aqc.frameCount = FRAME_COUNT;
    aqc.sampleLen = len / BYTES_PER_SAMPLE;
    aqc.playPtr = 0;
    aqc.pcmBuffer = (sampleFrame *)pcmbuffer;
    
    err = AudioQueueNewOutput(&aqc.mDataFormat,
                              AQBufferCallback,
                              &aqc,
                              NULL,
                              kCFRunLoopCommonModes,
                              0,
                              &aqc.queue);
    if (err)
        return err;
    
    aqc.frameCount = FRAME_COUNT;
    bufferSize = aqc.frameCount * aqc.mDataFormat.mBytesPerFrame;
    
    for (i=0; i<AUDIO_BUFFERS; i++) {
        err = AudioQueueAllocateBuffer(aqc.queue, bufferSize,
                                       &aqc.mBuffers[i]);
        if (err)
            return err;
        AQBufferCallback(&aqc, aqc.queue, aqc.mBuffers[i]);
    }
    
    err = AudioQueueStart(aqc.queue, NULL);
    if (err)
        return err;
    struct timeval tv = {1.0, 0};
    while(aqc.playPtr < aqc.sampleLen) { select(0, NULL, NULL, NULL, &tv); }
    sleep(1);
    return 0;
}