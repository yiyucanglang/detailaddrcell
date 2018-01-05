//
//  ZYJTitleTextViewCellView.m
//  ZMParentsProject
//
//  Created by James on 2017/11/11.
//  Copyright © 2017年 Sea. All rights reserved.
//

#import "ZYJTitleTextViewCellView.h"

#import "ZYJTitleInputCellModel.h"

#import "UIPlaceHolderTextView.h"

#import "NSString+RemoveEmoji.h"

@interface ZYJTitleTextViewCellView()
<
    UITextViewDelegate
>
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) UIPlaceHolderTextView *referenceTextView;
@property (nonatomic, strong) UIView *seperatorLineView;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) CGFloat textViewSingleLineHeight;
@end

@implementation ZYJTitleTextViewCellView
{
    BOOL _adjustTextViewContentPositionForTheFirstTime;
    CGFloat manualeOffsetY;
}
@dynamic delegate;
#pragma mark - Life Cycle


#pragma mark - System Mehthod
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        //optimize for user experience
        CGSize newContentSize = [change[@"new"] CGSizeValue];
        CGSize oldContentSize = [change[@"old"] CGSizeValue];
        if (newContentSize.height < oldContentSize.height) {
            self.textView.contentOffset = CGPointMake(self.textView.contentOffset.x, MAX(self.textView.contentOffset.y - 8, 0));
            manualeOffsetY = self.textView.contentOffset.y;
        }
        
    }
    else if ([keyPath isEqualToString:@"contentOffset"]) {
        
        if (manualeOffsetY > 0) {
            CGFloat temp = manualeOffsetY;
            manualeOffsetY = 0;
            
            self.textView.contentOffset = CGPointMake(self.textView.contentOffset.x, temp);
            
        }
        
    }
}

#pragma mark - Private Method
- (void)addTextViewObserver {
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.textView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeTextViewObserver {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
    [self.textView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark Assist Method


- (void)adjustTextViewContentPositionForTheFirstTime {
    if (_adjustTextViewContentPositionForTheFirstTime) {
        return;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if(self.textView.contentSize.height > self.textView.frame.size.height) {
        self.textView.contentOffset = CGPointMake(self.textView.contentOffset.x, fabs(self.textView.contentSize.height - self.textView.frame.size.height - 8));
        _adjustTextViewContentPositionForTheFirstTime = YES;
    }
}

#pragma mark - Public Method
- (void)UILayout {
    [super UILayout];
    
    [self addTextViewObserver];
    
    [self addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(105);
        make.centerY.equalTo(self).with.offset(1);
        make.height.equalTo(@(self.textViewSingleLineHeight));
        make.right.equalTo(self).with.offset(-30);
    }];
    
    [self addSubview:self.referenceTextView];
    [self.referenceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView);
    }];
    
    self.seperatorLineView = [UIView new];
    self.seperatorLineView.backgroundColor = kZMPSeperatorColor;
    [self addSubview:self.seperatorLineView];
    [self.seperatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@.5);
    }];
    
   
    
}

- (void)bindingDataWithViewModel:(ZYJTitleInputCellModel *)model {
    [super bindingDataWithViewModel:model];
    
    self.titleLB.text         = model.title;
    self.textView.placeholder = model.placeHolder;
    self.textView.text        = model.inputText;
    self.maxLength            = model.maxLength;
    self.seperatorLineView.hidden = model.hiddenSeperator;
    [self adjustTextViewContentPositionForTheFirstTime];
}

#pragma mark - Delegate
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(beginEditingInZYJTitleTextViewCellView:bindingModel:)]) {
        [self.delegate beginEditingInZYJTitleTextViewCellView:self bindingModel:self.viewModel];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    ((ZYJTitleInputCellModel *)self.viewModel).inputText = textView.text;
    if([self.delegate respondsToSelector:@selector(endEditingInZYJTitleTextViewCellView:bindingModel:)]) {
        [self.delegate endEditingInZYJTitleTextViewCellView:self bindingModel:self.viewModel];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView markedTextRange]) {
        return;
    }
    
    textView.text = [textView.text removingEmoji];
    if (textView.text.length > self.maxLength) {
        textView.text = [textView.text substringToIndex:self.maxLength];
    }
}

#pragma mark - Getter And Setter
- (UILabel *)titleLB {
    
    if (!_titleLB) {
        _titleLB = [UILabel convienceInitWithTitle:@"" font:kZMPFont(15) alignment:NSTextAlignmentLeft titleColor:kZMPMiddleBlack];
    }
    
    return _titleLB;
}

- (UIPlaceHolderTextView *)textView {
    if (!_textView) {
        _textView = [[UIPlaceHolderTextView alloc] init];
        _textView.delegate          = self;
        _textView.font              = kZMPFont(15);
        _textView.placeholderFont   = kZMPFont(14);
        _textView.placeholderColor  = HEX_RGB(0XCCCCCC);
        _textView.textColor         = kZMPMiddleBlack;
        _textView.returnKeyType     = UIReturnKeyDone;
    }
    return _textView;
}

- (UIPlaceHolderTextView *)referenceTextView {
    if (!_referenceTextView) {
        _referenceTextView = [[UIPlaceHolderTextView alloc] init];
        _referenceTextView.font     = self.textView.font;
        _referenceTextView.hidden   = YES;
    }
    return _referenceTextView;
}

- (CGFloat)textViewSingleLineHeight {
    if (_textViewSingleLineHeight <= 0) {
        self.referenceTextView.text = @"收货地址";
        _textViewSingleLineHeight = [self.referenceTextView sizeThatFits:CGSizeZero].height + 2;
    }
    return _textViewSingleLineHeight;
}

#pragma mark - Delloc
-(void)dealloc {
    [self removeTextViewObserver];
}
@end
