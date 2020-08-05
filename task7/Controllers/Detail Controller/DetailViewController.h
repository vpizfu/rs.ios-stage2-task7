//
//  DetailViewController.h
//  task7
//
//  Created by Roman on 7/21/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
-(id) initWith:(UIImage *)image titleText:(NSString *)titleText speakersText:(NSString *)speakersText
descriptionText:(NSString *)descriptionText videoUrl:(NSString *)videoUrl fetchRequest:(NSFetchRequest *)fetchRequest index:(NSInteger *)index context:(NSManagedObjectContext *) context count:(NSInteger *)count;
-(void)playVideo;
-(void)showActivityController;
-(void)workWithFavorites;
@end

NS_ASSUME_NONNULL_END
