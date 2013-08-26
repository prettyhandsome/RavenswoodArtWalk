//
//  RAWLocation.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/16/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface RAWLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * tent;
@property (nonatomic, retain) NSSet *artists;
@end

@interface RAWLocation (CoreDataGeneratedAccessors)

- (void)addArtistsObject:(Artist *)value;
- (void)removeArtistsObject:(Artist *)value;
- (void)addArtists:(NSSet *)values;
- (void)removeArtists:(NSSet *)values;

@end
