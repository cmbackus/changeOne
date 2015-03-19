//
//  GameOverViewController.m
//  ChangeOne
//
//  Created by Student on 12/14/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "GameOverViewController.h"
#import "ViewController.h"


@interface GameOverViewController ()

@end

@implementation GameOverViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scoreLabel.text= [NSString stringWithFormat:@"Your Score : %d", *_scoreValue ];
    [self handleHighscore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleHighscore{
    int highscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscorekey"] integerValue];
    
    if (*_scoreValue > highscore) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:*_scoreValue] forKey:@"highscorekey"];
    }
    
    int highscoreshowm = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscorekey"] integerValue];
    _highScoreLabel.text= [NSString stringWithFormat: @"High Score: %d", highscoreshowm];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ViewController *newVC= segue.destinationViewController;
    if([[sender currentTitle] isEqualToString:@"Try Again"]){
        newVC.curWord = _startWord;
    }
}


-(IBAction)PostToTwitter:(id)sender{
    mySLComposerSheet =[[SLComposeViewController alloc]init];
    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"I scored %d when I started with \u201c%@\u201d #ChangeOne ",*_scoreValue, _startWord]];
    [self presentViewController:mySLComposerSheet animated:YES completion:NULL];

}

@end
