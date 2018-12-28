//
//  GlobalConstants.h
//  ARKitImageRecognition
//
//  Created by Zeeshan on 11/06/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#ifndef GlobalConstants_h
#define GlobalConstants_h

typedef enum
{
    ButtonNodeCall = 1,
    ButtonNodeURL,
    ButtonNodeWhatsApp,
    ButtonNodeEmail,
    ButtonNodeSaveContact,
    ButtonNodeDefault
} ButtonNodeType;

//#define msgboxWithTitle:(NSString *)title message:(NSString *)message andButton:(NSString *)button

#define SCREENNAME_VISIONCODE_SCANNER @"CodeScanner"
#define SCREENNAME_MARKERBASE @"MarkerBase"
#define SCREENNAME_MARKERLESS @"MarkerLess"
#define SCREENNAME_RECENTS @"RecentCodes"
#define SCREENNAME_FAVOURITE @"Favourite"
#define SCREENNAME_TUTORIAL @"Tutorial"
#define SCREENNAME_SUPPORT @"Support"
#define SCREENNAME_SETTINGS @"Settings"
#define SCREENNAME_URLBROWSER @"URLBrowser"
#define SCREENNAME_VIDEO360 @"VIDEO360"

#define EVENT_VISIONCODE_SCANNED @"CodeScanned"
#define EVENT_VISIONCODE_TYPED @"CodeTyped"
#define EVENT_CAMPAIGNVIEWED @"CampaignViewed"
#define EVENT_CAMPAIGNDOWNLOADED @"CampaignDownloaded"
#define EVENT_ACTION_TRIGGER @"ActionEvent"
#define EVENT_ACTION_VIEWS @"AssetViews"
#define EVENT_ASSET_INTERACT @"AssetInteract"

#define EVENT_LATITUDE @"latitude"
#define EVENT_LONGITUDE @"longitude"
#define EVENT_LANGUAGE @"language"
#define EVENT_GENDER @"gender"
#define EVENT_BIRTHYEAR @"birthyear"

#define EVENT_TRIGGER_TAP @"TriggerTap"
#define EVENT_TRIGGER_FINISH @"TriggerFinish"
#define EVENT_TRIGGER_TYPE @"TriggerType"
#define EVENT_ASSET_VIEW @"Show"
#define EVENT_ASSET_HIDE @"Hide"

#define EVENT_PLAY_VIDEO @"PlayVideo"
#define EVENT_PLAY_AUDIO @"PlaySound"

#define EVENT_CAMPAIGN_ID @"CampaignID"
#define EVENT_ASSET_ID @"AssetId"
#define EVENT_ACTION_TYPE @"ActionType"
#define EVENT_DEVICEID @"userDeviceID"

#define EVENT_ASSET_TYPE @"AssetType"
#define EVENT_ACTION_VALUE @"Value"
#define EVENT_ASSET_BUTTON @"button"
#define EVENT_ASSET_IMAGE @"image"
#define EVENT_ASSET_Video @"video"
#define EVENT_ASSET_Text @"text"
#define EVENT_ASSET_Contact @"savecontact"
#define EVENT_ASSET_EVENT @"saveevent"

// UI Parameters
#define SIDEMENU_WIDTH 300
#define NAVIGATIONBAR_BACKGROUND_COLOR @"#0D1D22"
#define THEME_COLOR @"#25C8FF"
#define GRAY_COLOR @"#7E949A"
#define DARK_GRAY_COLOR @"#0D1D22"
#define SIDEMENU_BUTTON_GRAY_COLOR @"#0A242B"

#define SCREENTITLE_RECENT @"Recent"
#define SCREENTITLE_FAVOURITE @"Favourite"
#define SCREENTITLE_TUTORIAL @"Tutorial"
#define SCREENTITLE_SETTING @"Settings"
#define SCREENTITLE_SUPPORT @"Support"

// User default keys
#define RECENTVISION_CODES_KEYS @"recentVisionCodes1"
#define FAVOURITEVISION_CODES_KEYS @"favouriteVisionCodes"

// Messages
#define TITLE_ALERT @"Alert"
#define MESSAGE_CODE_NOTFOUND @"Invalid Vision Code"
#define MESSAGE_SERVER_JSON_NOTFOUND @"Unexpected System Response"

