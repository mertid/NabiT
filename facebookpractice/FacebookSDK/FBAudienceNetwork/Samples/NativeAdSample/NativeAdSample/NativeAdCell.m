/**
 * Copyright 2014 Facebook, Inc.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to
 * use, copy, modify, and distribute this software in source code or binary
 * form for use in connection with the web and mobile services and APIs
 * provided by Facebook.
 *
 * As with any software that integrates with the Facebook platform, your use
 * of this software is subject to the Facebook Developer Principles and
 * Policies [http://developers.facebook.com/policy/]. This copyright notice
 * shall be included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */

#import "NativeAdCell.h"

@implementation NativeAdCell

- (void)populate:(FBNativeAd *)nativeAd;
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSData *iconImageData = [NSData dataWithContentsOfURL:nativeAd.icon.url];
    NSData *coverImageData = [NSData dataWithContentsOfURL:nativeAd.coverImage.url];

    dispatch_async(dispatch_get_main_queue(), ^{
      // Render native ads onto UIView
      self.adIconImageView.image = [UIImage imageWithData:iconImageData];
      self.adCoverImageView.image = [UIImage imageWithData:coverImageData];

      self.adTitleLabel.text = nativeAd.title;
      self.adBodyLabel.text = nativeAd.body;
      [self.adCallToActionButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];


    });
  });
}

@end
