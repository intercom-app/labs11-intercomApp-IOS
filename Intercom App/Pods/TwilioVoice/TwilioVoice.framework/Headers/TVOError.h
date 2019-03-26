//
//  TVOError.h
//  TwilioVoice
//
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TVOError_h
#define TVOError_h

FOUNDATION_EXPORT NSString * _Nonnull const kTVOErrorDomain;

/**
 * An enumeration indicating the errors that can be raised by the SDK.
 */
typedef NS_ENUM (NSInteger, TVOError) {
    TVOErrorAccessTokenInvalid                  = 20101,    ///< Invalid Access Token
    TVOErrorAccessTokenHeaderInvalid            = 20102,    ///< Invalid Access Token header
    TVOErrorAccessTokenIssuerInvalid            = 20103,    ///< Invalid Access Token issuer/subject
    TVOErrorAccessTokenExpired                  = 20104,    ///< Access Token expired or expiration date invalid
    TVOErrorAccessTokenNotYetValid              = 20105,    ///< Access Token not yet valid
    TVOErrorAccessTokenGrantsInvalid            = 20106,    ///< Invalid Access Token grants
    TVOErrorAccessTokenSignatureInvalid         = 20107,    ///< Invalid Access Token signature
    TVOErrorExpirationTimeExceedsMaxTimeAllowed = 20157,    ///< Expiration Time Exceeds Maximum Time Allowed
    TVOErrorAccessForbidden                     = 20403,    ///< The account lacks permission to access the Twilio API
    TVOErrorApplicationNotFound                 = 21218,    ///< Invalid Application Sid
    TVOErrorConnectionTimeout                   = 31003,    ///< Connection timeout
    TVOErrorInitializationError                 = 31004,    ///< Initialization error
    TVOErrorConnectionError                     = 31005,    ///< Connection error
    TVOErrorMalformedRequest                    = 31100,    ///< Malformed request
    TVOErrorInvalidData                         = 31106,    ///< Invalid data
    TVOErrorAuthorizationError                  = 31201,    ///< Authorization error
    TVOErrorInvalidJWTToken                     = 31204,    ///< Invalid JWT token
    TVOErrorMicrophoneAccessDenial              = 31208,    ///< User denied access to microphone
    TVOErrorRegistrationError                   = 31301     ///< Registration error
};

#endif
