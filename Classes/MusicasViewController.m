//
//  MusicasViewController.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/16/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import "MusicasViewController.h"


@implementation MusicasViewController

@synthesize musics, navegador, session, peers, friendMusic;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
	
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	UITableView* table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
	
	delegate = [[MusicTableViewDelegate alloc] initWithStyle:UITableViewCellStyleSubtitle];
	[delegate setTableView:table];
	[delegate setNavegador:self.navigationController];
	[delegate setMusics:musics];
	[delegate setSession:session];
	[delegate setPeers:peers];
	[delegate setFriendMusic:friendMusic];
	//self.navigationController.navigationBar.tintColor = [UIColor blackColor]; 
	
	[self.view addSubview:delegate.view];
	
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end

