//
//  CustomCell.h
//  task7
//
//  Created by Roman on 7/19/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


NS_ASSUME_NONNULL_BEGIN

@interface CustomCell : UITableViewCell
@property (nonatomic, strong) UIImageView* imageViewMain;
@property (nonatomic, strong) UILabel* labelTitle;
@property (nonatomic, strong) UILabel* labelDescription;
-(void)setData:(NSManagedObject *)object;
@end

NS_ASSUME_NONNULL_END
