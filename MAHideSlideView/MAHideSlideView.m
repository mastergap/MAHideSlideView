//  Created by Michele Ambrosi on 20/02/13.

/*
 Copyright (c) 2013, Intesys s.r.l
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "MAHideSlideView.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    kClosed,
    kOpened
} SlideViewControlState;

#define kHiddenViewTag 347

@implementation MAHideSlideView {
    UIImageView *coverImageView;
    UIView *hiddenViewContainer;
    UIImageView *hiddenImageView;
    UIButton *hiddenButton;
    CGFloat coverMidPoint;
    CGFloat initialY;
    UITapGestureRecognizer *hiddenImageGestureRecognizer;
    CALayer *darkMaskLayer;
    SlideViewControlState state;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        state = kClosed;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andCoverImage:(UIImage *)coverImage andHiddenImage:(UIImage *)hiddenImage {
    self = [self initWithFrame:frame];
    if (self) {
        _coverImage = coverImage;
        _hiddenImage = hiddenImage;
        if (_coverImage != nil && _hiddenImage != nil) {
            coverImageView = [[UIImageView alloc] initWithImage:_coverImage];
            hiddenImageView = [[UIImageView alloc] initWithImage:_hiddenImage];

            CGRect frame = self.frame;
            frame.size.width = _coverImage.size.width;
            frame.size.height = _coverImage.size.height;
            self.frame = frame;
            
            hiddenViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            
            hiddenViewContainer.tag = kHiddenViewTag;
            
            
            
            [hiddenViewContainer addSubview:hiddenImageView];
            [hiddenImageView setCenter:CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f)];
            
            [self addSubview:hiddenViewContainer];
            [self adaptView:hiddenImageView inView:hiddenViewContainer];
            [self addSubview:coverImageView];
            
            initialY = self.frame.origin.y;
            coverMidPoint = frame.size.height * 0.2f;
            
            _coverOverlap = frame.size.height * 0.15f;
            
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(coverPan:)];
            panGestureRecognizer.maximumNumberOfTouches = 1;
            panGestureRecognizer.minimumNumberOfTouches = 1;
            panGestureRecognizer.delegate = self;
            
            coverImageView.userInteractionEnabled = YES;
            [coverImageView addGestureRecognizer:panGestureRecognizer];
        }
    }
    return self;
}

- (void)setCoverOverlap:(CGFloat)pixels {
    _coverOverlap = pixels;
}


//button mode configurations methods
- (void)setButtonTitle:(NSString *)title forControlState:(UIControlState)controlState {
    if (hiddenButton) [hiddenButton setTitle:title forState:controlState];
}

- (void)setButtonTitleColor:(UIColor *)color forControlState:(UIControlState)controlState {
    if (hiddenButton) [hiddenButton setTitleColor:color forState:controlState];
}

- (void)setButtonTitleShadowColor:(UIColor *)color forControlState:(UIControlState)controlState {
    if (hiddenButton) [hiddenButton setTitleShadowColor:color forState:controlState];
}

- (void)setButtonTitleShadowOffset:(CGSize)offset {
    if (hiddenButton) [hiddenButton.titleLabel setShadowOffset:offset];
}

- (void)setButtonTitleFont:(UIFont *)font {
    if (hiddenButton) [hiddenButton.titleLabel setFont:font];
}


- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
    if (state == kOpened) {
        initialY = origin.y + (coverImageView.frame.size.height - _coverOverlap);
    } else {
        initialY = origin.y;
    }
}

- (CGSize)getClosedSize {
    return coverImageView.frame.size;
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    [coverImageView setImage:coverImage];
}

- (void)setHiddenImage:(UIImage *)hiddenImage {
    _hiddenImage = hiddenImage;
    if (_buttonMode) {
        
        [hiddenButton setBackgroundImage:hiddenImage forState:UIControlStateNormal];
    } else {
        [hiddenImageView setImage:hiddenImage];
    }
}

- (void)coverPan:(UIPanGestureRecognizer *)sender {
    CGRect imageFrame;
    UIView *hiddenView;
    CGRect mainFrame = self.frame;
    CGPoint translatedPoint = [sender translationInView:self.superview];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            break;
        
        case UIGestureRecognizerStateChanged:
            hiddenView = [self viewWithTag:kHiddenViewTag];
            imageFrame = hiddenView.frame;
            if (translatedPoint.y < 0) {
                if (imageFrame.origin.y < imageFrame.size.height - 20) {
                    imageFrame.origin.y += fabsf(translatedPoint.y) * 0.05f;
                    mainFrame.origin.y -= fabsf(translatedPoint.y) * 0.05f;
                    mainFrame.size.height += fabsf(translatedPoint.y) * 0.05f;
                }
            } else {
                if (imageFrame.origin.y > 0) {
                    mainFrame.origin.y += translatedPoint.y * 0.05f;
                    mainFrame.size.height -= fabsf(translatedPoint.y) * 0.05f;
                    imageFrame.origin.y -= fabsf(translatedPoint.y) * 0.05f;
                    if (imageFrame.origin.y < 0) {
                        imageFrame.origin.y = 0;
                        mainFrame.origin.y = initialY;
                        mainFrame.size.height = coverImageView.frame.size.height;
                    }
                }
            }
            hiddenView.frame = imageFrame;
            self.frame = mainFrame;
            break;
        
        case UIGestureRecognizerStateEnded: {
            hiddenView = [self viewWithTag:kHiddenViewTag];
            imageFrame = hiddenView.frame;
            BOOL stateChanged = NO;
            if (imageFrame.origin.y < coverMidPoint && imageFrame.origin.y != 0) {
                imageFrame.origin.y = 0;
                mainFrame.origin.y = initialY;
                mainFrame.size.height = coverImageView.frame.size.height;
                if (state == kOpened) {
                    state = kClosed;
                    stateChanged = YES;
                    coverMidPoint = coverImageView.frame.size.height * 0.2f;
                }
            } else if (imageFrame.origin.y > coverMidPoint && imageFrame.origin.y != (imageFrame.size.height - _coverOverlap)) {
                imageFrame.origin.y = imageFrame.size.height - _coverOverlap;
                mainFrame.size.height = coverImageView.frame.size.height + imageFrame.size.height - _coverOverlap;
                mainFrame.origin.y = initialY - imageFrame.size.height + _coverOverlap;
                if (state == kClosed) {
                    state = kOpened;
                    stateChanged = YES;
                    coverMidPoint = coverImageView.frame.size.height - _coverOverlap - (coverImageView.frame.size.height * 0.2f);
                }
            }
            
            [UIView animateWithDuration:0.3f animations:^{
                hiddenView.frame = imageFrame;
                self.frame = mainFrame;
            } completion:^(BOOL finished) {
                if (_delegate != nil && stateChanged) {
                    if (state == kOpened && [_delegate respondsToSelector:@selector(slideViewControlDidOpen:)]) {
                        [_delegate slideViewControlDidOpen:self];
                    } else if ([_delegate respondsToSelector:@selector(slideViewControlDidClose:)]) {
                        [_delegate slideViewControlDidClose:self];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)setButtonMode:(BOOL)mode {
    _buttonMode = mode;
    if (mode) {
        hiddenButton = [[UIButton alloc] initWithFrame:hiddenImageView.frame];
        [hiddenButton setBackgroundImage:_hiddenImage forState:UIControlStateNormal];
        [hiddenImageView removeFromSuperview];
        hiddenImageView = nil;
        [hiddenViewContainer addSubview:hiddenButton];
        [hiddenButton setCenter:CGPointMake(hiddenViewContainer.frame.size.width * 0.5f, hiddenViewContainer.frame.size.height * 0.5f)];
        [self bringSubviewToFront:coverImageView];
    } else {
        hiddenImageView = [[UIImageView alloc] initWithFrame:hiddenButton.frame];
        [hiddenImageView setImage:_hiddenImage];
        [hiddenButton removeFromSuperview];
        hiddenButton = nil;
        [hiddenViewContainer addSubview:hiddenImageView];
        [hiddenImageView setCenter:CGPointMake(hiddenViewContainer.frame.size.width * 0.5f, hiddenViewContainer.frame.size.height * 0.5f)];
        [self bringSubviewToFront:coverImageView];
    }
}

- (void)addHiddenButtonTarget:(id)target action:(SEL)selector forEvent:(UIControlEvents)event {
    if (hiddenButton) {
        [hiddenButton addTarget:target action:selector forControlEvents:event];
    }
}

- (void)adaptView:(UIView *)containedView inView:(UIView *)containerView {
    if (containedView.frame.size.width > containerView.frame.size.width || containedView.frame.size.height > containerView.frame.size.height) {
        CGFloat deltaWidth = containedView.frame.size.width - containerView.frame.size.width;
        CGFloat deltaHeigth = containedView.frame.size.height - containerView.frame.size.height;
        CGFloat resizeFactor;
        if (deltaWidth > deltaHeigth) {
            resizeFactor = containerView.frame.size.width - containedView.frame.size.width;
            CGRect frame = containedView.frame;
            frame.size.width = containerView.frame.size.width;
            frame.size.height = containedView.frame.size.height * resizeFactor;
            containedView.frame = frame;
        } else {
            resizeFactor = containerView.frame.size.height - containedView.frame.size.height;
            CGRect frame = containedView.frame;
            frame.size.height = containerView.frame.size.height;
            frame.size.width = containedView.frame.size.width * resizeFactor;
            containedView.frame = frame;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
