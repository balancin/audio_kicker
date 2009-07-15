//
//  audio_kickerViewController.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/10/09.
//  Copyright Umpulo 2009. All rights reserved.
//

#import "audio_kickerViewController.h"

@implementation audio_kickerViewController

//@synthesize akSession, akPeerID;
@synthesize mSession;

#define kTankSessionID @"gktank"

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
	
	HomeViewController* viewController = [[HomeViewController alloc] init];
	
	navegador = [[UINavigationController alloc] initWithRootViewController:viewController];
	navegador.view.userInteractionEnabled = YES;
	navegador.navigationBar.topItem.title = @"Audio Kicker";
	
	[self.view addSubview:navegador.view];	
	
	mPicker=[[GKPeerPickerController alloc] init];
	mPicker.delegate=self;
	mPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
	mPeers=[[NSMutableArray alloc] init];
	
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
	[mPeers release];
    [super dealloc];
}

#pragma mark Events

-(IBAction) connectClicked:(id)sender{
	//Show the connector
	[mPicker show];
}

#pragma mark PeerPickerControllerDelegate stuff

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
	
	//UIApplication *app=[UIApplication sharedApplication];
	NSString *txt=mTextField.text;
	
	GKSession* session = [[GKSession alloc] initWithSessionID:@"gavi" displayName:txt sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	NSLog(@"Connected from %@",peerID);
	
	// Use a retaining property to take ownership of the session.
    self.mSession = session;
	// Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
	// Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
	// Start your game.
}

-(IBAction) sendData:(id)sender{
	
	//NSString *str=mTextField.text;
	//[mSession sendData:[@"lalalala" dataUsingEncoding: NSASCIIStringEncoding] toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
	
	MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *playlists = [myPlaylistsQuery collections];
	//NSData* data = [playlists convertToData];
	
	//NSArray* playlists = [[NSArray alloc] initWithObjects:@"teste", @"teste1", nil];
	
	//NSData* data = [playlists convertToData];
	
	//[mSession sendData:data toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
	
//	NSData *dataRep; 
//	NSString *errorStr = nil; 
//	NSDictionary *propertyList;
//	 
//	propertyList = [NSDictionary dictionaryWithObjectsAndKeys: 
//                    @"Javier", @"FirstNameKey", 
//                    @"Alegria", @"LastNameKey", nil];
//	
//	dataRep = [NSPropertyListSerialization dataFromPropertyList: propertyList 
//														 format: NSPropertyListXMLFormat_v1_0 
//											   errorDescription: &errorStr];
//	
//	NSLog(@"%@", [[NSString alloc] initWithData:dataRep encoding:NSASCIIStringEncoding]);
		
	NSData *dataRep; 
	NSString *errorStr = nil; 
	NSDictionary *musicPropertyList; 
	
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
				
				dataRep = [NSPropertyListSerialization dataFromPropertyList: musicPropertyList 
																	 format: NSPropertyListXMLFormat_v1_0 
														   errorDescription: &errorStr];
				
				[mSession sendData:dataRep toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
				
				musicPropertyList = nil;
				dataRep = nil;
				errorStr = nil;
				
			}
			
		}
	}
	
	//[mSession sendData:[@"teste" dataUsingEncoding: NSASCIIStringEncoding] toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
	
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    // Read the bytes in data and perform an application-specific action.
	
	//NSString* aStr;
	//NSArray *playlists = [NSArray arrayWithData:data];
//	NSLog(playlists);
	
	//for (MPMediaPlaylist *playlist in playlists) {
//		NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
//		
//		NSArray *songs = [playlist items];
//		for (MPMediaItem *song in songs) {
//			NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//			NSString *songArtist = [song valueForProperty: MPMediaItemPropertyAlbumArtist];
//			NSString *songPlayCount = [song valueForProperty: MPMediaItemPropertyPlayCount];
//			NSString *songSkipCount = [song valueForProperty: MPMediaItemPropertySkipCount];
//			NSString *songLastPlayedDate = [song valueForProperty: MPMediaItemPropertyLastPlayedDate];
//			NSNumber* songMediaType = [song valueForProperty: MPMediaItemPropertyMediaType];
//			NSString *songGenre = [song valueForProperty: MPMediaItemPropertyGenre];
//			NSString *songRating = [song valueForProperty: MPMediaItemPropertyRating];
//
//			//verifica se é uma música
//			if([songMediaType intValue] == 1)
//				NSLog (@"\t%@ - %@ - %@ - %@ - %@ - %i - %@ - %@", songArtist, songTitle, songPlayCount, songSkipCount, songLastPlayedDate, [songMediaType intValue], songGenre, songRating);
//			
//		}
//	}
	
	NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Received Data from %@",peer);
	mTextView.text=[mTextView.text stringByAppendingString:aStr];
	
}

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
	
}

#pragma mark GameSessionDelegate stuff

/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	
	switch (state)
    {
        case GKPeerStateConnected:
		{
			NSString *str=[NSString stringWithFormat:@"%@\n%@%@",mTextView.text,@"Connected from pier ",peerID];
			mTextView.text= str;
			NSLog(str);
			[mPeers addObject:peerID];
			break;
		}
        case GKPeerStateDisconnected:
		{
			[mPeers removeObject:peerID];
			
			NSString *str=[NSString stringWithFormat:@"%@\n%@%@",mTextView.text,@"DisConnected from pier ",peerID];
			mTextView.text= str;
			NSLog(str);
			break;
		}
    }
}

