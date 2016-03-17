//
//  ViewController.m
//  LoadingAnimation
//
//  Created by 宫城 on 16/3/17.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "ViewController.h"
#import "GCDownloadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    GCDownloadingView *view = [GCDownloadingView showDownloadingViewAddedTo:self.view];
//    view.downloadingViewWidth = 50;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [GCDownloadingView showDownloadingViewAddedTo:self.view];
    [GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusStart;
    CGFloat delay = 2.0f;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusDone;
        dispatch_time_t time2 = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(time2, dispatch_get_main_queue(), ^{
            [GCDownloadingView hideDownloadingViewForView:self.view];
        });
    });
}

- (IBAction)fail:(id)sender {
    [GCDownloadingView showDownloadingViewAddedTo:self.view];
    [GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusStart;
    CGFloat delay = 2.0f;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusFail;
        dispatch_time_t time2 = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(time2, dispatch_get_main_queue(), ^{
            [GCDownloadingView hideDownloadingViewForView:self.view];
        });
    });
}

@end
