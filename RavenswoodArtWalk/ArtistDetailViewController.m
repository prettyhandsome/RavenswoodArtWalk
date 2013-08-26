//
//  ArtistDetailViewController.m
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/14/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "AppDelegate.h"


@interface ArtistDetailViewController ()
{
    UIView  *maskView;

}

@property (strong, nonatomic) NSFileManager                 *fileManager;
@property (strong, nonatomic) NSURL                         *documentDirectory;
@property (strong, nonatomic) NSFetchedResultsController    *fetchedResultsController;

-(void)populateSummary;
-(void)loadImage;
-(void)createImageFrame;
-(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;


@end

@implementation ArtistDetailViewController

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
    
    self.managedObjectContext = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;

    [self loadImage];
    [self createImageFrame];
    [self populateSummary];
    [self setInitialButtonViews];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateSummary
{
    UIFont *oswald = [UIFont fontWithName:@"Oswald" size:self.artistDetailLabel.font.pointSize];
    self.artistDetailLabel.font = oswald;
    
    self.studioNameLabel.text = self.selectedArtist.studioName;
    
    UIFont *podkova = [UIFont fontWithName:@"Podkova" size:self.blurbLabel.font.pointSize];
    self.blurbLabel.font = podkova;
    self.blurbLabel.text = self.selectedArtist.blurb;
    
    }

-(void)loadImage
{
    if (self.selectedArtist.imageData ==nil){
        
        self.fileManager =[NSFileManager defaultManager];
        self.documentDirectory = [[self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
       
        NSString *imageURLString = self.selectedArtist.imagePath;
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [self downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                
                // change the image in the view
                UIImage *artistImage = image;
                self.artImage.image = artistImage;
        
                NSURL *imageURL = [NSURL URLWithString:imageURLString];
                NSString *fileName =[imageURL lastPathComponent];
                NSURL *localImageUrl = [self.documentDirectory URLByAppendingPathComponent:fileName];
                NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
                [imageData writeToURL: localImageUrl atomically: YES];
                
                self.selectedArtist.imageData = imageData;
                NSError *saveError = nil;
                [self.managedObjectContext save: &saveError];
                 
    
            }
        }];
    } else {
        
        UIImage *artistImage = [UIImage imageWithData:self.selectedArtist.imageData];
        self.artImage.image = artistImage;

    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

-(void)createImageFrame
{
    self.artImage.layer.cornerRadius=8.0f;
    self.artImage.layer.masksToBounds=YES;
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(self.artImage.frame.origin.x, self.artImage.frame.origin.y, CGRectGetWidth(self.artImage.frame), CGRectGetHeight(self.artImage.frame))];
    //maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    maskView.alpha = 1.0f;
    
    maskView.layer.cornerRadius=8.0f;
    maskView.layer.masksToBounds=YES;
    maskView.layer.borderColor = [[UIColor colorWithRed:49.0/255.0 green:25.0/255.0 blue:60.0/255.0 alpha:1.0]CGColor];
    maskView.layer.borderWidth= 1.0f;
    
    [self.view insertSubview:maskView aboveSubview:self.artImage];

    
}

-(void)setInitialButtonViews
{
   if (self.selectedArtist.website == nil)
   {
       [self.visitWebsiteButtonOutlet setTitle:@"No website available for this artist" forState:UIControlStateNormal];
       [self.visitWebsiteButtonOutlet setUserInteractionEnabled:NO];
       self.visitWebsiteButtonOutlet.alpha = .5;
   }
   else
   {
    [self.visitWebsiteButtonOutlet setTitle:@"No website available for this artist" forState:UIControlStateNormal];self.visitWebsiteButtonOutlet.titleLabel.text= @"Visit Artist's Website";
   }
    if (self.selectedArtist.email == nil)
    {
        self.contactArtistButtonOutlet.titleLabel.text= @"No e-mail address available for this artist";
        [self.contactArtistButtonOutlet setUserInteractionEnabled:NO];
        self.contactArtistButtonOutlet.alpha = .5;
    }
    else
    {
        self.contactArtistButtonOutlet.titleLabel.text= @"Contact Artist";
    }
    if (self.selectedArtist.favorite == nil)
    {
        self.favoriteButtonOutlet.titleLabel.text= @"Mark this artist as a favorite";
    }
    else
    {
        self.favoriteButtonOutlet.titleLabel.text= @"Remove from Favorites";
    }
}
//if the artist.website =nil, then set the alpha to .5 and change the message and disable clicking.  if in favorites, make sure selected already

- (IBAction)visitWebsiteButton:(id)sender {
    NSString* launchUrl = self.selectedArtist.website;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (IBAction)contactArtistButton:(id)sender {
    NSString *subjectLine = @"Ravenswood Art Fair";
    NSString *mailString = [NSString stringWithFormat:@"mailto:%@?subject=%@", self.selectedArtist.email, subjectLine];
    NSString *emailUrl =[mailString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"emailUrl: %@",emailUrl);

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: emailUrl]];
}
- (IBAction)favoriteButton:(id)sender {
    
    if (self.selectedArtist.favorite == nil)
    {
        self.selectedArtist.favorite = [NSNumber numberWithBool:YES];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"An error occured: %@", error);
        }    }
    else
    {
        self.selectedArtist.favorite = [NSNumber numberWithBool:NO];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"An error occured: %@", error);
        }    }
    

    }
@end
