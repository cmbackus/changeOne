//
//  WordModel.m
//  ChangeOne
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

-(BOOL)checkWord:(NSString*) word{
    UITextChecker *textChecker = [[UITextChecker alloc]init];
    
    NSString * currentWord;
    //Change the textField.text to the string
    currentWord = word;
    //if the string is all CAPs it won't work, so I make it all lowercase
    //just to be sure
    NSRange range = NSMakeRange(0, 0);
    //the textChecker returns a range of the misspelled word
    //if there is no misspelled word there is no range
    range = [textChecker rangeOfMisspelledWordInString:[currentWord lowercaseString]
                                                 range:NSMakeRange(0, [currentWord length])
                                            startingAt:0
                                                  wrap:NO
                                              language:@"en_US"];
    
    if (range.location == NSNotFound ) {
        //if it is actually a word call all of the other functions here
        NSLog(@"Word found");
        return TRUE;
    }
    
    else {
        // if it's not a word do the stuff below
        NSLog(@"Word not found");
        return FALSE;
        
    }
}

-(BOOL)checkForRepeat:(NSString*)word useWords:(NSMutableArray *)usedWords{
    BOOL match=FALSE;
    //go through and check all of the words that have been posted and
    //return if there is a double
    for(NSInteger i=0; i<usedWords.count; i++){
        NSString *thisWord=usedWords[i];
        if ([thisWord isEqualToString:word]){
            match=TRUE;
        }
    }
    return match;
}

-(BOOL)checkOnlyOneChange:(NSString *)newWord oldWord:(NSString *)oldWord{
    NSString *shortWord;
    NSString *longWord;
    NSInteger numChanges=0;
    //check if one is 2 longer if so return false
    if (abs(newWord.length - oldWord.length) > 1 ){
        return FALSE;
    }else{
        //determine which one is shorter
        if(oldWord.length <= newWord.length){shortWord = oldWord; longWord=newWord;}
        else{shortWord = newWord; longWord=oldWord;}
        
        //check each letter for a discrepency
        //if there is a discrepency check the next letter
        //if the next letter matches check the rest of the string
        for (NSInteger i=0; i< shortWord.length; i++){
            if([shortWord characterAtIndex:i] != [longWord characterAtIndex:i]){
                if(i<shortWord.length-1){
                    if([shortWord characterAtIndex:i] != [longWord characterAtIndex:i+1] ){
                        numChanges++;
                    }
                    else{
                        NSString *shortSubString = [shortWord substringFromIndex:i];
                        NSString *longSubString = [longWord substringFromIndex:i+1];
                        return ([shortSubString isEqual:longSubString ]);
                        
                    }
                }
            }
        }//end of for
    }//end of else
    
    
    return (numChanges <= 1);
}




@end
