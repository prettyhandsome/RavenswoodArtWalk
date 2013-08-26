//
//  Artist.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/22/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RAWLocation;

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * medium;
@property (nonatomic, retain) NSString * rawLocation;
@property (nonatomic, retain) NSString * studioName;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * sortChar;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) RAWLocation *location;

@end
