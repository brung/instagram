//
//  PhotoDetailViewController.m
//  instagram
//
//  Created by Bruce Ng on 1/22/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PhotoCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 320;
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoCellTableViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCellTableViewCell"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:[self.post valueForKeyPath:@"images.standard_resolution.url"]]];
    return cell;
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
