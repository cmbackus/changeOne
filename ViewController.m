//
//  ViewController.m
//  ChangeOne
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "ViewController.h"
#import "GameOverViewController.h"
#import "WordModel.h"


@import UIKit;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *typedWords;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;


@end

@implementation ViewController{
    NSInteger MAX_SLOTS;
    UILabel *selectedBox;
    NSMutableArray *textBoxes;
    NSMutableArray *usedWords;
    NSMutableArray *gridArray;
    NSMutableArray *keysArray;
    WordModel *wordHandler;
    bool timeRunning;
}

- (void)viewDidLoad {
    //create the world model
    wordHandler = [[WordModel alloc]init];
    [super viewDidLoad];
    //make the arrays to be used
    textBoxes=[NSMutableArray array];
    usedWords=[NSMutableArray array];
    //max slots allowed for input
    MAX_SLOTS=5;
    //the array that creates the keyboard
    keysArray=[NSMutableArray arrayWithObjects:@"q", @"w", @"e", @"r", @"t", @"y",@"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @" ",  nil];
    //is the timer running
    timeRunning=false;
    //make the keyboard and the grid for the answer tiles
    [self makeKeyboard];
    [self makeGrid];
    //start with one box selected
    selectedBox= textBoxes[0];
    [self selectBox];
    
    
    
   
    //GESTURES
    // Do any additional setup after loading the view, typically from a nib.
    //set up swipe gesture recognizers
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(swipeRight:)] ;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(swipeLeft:)] ;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:swipeLeft];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitClicked:(id)sender {
    //when you click submit gather the word
    [self gatherWord];
}

-(void)gatherWord{
    
    
    self.curWord=@" ";
    if(usedWords.count<1){
        _typedWords.text=@" ";
    }
    
    for(UILabel*i in textBoxes){
        if(![i.text isEqual:@" "]){
        self.curWord=[NSString stringWithFormat:@"%@%@", self.curWord, i.text];
        }
    }
    
    BOOL checkUp=[wordHandler checkWord:self.curWord];
    BOOL repeat=[wordHandler checkForRepeat:self.curWord useWords:usedWords];
    BOOL oneChanged;
    if ([usedWords count] <1){
        oneChanged = TRUE;
    }else{
        oneChanged = [wordHandler checkOnlyOneChange:self.curWord oldWord:[usedWords objectAtIndex:([usedWords count]-1)]];
    }
    if(checkUp && repeat==FALSE && oneChanged){
    NSString *curWord=[NSString stringWithFormat:@"%@ \n %@",   self.curWord, _typedWords.text];
    _typedWords.text=curWord;
    [_typedWords.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [usedWords addObject:self.curWord];
    [self Start];
    [self scoreHandle:YES];
    }
    
    //if any of the check variable are bad post and error message and shake the labels to indicate
    //an incorrect entry
    if(repeat){
        for(UILabel*i in textBoxes){[self shakeView:i];}
        [self scoreHandle:FALSE];
        _typedWords.text=[NSString stringWithFormat: @"%@ \n You already used that!", _typedWords.text];
    }else if(oneChanged == FALSE){
        for(UILabel*i in textBoxes){[self shakeView:i];}
        [self scoreHandle:FALSE];
        _typedWords.text=[NSString stringWithFormat: @"%@ \n Too many Letter Changes!", _typedWords.text];
    }else if(checkUp ==false){
        [self scoreHandle:FALSE];
        for(UILabel*i in textBoxes){[self shakeView:i];}
       _typedWords.text=[NSString stringWithFormat: @"%@ \n That's not a word!", _typedWords.text];
    }
}


//shake on error
- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

//make keyboard
-(void) makeKeyboard{
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger width=screenWidth/14;
    NSInteger padding=10;
    NSInteger height=screenHeight/14;
    NSInteger startx=0+padding;
    NSInteger starty=(screenHeight/2)+height+padding;
    NSInteger maxSlots=10;
    //NSInteger numSlots=(screenWidth-startx)/(width+padding);
    //NSInteger slots=0;
    NSInteger curY=starty;
    NSInteger curLetter=0;
    for(NSInteger i = 0; i < keysArray.count; i++) {
        
        for (NSInteger j=0; j<maxSlots; j++){
            if(curLetter+j<keysArray.count){
                NSInteger curX=startx+((width+padding)*j);
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self
                           action:@selector(typeLetter:)
                 forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:keysArray[j+curLetter] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundColor :[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1]];/*#e6e6e6*/
                button.frame = CGRectMake(curX, curY, width, height);
                [self.view addSubview:button];
            }
        }
        
        curY+=(height+padding);
        curLetter+=maxSlots;
        startx+=width/2;
        maxSlots-=1;
        
    }
    
    
}

