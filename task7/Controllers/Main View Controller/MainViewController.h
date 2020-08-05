//
//  MainViewController.h
//  task7
//
//  Created by Roman on 7/19/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>
-(id)initWith:(NSPredicate *)predicate labelString:(NSString *)labelString;
@end

NS_ASSUME_NONNULL_END
