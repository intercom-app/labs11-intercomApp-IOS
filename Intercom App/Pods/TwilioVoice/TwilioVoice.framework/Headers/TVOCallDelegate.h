//
//  TVOCallDelegate.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

@class TVOCall;

/**
 * Objects can conform to the `TVOCallDelegate` protocol to be informed of the lifecycle events of a `<TVOCall>`.
 */
@protocol TVOCallDelegate <NSObject>

/**
 * @name Required Methods
 */

/**
 * @brief Notifies the delegate that a Call has connected.
 *
 * @param call The `<TVOCall>` that was connected.
 *
 * @see TVOCall
 */
- (void)callDidConnect:(nonnull TVOCall *)call;

/**
 * @brief Notifies the delegate that a Call has failed to connect.
 *
 * @param call The `<TVOCall>` that failed to connect.
 * @param error The `<NSError>` that occurred.
 *
 * @see TVOCall
 */
- (void)call:(nonnull TVOCall *)call didFailToConnectWithError:(nonnull NSError *)error;

/**
 * @brief Notifies the delegate that a Call has disconnected.
 *
 * @discussion If the disconnection was unexpected then a Non-null `NSError` will be present.
 *
 * @param call The `<TVOCall>` that was disconnected.
 * @param error Indicates why the disconnect occurred.
 *
 * @see TVOCall
 */
- (void)call:(nonnull TVOCall *)call didDisconnectWithError:(nullable NSError *)error;

@end
