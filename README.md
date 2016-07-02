# DownloadingAnimation

## Introduction
This aniamtion is downloading animation include success and fail.

## Gif
![](https://github.com/Yuzeyang/DownloadingAnimation/raw/master/loadingAnimation2.gif)

## How to use

before you send a request, you should add `GCDownloadingView` in associated view, and set the `GCDownloadingView` start to loading

```objective-c
[GCDownloadingView showDownloadingViewAddedTo:self.view];
[GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusStart;
```

when the response return the result is success, you should set the `GCDownloadingView` is done

```objective-c
[GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusDone;
```

or when the result is failure

```objective-c
[GCDownloadingView downloadViewForView:self.view].downloadingStatus = GCDownloadingStatusFail;
```

and then hide the `GCDownloadingView`

```objective-c
[GCDownloadingView hideDownloadingViewForView:self.view];
```

