//
//  HomeViewController.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/14/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController

@synthesize mSession;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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
	
	mPicker=[[GKPeerPickerController alloc] init];
	mPicker.delegate=self;
	mPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
	mPeers=[[NSMutableArray alloc] init];
	
	library = [[NSMutableArray alloc] init];
	[self loadLocalIPodLibrary];
	
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
	
	delegate = [[UsersTableViewDelegate alloc] initWithStyle:UITableViewCellStyleSubtitle];
	[delegate setTableView:table];
	[delegate setUsers:library];
	
	self.navigationController.navigationBar.tintColor = [UIColor blackColor]; 
	
	self.navigationController.navigationBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Add User"
																										   style:UIBarButtonItemStylePlain
																										  target:self
																										  action:@selector(addUserLibrary)] autorelease];

	self.navigationController.navigationBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send"
																										   style:UIBarButtonItemStylePlain
																										  target:self
																										  action:@selector(sendData)] autorelease];
	
	[self.view addSubview:delegate.view];
	
}

-(void)addUserLibrary {
	
	[mPicker show];
	
}

-(void)loadLocalIPodLibrary {
	
	NSMutableArray* musics = [[NSMutableArray alloc] init];
	NSMutableDictionary* userProperties = [[NSMutableDictionary alloc] init];
	[userProperties setValue:@"Your iPod" forKey:@"user"];
	
	NSDictionary *musicPropertyList; 
	MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *playlists = [myPlaylistsQuery collections];
	
	for (MPMediaPlaylist *playlist in playlists) {
		NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
		
		NSArray *songs = [playlist items];
		for (MPMediaItem *song in songs) { 
			
			NSNumber* songMediaType = [song valueForProperty: MPMediaItemPropertyMediaType]; 
			
			//verifica se é uma música
			if([songMediaType intValue] == 1) {
				
				musicPropertyList = [NSDictionary dictionaryWithObjectsAndKeys: 
									 [song valueForProperty: MPMediaItemPropertyMediaType], @"songTitle", 
									 [song valueForProperty: MPMediaItemPropertyAlbumArtist], @"songArtist", 
									 [song valueForProperty: MPMediaItemPropertyPlayCount], @"songPlayCount", 
									 [song valueForProperty: MPMediaItemPropertyAlbumArtist], @"songArtist", 
									 [song valueForProperty: MPMediaItemPropertySkipCount], @"songSkipCount", 
									 [song valueForProperty: MPMediaItemPropertyLastPlayedDate], @"songLastPlayedDate", 
									 [song valueForProperty: MPMediaItemPropertyGenre], @"songArtist", 
									 [song valueForProperty: MPMediaItemPropertyAlbumArtist], @"songGenre", 
									 [song valueForProperty: MPMediaItemPropertyRating], @"songRating", 
									 nil];
				
				//dataRep = [NSPropertyListSerialization dataFromPropertyList: musicPropertyList 
//																	 format: NSPropertyListXMLFormat_v1_0 
//														   errorDescription: &errorStr];
//				
//				[mSession sendData:dataRep toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
//				
				[musics addObject:musicPropertyList];
				
				//musicPropertyList = nil;
				
			}
			
		}
	}
	
	NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
	[user setValue:userProperties forKey:@"user"];
	[user setValue:musics forKey:@"library"];
	
	[library addObject:user];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/* Notifies delegate that a connection type was chosen by the user.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{
	if (type == GKPeerPickerConnectionTypeOnline) {
        picker.delegate = nil;
        [picker dismiss];
        [picker autorelease];
		//[picker show];
    }
}

/* Notifies delegate that the connection type is requesting a GKSession object.
 
 You should return a valid GKSession object for use by the picker. If this method is not implemented or returns 'nil', a default GKSession is created on the delegate's behalf.
 */
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	
	GKSession* session = [[GKSession alloc] initWithSessionID:@"ackicker" displayName:nil sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	NSLog(@"Connected from %@",peerID);
	session.delegate = self;
	
	[session sendData:[@"lalalala" dataUsingEncoding: NSASCIIStringEncoding] toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
	
	// Use a retaining property to take ownership of the session.
    self.mSession = session;
	// Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
	// Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
	
	NSMutableDictionary* userProperties = [[NSMutableDictionary alloc] init];
	[userProperties setValue:[session displayName] forKey:@"user"];
	NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
	NSMutableArray* musics = [[NSMutableArray alloc] init];

	[user setValue:userProperties forKey:@"user"];
	[user setValue:musics forKey:@"library"];
	
	[library addObject:user];
	
	[delegate setUsers:library];
	
	[[delegate tableView] reloadData];
	
	
	
}

-(void) sendData {
	
	NSDictionary *musicPropertyList; 
	MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *playlists = [myPlaylistsQuery collections];
	NSData* dataRep;
	NSString *errorStr = nil; 
	
	for (MPMediaPlaylist *playlist in playlists) {
		NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
		
		NSArray *songs = [playlist items];
		for (MPMediaItem *song in songs) { 
			
			NSNumber* songMediaType = [song valueForProperty: MPMediaItemPropertyMediaType]; 
			
			//verifica se é uma música
			if([songMediaType intValue] == 1) {
				
				musicPropertyList = [NSDictionary dictionaryWithObjectsAndKeys: 
									 [song valueForProperty: MPMediaItemPropertyTitle], @"songTitle", 
									 [song valueForProperty: MPMediaItemPropertyAlbumArtist], @"songArtist", 
									 [song valueForProperty: MPMediaItemPropertyPlayCount], @"songPlayCount", 
									 [song valueForProperty: MPMediaItemPropertyAlbumArtist], @"songArtist", 
									 [song valueForProperty: MPMediaItemPropertySkipCount], @"songSkipCount", 
									 [song valueForProperty: MPMediaItemPropertyLastPlayedDate], @"songLastPlayedDate", 
									 [song valueForProperty: MPMediaItemPropertyGenre], @"songArtist", 
									 [song valueForProperty: MPMediaItemPropertyAlbumArtist], @"songGenre", 
									 [song valueForProperty: MPMediaItemPropertyRating], @"songRating", 
									 nil];
				
				NSLog(@"%@ %@", musicPropertyList, [song valueForProperty: MPMediaItemPropertyAlbumArtist]);
				
				dataRep = [NSPropertyListSerialization dataFromPropertyList: musicPropertyList 
																					 format: NSPropertyListXMLFormat_v1_0 
																		   errorDescription: &errorStr];
								
				[mSession sendData:dataRep toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
								
				musicPropertyList = nil;
				
				break;
				
			}
			
		}
	}	
	
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	NSString *errorStr = nil; 
	NSMutableDictionary* array = [NSPropertyListSerialization propertyListFromData:data 
											mutabilityOption:NSPropertyListImmutable 
											format:nil
											errorDescription:&errorStr];
	
	if([[array objectForKey:@"songArtist"] length] > 0){
		
		for(int i = 0; i < [library count]; i++){
		
			if([[[[library objectAtIndex:i] objectForKey:@"user"] objectForKey:@"user"] isEqualToString:mSession.displayName]){
			
				if([[[library objectAtIndex:i] objectForKey:@"user"] objectForKey:@"library"] != nil)
					[[[library objectAtIndex:i] objectForKey:@"user"] setValue:[[NSMutableArray alloc] init] forKey:@"library"];
				
				[[[[library objectAtIndex:i] objectForKey:@"user"] objectForKey:@"library"] addObject:array];
				
			}
			
		}
		
		[[delegate tableView] reloadData];
		
	}
	
	NSLog(@"%@ %i", array, [[array objectForKey:@"songArtist"] length]);
	
	NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//NSLog(@"Received Data from %@ %@",peer, aStr);
	
	UIAlertView* myAlert = [[[UIAlertView alloc] initWithTitle:@"Add User" message:[NSString stringWithFormat:@"Received Data from %@ %@",peer, aStr] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil] autorelease];
	[myAlert show];
	
	
}

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
	
	NSLog(@"cancelando");
	
}

#pragma mark GameSessionDelegate stuff

/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	
	switch (state)
    {
        case GKPeerStateConnected:
		{
			NSString *str=[NSString stringWithFormat:@"%@%@",@"Connected from pier ",peerID];
			NSLog(str);
			[mPeers addObject:peerID];
			break;
		}
        case GKPeerStateDisconnected:
		{
			[mPeers removeObject:peerID];
			
			NSString *str=[NSString stringWithFormat:@"%@%@",@"DisConnected from pier ",peerID];
			NSLog(str);
			break;
		}
    }
}

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
