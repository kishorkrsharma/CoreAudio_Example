//
//  main.m
//  CAMetadata
//
//  Created by Kishor on 12/3/20.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

int main (int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            printf ("Usage: CAMetadata fullpath/to/audiofile\n");
            return -1;                                                    // 1
        }
        NSString *audioFilePath = [[NSString stringWithUTF8String:argv[1]] stringByExpandingTildeInPath]; //2
        NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath]; //3
        AudioFileID audioFile; //4
        OSStatus theErr = noErr; //5
        theErr = AudioFileOpenURL((__bridge CFURLRef)audioURL, kAudioFileReadPermission, 0, &audioFile);
        assert (theErr == noErr);                                     // 7
        UInt32 dictionarySize = 0;                                    // 8
        theErr = AudioFileGetPropertyInfo (audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0);
        assert (theErr == noErr);
        CFDictionaryRef dictionary;
        theErr = AudioFileGetProperty (audioFile,kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary);
        assert (theErr == noErr);
        NSLog (@"dictionary: %@", dictionary);
        CFRelease (dictionary);
        theErr = AudioFileClose (audioFile);
        assert (theErr == noErr);
        return 0;
    }
}
