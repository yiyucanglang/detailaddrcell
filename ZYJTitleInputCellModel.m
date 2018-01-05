//
//  ZYJTitleInputCellModel.m
//  ZMParentsProject
//
//  Created by James on 2017/11/11.
//  Copyright © 2017年 Sea. All rights reserved.
//

#import "ZYJTitleInputCellModel.h"
#import "ZMPInputValidator.h"

@implementation ZYJTitleInputCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.cellClassName = @"ZYJTitleInputCellView";
        self.cellHeight    = 48;
        self.maxLength     = 11;
        self.validate      = [[ZMPInputValidator alloc] init];
    }
    return self;
}

@end
