//
//  UsersTableViewDelegate.m
//  audio_kicker
//
//  Created by Fabio Balancin on 7/14/09.
//  Copyright 2009 Umpulo. All rights reserved.
//

#import "UsersTableViewDelegate.h"

@implementation UsersTableViewDelegate

@synthesize users, navegador, session, peers;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [users count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease]; 
		
    }

	cell.textLabel.text = [[[users objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"user"];
	
	int musicsNumber = [[[users objectAtIndex:indexPath.row] objectForKey:@"library"] count];
	
	cell.detailTextLabel.text = (musicsNumber > 0) ? [NSString stringWithFormat:@"%i music(s) in library", musicsNumber] : @"no musics";
	
	return cell;
	
}	

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 60;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	MusicasViewController* viewController = [[MusicasViewController alloc] init];
	[viewController setMusics:[[users objectAtIndex:indexPath.row] objectForKey:@"library"]];
	[viewController setNavegador:navegador];
	[viewController setSession:session];
	[viewController setPeers:peers];
	
	if(indexPath.row == 1)
		[viewController setFriendMusic:YES];
		
	[navegador pushViewController:viewController animated:YES];
	
}

@end
