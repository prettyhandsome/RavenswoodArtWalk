//
//  FavoritesViewController.m
//  RavenswoodArtWalk
//
//  Created by ehochs  on 9/6/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "Artist.h"
#import "ArtistCell.h"
#import "ArtistDetailViewController.h"

static NSString *CellIdentifier = @"favCell";

@interface FavoritesViewController ()

@property (strong, nonatomic) NSFetchedResultsController    *favoritesResultsController;
@property (strong, nonatomic) Artist                        *tappedArtist;

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFavorites];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFavorites
{
    
    NSManagedObjectContext *managedObjectContext = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    
    NSFetchRequest *favoritesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate * selectedPredicate = [NSPredicate predicateWithFormat:@"favorite = %d", 1];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:managedObjectContext];
    [favoritesFetchRequest setEntity:entity];
    [favoritesFetchRequest setPredicate: selectedPredicate];
    
    favoritesFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"studioName" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"rawLocation" ascending:NO]];
    
    
    self.favoritesResultsController= [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:favoritesFetchRequest
                                      managedObjectContext:managedObjectContext
                                      sectionNameKeyPath:@"studioName"
                                      cacheName:@"nil"];
    
    NSError *error;
    
    BOOL success = [self.favoritesResultsController performFetch:&error];
    if (!success) {
        NSLog (@"Error: %@", error.description);
    }
    
    
}

#pragma mark -- TableView Setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.favoritesResultsController sections] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.favoritesResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArtistCell *artistCell = (ArtistCell*)[self.favoritesTable dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Artist *artist = [self.favoritesResultsController objectAtIndexPath:indexPath];
    artistCell.studioNameLabel.text = artist.studioName;
    artistCell.mediumLabel.text = artist.medium;
    NSLog(@"artistName: %@", artist.studioName);
    
    // Configure the cell with data from the managed object.
    
    return artistCell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.favoritesResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

#pragma
#pragma Segue

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.tappedArtist= [self.favoritesResultsController objectAtIndexPath:indexPath];
    
    [self.favoritesTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"segueToArtistDetails" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((ArtistDetailViewController *)segue.destinationViewController).selectedArtist = self.tappedArtist;
    NSLog(@"artist for segue: %@", self.tappedArtist.studioName);
}



@end
