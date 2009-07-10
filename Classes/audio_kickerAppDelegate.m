//
//  audio_kickerAppDelegate.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/10/09.
//  Copyright Umpulo 2009. All rights reserved.
//

#import "audio_kickerAppDelegate.h"
#import "audio_kickerViewController.h"

@implementation audio_kickerAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
