//
//  Appearance.m
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/24/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "Appearance.h"

@implementation Appearance

+(void)applyStyle{
    
    
#pragma
#pragma Navigation Bar Appearance
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"NavBarBG.png"]  forBarMetrics:UIBarMetricsDefault];
   // [navigationBarAppearance setTitleVerticalPositionAdjustment:-2.0f forBarMetrics:UIBarMetricsDefault];
    //[navigationBarAppearance setTranslucent:NO];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:191.0/255.0 green:47.0/255.0 blue:28.0/255.0 alpha:1.0], UITextAttributeTextColor, [UIFont fontWithName:@"Oswald" size:23.0],UITextAttributeFont, nil];

    [navigationBarAppearance setTitleTextAttributes: textAttributes];
    


#pragma
#pragma BackButton Attributes
    
    
    UIImage *barItemBackDefaultImg = [[UIImage imageNamed:@"navBarBack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.0, 0, 10.0)];
    UIImage *barItemBackSelectImg = [[UIImage imageNamed:@"navBarBack-Selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20.0, 0, 25.0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage: barItemBackDefaultImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage: barItemBackSelectImg
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor grayColor],UITextAttributeTextColor,
                                [UIColor clearColor],UITextAttributeTextShadowColor,
                                [UIFont fontWithName:@"oswald" size:12.0f],UITextAttributeFont,
                                nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
   /* UIImage *barButtonImage = [[UIImage imageNamed:@"monsterNavBar-stretchyButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0] ;
    UIImage *barButtonTappedImage = [[UIImage imageNamed:@"monsterNavBar-stretchyButton-tapped.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0] ;
    
    [[UIBarButtonItem appearance] setTintColor: [UIColor purpleColor]];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage
                                            forState:UIControlStateNormal
                                               style:UIBarButtonItemStyleBordered
                                          barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonTappedImage
                                            forState:UIControlStateHighlighted
                                               style:UIBarButtonItemStyleBordered
                                          barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 1.f) forBarMetrics:UIBarMetricsDefault];*/
}

@end
