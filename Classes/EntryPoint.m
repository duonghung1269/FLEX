//
//  EntryPoint.m
//  FLEX
//
//  Created by Dang Duong Hung on 15/1/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLEXManager.h"
#import <Security/SecureTransport.h>

@interface CodeInjection: NSObject
@end

@implementation CodeInjection

static void __attribute__((constructor)) initialize(void){
    NSLog(@"==== Code Injection in Action====");
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"SHOW FLEX Explorer");
        [[FLEXManager sharedManager] showExplorer];
    });    
}

@end
