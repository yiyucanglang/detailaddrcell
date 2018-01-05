//
//  ZYJTitleTextViewCellView.h
//  ZMParentsProject
//
//  Created by James on 2017/11/11.
//  Copyright © 2017年 Sea. All rights reserved.
//

#import "BaseCellView.h"

@class ZYJTitleTextViewCellView,ZYJTitleInputCellModel;
@protocol ZYJTitleTextViewCellViewDelegate<NSObject>

@optional
- (void)beginEditingInZYJTitleTextViewCellView:(ZYJTitleTextViewCellView *)cellView bindingModel:(ZYJTitleInputCellModel *)model;

- (void)endEditingInZYJTitleTextViewCellView:(ZYJTitleTextViewCellView *)cellView bindingModel:(ZYJTitleInputCellModel *)model;
@end

@interface ZYJTitleTextViewCellView : BaseCellView
@property (nonatomic, weak) id<ZYJTitleTextViewCellViewDelegate> delegate;
@end
