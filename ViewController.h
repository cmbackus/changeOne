//
//  ViewController.h
//  ChangeOne
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
int CountNumber;
@interface ViewController : UIViewController
{
    IBOutlet UIProgressView *timerDisplay;
    IBOutlet UILabel *timerText;
    NSTimer *timer;
    IBOutlet UILabel *scoreText;
}
@property(nonatomic) int curScore;
@property(nonatomic,copy) NSString* curWord;
@property(nonatomic,copy) NSString* startWord;
-(void)TimerCount;

@end

