//
//  ArtistViewController.m
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/14/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "ArtistViewController.h"
#import "AppDelegate.h"

static NSString *CellIdentifier = @"CellID";

@interface ArtistViewController ()

{
    NSData          *artistData;
    NSString        *sortString;
}

@property (strong, nonatomic) NSFileManager                 *fileManager;
@property (strong, nonatomic) NSURL                         *documentDirectory;
@property (strong, nonatomic) NSFetchedResultsController    *fetchedResultsController;
@property (strong, nonatomic) Artist                        *tappedArtist;

-(void)setupArtists;
-(void)parseArtistJSON;
-(void)formatSegmentControl;

@end

@implementation ArtistViewController

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
    
    UIFont *oswald = [UIFont fontWithName:@"Oswald" size:self.titleLabel.font.pointSize];
    self.titleLabel.font = oswald;
    
    self.fileManager =[NSFileManager defaultManager];
    self.documentDirectory = [[self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSLog(@"%@", self.documentDirectory);
    
    self.managedObjectContext = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    
    [self setupArtists];
    NSInteger count = self.fetchedResultsController.sections.count;
    NSLog(@"results section count %d", count);
    
    if (count ==0){
        
        [self parseArtistJSON];
    }
    [self setupArtists];
    
    [self.sortSegment addTarget:self action:@selector(formatSegmentControl) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)formatSegmentControl
{
    // Change to the alternate layout
    
    if (self.sortSegment.selectedSegmentIndex == 0)
    {
        [self setupArtists];
      
    }
    else if (self.sortSegment.selectedSegmentIndex == 1)
    {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
        
        [fetchRequest setEntity:entity];
        
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"medium" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"studioName" ascending:YES]];
        
        self.fetchedResultsController= [[NSFetchedResultsController alloc]
                                        initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                        sectionNameKeyPath:@"medium"
                                        cacheName:@"nil"];
        
        NSError *error;
        
        BOOL success = [self.fetchedResultsController performFetch:&error];
        if (!success) {
            NSLog (@"Error: %@", error.description);
        }
        NSLog(@"media, fetchResults: %@", [self.fetchedResultsController objectAtIndexPath:0]);

    } else {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
        
        [fetchRequest setEntity:entity];
        
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rawLocation" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"studioName" ascending:YES]];
        
        self.fetchedResultsController= [[NSFetchedResultsController alloc]
                                        initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                        sectionNameKeyPath:@"rawLocation"
                                        cacheName:@"nil"];
        
        NSError *error;
        
        BOOL success = [self.fetchedResultsController performFetch:&error];
        if (!success) {
            NSLog (@"Error: %@", error.description);
        }
        NSLog(@"location, fetchResults: %@", [self.fetchedResultsController objectAtIndexPath:0]);
    }
      [self.artistsTable reloadData];
}

-(void)setupArtists
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"studioName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"rawLocation.location" ascending:YES]];
    
    self.fetchedResultsController= [[NSFetchedResultsController alloc]
                                    initWithFetchRequest:fetchRequest
                                    managedObjectContext:self.managedObjectContext
                                    sectionNameKeyPath:@"sortChar"
                                    cacheName:@"nil"];
    
    NSError *error;
    
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if (!success) {
        NSLog (@"Error: %@", error.description);
    }
    NSLog(@"setupArtists, fetchResults: %@", self.fetchedResultsController);
}

-(void)parseArtistJSON
{
    self.fileManager = [NSFileManager defaultManager];
    self.documentDirectory = [self.fileManager URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask][0];
       
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *artistFile = [mainBundle pathForResource: @"artistData" ofType: @"json"];
    artistData = [NSData dataWithContentsOfFile:artistFile];
    
    if (artistData) {
        NSLog(@"artistData:%@", artistData);
        
        NSDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:artistData
                                                                 options:0
                                                                   error:nil];
        
        NSMutableArray *mainArray = [mainDict objectForKey:@"artists"];
        
        NSMutableArray *artistTableArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in mainArray)
        {
            NSString *studioName = [dict objectForKey:@"studioName"];
            NSString *artistName = [dict objectForKey:@"artistName"];
            NSString *rawLocation = [dict objectForKey:@"RAWlocation"];
            NSString *blurb = [dict objectForKey:@"blurb"];
            NSString *medium = [dict objectForKey:@"medium"];
            NSString *email = [dict objectForKey:@"email"];
            NSString *address = [dict objectForKey:@"address"];
            NSString *website = [dict objectForKey:@"link"];
            NSString *imagePath = [dict objectForKey:@"imageName"];
            
            if (studioName != nil) {
                //make case insensitive :)
                NSLog(@"%c", [studioName characterAtIndex:0]);
                char alphaSort = [studioName characterAtIndex:0];
                sortString = [NSString stringWithFormat:@"%c" , alphaSort];
                
            } else {
                NSLog(@"Studio name is nil?!?");
            }
            
            
            Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Artist class]) inManagedObjectContext:self.managedObjectContext];
            
            artist.studioName = studioName;
            artist.sortChar = sortString;
            artist.artistName = artistName;
            artist.rawLocation = rawLocation;
            artist.blurb = blurb;
            artist.address = address;
            artist.website = website;
            artist.medium = medium;
            artist.email = email;
            artist.imagePath = imagePath;
            
            [artistTableArray addObject:artist];
        }
        
    } else {
        NSLog(@"Can't find file");
        return;
    }

    NSError *saveError = nil;
    [self.managedObjectContext save: &saveError];
    [self setupArtists];
    [self.artistsTable reloadData];
}


#pragma mark -- TableView Setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.fetchedResultsController sections] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArtistCell *artistCell = (ArtistCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    artistCell.studioNameLabel.text = artist.studioName;
    artistCell.mediumLabel.text = artist.medium;
    
    //tableViewCell.imageView.image = [UIImage imageNamed:person.imageName];
    
    // Configure the cell with data from the managed object.
    
    return artistCell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

#pragma
#pragma Segue

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.tappedArtist= [self.fetchedResultsController objectAtIndexPath:indexPath];

    [self.artistsTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"segueToArtistDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
((ArtistDetailViewController *)segue.destinationViewController).selectedArtist = self.tappedArtist;
    NSLog(@"artist for segue: %@", self.tappedArtist.studioName);
}


@end
