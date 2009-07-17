//
//  MusicTableViewDelegate.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/16/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <GameKit/GameKit.h>

@interface MusicTableViewDelegate : UITableViewController <UITableViewDelegate, UITextViewDelegate, UIWebViewDelegate> {

	NSMutableArray* musics;
	GKSession* session;
	UINavigationController* navegador;
	MPMusicPlayerController	*musicPlayer;
	NSArray* peers;
	BOOL friendMusic;
	
}

@property(nonatomic, retain) GKSession* session;
@property(nonatomic, retain) NSMutableArray* musics;
@property(nonatomic, retain) UINavigationController* navegador;
@property(nonatomic, retain) NSArray* peers;
@property(nonatomic, readwrite) BOOL friendMusic;

@end
