//
//  AppDelegate.m
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import "AppDelegate.h"
#import "Manager.h"
#import "SysVolumeManager.h"

@interface AppDelegate()

@property (weak) IBOutlet NSMenu *statusMenu;
@property(retain) NSStatusItem *statusItem;
@property(retain)CLLocationManager * locationManager;
@property (weak) IBOutlet Manager *manager;
@property (weak) IBOutlet NSMenuItem *locationDetact;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self setupStatusItem];
    [self setupManager];
    //tls用のレジューム時チェック
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNotification:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
//    [self setVolume:0.5];
//    NSLog(@"volue is %f",[self volume]);
    SysVolumeManager* sysVolumeManager = [[SysVolumeManager alloc]init];
    [sysVolumeManager setVolume:0.5];
}

- (void)receiveWakeNotification:(NSNotification *)notification
{
    NSLog(@"wakeup!! %@",notification);
}


-(void)setupManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];

}

- (void)setupStatusItem
{
    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];
    self.statusItem = [systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setTitle:@"GPSVol"];
    [self.statusItem setImage:[NSImage imageNamed:@"StatusBarIconTemplate"]];
    [self.statusItem setMenu:self.statusMenu];
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {
    NSLog(@"%@\n",aNotification);
}

//- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key
//{
//    NSLog(@"sender=%@,delegateHandlesKey=%@\n",sender,key);
//    return YES;
//}
//

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation  {
    if (oldLocation != nil) {
        NSLog(@"%s\n",[[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] UTF8String]);
        
        self.manager.longitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
        self.manager.latitude =[NSNumber numberWithDouble:newLocation.coordinate.latitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"%s\n",[[NSString stringWithFormat:@"%@: %@",[error localizedDescription],[error localizedFailureReason]] UTF8String]);
}
@end
