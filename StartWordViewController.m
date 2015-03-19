//
//  StartWordViewController.m
//  ChangeOne
//
//  Created by Student on 12/11/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "StartWordViewController.h"
#import "ViewController.h"

@interface StartWordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *button10;

@end

@implementation StartWordViewController{
    NSMutableArray *wordButtons;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wordButtons=[NSMutableArray arrayWithObjects: _button1, _button2, _button3, _button4, _button5, _button6, _button7, _button8, _button9, _button10, nil];
    
    [self loadStartWords];
   
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)loadStartWords{
    NSMutableArray *startWords = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"csv"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading CSV file" message:[error description] delegate:self cancelButtonTitle:nil otherButtonTitles:@":(", nil];
        
        [alert show];
        return;
    }else{
        //NSLog(@"%@", content);
        //load in the csv and grab each value seperated by a comma
        NSArray *words = [content componentsSeparatedByString:@","];
        for (NSInteger i = 0; i <10; i++){
            NSInteger x = arc4random_uniform([words count]);
            [startWords addObject:[words objectAtIndex:x]];
        }
        [self setTheButtons:startWords];
    }
}


-(void) setTheButtons:(NSMutableArray*)startWords{
  
  
    for(NSInteger i=0; i<wordButtons.count; i++){
        
        UIButton *button=wordButtons[i];
        [button setTitle:[startWords objectAtIndex:i] forState:UIControlStateNormal];
        
    }
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *newVC=segue.destinationViewController;
    newVC.curWord=[sender currentTitle];
    // Pass the selected object to the new view controller.
    
  
    
}



@end
