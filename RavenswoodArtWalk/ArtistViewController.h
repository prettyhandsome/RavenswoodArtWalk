//
//  ArtistViewController.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/14/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Artist.h"
#import "RAWLocation.h"
#import "ArtistCell.h"
#import "ArtistDetailViewController.h"

@interface ArtistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITableView *artistsTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sortSegment;

@end
