//
//  Manager.m
//  GPSVolume
//
//  Created by m0a on 2014/07/31.
//  Copyright (c) 2014年 m0a. All rights reserved.
//

#import "Manager.h"

@implementation Manager

#pragma mark - property
//TODO 基本的に設定すべきはGPS座標のみ。それをうまく変換して表示するように修正したい。
//以下の記述は必要だろうか？　結局glueコードを書いている。
-(NSString*) locationString
{
    return [NSString stringWithFormat:@"%@,%@",self.longitude,self.latitude];
}

-(void) setMute:(NSNumber*) val
{
    NSLog(@"set mute is %@",val);
    return;
}

-(NSNumber*) mute
{
    return [NSNumber numberWithBool:YES];
}

#pragma mark - KVO

+(NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key
{
    if ([key isEqualToString:@"locationString"])
    {
        return [NSSet setWithObjects:@"latitude", @"longitude", nil];
    }
    return nil;
}

@end
