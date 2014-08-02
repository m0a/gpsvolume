//
//  SysVolumeManager.m
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import "SysVolumeManager.h"
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioServices.h>

@interface SysVolumeManager()

@property (nonatomic, retain) AMCoreAudioHardware *audioHardware;

/*
 Keeps state of all the known devices
 **/
@property (nonatomic, retain) NSSet *allKnownDevices;

@end

@implementation SysVolumeManager

-(void)setVolume:(float)volume
{
    NSLog(@"test");
    NSSet* allOutPutDevices = [AMCoreAudioDevice allOutputDevices];
    for (AMCoreAudioDevice* device in allOutPutDevices) {
        if (![device setMasterVolume:volume forDirection:kAMCoreAudioDeviceInvalidDirection])
        {
            NSLog(@"error!!!!");
        }
    }
}

-(float)volume
{
    NSLog(@"test");
    return 0.0;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        // Populate allKnownDevices
        
        _allKnownDevices = [AMCoreAudioDevice allDevices];
        
        // Update delegates
        
        [self audioDeviceSetDelegatesFor:_allKnownDevices
                   andRemoveDelegatesFor:nil];
        
        // Initialize our AMCoreAudioHardware object and set its delegate
        // to self, so we can start receiving hardware-related notifications
        
        _audioHardware = [AMCoreAudioHardware new];
        _audioHardware.delegate = self;
    }
    
    return self;
}


#pragma mark - AMCoreAudioHardwareDelegate methods

- (void)hardwareDeviceListChanged:(id)sender
{
    NSSet *latestDeviceList;
    NSMutableSet *addedDevices;
    NSMutableSet *removedDevices;
    
    // Get the latest device list
    
    latestDeviceList = [AMCoreAudioDevice allDevices];
    
    // Do some basic arithmetic with mutable sets
    // to obtain added and removed devices
    
    addedDevices = [latestDeviceList mutableCopy];
    [addedDevices minusSet:self.allKnownDevices];
    
    removedDevices = [self.allKnownDevices mutableCopy];
    [removedDevices minusSet:latestDeviceList];
    
    // Update our allKnownDevices
    
    self.allKnownDevices = latestDeviceList;
    
    // Update delegates
    
    [self audioDeviceSetDelegatesFor:addedDevices
               andRemoveDelegatesFor:removedDevices];
    
    // Display results
    
    if (addedDevices && addedDevices.count > 0)
    {
        NSLog(@"Devices added: %@", addedDevices);
    }
    
    if (removedDevices && removedDevices.count > 0)
    {
        NSLog(@"Devices removed: %@", removedDevices);
    }
}

- (void)hardwareDefaultInputDeviceChanged:(id)sender
{
    AMCoreAudioDevice *audioDevice;
    
    audioDevice = [AMCoreAudioDevice defaultInputDevice];
    
    NSLog(@"Default input device changed to %@", audioDevice.deviceName);
}

- (void)hardwareDefaultOutputDeviceChanged:(id)sender
{
    AMCoreAudioDevice *audioDevice;
    
    audioDevice = [AMCoreAudioDevice defaultOutputDevice];
    
    NSLog(@"Default output device changed to %@", audioDevice.deviceName);
}

- (void)hardwareDefaultSystemDeviceChanged:(id)sender
{
    AMCoreAudioDevice *audioDevice;
    
    audioDevice = [AMCoreAudioDevice systemOutputDevice];
    
    NSLog(@"System output device changed to %@", audioDevice.deviceName);
}

#pragma mark - AMCoreAudioDeviceDelegate methods

- (void)audioDeviceNominalSampleRateDidChange:(id)sender
{
    AMCoreAudioDevice *audioDevice = sender;
    
    NSLog(@"%@ sample rate changed to %f", audioDevice.deviceName, audioDevice.nominalSampleRate);
}

- (void)audioDeviceVolumeDidChange:(id)sender
                        forChannel:(UInt32)channel
                      andDirection:(AMCoreAudioDirection)direction
{
    AMCoreAudioDevice *audioDevice = sender;
    Float32 newVolume = [audioDevice volumeInDecibelsForChannel:channel
                                                   andDirection:direction];
    
    NSLog(@"%@ volume for channel %d and direction %ld changed to %.2fdbFS", audioDevice.deviceName, channel, direction, newVolume);
}

- (void)audioDeviceMuteDidChange:(id)sender
                      forChannel:(UInt32)channel
                    andDirection:(AMCoreAudioDirection)direction
{
    AMCoreAudioDevice *audioDevice = sender;
    BOOL isMuted = [audioDevice isChannelMuted:channel andDirection:direction];
    
    NSLog(@"%@ mute for channel %d and direction %ld changed to %d", audioDevice.deviceName, channel, direction, isMuted);
}

- (void)audioDeviceClockSourceDidChange:(id)sender
                             forChannel:(UInt32)channel
                           andDirection:(AMCoreAudioDirection)direction
{
    AMCoreAudioDevice *audioDevice = sender;
    NSString *clockSourceName = [audioDevice clockSourceForChannel:channel
                                                      andDirection:direction];
    
    NSLog(@"%@ clock source changed to %@", audioDevice.deviceName, clockSourceName);
}

- (void)audioDeviceNameDidChange:(id)sender
{
    AMCoreAudioDevice *audioDevice = sender;
    
    NSLog(@"%@ name changed to %@", audioDevice.deviceUID, audioDevice.deviceName);
}

- (void)audioDeviceAvailableNominalSampleRatesDidChange:(id)sender
{
    AMCoreAudioDevice *audioDevice = sender;
    
    NSLog(@"%@ nominal sample rates changed to %@", audioDevice.deviceName, [audioDevice nominalSampleRates]);
}

#pragma mark - Private

- (void)audioDeviceSetDelegatesFor:(id<NSFastEnumeration>)addedDevices
             andRemoveDelegatesFor:(id<NSFastEnumeration>)removedDevices
{
    for (AMCoreAudioDevice *device in addedDevices)
    {
        device.delegate = self;
        NSLog(@"Setting delegate for %@", device.deviceName);
    }
    
    for (AMCoreAudioDevice *device in removedDevices)
    {
        device.delegate = nil;
        NSLog(@"Removing delegate for %@", device.cachedDeviceName);
    }
}


@end
