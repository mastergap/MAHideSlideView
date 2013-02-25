//  Copyright (c) 2013 Intesys. All rights reserved.

/*
 Copyright (c) 2013, Intesys s.r.l
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "IntesysImgUtils.h"

@implementation IntesysImgUtils

- (UIImage *)highlightedImage:(UIImage *) image
{
    const CGSize  size = image.size;
    const CGRect  bnds = CGRectMake(0.0, 0.0, size.width, size.height);
    UIColor*      colr = nil;
    UIImage*      copy = nil;
    CGContextRef  ctxt = NULL;
    
    // this is the mask color
    colr = [[UIColor alloc] initWithWhite:0 alpha:0.46];
    
    // begin image context
    if (UIGraphicsBeginImageContextWithOptions == NULL)
    {
        UIGraphicsBeginImageContext(bnds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(bnds.size, FALSE, 0.0);
    }
    ctxt = UIGraphicsGetCurrentContext();
    
    // transform CG* coords to UI* coords
    CGContextTranslateCTM(ctxt, 0.0, bnds.size.height);
    CGContextScaleCTM(ctxt, 1.0, -1.0);
    
    // draw original image
    CGContextDrawImage(ctxt, bnds, image.CGImage);
    
    // draw highlight overlay
    CGContextClipToMask(ctxt, bnds, image.CGImage);
    CGContextSetFillColorWithColor(ctxt, colr.CGColor);
    CGContextFillRect(ctxt, bnds);
    
    // finish image context
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

@end
