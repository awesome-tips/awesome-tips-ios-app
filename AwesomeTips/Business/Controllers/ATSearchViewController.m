//
//  ATSearchViewController.m
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import "ATSearchViewController.h"
#import "ATFeedItemModel.h"
#import "ATFeedTableViewCell.h"
#import "ATNetworkManager.h"
#import <SafariServices/SafariServices.h>

@interface ATSearchViewController ()

@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, assign, getter=isLoadingSearchData) BOOL loadingSearchData;
@property (nonatomic, strong) NSMutableArray<ATFeedItemModel *> *searchDataList;

@end

@implementation ATSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xm_setupViews];
}

#pragma mark - Layout

- (void)xm_setupViews {
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setEstimatedRowHeight:[ATFeedTableViewCell cellHeight]];
    [self.tableView registerClass:[ATFeedTableViewCell class] forCellReuseIdentifier:[ATFeedTableViewCell reuseIdentifier]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATFeedTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFSafariViewController *sfViewController = [self xm_getDetailViewControllerAtIndexPath:indexPath];
    if (sfViewController) {
        [self presentViewController:sfViewController animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.searchDataList.count) {
        ATFeedItemModel *model = self.searchDataList[indexPath.row];
        ATFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ATFeedTableViewCell reuseIdentifier] forIndexPath:indexPath];
        [cell layoutUIWithModel:model];
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *newKeyword = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.searchKeyword isEqualToString:newKeyword]) {
        return;
    }
    self.searchKeyword = newKeyword;
    if (self.searchKeyword.length > 0) {
        [self xm_searchFeedListFromNet];
    }
}

#pragma mark - Private Methods

- (SFSafariViewController *)xm_getDetailViewControllerAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.searchDataList.count) {
        ATFeedItemModel *model = self.searchDataList[indexPath.row];
        if (model.url.length > 0) {
            NSURL *url = [NSURL URLWithString:model.url];
            SFSafariViewController *sfViewController = [[SFSafariViewController alloc] initWithURL:url];
            if (@available(iOS 11.0, *)) {
                sfViewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
                sfViewController.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
            }
            return sfViewController;
        }
    }
    return nil;
}

#pragma mark - Network

- (void)xm_searchFeedListFromNet {
    if (self.searchKeyword.length == 0) {
        return;
    }
    if (self.isLoadingSearchData) {
        return;
    }
    self.loadingSearchData = YES;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"feed/search";
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"key": self.searchKeyword};
    } onSuccess:^(id  _Nullable responseObject) {
        // 上层已经过滤过错误数据，这里 responseObject 一定是成功且有数据的
        [self.searchDataList removeAllObjects];
        NSArray *array = responseObject[@"feeds"];
        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
            [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ATFeedItemModel *model = [ATFeedItemModel modelWithDictionary:obj];
                if (model) {
                    [self.searchDataList addObject:model];
                }
            }];
        }
        [self.tableView reloadData];
    } onFailure:^(NSError * _Nullable error) {
        NSLog(@"[Net Error]: %@", error.localizedDescription);
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        self.loadingSearchData = NO;
    }];
}

#pragma mark - Getters

- (NSMutableArray<ATFeedItemModel *> *)searchDataList {
    if (!_searchDataList) {
        _searchDataList = [NSMutableArray array];
    }
    return _searchDataList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
