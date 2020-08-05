//
//  DetailViewController.m
//  task7
//
//  Created by Roman on 7/21/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "DetailViewController.h"
#import <AVKit/AVKit.h>


@interface DetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSpeakers;
@property (nonatomic, strong) UILabel *labelInfo;
@property (nonatomic, strong) UILabel *labelDescription;
@property (nonatomic, strong) UIButton *buttonLike;
@property (nonatomic, strong) UIButton *buttonShare;
@property (nonatomic, strong) UIButton *buttonPlay;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *speakersText;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *videoUrl;
@property (strong, nonatomic) UIScrollView* scroll;
@property (nonatomic,strong)NSLayoutConstraint* image_height_constraint;
@property (nonatomic,strong)NSManagedObjectContext *context;
@property (nonatomic,strong)NSFetchRequest* fetchRequest;
@property (nonatomic, assign)NSInteger *index;
@property (nonatomic, assign)NSInteger *count;
@end

@implementation DetailViewController

-(id) initWith:(UIImage *)image titleText:(NSString *)titleText speakersText:(NSString *)speakersText
descriptionText:(NSString *)descriptionText videoUrl:(NSString *)videoUrl fetchRequest:(NSFetchRequest *)fetchRequest index:(NSInteger *)index context:(NSManagedObjectContext *) context count:(NSInteger *)count {
    self = [super init];
    if(self) {
        _image = image;
        _titleText = titleText;
        _speakersText = speakersText;
        _descriptionText = descriptionText;
        _videoUrl = videoUrl;
        _fetchRequest = fetchRequest;
        _index = index;
        _context = context;
        _count = count;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    _scroll = [self createScrollView];
    _contentView = [self createContentView];
    _imageView = [self createImageView];
    _buttonPlay = [self createPlayButton];
    _labelTitle = [self createTitleLabel];
    _labelSpeakers = [self createSpeakersLabel];
    _buttonLike = [self createLikeButton];
    _buttonShare = [self createShareButton];
    _labelInfo = [self createInfoLabel];
    _separatorView = [self createSeparatorView];
    _labelDescription = [self createDescriptionLabel];
}

//MARK: - Creating UI Elements
-(UIScrollView *)createScrollView {
    UIScrollView *scroll = [UIScrollView new];
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    __auto_type contentInset = scroll.contentInset;
    scroll.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom + 10, contentInset.right);
    [self.view addSubview:scroll];
    [self addConstraintsToScrollView:scroll];
    return scroll;
}

-(UIView *)createContentView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    [_scroll addSubview:view];
    [self addConstraintsToContentView:view];
    return view;
}

-(UIImageView *)createImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = TRUE;
    [_contentView addSubview:imageView];
    [self addConstraintsToImageView:imageView];
    return imageView;
}

