//
//  ViewController.h
//  LiveStreamDemo
//
//  Created by Ratish Mahajan on 19/11/15.
//  Copyright © 2015 Ratish Mahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;
- (IBAction)playVideo:(id)sender;

@end

