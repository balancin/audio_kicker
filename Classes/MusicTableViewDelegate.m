//
//  MusicTableViewDelegate.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/16/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import "MusicTableViewDelegate.h"


@implementation MusicTableViewDelegate

@synthesize navegador, musics, session, peers, friendMusic;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [musics count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.imageView.image = [UIImage imageNamed:@"play_button.png"];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	cell.textLabel.text = [[musics objectAtIndex:indexPath.row] objectForKey:@"songTitle"];
    cell.detailTextLabel.text = [[musics objectAtIndex:indexPath.row] objectForKey:@"songArtist"];
	
    // Set up the cell...
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 90;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	if(!friendMusic){
		
		musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
			
		MPMediaPropertyPredicate *artistNamePredicate = [MPMediaPropertyPredicate predicateWithValue: 
														 [[musics objectAtIndex:indexPath.row] objectForKey:@"songArtist"]
										  forProperty: MPMediaItemPropertyArtist];
		
		MPMediaPropertyPredicate *titlePredicate = [MPMediaPropertyPredicate predicateWithValue: 
													[[musics objectAtIndex:indexPath.row] objectForKey:@"songTitle"]
										 forProperty: MPMediaItemPropertyTitle];
		
		MPMediaQuery *myComplexQuery = [[MPMediaQuery alloc] init];
		[myComplexQuery addFilterPredicate: artistNamePredicate];
		[myComplexQuery addFilterPredicate: titlePredicate];
		
		[musicPlayer setQueueWithQuery:myComplexQuery];
		
		MPMusicPlaybackState playbackState = [musicPlayer playbackState];
		
		if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
			[musicPlayer play];
		} else if (playbackState == MPMusicPlaybackStatePlaying) {
			[musicPlayer pause];
		}
		
	} else {
	
		NSMutableDictionary* music = [[NSMutableDictionary alloc] init];
		[music setValue:[[musics objectAtIndex:indexPath.row] objectForKey:@"index"] forKey:@"playTune"];
		
		NSData* dataRep;
		NSString *errorStr = nil; 
		dataRep = [NSPropertyListSerialization dataFromPropertyList: music 
															 format: NSPropertyListXMLFormat_v1_0 
												   errorDescription: &errorStr];
		
		[session sendData:dataRep toPeers:peers withDataMode:GKSendDataReliable error:nil];
			
	}
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

