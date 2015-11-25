//
//  ViewController.m
//  LiveStreamDemo
//
//  Created by Ratish Mahajan on 19/11/15.
//  Copyright © 2015 Ratish Mahajan. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *videoplayer = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:videoplayer];
    
    if ([videoplayer
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [videoplayer.view removeFromSuperview];
            [activityIndicator stopAnimating];
        // remove the video player from superview.
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

// iOS6 support
// ---
- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)playVideo:(id)sender {
    [self.urlTextField setText:@"http://techslides.com/demos/sample-videos/small.mp4"];
    NSString *placeholderText=self.urlTextField.text;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    NSURL *url = [NSURL URLWithString:placeholderText];
    _videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [_videoPlayer setControlStyle:MPMovieControlStyleNone];
    _videoPlayer.scalingMode = MPMovieScalingModeAspectFit;
    CGRect frame;
    if([[UIApplication sharedApplication] statusBarOrientation] ==UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] ==UIInterfaceOrientationPortraitUpsideDown)
        frame = CGRectMake(20, 69, 280, 170);
    else if([[UIApplication sharedApplication] statusBarOrientation] ==UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] ==UIInterfaceOrientationLandscapeRight)
        frame = CGRectMake(20, 61, 210, 170);
    [_videoPlayer.view setFrame:frame];  // player's frame must match parent's
    //[self.view addSubview: moviePlayer.view];
    [self.view bringSubviewToFront:_videoPlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:_videoPlayer];

    
    //_videoPlayer.controlStyle = MPMovieControlStyleDefault;
    
    // Set shouldAutoplay to YES
    _videoPlayer.shouldAutoplay = YES;
    
    // Add _videoPlayer's view as subview to current view.
    //[self.view addSubview:_videoPlayer.view];
    
    [self.view addSubview:activityIndicator];
    activityIndicator.center = self.view.center;
    
    //_videoPlayer.view.frame = self.view.bounds;
    [self.view insertSubview:_videoPlayer.view belowSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];

    [activityIndicator startAnimating];

    
    // Set the screen to full.
    [_videoPlayer setFullscreen:YES animated:YES];

}

#pragma mark MPMoviePlayerController notifications

- (void)moviePlayerLoadStateChanged:(NSNotification *)notif
{
    if (_videoPlayer.loadState & MPMovieLoadStateStalled) {
        [self.view bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
        [_videoPlayer pause];
    } else if (_videoPlayer.loadState & MPMovieLoadStatePlaythroughOK) {
        [activityIndicator stopAnimating];
        [_videoPlayer play];
        
    }
}

@end
