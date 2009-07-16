//
//  HomeViewController.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/14/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersTableViewDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <GameKit/GameKit.h>

@interface HomeViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate> {

	NSMutableArray* library;
	GKPeerPickerController *mPicker;
	GKSession *mSession;
	NSMutableArray *mPeers;
	UITableView* table;
	UsersTableViewDelegate* delegate;
	int totalFriendMusics;
	int totalFriendMusicsTemp;
	NSTimer* syncTimer;
	BOOL sentMusicComplete;
	
}

-(void)loadLocalIPodLibrary;
-(void)addUserLibrary;
-(void)sendData;
-(void)receiveData;
- (void) syncronize:(id)sender;

@property(nonatomic, retain) GKSession* mSession;

@end
