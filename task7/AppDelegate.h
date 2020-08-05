//
//  AppDelegate.h
//  task7
//
//  Created by Roman on 7/19/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

