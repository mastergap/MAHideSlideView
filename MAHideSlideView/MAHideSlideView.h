//  Created by Michele Ambrosi on 20/02/13.

/*
 Copyright (c) 2013, Intesys s.r.l
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import <UIKit/UIKit.h>

@protocol MAHideSlideViewDelegate;

@interface MAHideSlideView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImage *coverImage;
@property (strong, nonatomic) UIImage *hiddenImage;
@property (nonatomic, assign) BOOL buttonMode;
@property (nonatomic, assign) CGFloat coverOverlap;
@property (strong, nonatomic) id<MAHideSlideViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andCoverImage:(UIImage *)coverImage andHiddenImage:(UIImage *)hiddenImage;

- (void)setOrigin:(CGPoint)origin;

- (void)addHiddenButtonTarget:(id)target action:(SEL)selector forEvent:(UIControlEvents)event;

- (CGSize)getClosedSize;


//button mode configuration methods
- (void)setButtonTitle:(NSString *)title forControlState:(UIControlState)controlState;

- (void)setButtonTitleColor:(UIColor *)color forControlState:(UIControlState)controlState;

- (void)setButtonTitleShadowColor:(UIColor *)color forControlState:(UIControlState)controlState;

- (void)setButtonTitleShadowOffset:(CGSize)offset;

- (void)setButtonTitleFont:(UIFont *)font;


@end

@protocol MAHideSlideViewDelegate <NSObject>

@optional
- (void)slideViewControlDidOpen:(MAHideSlideView *)slideViewControl;

@optional
- (void)slideViewControlDidClose:(MAHideSlideView *)slideViewControl;

@end



