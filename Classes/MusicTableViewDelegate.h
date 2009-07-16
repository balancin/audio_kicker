//
//  MusicTableViewDelegate.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/16/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableViewDelegate : UITableViewController <UITableViewDelegate, UITextViewDelegate, UIWebViewDelegate> {

	NSMutableArray* musics;
	
}

@property(nonatomic, retain) NSMutableArray* musics;

@end
