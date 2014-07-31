//
//  AppDelegate.m
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate()

@property (weak) IBOutlet NSMenu *statusMenu;
@property(retain) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self setupStatusItem];
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
@end
