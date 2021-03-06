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
	[delegate setNavegador:self.navigationController];
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
	
	int indexMusic = 0;
	
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
									 [song valueForProperty: MPMediaItemPropertySkipCount], @"songSkipCount", 
									 [song valueForProperty: MPMediaItemPropertyLastPlayedDate], @"songLastPlayedDate",  
									 [song valueForProperty: MPMediaItemPropertyGenre], @"songGenre", 
									 [song valueForProperty: MPMediaItemPropertyRating], @"songRating", 
									 [[NSNumber alloc] initWithInt:indexMusic], @"index", 
									 nil]; 
				
				[musics addObject:musicPropertyList]; 
				indexMusic++;
				
			}
			
		}
		
		
	}
	
	NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
	[user setValue:userProperties forKey:@"user"];
	[user setValue:musics forKey:@"library"];
	
	[library addObject:user];
	
}

-(void)makeCommonSongs {
	
	NSMutableArray* lib = [[NSMutableArray alloc] init];
	
	if([library count] > 1){
		for(int i=0; i < [library count]-1; i++){
			
			for(int j=0; j < [[[library objectAtIndex:0] objectForKey:@"library"] count]; j++){
				
				for(int y=0; y < [[[library objectAtIndex:i+1] objectForKey:@"library"] count]; y++){
					
					if([[[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:j] objectForKey:@"songTitle"] 
						isEqualToString:[[[[library objectAtIndex:i+1] objectForKey:@"library"] objectAtIndex:y] objectForKey:@"songTitle"]] && 
					   [[[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:j] objectForKey:@"songArtist"] 
						isEqualToString:[[[[library objectAtIndex:i+1] objectForKey:@"library"] objectAtIndex:y] objectForKey:@"songArtist"]]){
						
						//NSLog(@"%i %i %i %@-%@* bate!", i, j, y, [[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:j] objectForKey:@"songTitle"], [[[[library objectAtIndex:i+1] objectForKey:@"library"] objectAtIndex:y] objectForKey:@"songTitle"]);
						
						[lib addObject:[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:j]];
						break;
					} else {
						
						//NSLog(@"- %i %i %i %@-%@", i, j, y, [[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:j] objectForKey:@"songTitle"], [[[[library objectAtIndex:i+1] objectForKey:@"library"] objectAtIndex:y] objectForKey:@"songTitle"]);
						
					}
					
				}
			}
		}
	}
	
	NSMutableDictionary* userProperties = [[NSMutableDictionary alloc] init];
	[userProperties setValue:@"Common Songs" forKey:@"user"];
	
	NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
	[user setValue:userProperties forKey:@"user"];
	[user setValue:lib forKey:@"library"];
	
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
	
	//NSLog(@"Connected from %@",peerID);
	
	[self.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:NO];
	
	session.delegate = self;
	mPeerID = peerID;
	
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
	[userProperties setValue:[session displayNameForPeer:mPeerID] forKey:@"user"];
	NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
	NSMutableArray* musics = [[NSMutableArray alloc] init];

	[user setValue:userProperties forKey:@"user"];
	[user setValue:musics forKey:@"library"];
	
	[library addObject:user];
	
	[delegate setUsers:library];
	[delegate setSession:mSession];
	[delegate setPeers:mPeers];
	
	[[delegate tableView] reloadData];
	
	
}

