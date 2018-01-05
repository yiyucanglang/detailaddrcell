//
//  ZYJTitleInputCellModel.h
//  ZMParentsProject
//
//  Created by James on 2017/11/11.
//  Copyright © 2017年 Sea. All rights reserved.
//

#import "BaseCellModel.h"
#import "ZYJTitleInputCellView.h"
#import "ZMPInputValidator.h"

@interface ZYJTitleInputCellModel : BaseCellModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *inputText;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL hiddenSeperator;

@property (nonatomic, strong) ZMPInputValidator *validate;
@end
