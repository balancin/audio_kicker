//
//  UsersTableViewDelegate.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/14/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersTableViewDelegate : UITableViewController <UITableViewDelegate, UITextViewDelegate, UIWebViewDelegate> {
	
	NSMutableArray* users;
	
}

@property(nonatomic, retain) NSMutableArray* users;

@end
