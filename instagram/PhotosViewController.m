//
//  PhotosViewController.m
//  instagram
//
//  Created by Bruce Ng on 1/22/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCellTableViewCell.h"
#import "PhotoDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *media;
@property (weak, nonatomic) IBOutlet UITableView *photoTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL updatingMedia;

- (void)updateMedia;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateMedia];
    
    [self.photoTableView registerNib:[UINib nibWithNibName:@"PhotoCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoCellTableViewCell"];
    
    self.media = [[NSMutableArray alloc] init];
    self.updatingMedia = NO;
    self.photoTableView.rowHeight = 320;
    self.photoTableView.delegate = self;
    self.photoTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.photoTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.media.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCellTableViewCell"];
    if(indexPath.row == self.media.count - 1) {
        
        if (!self.updatingMedia) {
            self.updatingMedia = YES;
            UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [loadingView startAnimating];
            loadingView.center = tableFooterView.center;
            [tableFooterView addSubview:loadingView];
            self.photoTableView.tableFooterView = tableFooterView;
            
            [self updateMedia];
        }
        
    }
    
    NSDictionary *post = self.media[indexPath.row];
    [cell.photoView setImageWithURL:[NSURL URLWithString:[post valueForKeyPath:@"images.low_resolution.url"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotoDetailViewController *vc = [[PhotoDetailViewController alloc] init];
    vc.post = self.media[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onRefresh {
    [self updateMedia];
}

- (void)updateMedia {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=2e4517ce490b430680716f1f7c443ad1"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"response: %@", responseDictionary);
        
        if(self.updatingMedia) {
            // append media
            [self.media addObjectsFromArray:responseDictionary[@"data"]];
            self.updatingMedia = NO;
            if (self.photoTableView.tableFooterView != nil) {
                [self.photoTableView.tableFooterView removeFromSuperview];
            }
            
        } else {
            self.media = [[NSMutableArray alloc] initWithArray:responseDictionary[@"data"]];
        }
        
        [self.photoTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
