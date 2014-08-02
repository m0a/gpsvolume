//
//  SysVolumeManager.h
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMCoreAudio/AMCoreAudio.h>

@interface SysVolumeManager : NSObject<AMCoreAudioHardwareDelegate>
-(void)setVolume:(float)volume;
-(float)volume;
@end
