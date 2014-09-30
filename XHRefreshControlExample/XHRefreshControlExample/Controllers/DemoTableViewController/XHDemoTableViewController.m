//
//  XHDemoTableViewController.m
//  XHRefreshControlExample
//
//  Created by 曾 宪华 on 14-6-8.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHDemoTableViewController.h"

#import "NSDate+TimeAgo.h"

@interface XHDemoTableViewController ()

@end

@implementation XHDemoTableViewController

- (void)loadDataSource {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      nil];
        
        NSMutableArray *indexPaths;
        if (self.requestCurrentPage) {
            indexPaths = [[NSMutableArray alloc] initWithCapacity:dataSource.count];
            [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:self.dataSource.count + idx inSection:0]];
            }];
        }
        sleep(1.5);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestCurrentPage) {
                if (self.requestCurrentPage == arc4random() % 10) {
                    [self endMoreOverWithMessage:@"段子已加载完"];
                } else {
                    
                    [self.dataSource addObjectsFromArray:dataSource];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self endLoadMoreRefreshing];
                }
            } else {
                if (rand() % 3 > 1) {
                    self.loadMoreRefreshed = NO;
                }

                self.dataSource = dataSource;
                [self.tableView reloadData];
                [self endPullDownRefreshing];
            }
        });
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 别把这行代码放到别处，然后导致了错误，那就不好了嘛！
    [self startPullDownRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHRefreshControl Delegate

- (NSString *)lastUpdateTimeString {
    
    NSDate *nowDate = [NSDate date];
    
    NSString *destDateString = [nowDate timeAgo];
    
    return destDateString;
}

- (UIView *)customPullDownRefreshView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.tag = 100;
    progressView.frame = CGRectMake(0, CGRectGetHeight(backgroundView.bounds) / 2.0 - 3, 320, 3);
    if ([progressView respondsToSelector:@selector(setTintColor:)]) {
        progressView.tintColor = [UIColor orangeColor];
    }
    [backgroundView addSubview:progressView];
    return backgroundView;
}

- (void)customPullDownRefreshView:(UIView *)customPullDownRefreshView withPullDownOffset:(CGFloat)pullDownOffset {
    UIProgressView *progessView = (UIProgressView *)[customPullDownRefreshView viewWithTag:100];
    [progessView setProgress:pullDownOffset / 40.0 animated:NO];
}

- (void)customPullDownRefreshViewWillStartRefresh:(UIView *)customPullDownRefreshView {
    UIProgressView *progressView = (UIProgressView *)[customPullDownRefreshView viewWithTag:100];
    [progressView setProgress:1.0];
    if ([progressView respondsToSelector:@selector(setTintColor:)]) {
        [progressView setTintColor:[UIColor greenColor]];
    }
}

- (void)customPullDownRefreshViewWillEndRefresh:(UIView *)customPullDownRefreshView {
    UIProgressView *progressView = (UIProgressView *)[customPullDownRefreshView viewWithTag:100];
    if ([progressView respondsToSelector:@selector(setTintColor:)]) {
        [progressView setTintColor:[UIColor greenColor]];
    }
    [progressView setProgress:0.0 animated:NO];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
    }
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = (indexPath.row % 2) ? @"曾宪华" : @"xhzengAIB@gmail.com";
        cell.detailTextLabel.text = self.dataSource[indexPath.row];
    }
    
    
    if (indexPath.row == 4) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.097 green:0.633 blue:1.000 alpha:1.000];
    } else {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