-(UIButton *)createPlayButton {
    UIButton *button = [UIButton new];
    UIImage *playButtonImage = [UIImage imageNamed:@"play"];
    [button setImage:playButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    [self addConstraintsToPlayButton:button];
    return button;
}

-(UILabel *)createTitleLabel {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.text = _titleText;
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
    [_contentView addSubview:label];
    [self addConstraintsToTitleLabel:label];
    return label;
}

-(UILabel *)createSpeakersLabel {
    UILabel *label = [UILabel new];
    label.text = _speakersText;
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
    [_contentView addSubview:label];
    [self addConstraintsToSpeakersLabel:label];
    return label;
}

-(UIButton *)createLikeButton {
    UIButton *button = [UIButton new];
    UIImage *favorite = [UIImage imageNamed:@"favorite"];
    UIImage *favoriteAdded = [UIImage imageNamed:@"favorite_added"];
    if ([self fetchManagedObject] != nil) {
        NSManagedObject *favoritsGrabbed = [self fetchManagedObject];
        if ([[favoritsGrabbed valueForKey:@"favorite"] isEqualToString:@"YES"]) {
            [button setImage:favoriteAdded forState:UIControlStateNormal];
        } else {
            [button setImage:favorite forState:UIControlStateNormal];
        }
    }
    button.tintColor = UIColor.lightGrayColor;
    [button addTarget:self action:@selector(workWithFavorites) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    [self addConstraintsToLikeButton:button];
    return button;
}

-(UIButton *)createShareButton {
    UIButton *button = [UIButton new];
    UIImage *share = [UIImage imageNamed:@"share"];
    [button setImage:share forState:UIControlStateNormal];
    button.tintColor = UIColor.lightGrayColor;
    [button addTarget:self action:@selector(showActivityController) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    [self addConstraintsToShareButton:button];
    return button;
}

-(UILabel *)createInfoLabel {
    UILabel *label = [UILabel new];
    label.text = @"ИНФОРМАЦИЯ";
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
    [label sizeToFit];
    [_contentView addSubview:label];
    [self addConstraintsToInfoLabel:label];
    return label;
}

-(UIView *)createSeparatorView {
    UIView* separatorView = [UIView new];
    separatorView.backgroundColor = UIColor.redColor;
    [_contentView addSubview:separatorView];
    [self addConstraintsToSeparatorView:separatorView];
    return separatorView;
}

-(UILabel *)createDescriptionLabel {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.text = _descriptionText;
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
    [_contentView addSubview:label];
    [self addConstraintsToDescriptionLabel:label];
    return label;
}

//MARK: - Anchors
-(void)addConstraintsToScrollView:(UIScrollView *)scroll {
    scroll.translatesAutoresizingMaskIntoConstraints = false;
    [scroll.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = TRUE;
    [scroll.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = TRUE;
    [scroll.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = TRUE;
    [scroll.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = TRUE;
}

-(void)addConstraintsToContentView:(UIView *)contentView {
    contentView.translatesAutoresizingMaskIntoConstraints = false;
    [contentView.topAnchor constraintEqualToAnchor:_scroll.topAnchor].active = TRUE;
    [contentView.bottomAnchor constraintEqualToAnchor:_scroll.bottomAnchor].active = TRUE;
    [contentView.leadingAnchor constraintEqualToAnchor:_scroll.leadingAnchor].active = TRUE;
    [contentView.trailingAnchor constraintEqualToAnchor:_scroll.trailingAnchor].active = TRUE;
    [contentView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = TRUE;
}

-(void)addConstraintsToImageView:(UIImageView *)imageView {
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [imageView.topAnchor constraintEqualToAnchor:_contentView.topAnchor].active = true;
    [imageView.leftAnchor constraintEqualToAnchor:_contentView.leftAnchor].active = true;
    [imageView.rightAnchor constraintEqualToAnchor:_contentView.rightAnchor].active = true;
    CGFloat our_ratio = _image.size.height / _image.size.width;
    _image_height_constraint = [imageView.heightAnchor constraintEqualToAnchor:imageView.widthAnchor multiplier:our_ratio];
    _image_height_constraint.active = TRUE;
}

-(void)addConstraintsToPlayButton:(UIButton *)button {
    button.translatesAutoresizingMaskIntoConstraints = false;
    [button.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor].active = YES;
    [button.centerYAnchor constraintEqualToAnchor:self.imageView.centerYAnchor].active = YES;
    [button.widthAnchor constraintEqualToConstant:80].active = YES;
    [button.heightAnchor constraintEqualToConstant:80].active = YES;
}

-(void)addConstraintsToTitleLabel:(UILabel *)label {
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:15].active = YES;
    [label.leftAnchor constraintEqualToAnchor:self.imageView.leftAnchor constant:15].active = YES;
    [label.rightAnchor constraintEqualToAnchor:self.imageView.rightAnchor constant:-15].active = YES;
}

-(void)addConstraintsToSpeakersLabel:(UILabel *)label {
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label.topAnchor constraintEqualToAnchor:self.labelTitle.bottomAnchor constant:5].active = YES;
    [label.leftAnchor constraintEqualToAnchor:self.labelTitle.leftAnchor].active = YES;
    [label.rightAnchor constraintEqualToAnchor:self.labelTitle.rightAnchor].active = YES;
    [label.heightAnchor constraintEqualToConstant:30].active = YES;
}

-(void)addConstraintsToLikeButton:(UIButton *)button {
    button.translatesAutoresizingMaskIntoConstraints = false;
    [button.topAnchor constraintEqualToAnchor:self.labelSpeakers.bottomAnchor constant:15].active = YES;
    [button.leftAnchor constraintEqualToAnchor:self.labelTitle.leftAnchor].active = YES;
    [button.widthAnchor constraintEqualToConstant:25].active = YES;
    [button.heightAnchor constraintEqualToConstant:25].active = YES;
}

-(void)addConstraintsToShareButton:(UIButton *)button {
    button.translatesAutoresizingMaskIntoConstraints = false;
    [button.centerYAnchor constraintEqualToAnchor:self.buttonLike.centerYAnchor].active = YES;
    [button.leftAnchor constraintEqualToAnchor:self.buttonLike.rightAnchor constant:15].active = YES;
    [button.widthAnchor constraintEqualToConstant:25].active = YES;
    [button.heightAnchor constraintEqualToConstant:25].active = YES;
}

-(void)addConstraintsToInfoLabel:(UILabel *)label {
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label.topAnchor constraintEqualToAnchor:self.buttonLike.bottomAnchor constant:15].active = YES;
    [label.leftAnchor constraintEqualToAnchor:self.buttonLike.leftAnchor].active = YES;
}

-(void)addConstraintsToSeparatorView:(UIView *)separatorView {
    separatorView.translatesAutoresizingMaskIntoConstraints = false;
    [separatorView.topAnchor constraintEqualToAnchor:self.labelInfo.bottomAnchor constant:5].active = YES;
    [separatorView.leftAnchor constraintEqualToAnchor:self.labelInfo.leftAnchor constant:1].active = YES;
    [separatorView.rightAnchor constraintEqualToAnchor:self.labelInfo.rightAnchor constant:-1].active = YES;
    [separatorView.heightAnchor constraintEqualToConstant:1].active = YES;
}

-(void)addConstraintsToDescriptionLabel:(UILabel *)descriptionLabel {
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [descriptionLabel.topAnchor constraintEqualToAnchor:self.separatorView.bottomAnchor constant:10].active = YES;
    [descriptionLabel.leftAnchor constraintEqualToAnchor:self.labelTitle.leftAnchor].active = YES;
    [descriptionLabel.rightAnchor constraintEqualToAnchor:self.labelTitle.rightAnchor].active = YES;
    [descriptionLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
}


-(void)playVideo {
    NSURL *videoURL = [NSURL URLWithString:_videoUrl];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:^{
        [playerViewController.player play];
    }];
}

//MARK: - Core Data
-(NSManagedObject *)fetchManagedObject{
    NSError *error = nil;
    NSArray *arrayOfCoreData = [_context executeFetchRequest:_fetchRequest error:&error];
    if (arrayOfCoreData.count != _count) {
        return nil;
    }
    NSManagedObject *favoritsGrabbed = [arrayOfCoreData objectAtIndex:_index];
    return favoritsGrabbed;
}

-(void)workWithFavorites {
    NSError *error = nil;
    if ([self fetchManagedObject] != nil) {
        NSManagedObject *favoritsGrabbed = [self fetchManagedObject];
        if ([[favoritsGrabbed valueForKey:@"favorite"] isEqualToString:@"NO"]) {
            [favoritsGrabbed setValue:@"YES" forKey:@"favorite"];
            UIImage *favoriteAdded = [UIImage imageNamed:@"favorite_added"];
            [_buttonLike setImage:favoriteAdded forState:UIControlStateNormal];
            NSLog(@"Added to favorites");
        } else {
            [favoritsGrabbed setValue:@"NO" forKey:@"favorite"];
            UIImage *favorite = [UIImage imageNamed:@"favorite"];
            [_buttonLike setImage:favorite forState:UIControlStateNormal];
            NSLog(@"Deleted from favorites");
        }
        if (![_context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        } else {
            NSLog(@"Saved data!");
        }
    } else {
        NSLog(@"Cant add from favorite controller!!!");
    }
}

//MARK: - Other Methods
-(void)showActivityController {
    NSURL *url = [[NSURL alloc] initWithString:_videoUrl];
    NSMutableArray *activityItems = [NSMutableArray arrayWithObjects:url, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end
