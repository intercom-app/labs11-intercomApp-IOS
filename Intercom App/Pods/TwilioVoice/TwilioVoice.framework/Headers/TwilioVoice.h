//
//  TwilioVoice.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TVOCall.h"
#import "TVOCallDelegate.h"
#import "TVOCallInvite.h"
#import "TVOError.h"
#import "TVONotificationDelegate.h"

/**
 * An enumeration indicating log levels that can be used with the SDK.
 */
typedef NS_ENUM(NSUInteger, TVOLogLevel) {
    TVOLogLevelOff = 0,     ///< Disables all SDK logging.
    TVOLogLevelError,       ///< Show errors only.
    TVOLogLevelWarn,        ///< Show warnings as well as all **Error** log messages.
    TVOLogLevelInfo,        ///< Show informational messages as well as all **Warn** log messages.
    TVOLogLevelDebug,       ///< Show debugging messages as well as all **Info** log messages.
    TVOLogLevelVerbose      ///< Show low-level debugging messages as well as all **Debug** log messages.
};

/**
 * `TwilioVoice` logging modules.
 */
typedef NS_ENUM(NSUInteger, TVOLogModule) {
    TVOLogModulePJSIP = 0,  ///< PJSIP Module
};

/**
 * `TwilioVoice` is the entry point to the Twilio Voice SDK. You can register for VoIP push notifications, make outgoing
 * Calls, receive CallInvites and manage audio using this class.
 */
@interface TwilioVoice : NSObject

/**
 * @brief The current logging level used by the SDK.
 *
 * @discussion The default logging level is `TVOLogLevelError`. `TwilioVoice` and its components use NSLog internally.
 *
 * @see TVOLogLevel
 */
@property (nonatomic, assign, class) TVOLogLevel logLevel;

/**
 * @brief Enable or disable the audio device.
 *
 * @discussion The default value for the audio device is enabled. Setting audioEnabled to `YES` ensures that the audio
 * device will be used or will activate the audio device if there is an active Call. Setting audioEnabled to `NO`
 * ensures that the audio device will not be started when placing a Call or will disable the audio device if it is
 * already active. The application should use this method to ensure the audio I/O units are activated and deactivated
 * properly when using CXProviderDelegate.
 */
@property (nonatomic, assign, getter=isAudioEnabled, class) BOOL audioEnabled;

/**
 * @brief Defines the region (Twilio data center) used for media and signaling traffic.
 *
 * @discussion The default region uses Global Low Latency routing, which establishes a connection with the closest
 * region to the user. ***Note:*** Setting the region during a Call will not apply until all ongoing Calls have ended
 * and a subsequent Call is placed.
 */
@property (nonatomic, copy, nonnull, class) NSString *region;

/**
 * @brief Returns the version of the SDK.
 *
 * @return The version of the SDK.
 */
+ (nonnull NSString *)version;

/**
 * @brief Sets the logging level for an individual module.
 *
 * @param module The `<TVOLogModule>` for which the logging level is to be set.
 * @param level The `<TVOLogLevel>` level to be used by the module.
 *
 * @see TVOLogModule
 * @see TVOLogLevel
 */
+ (void)setModule:(TVOLogModule)module
         logLevel:(TVOLogLevel)level;

/**
 * @name Managing VoIP Push Notifications
 */

/**
 * @brief Registers for Twilio VoIP push notifications.
 *
 * @discussion Registering for push notifications is required to receive incoming Calls through Twilio's infrastructure.
 * Once you've successfully registered it's not necessary to do so again unless your device token changes.
 *
 * @param accessToken Twilio Access Token.
 * @param deviceToken The push registry token for Apple VoIP Service.
 * @param completion Callback block to receive the result of the registration.
 */
+ (void)registerWithAccessToken:(nonnull NSString *)accessToken
                    deviceToken:(nonnull NSString *)deviceToken
                     completion:(nullable void(^)(NSError * __nullable error))completion;

