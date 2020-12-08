//
//  main.m
//  CAStreamFormatTester
//
//  Created by Kishor on 12/7/20.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        AudioFileTypeAndFormatID fileTypeAndFormat;
        fileTypeAndFormat.mFileType = kAudioFileMP3Type;
        fileTypeAndFormat.mFormatID = kAudioFormatMPEG4AAC;
        
        OSStatus audioErr = noErr;
        UInt32 infoSize = 0;
        
        audioErr = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat,
             sizeof (fileTypeAndFormat),
             &fileTypeAndFormat,
             &infoSize);
    
        if (audioErr != noErr) {
            UInt32 err4cc = CFSwapInt32HostToBig(audioErr);
            NSLog (@"audioErr = %4.4s",  (char*)&err4cc);
        }
        assert (audioErr == noErr);
        
        AudioStreamBasicDescription *asbds = malloc (infoSize);
        audioErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat,
            sizeof (fileTypeAndFormat),
            &fileTypeAndFormat,
            &infoSize,
            asbds);
        assert (audioErr == noErr);
        int asbdCount = infoSize / sizeof (AudioStreamBasicDescription);
        for (int i=0; i<asbdCount; i++) {
            UInt32 format4cc = CFSwapInt32HostToBig(asbds[i].mFormatID);
            NSLog (@"%d: mFormatId: %4.4s, mFormatFlags: %d, mBitsPerChannel: %d", i,
                 (char*)&format4cc,
                 asbds[i].mFormatFlags,
                 asbds[i].mBitsPerChannel);
          }
        free (asbds);
    }
    return 0;
}
