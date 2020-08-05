//
//  CustomCell.m
//  task7
//
//  Created by Roman on 7/19/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "CustomCell.h"
#import "ImageCache.h"
#import "Cancelable.h"

@interface CustomCell ()
@property (strong, nonatomic)Cancelable *cancelable;
@property (strong, nonatomic)NSString *string;
@property (strong, nonatomic)UILabel *labelDuration;
@end

@implementation CustomCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageViewMain = [self createMainImageView];
        _labelTitle = [self createTitleLabel];
        _labelDuration = [self createDurationLabel];
        _labelDescription = [self createDescriptionLabel];
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    _imageViewMain.image = nil;
    [_cancelable cancel];
}

//MARK: - Creating UI Elements
-(UIImageView *)createMainImageView {
    UIImageView *imageView = [UIImageView new];
    [self.contentView addSubview:imageView];
    [self addConstraintsToMainImageView:imageView];
    return imageView;
}

-(UILabel *)createTitleLabel {
    UILabel *label = [UILabel new];
    label = [UILabel new];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
    [self.contentView addSubview:label];
    [self addConstraintsToTitleLable:label];
    return label;
}

-(UILabel *)createDurationLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = UIColor.blackColor;
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightBold]];
    [self.contentView addSubview:label];
    [self addConstraintsToDurationLabel:label];
    return label;
}

-(UILabel *)createDescriptionLabel {
    UILabel *label = [UILabel new];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightSemibold]];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    [self addConstraintsToDescriptionLabel:label];
    return label;
}

//MARK: - Anchors
-(void)addConstraintsToMainImageView:(UIImageView *)imageView {
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [imageView.widthAnchor constraintEqualToConstant:180].active = true;
    [imageView.heightAnchor constraintEqualToConstant:100].active = true;
    [imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:15].active = true;
    [imageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:10].active = true;
}

-(void)addConstraintsToTitleLable:(UILabel *)label {
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-10].active = true;
    [label.heightAnchor constraintEqualToConstant:15].active = true;
    [label.topAnchor constraintEqualToAnchor:_imageViewMain.topAnchor constant:5].active = true;
    [label.leftAnchor constraintEqualToAnchor:_imageViewMain.rightAnchor constant:15].active = true;
}

-(void)addConstraintsToDurationLabel:(UILabel *)label {
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label.rightAnchor constraintEqualToAnchor:_imageViewMain.rightAnchor constant:-5].active = true;
    [label.heightAnchor constraintEqualToConstant:15].active = true;
    [label.widthAnchor constraintEqualToConstant:40].active = true;
    [label.bottomAnchor constraintEqualToAnchor:_imageViewMain.bottomAnchor constant:-5].active = true;
}

-(void)addConstraintsToDescriptionLabel:(UILabel *)label  {
    label.translatesAutoresizingMaskIntoConstraints = false;
   [label.rightAnchor constraintEqualToAnchor:_labelTitle.rightAnchor].active = true;
    [label.topAnchor constraintEqualToAnchor:_labelTitle.bottomAnchor constant:5].active = true;
    [label.leftAnchor constraintEqualToAnchor:_labelTitle.leftAnchor].active = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//MARK: - Data Managment
- (void)setData:(NSManagedObject *)object {
    self.backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    if ([object valueForKey:@"speakerTwo"] != nil) {
        _string = [[NSString alloc] initWithFormat:@"%@ and %@", [object valueForKey:@"speaker"], [object valueForKey:@"speakerTwo"]];
    } else {
        _string = [object valueForKey:@"speaker"];
    }
    [_labelTitle setText:_string];
    [_labelDuration setTextAlignment:NSTextAlignmentCenter];
    [_labelDuration setText:[object valueForKey:@"duration"]];
    [_labelDescription setText:[object valueForKey:@"title"]];
    _imageViewMain.image = [UIImage imageNamed:@"default-image"];
    __auto_type url = [[NSURL alloc] initWithString:[object valueForKey:@"imageUrl"]];
    _cancelable = [ImageCache.shared fetchImageFrom:url withCompletion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.imageViewMain.image = image;
    }];
}

@end
