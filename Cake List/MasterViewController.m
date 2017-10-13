//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CakeCell *cell = (CakeCell*)[tableView dequeueReusableCellWithIdentifier:@"CakeCell"];
            
    NSDictionary *object = self.objects[indexPath.row];
    cell.titleLabel.text = object[@"title"];
    cell.descriptionLabel.text = object[@"desc"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void) {
        NSURL *aURL = [NSURL URLWithString:object[@"image"]];
        NSData *data = [NSData dataWithContentsOfURL:aURL];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.cakeImageView setImage:image];
        });
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getData{

    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        
        id responseData = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:kNilOptions
                           error:&error];
        
        self.objects = responseData;
        [self.tableView reloadData];

    }];
}

@end
