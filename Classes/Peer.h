//
//  Peer.h
//  audio_kicker
//
//  Created by Fabio Balancin on 7/11/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface Peer : NSObject {

	GKSession* _session;
	NSMutableArray* peerList;
	
}

- (BOOL) startPeer;
- (void) stopPeer;
- (void) loadPeerList;
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state;


@end
