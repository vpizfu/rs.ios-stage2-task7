//
//  TabBarController.m
//  task7
//
//  Created by Roman on 7/19/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    MainViewController *controllerMain = [[MainViewController alloc] initWith:nil labelString:@"Все видео"];
    MainViewController *controllerFavorite = [[MainViewController alloc] initWith: [NSPredicate predicateWithFormat:@"favorite = %@", @"YES"] labelString:@"Любимые видео"];
    UINavigationController *navControllerMain = [[UINavigationController alloc] initWithRootViewController:controllerMain];
    UINavigationController *navControllerFavorite = [[UINavigationController alloc] initWithRootViewController:controllerFavorite];
    NSArray* controllers = [NSArray arrayWithObjects:navControllerMain, navControllerFavorite, nil];
    [self setViewControllers:controllers];
    self.tabBar.barTintColor = [UIColor colorWithRed:35.0f/255.0f green:38.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    UITabBarItem *barButtonMainController = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"home_notselected"] selectedImage:[UIImage imageNamed:@"home_selected"]];
    UITabBarItem *barButtonControllerFavorite = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"favorite_notselected"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    controllerMain.tabBarItem = barButtonMainController;
    controllerFavorite.tabBarItem = barButtonControllerFavorite;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    [(UINavigationController*)viewController popToRootViewControllerAnimated:YES];
    return YES;
}

@end