-(void) sendData {
	
	//NSDictionary *musicPropertyList; 
	//NSMutableArray* musics = [[NSMutableArray alloc] init];
	//MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
	//NSArray *playlists = [myPlaylistsQuery collections];
	NSData* dataRep;
	NSString *errorStr = nil; 
	
	[self.navigationController.navigationBar.topItem.leftBarButtonItem setEnabled:NO];
	
	NSMutableDictionary* props = [[NSMutableDictionary alloc] init];
	[props setValue:[[NSNumber alloc] initWithInt:[[[library objectAtIndex:0] objectForKey:@"library"] count]] forKey:@"FriendTotalMusics"];
	
	dataRep = [NSPropertyListSerialization dataFromPropertyList: props 
														 format: NSPropertyListXMLFormat_v1_0 
											   errorDescription: &errorStr];
	[mSession sendData:dataRep toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
	
	
}

- (void) syncronize:(id)sender {
		
	totalFriendMusicsTemp = totalFriendMusicsTemp-1;
	
	//Requisita a musica ao amigo
	NSMutableDictionary* props = [[NSMutableDictionary alloc] init];
	[props setValue:[[NSNumber alloc] initWithInt:totalFriendMusicsTemp] forKey:@"giveMeTune"];
	
	NSData* dataRep;
	NSString *errorStr = nil; 
	dataRep = [NSPropertyListSerialization dataFromPropertyList: props 
														 format: NSPropertyListXMLFormat_v1_0 
											   errorDescription: &errorStr];
	[mSession sendData:dataRep toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
	
	//NSLog(@"pedindo %i", totalFriendMusicsTemp);

	//verifica se acabaram as musicas do amigo
	if(totalFriendMusicsTemp == 0){
		[syncTimer invalidate];
		syncTimer = nil;
		
		if(!sentMusicComplete)
			[self sendData];
	}
	
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	NSString *errorStr = nil; 
	NSMutableDictionary* array = [NSPropertyListSerialization propertyListFromData:data 
											mutabilityOption:NSPropertyListImmutable 
											format:nil
											errorDescription:&errorStr];
	
	if([array objectForKey:@"FriendTotalMusics"]){
	
		totalFriendMusics = totalFriendMusicsTemp = [[array objectForKey:@"FriendTotalMusics"] intValue];
		//NSLog(@"O amigo tem %i musicas", [[array objectForKey:@"FriendTotalMusics"] intValue]);
		syncTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(syncronize:) userInfo:nil repeats:YES];
		
	}
	
	if([array objectForKey:@"giveMeTune"]){
		
		//NSLog(@"giveMeTune %i", [[array objectForKey:@"giveMeTune"] intValue]);
		
		NSData* dataRep;
		NSString *errorStr = nil; 
		dataRep = [NSPropertyListSerialization dataFromPropertyList: [[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:[[array objectForKey:@"giveMeTune"] intValue]] 
															 format: NSPropertyListXMLFormat_v1_0 
												   errorDescription: &errorStr];
		[mSession sendData:dataRep toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
		
		if([[array objectForKey:@"giveMeTune"] intValue] == 0)
			sentMusicComplete = true;
		
	}
	
	if([array objectForKey:@"playTune"]){
		
		//NSLog(@"%i", [[array objectForKey:@"playTune"] intValue]);
		
		MPMusicPlayerController* musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
		
		MPMediaPropertyPredicate *artistNamePredicate = [MPMediaPropertyPredicate predicateWithValue: 
														 [[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:[[array objectForKey:@"playTune"] intValue]] objectForKey:@"songArtist"]
																						 forProperty: MPMediaItemPropertyArtist];
		
		MPMediaPropertyPredicate *titlePredicate = [MPMediaPropertyPredicate predicateWithValue: 
													[[[[library objectAtIndex:0] objectForKey:@"library"] objectAtIndex:[[array objectForKey:@"playTune"] intValue]] objectForKey:@"songTitle"]
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
		
	}
	
//	NSLog(@"titulo... %@", [array objectForKey:@"songTitle"]);
	if([array objectForKey:@"songTitle"]){
		
		
		NSMutableArray* user;
		NSMutableArray* musics;

		for(int i = 0; i < [library count]; i++){
		
			if([[[[library objectAtIndex:i] objectForKey:@"user"] objectForKey:@"user"] isEqualToString:[mSession displayNameForPeer:mPeerID]]){
			
				//NSLog(@"Recebendo...");
				user = [library objectAtIndex:i];
				
				if([[user objectForKey:@"library"] count] > 0 && i == 0){
					[user setValue:[[NSMutableArray alloc] init] forKey:@"library"];
					//NSLog(@"Reiniciando musica usuario... %i", [[user objectForKey:@"library"] count]);
				}
				
				//NSLog(@"%i %i", [[user objectForKey:@"library"] count], totalFriendMusics-1);
				if([[user objectForKey:@"library"] count] == totalFriendMusics-1){
					
					[self makeCommonSongs];
					
				}
				
				musics = [user objectForKey:@"library"];//[[NSMutableArray alloc] init];
				
			}
			
		}
		
		[musics addObject:array];
		[[delegate tableView] reloadData];
		
	}
//		
//		//NSLog(@"LIBRARY: \n %@", library);
//		
//		
//		NSMutableArray* user;
//		NSMutableArray* musics;
//		
//		for(int i = 0; i < [library count]; i++){
//		
//			if([[[[library objectAtIndex:i] objectForKey:@"user"] objectForKey:@"user"] isEqualToString:mSession.displayName]){
//			
//				NSLog(@"Recebendo musica");
//				user = [library objectAtIndex:i];
//				
//				if([[user objectForKey:@"library"] count] > 0 && i == 0){
//					[user setValue:[[NSMutableArray alloc] init] forKey:@"library"];
//					NSLog(@"Reiniciando musica usuario... %i", [[user objectForKey:@"library"] count]);
//				}
//				
//				musics = [user objectForKey:@"library"];//[[NSMutableArray alloc] init];
//				
//			}
//			
//		}
//		
//		
//		if(totalFriendMusics != [musics count]){
//		
//			[musics addObject:array];
//			
//			totalFriendMusicsTemp = totalFriendMusicsTemp-1;
//			NSLog(@"Falta... %i \n A ultima: %@", totalFriendMusicsTemp, [[musics lastObject] objectForKey:@"songTitle"]);
//			
//			if(totalFriendMusicsTemp == 0){
//				NSLog(@"- Enviando dados");
//				[self sendData];
//				
//			}
//			
//		} else {
//		
//			NSLog(@"Ja foi sincronizado !!");
//			
//		}
//		[[delegate tableView] reloadData];
		
//	}
	
	//NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//	//NSLog(@"Received Data from %@ %@",peer, aStr);
//	
//	UIAlertView* myAlert = [[[UIAlertView alloc] initWithTitle:@"Add User" message:[NSString stringWithFormat:@"Received Data from %@ %@",peer, aStr] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil] autorelease];
//	[myAlert show];
	
	
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
