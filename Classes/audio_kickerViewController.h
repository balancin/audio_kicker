//
//  audio_kickerViewController.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/10/09.
//  Copyright Umpulo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <GameKit/GameKit.h>
#import "HomeViewController.h"

@interface audio_kickerViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate> {

	GKPeerPickerController *mPicker;
	GKSession *mSession;
	IBOutlet UITextField *mTextField;
	IBOutlet UITextView *mTextView;
	NSMutableArray *mPeers;
	UINavigationController* navegador;
	
}

-(IBAction) connectClicked:(id)sender;
-(IBAction) sendData:(id)sender;
@property (retain) GKSession *mSession;

//	NSString* akPeerID;
//	GKPeerPickerController* akPicker;
//	GKSession *akSession;
//	NSMutableArray* akPeers;
//	
//}
//
//@property(nonatomic, retain) GKSession *akSession;
//@property(nonatomic, retain) NSString* akPeerID;

@end

