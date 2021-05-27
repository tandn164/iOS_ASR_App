//AppCommand.swift

import Foundation

@objc public enum Command: Int {
    public typealias RawValue = Int
    
    case
        drop,
        vShowError,
        vShowSocketError,
        _vStartLoadingAnimation,
        _vStopLoadingAnimation,
        _vUpdateList,
        _vAddItems,
        vBack,
        vBackResetPassword,
        vDismissViewController,
        vDone,
        cError,
        cSocketError,
        vClosePlayer,
        gReachable,
        gUnreachable,
        gApplicationDidEnterBackground,
        gApplicationWillEnterForeground,
        gApplicationDidBecomeActive,
        vSuggestUpdate,
        vUpdateRightBarBotton,
        vResendCode,
        
        vShowLastScreen,
        
        vKeyboardWillShow,
        vKeyboardWillHide,
        vHideKeyboard,
        
        sReceiveSocketData = 1000, //Constant.commandReceiveSocketData
        sSocketError = 1001, //Constant.commandSocketError
        sUpdateGlobalData = 1002, //Constant.commandReceiveGlobalData
        sRoomChanged = 1003, //Constant.commandRoomChanged
        cUpdateGlobalData,
        vUpdateGlobalData,
        vEnableUpdateToolbarsOffset,
        vStartUpdateToolbarsOffset,
        
        vShowNetworkError,
        vShowToolbars,
        vUpdateToolbarsOffset,
        vUpdateToolbarsVisibility,
        vDisableUpdateToolbarsOffset,
        
        // Edit profile
        vEditProfileFalse,
        vChangeAvatar,
        vChangeBackground,
        vUpdateAvatarSuccess,
        vUpdateAvatarFail,
        vUpdateBackgroundSuccess,
        vUpdateBackgroundFail,
        
        vSelectFollower,
        vUpdateLanguage,
        
        vGetTranscriptionSuccess
    
}
