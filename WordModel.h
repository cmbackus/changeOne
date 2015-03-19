//
//  WordModel.h
//  ChangeOne
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WordModel : NSObject

-(BOOL)checkWord:(NSString*) word;
-(BOOL)checkForRepeat:(NSString*)word useWords:(NSMutableArray *)usedWords;
-(BOOL)checkOnlyOneChange:(NSString *)newWord oldWord:(NSString *)oldWord;
@end
