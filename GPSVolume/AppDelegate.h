//
//  AppDelegate.h
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, CLLocationManagerDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