//@end

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad {
//    [super viewDidLoad];
//	
//	//MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
//	NSArray *playlists = [myPlaylistsQuery collections];
//	
//	for (MPMediaPlaylist *playlist in playlists) {
//		NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
//		
//		NSArray *songs = [playlist items];
//		for (MPMediaItem *song in songs) {
//			NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//			NSString *songArtist = [song valueForProperty: MPMediaItemPropertyAlbumArtist];
//			NSString *songPlayCount = [song valueForProperty: MPMediaItemPropertyPlayCount];
//			NSString *songSkipCount = [song valueForProperty: MPMediaItemPropertySkipCount];
//			NSString *songLastPlayedDate = [song valueForProperty: MPMediaItemPropertyLastPlayedDate];
//			NSNumber* songMediaType = [song valueForProperty: MPMediaItemPropertyMediaType];
//			NSString *songGenre = [song valueForProperty: MPMediaItemPropertyGenre];
//			NSString *songRating = [song valueForProperty: MPMediaItemPropertyRating];
//	
//			//verifica se é uma música
//			if([songMediaType intValue] == 1)
//				NSLog (@"\t%@ - %@ - %@ - %@ - %@ - %i - %@ - %@", songArtist, songTitle, songPlayCount, songSkipCount, songLastPlayedDate, [songMediaType intValue], songGenre, songRating);
//			
//		}
//	}
//	
//	akPicker = [[GKPeerPickerController alloc] init];
//	akPicker.delegate = self;
//	akPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
//	akPeers=[[NSMutableArray alloc] init];
//
//	[akPicker show];
//	
//	
//}
//
//-(IBAction) sendData:(id)sender{
//	
//	NSString *str=@"Hello SaiBaba";
//	[akSession sendData:[str dataUsingEncoding: NSASCIIStringEncoding] toPeers:akPeers withDataMode:GKSendDataReliable error:nil];
//	
//}
//
//- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
//{
//    // Read the bytes in data and perform an application-specific action.
//	
//	NSString* aStr;
//	aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//	NSLog(@"Received Data from %@",peer);
//	NSLog(aStr);
//	
//	
//}
//
//
//#pragma mark Pos jogo
//
//- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerIDtoSession:(GKSession *)session {
//	
//	self.akPeerID = peerIDtoSession;	
//	NSLog(@"Connected from %@",peerIDtoSession);
//	
//	// Use a retaining property to take ownership of the session.
//    self.akSession = session;
//	// Assumes our object will also become the session's delegate.
//    session.delegate = self;
//    [session setDataReceiveHandler: self withContext:nil];
//	// Remove the picker.
//    picker.delegate = nil;
//    [picker dismiss];
//    [picker autorelease];
//	
//	
//}
//
//- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
//	if (type == GKPeerPickerConnectionTypeOnline) {
//        picker.delegate = nil;
//        [picker dismiss];
//        [picker autorelease];
//		// Implement your own internet user interface here.
//    }	
//}
//
//- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
//
//	//UIApplication *app=[UIApplication sharedApplication];
//	//NSString *txt=mTextField.text;
//	
//	GKSession* session = [[GKSession alloc] initWithSessionID:@"gavi" displayName:@"audiokicker" sessionMode:GKSessionModePeer];
//    [session autorelease];
//    return session;	
//	
//}
//
//- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
//	
//	NSLog(@"teste");
//	
//}
//
//- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
//	
//	switch (state)
//    {
//        case GKPeerStateConnected:
//		{
//			NSString *str=[NSString stringWithFormat:@"%@ %@",@"Connected from pier ",peerID];
//			//mTextView.text= str;
//			NSLog(str);
//			[akPeers addObject:peerID];
//			break;
//		}
//        case GKPeerStateDisconnected:
//		{
//			[akPeers removeObject:peerID];
//			
//			NSString *str=[NSString stringWithFormat:@"%@ %@",@"DisConnected from pier ",peerID];
//			//mTextView.text= str;
//			NSLog(str);
//			break;
//		}
//    }
//}
//
//
///*
// Override to allow orientations other than the default portrait orientation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//*/
//
//- (void)didReceiveMemoryWarning {
//	// Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//	
//	// Release any cached data, images, etc that aren't in use.
//}
//
//- (void)viewDidUnload {
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}
//
//
//- (void)dealloc {
//    [super dealloc];
//}

@end
//
//@interface NSArray : NSObject <NSCopying, NSMutableCopying, NSCoding, NSFastEnumeration>
//{
//	
//}
//
//- (NSData*) convertToData;
//+ (NSArray*) arrayWithData:(NSData*) data;
//
//
//@end


@implementation NSArray (dataConversion)

/** Convert to NSData, NOT encoding the including objects (only pointers) */
- (NSData*) convertToData {
	unsigned n= [self count];
	NSMutableData* data = [NSMutableData dataWithLength: sizeof(unsigned)+
						   sizeof(id) *n];
	unsigned* p = [data mutableBytes];
	*p++= n;
	[self getObjects:(void*)p];
	return data;
}

/** Reciprocal of convertToData */
+ (NSArray*) arrayWithData:(NSData*) data {
	unsigned* p = (unsigned*)[data bytes];
	unsigned n = *p++;
	return [NSArray arrayWithObjects:(id*)p count:n];
}

@end
