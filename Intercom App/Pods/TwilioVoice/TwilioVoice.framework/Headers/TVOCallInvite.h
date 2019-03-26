//
//  TVOCallInvite.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVOCall;
@protocol TVOCallDelegate;

/**
 * Enumeration indicating the state of the Call Invite.
 */
typedef NS_ENUM(NSUInteger, TVOCallInviteState) {
    TVOCallInviteStatePending = 0,      ///< The Call Invite is pending for action.
    TVOCallInviteStateAccepted,         ///< The Call Invite has been accepted.
    TVOCallInviteStateRejected,         ///< The Call Invite has been rejected.
    TVOCallInviteStateCanceled          ///< The Call Invite has been canceled by the caller.
};

/**
 * The `TVOCallInvite` object represents an incoming Call Invite. `TVOCallInvite`s are not created directly;
 * they are returned by the `<[TVONotificationDelegate callInviteReceived:]>` delegate method.
 */
@interface TVOCallInvite : NSObject

/**
 * @name Properties
 */

/**
 * @brief `From` value of the Call Invite.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *from;

/**
 * @brief `To` value of the Call Invite.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *to;

/**
 * @brief A server assigned identifier (SID) for the incoming Call.
 *
 * @discussion Accepting a `TVOCallInvite` yields a `TVOCall` which inherits this SID.
 *
 * @see TVOCall.sid
 */
@property (nonatomic, strong, readonly, nonnull) NSString *callSid;

/**
 * @brief State of the Call Invite.
 *
 * @see TVOCallInviteState
 */
@property (nonatomic, assign, readonly) TVOCallInviteState state;

/**
 * @name Call Invite Actions
 */

/**
 * @brief Accepts the incoming Call Invite.
 *
 * @param delegate The `<TVOCallDelegate>` object that will receive call state updates.
 *
 * @return A `TVOCall` object.
 *
 * @see TVOCallDelegate
 */
- (nonnull TVOCall *)acceptWithDelegate:(nonnull id<TVOCallDelegate>)delegate;

/**
 * @brief Rejects the incoming Call Invite.
 */
- (void)reject;

/**
 * @brief Call Invites cannot be instantiated directly. See `<TVONotificationDelegate>` instead.
 *
 * @see TVONotificationDelegate
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Call Invites cannot be instantiated directly. See `TVONotificationDelegate`")));

@end


/**
 * CallKit Call Actions
 */
@interface TVOCallInvite (CallKitIntegration)

/**
 * @brief UUID of the Call Invite.
 *
 * @discussion Use this UUID for CallKit methods. Accepting a `TVOCallInvite` yields a `TVOCall` which inherits its
 * UUID from the Invite.
 */
@property (nonatomic, strong, readonly, nonnull) NSUUID *uuid;

@end
