//
//  MainViewController.m
//  task7
//
//  Created by Roman on 7/19/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "MainViewController.h"
#import "CustomCell.h"
#import "XmlParser.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchResultController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) XmlParser *xml;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSString *labelString;
@property (nonatomic, strong) NSManagedObject *record;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, assign) BOOL newElements;
@end

@implementation MainViewController

-(id) initWith:(NSPredicate *)predicate labelString:(NSString *)labelString {
    self = [super init];
    if(self) {
        _predicate = predicate;
        _labelString = labelString;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initManagedContext];
    [self loadData];
    [self fetchNewElements];
    _backButton = [self createBackButton];
    _searchBar = [self createSearchBar];
    _label = [self createTitleLabel];
    _titleView = [self createTitleView];
    _tableView = [self createTableView];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (_predicate != nil) {
//        [_tableView beginUpdates];
//        self.fetchRequest.predicate = _predicate;
//        NSError *error = nil;
//        if (![[self fetchResultController] performFetch:&error]) {
//            // Handle error
//            exit(-1);
//        }
//        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//        [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//        [_tableView endUpdates];
//    }
//}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//MARK: - XML
-(void)parseXml {
    _xml = [XmlParser new];
    [_xml parseObjects];
}

//MARK: - Core Data
-(void) initManagedContext {
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _context = _appDelegate.persistentContainer.viewContext;
}

-(void)writeNewObjectToCoreData:(XmlObject *)object {   
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Objects" inManagedObjectContext:_context];
    NSManagedObject *newObject = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:_context];
    [newObject setValue:object.descr forKey:@"descr"];
    [newObject setValue:object.duration forKey:@"duration"];
    [newObject setValue:object.imagerUrl forKey:@"imageUrl"];
    [newObject setValue:object.link forKey:@"link"];
    [newObject setValue:object.speaker forKey:@"speaker"];
    [newObject setValue:object.title forKey:@"title"];
    [newObject setValue:object.videoUrl forKey:@"videoUrl"];
    [newObject setValue:@"NO" forKey:@"favorite"];
    if (object.speakerTwo != nil) {
        [newObject setValue:object.speakerTwo forKey:@"speakerTwo"];
    }
    NSLog(@"Saved");
    NSError *error;
    [_context save:&error];
}

//MARK: - Fetched Result Controller
-(void)loadData {
    _fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Objects"];
    //_fetchRequest.fetchBatchSize = 20;
    if (_predicate != nil) {
        self.fetchRequest.predicate = _predicate;
    }
    [_fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"link" ascending:YES]]];
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:_fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:nil];
    [_fetchResultController setDelegate:self];
    NSError *error = nil;
    [_fetchResultController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

//MARK: - FRC Delegate Methods
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    NSArray *array;
    switch (type) {
        case NSFetchedResultsChangeInsert:
             array = [[NSArray alloc] initWithObjects:newIndexPath, nil];
            [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            array = [[NSArray alloc] initWithObjects:indexPath, nil];
            [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [_tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            array = [[NSArray alloc] initWithObjects:indexPath, nil];
            [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sectionIndex];
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            //[_tableView reloadData];
            break;
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            //[_tableView reloadData];
            break;
        default:
            break;
    }
}

//MARK: - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *sections = [self.fetchResultController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    CustomCell* cell = (CustomCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    _record = [self.fetchResultController objectAtIndexPath:indexPath];
    [cell setData:_record];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[self prepareToSegue:tableView indexPath:indexPath] animated:YES];
}

//MARK: - SearchBar Delegate Methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContentForSearchText:searchBar.text];
    [searchBar resignFirstResponder];
}

-(void)filterContentForSearchText:(NSString*)searchText {
    [self updatePredicateAndReloadTable:searchText];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    [searchBar setText:@""];
    [self updatePredicateAndReloadTable:@""];
}

//MARK: - Creating UI Elements
-(UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    return backButton;
}

-(UISearchBar *)createSearchBar {
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search";
    self.navigationItem.titleView = searchBar;
    self.definesPresentationContext = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    return searchBar;
}

-(UILabel *)createTitleLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15,200,30)];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:19 weight:UIFontWeightSemibold]];
    label.text = _labelString;
    return label;
}

-(UIView *)createTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,15,320,75)];
    titleView.backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    [titleView addSubview:_label];;
    return titleView;
}

-(UITableView *)createTableView {
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = _titleView;
    [tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"HistoryCell"];
    [self.view addSubview:tableView];
    [self addConstraintsToTableView:tableView];
    return tableView;
}

//MARK: - Anchors
-(void)addConstraintsToTableView:(UITableView *)tableView {
    tableView.translatesAutoresizingMaskIntoConstraints = false;
    [tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [tableView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active = YES;
    [tableView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active = YES;
    [tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

//MARK: - Other Methods
-(void)fetchNewElements {
    if (_predicate == nil) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self parseXml];
            self.newElements = false;
            
            for (XmlObject* i in self.xml.objects) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", i.link];
                self.fetchRequest.predicate = predicate;
                if ([self.context countForFetchRequest:self.fetchRequest error:nil] == 0) {
                    [self writeNewObjectToCoreData:i];
                    self.newElements = true;
                } else {
                    // NSLog(@"Already exist!");
                }
            }
            [self loadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.newElements == true) {
                    //[self.tableView reloadData];
                    [self.tableView beginUpdates];
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    self.newElements = false;
                }
            });
        });
    }
}

-(void)updatePredicateAndReloadTable:(NSString *)query {
    [_tableView beginUpdates];
    if (query && query.length) {
        if (_predicate == nil) {
            [self.fetchResultController.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title contains[cd] %@ or speaker contains[cd] %@ or speakerTwo contains[cd] %@", query, query, query]];
        } else {
            [self.fetchResultController.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(title contains[cd] %@ or speaker contains[cd] %@ or speakerTwo contains[cd] %@) and (favorite = %@)", query, query, query, @"YES"]];
        }
    } else {
        if (_predicate == nil) {
            self.fetchRequest.predicate = nil;
        } else {
            self.fetchRequest.predicate = _predicate;
        }
    }
    NSError *error = nil;
    if (![[self fetchResultController] performFetch:&error]) {
        // Handle error
        exit(-1);
    }
    [_tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView endUpdates];
}

-(DetailViewController *)prepareToSegue:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath  {
    CustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _record = [self.fetchResultController objectAtIndexPath:indexPath];
    __auto_type image = cell.imageViewMain.image;
    __auto_type titleText = cell.labelDescription.text;
    __auto_type speakersText = cell.labelTitle.text;
    NSString *descriptionText = [_record valueForKey:@"descr"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return [[DetailViewController alloc] initWith:image titleText:titleText speakersText:speakersText descriptionText:descriptionText videoUrl:[_record valueForKey:@"videoUrl"] fetchRequest:_fetchRequest index:indexPath.row context:_context count:self.fetchResultController.fetchedObjects.count];
}

@end