//key clicks
- (IBAction)typeLetter:(id)sender {
    selectedBox.text= [sender currentTitle];
}


-(void) makeGrid{
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger width=47;
    NSInteger padding=10;
    NSInteger height=32;
    NSInteger startx=(screenWidth/2)-(width*2.5+padding*2.5);
    NSInteger starty=screenHeight/2;
    NSInteger maxSlots=5;
    
    
    //NSInteger numSlots=(screenWidth-startx)/width;
    for(NSInteger i = 0; i < maxSlots; i++) {
        
        NSInteger curX= startx+((width+padding)*i);
        UILabel  * gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(curX, starty, width, height)];
        gridLabel.layer.borderColor = [UIColor grayColor].CGColor;
        gridLabel.layer.borderWidth = 1.0;
        gridLabel.textAlignment=NSTextAlignmentCenter;
        gridLabel.backgroundColor=[UIColor whiteColor];
        gridLabel.userInteractionEnabled = YES;
        gridLabel.text=@" ";
        
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        [gridLabel addGestureRecognizer:tapGesture];
        
        NSInteger count = [self.curWord length];
        
        if(!_startWord){
            _startWord = _curWord;
        }
        
        if(i<count){
            NSString * wordLetter = [_startWord substringWithRange:NSMakeRange(i, 1)];
            gridLabel.text=wordLetter;
        }
        
        [self.view addSubview:gridLabel];
        [textBoxes addObject:gridLabel];
    }
}

- (void)labelTapped:(UIPanGestureRecognizer *)tapGesture{
     UILabel *label = (UILabel *)tapGesture.view;
    selectedBox=label;
    [self selectBox];
    
}

- (void)Start{
    CountNumber =10;
    if(timer && timer.timeInterval==0){[timer invalidate];}
    if(timer.timeInterval < 1){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCount) userInfo:nil repeats:YES];
    }
    
}

-(void)TimerCount{

    CountNumber = CountNumber-1;
    [timerDisplay setProgress:CountNumber/10.0 animated:YES ];
    timerText.text = [NSString stringWithFormat:@"%d",CountNumber];
    
    if(CountNumber ==0) {
        [self gameIsDie];
    }
    
    
}



-(void)gameIsDie{
    timerText.text=@"Game Over";
    [_quitButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [timer invalidate];
    _submit.enabled = false;
    
}

-(void)selectBox{
    for(UILabel *l in textBoxes){
        if(selectedBox==l){
            l.layer.borderColor = [UIColor orangeColor].CGColor;
            l.layer.borderWidth = 2.0;
        }
        else{
            l.layer.borderColor = [UIColor grayColor].CGColor;
            l.layer.borderWidth = 1.0;
        }
    }
}

//gesture controls
- (void)swipeRight:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Swiped right");
    int selected= [textBoxes indexOfObject:selectedBox];
    int isspace=-1;
    for(int i=selected; i< textBoxes.count; i++){
        UILabel *current=textBoxes[i];
        if([current.text isEqual:@" "]){
            isspace=i;
            break;
        }
    }
    
    if(isspace !=-1){
        
        for(int i=isspace; i> selected; i--){
            UILabel *current=textBoxes[i];
            UILabel *left=textBoxes[i-1];
            current.text=left.text;
        }
        selectedBox.text=@" ";
    }
}

- (void)swipeLeft:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Swiped left");
    int selected= [textBoxes indexOfObject:selectedBox];
    int isspace=-1;
    for(int i=selected; i>= 0; i--){
        UILabel *current=textBoxes[i];
        if([current.text isEqual:@" "]){
            isspace=i;
            break;
        }
    }
    
    if(isspace !=-1){
        
        for(int i=isspace; i<selected; i++){
            UILabel *current=textBoxes[i];
            if(i!=MAX_SLOTS-1){
                UILabel *right=textBoxes[i+1];
                current.text=right.text;
            }
        }
        selectedBox.text=@" ";
    }
}

-(void)scoreHandle:(BOOL)direction{
    if(direction)self.curScore+=1;
    else self.curScore-=1;
    scoreText.text=[NSString stringWithFormat:@"Score: %d", self.curScore];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    GameOverViewController *newVC=segue.destinationViewController;
    newVC.scoreValue = &(_curScore);
    newVC.startWord = _startWord;
    
}



@end
