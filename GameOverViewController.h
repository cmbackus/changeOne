//
//  GameOverViewController.h
//  ChangeOne
//
//  Created by Student on 12/14/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface GameOverViewController : UIViewController{
    
    SLComposeViewController *mySLComposerSheet;
    
}

@property IBOutlet UILabel *scoreLabel;
@property IBOutlet UILabel *highScoreLabel;
@property NSString *startWord;
@property int *scoreValue;
@property int *highScoreValue;

-(IBAction)PostToTwitter:(id)sender;
@end
