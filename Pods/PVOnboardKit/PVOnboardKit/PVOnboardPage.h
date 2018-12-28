/*
 PVOnboardPage.h
 PVOnboardKit
 
 Copyright 2017 Victor Peschenkov
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 * The PVOnboardPage protocol. You'd implement this protocol if you want
 * processing the show/hide content events.
 */
NS_SWIFT_NAME(OnboardPage)
@protocol PVOnboardPage <NSObject>

@optional
/**
 * Invoked just after transition on the next page.
 */
- (void)willContentShow;

/**
 * Invoked before transition on the next page.
 */
@optional
- (void)didContentShow;

/**
 * Invoked just after transition on the next page.
 */
@optional
- (void)willContentHide;

/**
 * Invoked before transition on the next page.
 */
@optional
- (void)didContentHide;

@end

NS_ASSUME_NONNULL_END