// JSON defines keys
#define SCENES_JSON_KEY @"scenes"
#define MARKER_JSON_KEY @"marker"
#define MARKERIMAGEURL_JSON_KEY @"markerimage"
#define MARKERNAME_JSON_KEY @"name"
#define MARKERSCALEX_JSON_KEY @"scalex"
#define MARKERSCALEY_JSON_KEY @"scaley"
#define MARKERSCALEZ_JSON_KEY @"scalez"
#define SLAMUI_JSON_KEY @"slamui"

#define OBJECTS_JSON_KEY @"objects"
#define MODEL_JSON_KEY @"model"
#define OBJECT_OFF_JSON_KEY @"objoff"
#define THUMBNAIL_OFF_JSON_KEY @"thumbnailoff"

#define ASSET_JSON_KEY @"asset"
#define TYPE_JSON_KEY @"type"
#define TRANSFORM_JSON_KEY @"transform"
#define APPEARANCE_JSON_KEY @"appearance"
#define TRANSITION_JSON_KEY @"transitions"
#define ACTIONS_JSON_KEY @"actions"
#define UUID_JSON_KEY @"AssetID"
#define POSX_JSON_KEY @"posx"
#define POSY_JSON_KEY @"posy"
#define POSZ_JSON_KEY @"posz"
#define WIDTH_JSON_KEY @"width"
#define HEIGHT_JSON_KEY @"height"
#define SCALEX_JSON_KEY @"scalex"
#define SCALEY_JSON_KEY @"scaley"
#define SCALEZ_JSON_KEY @"scalez"
#define ROTATE_X_JSON_KEY @"rotatex"
#define ROTATE_Y_JSON_KEY @"rotatey"
#define ROTATE_Z_JSON_KEY @"rotatez"
#define TITLE_JSON_KEY @"title"
#define DESCRIPTION_JSON_KEY @"description"
#define PRICE_JSON_KEY @"price"
#define ACTIONBUTTONS_JSON_KEY @"actionbuttons"
#define ACTIONBUTTON_TITLE_JSON_KEY @"actiontitle"

#define BACKGROUND_JSON_KEY @"background"
#define VIDEOURL_JSON_KEY @"videourl"
#define TEXTCOLOR_JSON_KEY @"textcolor"
#define SOUNDURL_JSON_KEY @"soundurl"
#define BORDER_JSON_KEY @"border"
#define PARAMETERS_JSON_KEY @"parameters"
#define TRIGGER_JSON_KEY @"trigger"
#define VALUE_JSON_KEY @"value"
#define DURATION_JSON_KEY @"duration"
#define LENGTH_JSON_KEY @"length"
#define DEPTH_JSON_KEY @"depth"
#define DELAY_JSON_KEY @"delay"
#define EMAIL_JSON_KEY @"emailaddress"
#define SUBJECT_JSON_KEY @"subject"
#define BODY_JSON_KEY @"body"
#define CAROUSELIMAGES_JSON_KEY @"images"
#define CAROUSEL_URLIMAGE_JSON_KEY @"url"
#define ROTATION_JSON_KEY @"rotation"
#define THUMBNAIL_JSON_KEY @"thumbnail"
#define MATERIAL_JSON_KEY @"mat"
#define OBJECT_JSON_KEY @"obj"
#define TEXTURE_JSON_KEY @"texture"
#define PLAYONSTART_JSON_KEY @"playonstart"
#define LOOPVIDEO_JSON_KEY @"loopvideo"

//Save Contact JSON
#define IMAGE_JSON_KEY @"image"
#define FNAME_JSON_KEY @"firstname"
#define LNAME_JSON_KEY @"lastname"
#define COMPANYNAME_JSON_KEY @"companyname"
#define EMAILADDRESS_JSON_KEY @"emailaddress"
#define MOBILE_JSON_KEY @"mobile"
#define PHONE_JSON_KEY @"phone"
#define POSTALADDRESS_JSON_KEY @"postaladdress"
#define WEBSITE_JSON_KEY @"website"
#define FACEBOOK_JSON_KEY @"facebook"
#define TWITTER_JSON_KEY @"twitter"
#define LINKEDIN_JSON_KEY @"linkedin"
#define YOUTUBE_JSON_KEY @"youtube"

// Asset Type
#define NODE_TYPE_Button @"button"
#define NODE_TYPE_Text @"text"
#define NODE_TYPE_Image @"image"
#define NODE_TYPE_Video @"video"
#define NODE_TYPE_Model @"model"
#define NODE_TYPE_Contact @"contact"
#define NODE_TYPE_Event @"event"
#define NODE_TYPE_Sound @"sound"

