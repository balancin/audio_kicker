//
//  Peer.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/11/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import "Peer.h"


@implementation Peer

- (BOOL) startPeer
{
    BOOL result = NO;
	
    if (!_session) {
        _session = [[GKSession alloc] initWithSessionID:BLUETOOTHSESSION 
											displayName:nil 
											sessionMode:GKSessionModePeer];
        _session.delegate = self;
        [_session setDataReceiveHandler:self withContext:nil];
        _session.available = YES;
        result = YES;
    }
    return result;
}

- (void) stopPeer
{
    // Set up the session for the next connection
    //
    [_session disconnectFromAllPeers];
    _session.available = YES;
	
    [self cleanupProgressWindow];
}

- (void) loadPeerList 
{
    self.peerList = [[NSMutableArray alloc] initWithArray:[_session peersWithConnectionState:GKPeerStateAvailable]];
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    BOOL peerChanged = NO;
	
    switch(state) {
			
			// When peer list changes, we adjust the available list
			//
        case GKPeerStateAvailable:
			if (_peerList) {
				[_peerList addObject:peerID];
				peerChanged = YES;
			}
			break;
			
			// When peer list changes, we adjust the available list
			//
        case GKPeerStateUnavailable:
			if (_peerList) {
				[_peerList removeObject:peerID];
				peerChanged = YES;
			}
			break;
			
			
			// Called when the peer has connected to us.
			//
        case GKPeerStateConnected:
			// start reading and writing
			break;
			
        case GKPeerStateDisconnected:
        {
			if (_isWriter) {
				_isConnected = NO;
				_deviceToSend = nil;
				[self cleanupProgressWindow];
			} else {
				// Other side dropped, clean up local data and reset for next connection
				self.dataRead = nil;
			}
        }
			break;
    }
	
    // Notify peer list delegate that the list has changed so they can update the UI
    //
    if (peerChanged)
        CALLDELEGATE(_peerListDelegate, peerListChanged);                       
}


@end
