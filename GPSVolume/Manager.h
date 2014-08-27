//
//  Manager.h
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Manager : NSObject
@property(retain) NSNumber* latitude;
@property(retain) NSNumber* longitude;
@property(readonly) NSString* locationString;
@property(retain) NSNumber* volume;
@property(retain) NSNumber* mute;

@end
