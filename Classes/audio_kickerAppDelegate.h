//
//  audio_kickerAppDelegate.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/10/09.
//  Copyright Umpulo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class audio_kickerViewController;

@interface audio_kickerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    audio_kickerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet audio_kickerViewController *viewController;

@end