// Application Keywords
#define NODE_TYPE_KEY @"nodeType"

// Transitions Json Keywords
#define FADEIN_TRANSITION_KEY @"fadein"
#define FADEOUT_TRANSITION_KEY @"fadeout"
#define SLIDEINFROMLEFT_TRANSITION_KEY @"slideinfromleft"
#define SLIDEINFROMRIGHT_TRANSITION_KEY @"slideinfromright"
#define SLIDEINFROMTOP_TRANSITION_KEY @"slideinfromtop"
#define SLIDEINFROMBOTTOM_TRANSITION_KEY @"slideinfrombottom"
#define SCALEUPWITHFADE_TRANSITION_KEY @"scaleupwithfade"
#define SCALEDOWNWITHFADE_TRANSITION_KEY @"scaledownwithfade"
#define SLIDEOUTFROMLEFT_TRANSITION_KEY @"slideouttoleft"
#define SLIDEOUTFROMRIGHT_TRANSITION_KEY @"slideouttoright"
#define SLIDEOUTFROMTOP_TRANSITION_KEY @"slideouttotop"
#define SLIDEOUTFROMBOTTOM_TRANSITION_KEY @"slideouttobottom"

// Actions Json Keywords
#define CALL_ACTION_KEY @"call"
#define COMPOSE_EMAIL_ACTION_KEY @"composeemail"
#define SAVECONTACT_ACTION_KEY @"savecontact"
#define SAVEEVENT_ACTION_KEY @"generatevent"
#define URL_ACTION_KEY @"url"
#define SCALLING_ACTION_KEY @"scalling"
#define VIDEO360_ACTION_KEY @"video360"
#define HOSTMESSAGE_ACTION_KEY @"hostappmessage"
#define GOTOSCENE_ACTION_KEY @"gotoscene"
#define REPLAYVIDEO_ACTION_KEY @"replay"
#define AUDIOPLAY_ACTION_KEY @"audio"
#define WHATSAPP_ACTION_KEY @"whatsapp"
#define VIBERAPP_ACTION_KEY @"viberapp"
#define FBMESSENGER_ACTION_KEY @"fbmessenger"
#define ENLARGEIMAGE_ACTION_KEY @"enlarge"
#define CAROUSEL_ACTION_KEY @"carousel"
#define DESCRIPTIONBOX_ACTION_KEY @"descriptionbox"

#define BAVEL_BORDER_TYPE_JSON_KEY @"bevel"
#define SQUARE_FLAT_BORDER_TYPE_JSON_KEY @"squareflat"
#define SQUARE_INDENTED_BORDER_TYPE_JSON_KEY @"squareindented"
#define ROUNDED_CORNER_BORDER_TYPE_JSON_KEY @"roundedflat"
#define ROUNDED_RAISED_BORDER_TYPE_JSON_KEY @"roundedraised"
#define POLARIOD_BORDER_TYPE_JSON_KEY @"polaroid"
#define SQUARE_RAISED_BORDER_TYPE_JSON_KEY @"squareraised"

// Trigger Json keywords
#define TAP_TRIGGER_KEY @"tap"
#define PINCH_TRIGGER_KEY @"pinch"
#define ONVIDEOFINISH_TRIGGER_KEY @"onvideofinish"
#define ONSOUNDFINISH_TRIGGER_KEY @"onsoundfinish"

//Local Notifications
#define SHOWDESCRIPTIONPOPUP_NOTIFICATION_KEY @"showDescriptionBoxForModel"
#define SHOWDESCRIPTIONPOPUP_MARKERBASE_NOTIFICATION_KEY @"showDescriptionBoxForMarkerBaseModel"

#define SHOWPOPUP_NOTIFICATION_KEY @"ShowPopup"
#define ENLARGEIMAGE_NOTIFICATION_KEY @"ShowEnlargeImage"
#define SHOWCAROUSEL_NOTIFICATION_KEY @"showCarouselImagesWithArray"
#define REFRESH_ARSCENE_NOTIFICATION_KEY @"refreshJSON"
#define SHOWNOTIFICATION_CONTENT_ICONS @"showcontenticonscampaignview"
#define SHARE_STRING @"Check out the great AR"
#define SHARE_URL @"http://www.evolvear.io"

#endif /* GlobalConstants_h */
