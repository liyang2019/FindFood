//
//  YelpViewController.m
//  FindFood
//
//  Created by Li Yang on 10/11/17.
//  Copyright © 2017 Rice University. All rights reserved.
//



#import "YelpViewController.h"
#import "YelpDataModel.h"
#import "YelpNetworking.h"
#import "FindFoodTableViewCell.h"
#import "YelpDataStore.h"
#import "YelpDetailViewController.h"

@import MapKit;

@interface YelpViewController() <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSArray<YelpDataModel *> *dataModels;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation YelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadYelpData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FindFoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindFoodTableViewCell"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

}

- (void)setupUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // Setup search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor lightGrayColor];
    self.navigationItem.titleView = self.searchBar;
    
    //add constraint
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

}

- (void)loadYelpData
{
    __weak typeof(self) weakSelf = self;
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    CLLocation *loc = [YelpDataStore sharedInstance].userLocation;
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:@"restaurant" completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        weakSelf.dataModels = dataModelArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    ///
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindFoodTableViewCell" forIndexPath:indexPath];
    
    [cell updateBasedOnDataModel:self.dataModels[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpDetailViewController *detailVC = [[YelpDetailViewController alloc] initWithDataModel:self.dataModels[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
//    CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    CLLocation *loc = [YelpDataStore sharedInstance].userLocation;
    // the following code the key that we can finally make our table be able to search based on user’s input
    __weak typeof(self) weakSelf = self;
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:searchBar.text completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        weakSelf.dataModels = dataModelArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    }];
}

// Reset search bar state after cancel button clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


#pragma mark - Location manager methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    [[YelpDataStore sharedInstance] setUserLocation:currentLocation];
    
    [manager stopUpdatingLocation];
    NSLog(@"current location %lf %lf", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:currentLocation term:@"restaurant" completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    
}

@end

