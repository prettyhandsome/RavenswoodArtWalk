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
    UIView          *maskView;

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
    
    self.navigationItem.title=self.selectedArtist.studioName;

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
    UIFont *oswald = [UIFont fontWithName:@"Oswald" size:self.blurbTextView.font.pointSize];
    self.artistDetailLabel.font = oswald;
    
    self.studioNameLabel.text = self.selectedArtist.studioName;
    
    UIFont *podkova = [UIFont fontWithName:@"Podkova" size:self.blurbTextView.font.pointSize];
   // self.blurbLabel.font = podkova;
   // self.blurbLabel.text = self.selectedArtist.blurb;
    self.blurbTextView.font = podkova;
    self.blurbTextView.text = self.selectedArtist.blurb;
    NSString *text = self.selectedArtist.blurb;
    CGRect originalFrame = self.blurbTextView.frame;
    CGSize originalTextSize = self.blurbTextView.contentSize;
    NSLog(@"content height %f",originalTextSize.height);
    float lineCount = originalTextSize.height/18.0;
    CGSize frameSize = [text sizeWithFont:podkova forWidth:280.0 lineBreakMode:NSLineBreakByWordWrapping];
    self.blurbTextView.frame = CGRectMake(CGRectGetMinX(originalFrame), CGRectGetMinY(originalFrame), CGRectGetWidth(originalFrame), frameSize.height*lineCount);
    
    self.favoriteButtonOutlet.frame = CGRectMake(20,(self.blurbTextView.frame.origin.y + self.blurbTextView.frame.size.height +10), self.favoriteButtonOutlet.frame.size.width, self.favoriteButtonOutlet.frame.size.height);
    self.visitWebsiteButtonOutlet.frame = CGRectMake(20,(self.favoriteButtonOutlet.frame.origin.y + self.favoriteButtonOutlet.frame.size.height +10), self.visitWebsiteButtonOutlet.frame.size.width, self.visitWebsiteButtonOutlet.frame.size.height);
    self.contactArtistButtonOutlet.frame = CGRectMake(20,(self.visitWebsiteButtonOutlet.frame.origin.y + self.visitWebsiteButtonOutlet.frame.size.height +10), self.contactArtistButtonOutlet.frame.size.width, self.contactArtistButtonOutlet.frame.size.height);
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
    [self.visitWebsiteButtonOutlet setTitle:@"Visit Artist's Website" forState:UIControlStateNormal];
       //self.visitWebsiteButtonOutlet.titleLabel.text= @"Visit Artist's Website";
   }
    if (self.selectedArtist.email == nil)
    {
        [self.contactArtistButtonOutlet setTitle:@"No e-mail address available for this artist" forState:UIControlStateNormal];
        //self.contactArtistButtonOutlet.titleLabel.text= @"No e-mail address available for this artist";
        [self.contactArtistButtonOutlet setUserInteractionEnabled:NO];
        self.contactArtistButtonOutlet.alpha = .5;
    }
    else
    {
         [self.contactArtistButtonOutlet setTitle: @"Contact Artist" forState:UIControlStateNormal];
    }
    if (self.selectedArtist.favorite == [NSNumber numberWithInt:1])
    {
        [self.favoriteButtonOutlet setTitle:@"Remove from favorites" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.favoriteButtonOutlet setTitle:@"Add to favorites" forState:UIControlStateNormal];
        
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
    
    if (self.selectedArtist.favorite == [NSNumber numberWithInt:1])
    {
        self.selectedArtist.favorite = [NSNumber numberWithBool:NO];
        [self.favoriteButtonOutlet setTitle:@"Removed from favorites" forState:UIControlStateNormal];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"An error occured: %@", error);
        }
    
    }
    else
    {
        
     self.selectedArtist.favorite = [NSNumber numberWithBool:YES];
        [self.favoriteButtonOutlet setTitle:@"Added to favorites" forState:UIControlStateNormal];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"An error occured: %@", error);
        }    
    }
}
@end
