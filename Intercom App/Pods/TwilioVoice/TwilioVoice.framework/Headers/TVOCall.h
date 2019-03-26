//
//  TVOCall.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TVOCallDelegate;

/**
 * Enumeration indicating the state of the Call.
 */
typedef NS_ENUM(NSUInteger, TVOCallState) {
    TVOCallStateConnecting = 0, ///< The Call is connecting.
    TVOCallStateConnected,      ///< The Call is connected.
    TVOCallStateDisconnected    ///< The Call is disconnected.
};

/**
 * The `TVOCall` class represents a bi-directional voice Call. `TVOCall` objects are not created directly; they
 * are returned by `<[TVOCallInvite acceptWithDelegate:]>` or `<[TwilioVoice call:params:delegate:]>`.
 */
@interface TVOCall : NSObject

/**
 * @name Properties
 */

/**
 * @brief The `<TVOCallDelegate>` object that will receive Call state updates.
 *
 * @see TVOCallDelegate
 */
@property (nonatomic, weak, readonly, nullable) id<TVOCallDelegate> delegate;

/**
 * @brief `From` value of the Call.
 *
 * @discussion This may be `nil` if the call object was created by calling the 
 * `<[TwilioVoice call:params:delegate:]>` method.
 */
@property (nonatomic, strong, readonly, nullable) NSString *from;

/**
 * @brief `To` value of the Call.
 *
 * @discussion This may be `nil` if the call object was created by calling the 
 * `<[TwilioVoice call:params:delegate:]>` method.
 */
@property (nonatomic, strong, readonly, nullable) NSString *to;

/**
 * @brief A server assigned identifier (SID) for the Call.
 *
 * @discussion A SID is a globally unique identifier which can be very useful for debugging Call traffic.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *sid;

/**
 * @brief Property that defines if the Call is muted.
 *
 * @discussion Setting the property will only take effect if the `<state>` is `TVOCallStateConnected`.
 */
@property (nonatomic, assign, getter=isMuted) BOOL muted;

/**
 * @brief The current state of the Call.
 *
 * @discussion All `TVOCall` instances start in `TVOCallStateConnecting` and end in `TVOCallStateDisconnected`.
 * After creation, a Call will transition to `TVOCallStateConnected` if successful or `TVOCallStateDisconnected` if the
 * connection attempt fails.
 *
 * @see TVOCallState
 */
@property (nonatomic, assign, readonly) TVOCallState state;

/**
 * @brief Property that defines if the Call is on hold.
 *
 * @discussion Holding a Call ceases the flow of audio between parties.
 * Setting the property will only take effect if the `<state>` is `TVOCallConnected`.
 * While placing the Call on hold ceases the flow of audio, to deactivate the audio
 * device you must disable it via the `audioEnabled` property on the `TwilioVoice` class.
 * This operation is performed automatically in response to an AVAudioSession interruption.
 */
@property (nonatomic, getter=isOnHold) BOOL onHold;

/**
 * @name General Call Actions
 */

/**
 * @brief Disconnects the Call.
 *
 * @discussion Calling this method on a `TVOCall` that is in the `<state>` `TVOCallStateDisconnected` has no effect.
 */
- (void)disconnect;

/**
 * @brief Send a string of digits.
 *
 * @discussion Calling this method on a `TVOCall` that is not in the `<state>` `TVOCallStateConnected` has no effect.
 *
 * @param digits A string of characters to be played. Valid values are '0' - '9', '*', '#', and 'w'.
 *               Each 'w' will cause a 500 ms pause between digits sent.
 */
- (void)sendDigits:(nonnull NSString *)digits;


- (null_unspecified instancetype)init __attribute__((unavailable("Calls cannot be instantiated directly. See `TVOCallInvite acceptWithDelegate:` or `TwilioVoice call:params:delegate:`")));

@end


/**
 * CallKit Call Actions
 */
@interface TVOCall (CallKitIntegration)

/**
 * @brief A unique identifier for the Call.
 *
 * @discussion Use this UUID to identify the `TVOCall` when working with CallKit.
 * You can provide a UUID for outgoing calls using `<[TwilioVoice call:params:uuid:delegate:]>`.
 * Calls created via `<[TVOCallInvite acceptWithDelegate:]>` inherit their `uuid` from the Invite itself.
 */
@property (nonatomic, strong, readonly, nonnull) NSUUID *uuid;

@end
