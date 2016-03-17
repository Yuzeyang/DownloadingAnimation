//
//  GCDownloadingView.h
//  LoadingAnimation
//
//  Created by 宫城 on 16/3/17.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GCDownloadingStatus) {
    GCDownloadingStatusStart,
    GCDownloadingStatusStop,
    GCDownloadingStatusDone,
    GCDownloadingStatusFail
};

@interface GCDownloadingView : UIView

@property (nonatomic, assign) GCDownloadingStatus downloadingStatus;

/**
 *  The width of downloading view, default is 100
 */
@property (nonatomic, assign) CGFloat downloadingViewWidth;

/**
 *  Show downloading view in associated view
 *
 *  @param view The associated view
 *
 *  @return self
 */
+ (instancetype)showDownloadingViewAddedTo:(UIView *)view;

/**
 *  Hide downloading view from associated view
 *
 *  @param view The associated view
 *
 *  @return success or fail
 */
+ (BOOL)hideDownloadingViewForView:(UIView *)view;

/**
 *  Downloading view
 *
 *  @param view The associated view
 *
 *  @return self
 */
+ (instancetype)downloadViewForView:(UIView *)view;

@end
