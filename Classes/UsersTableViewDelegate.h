//
//  UsersTableViewDelegate.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/14/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MusicasViewController.h"

@interface UsersTableViewDelegate : UITableViewController <UITableViewDelegate, UITextViewDelegate, UIWebViewDelegate> {
	
	NSMutableArray* users;
	UINavigationController* navegador;
	GKSession* session;
	NSArray* peers;
	
}

@property(nonatomic, retain) NSMutableArray* users;
@property(nonatomic, retain) UINavigationController* navegador;
@property(nonatomic, retain) GKSession* session;
@property(nonatomic, retain) NSArray* peers;

@end
