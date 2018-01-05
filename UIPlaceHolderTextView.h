//
//  UIPlaceHolderTextView.h
//  GrowingTogether
//
//  Created by taocheng on 13-8-29.
//  Copyright (c) 2013年 陶 成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain)   NSString *placeholder;
@property (nonatomic, retain)   UIColor  *placeholderColor;
@property (nonatomic, strong)   UIFont   *placeholderFont;
@property (nonatomic, readonly) CGFloat  inputLeftMargin;
-(void)textChanged:(NSNotification*)notification;

@end