/**
 * @brief Unregisters from Twilio VoIP push notifications.
 *
 * @discussion Call this method when you no longer want to receive push notifications for incoming Calls.
 * If your device token changes you should call this method to unregister your previous invalid token.
 *
 * @param accessToken Twilio Access Token.
 * @param deviceToken The push registry token for Apple VoIP Service.
 * @param completion Callback block to receive the result of the unregistration.
 */
+ (void)unregisterWithAccessToken:(nonnull NSString *)accessToken
                      deviceToken:(nonnull NSString *)deviceToken
                       completion:(nullable void(^)(NSError * __nullable error))completion;

/**
 * @brief Processes an incoming VoIP push notification payload.
 *
 * @discussion This method will asynchronously process your notification payload and call the provided delegate
 * on the main dispatch queue.
 *
 * @param payload Push notification payload.
 * @param delegate A `<TVONotificationDelegate>` to receive incoming push notification callbacks.
 *
 * @see TVONotificationDelegate
 */
+ (void)handleNotification:(nonnull NSDictionary *)payload
                  delegate:(nonnull id<TVONotificationDelegate>)delegate;

/**
 * @name Making Outgoing Calls
 */

/**
 * @brief Makes an outgoing Call.
 *
 * @discussion This method is guaranteed to return a `<TVOCall>` object. It's possible for the returned Call to either
 * succeed or fail to connect. Calls created by this method are automatically assigned an `NSUUID` to the
 * `TVOCall.uuid` property.
 *
 * @param accessToken Twilio Access Token.
 * @param twiMLParams Additional parameters to be passed to the TwiML application.
 * @param delegate A `<TVOCallDelegate>` to receive Call state updates.
 *
 * @return A `<TVOCall>` object.
 *
 * @see TVOCall
 * @see TVOCallDelegate
 */
+ (nonnull TVOCall *)call:(nonnull NSString *)accessToken
                   params:(nullable NSDictionary <NSString *, NSString *> *)twiMLParams
                 delegate:(nonnull id<TVOCallDelegate>)delegate;


- (null_unspecified instancetype)init __attribute__((unavailable("TwilioVoice cannot be instantiated directly.")));

@end


/**
 * CallKit Audio Session Handling
 */
@interface TwilioVoice (CallKitIntegration)

/**
 * @brief Makes an outgoing Call.
 *
 * @discussion This method is guaranteed to return a `<TVOCall>` object. It's possible for the returned Call to either
 * succeed or fail to connect.
 *
 * @param accessToken Twilio Access Token.
 * @param twiMLParams Additional parameters to be passed to the TwiML application.
 * @param uuid An `NSUUID` used to uniquely identify this Call and suitable for sharing with `CXCallController`.
 * @param delegate A `<TVOCallDelegate>` to receive Call state updates.
 *
 * @return A `<TVOCall>` object.
 *
 * @see TVOCall
 * @see TVOCallDelegate
 */
+ (nonnull TVOCall *)call:(nonnull NSString *)accessToken
                   params:(nullable NSDictionary <NSString *, NSString *> *)twiMLParams
                     uuid:(nonnull NSUUID *)uuid
                 delegate:(nonnull id<TVOCallDelegate>)delegate;

/**
   @brief Configures, but does not activate the `AVAudioSession`.

   @discussion The application needs to use this method to set up the `AVAudioSession` with the desired configuration
   before letting the `CallKit` framework activate the audio session.

   This ensures that the SDK does not configure the `AVAudioSession` while making or accepting a Call. The settings
   applied by `configureAudioSession` will remain for the duration of active Calls. Calling `configureAudioSession`
   applies these settings:

      NSError *error = nil;
      [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                              mode:AVAudioSessionModeVoiceChat
                                           options:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                                             error:&error]

   If your use case requires different settings, you can apply them immediately after calling `configureAudioSession`
   and the Call will retain these settings. Some settings may not result in high quality audio playback and/or recording.
 */
+ (void)configureAudioSession;

@end
