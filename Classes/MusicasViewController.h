//
//  MusicasViewController.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/16/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicTableViewDelegate.h"
#import <GameKit/GameKit.h>

@interface MusicasViewController : UIViewController {

	MusicTableViewDelegate* delegate;
	NSMutableArray* musics;
	GKSession* session;
	UINavigationController* navegador;
	NSArray* peers;
	BOOL friendMusic;
	
}

@property(nonatomic, retain) GKSession* session;
@property(nonatomic, retain) NSMutableArray* musics;
@property(nonatomic, retain) UINavigationController* navegador;
@property(nonatomic, retain) NSArray* peers;
@property(nonatomic, readwrite) BOOL friendMusic;

@end
