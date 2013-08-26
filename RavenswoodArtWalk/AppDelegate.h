//
//  AppDelegate.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/2/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (void)saveContext;

@end
