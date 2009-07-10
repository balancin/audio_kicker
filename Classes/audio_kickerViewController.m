//
//  audio_kickerViewController.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/10/09.
//  Copyright Umpulo 2009. All rights reserved.
//

#import "audio_kickerViewController.h"

@implementation audio_kickerViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *playlists = [myPlaylistsQuery collections];
	
	for (MPMediaPlaylist *playlist in playlists) {
		NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
		
		NSArray *songs = [playlist items];
		for (MPMediaItem *song in songs) {
			NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
			NSString *songArtist = [song valueForProperty: MPMediaItemPropertyAlbumArtist];
			NSString *songPlayCount = [song valueForProperty: MPMediaItemPropertyPlayCount];
			NSString *songSkipCount = [song valueForProperty: MPMediaItemPropertySkipCount];
			NSString *songLastPlayedDate = [song valueForProperty: MPMediaItemPropertyLastPlayedDate];
			NSNumber* songMediaType = [song valueForProperty: MPMediaItemPropertyMediaType];
			NSString *songGenre = [song valueForProperty: MPMediaItemPropertyGenre];
			NSString *songRating = [song valueForProperty: MPMediaItemPropertyRating];
	
			//verifica se é uma música
			if([songMediaType intValue] == 1)
				NSLog (@"\t%@ - %@ - %@ - %@ - %@ - %i - %@ - %@", songArtist, songTitle, songPlayCount, songSkipCount, songLastPlayedDate, [songMediaType intValue], songGenre, songRating);
			
		}
	}
	
}

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
