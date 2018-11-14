//
//  UNKConstant.h
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#ifndef UNKConstant_h
#define UNKConstant_h

#define kUserDefault [NSUserDefaults standardUserDefaults]
// code for get screen size
#define kiPhoneWidth [[UIScreen mainScreen] bounds].size.width
#define kiPhoneHeight [[UIScreen mainScreen] bounds].size.height

// code for get current device screen size difference
#define kIs_Iphone4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define kIs_Iphone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define kIs_Iphone6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define kIs_Iphone6PLUS ([[UIScreen mainScreen] bounds].size.height == 736)


//// staging
//#define kAPIBaseURL @"http://staging.sirez.com/BrownAndGreens/FeederREST/"
//#define kOFFERBASEURL @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Promotions/"
//#define kImageUrl @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Products/"
//#define kBImageUrlProducts @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Products/"

// producion
#define kAPIBaseURL @"http://api.brownandgreens.com.au/"
#define kOFFERBASEURL @"http://cp.brownandgreens.com.au/avatars/Promotions/"

#define kProfileImageBaseUrl @"http://api.brownandgreens.com.au/avatars/Customers/"
#define kBCatImageUrl @"http://cp.brownandgreens.com.au/avatars/Category/"
#define kImageUrl @"http://cp.brownandgreens.com.au/avatars/Products/"
#define kBImageUrlProducts @"http://cp.brownandgreens.com.au/Products"

#define KPaymentPageUrl @"http://cp.brownandgreens.com.au/PG_CommBank_Prod.html"
#define KpaymentMerchentName @"merchant.BROGRECOM201"
#define KpaymentMerchentURL @"BROGRECOM201"
#define KPaymentMerchantpassword @"7c1e40469b27d697df29dc03ce60ea60"
#define KPaymentLink @"https://paymentgateway.commbank.com.au/api/rest/version/44/merchant/"


// Staging
/*#define kAPIBaseURL @"http://staging.sirez.com/BrownAndGreens/FeederREST/"
#define kOFFERBASEURL @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Promotions/"

#define kProfileImageBaseUrl @"http://staging.sirez.com/BrownAndGreens/FeederREST/avatars/Customers/"
#define kBCatImageUrl @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Category/"
#define kImageUrl @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Products/"

#define kBImageUrlProducts @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Products/"
 #define KpaymentMerchentName @"merchant.TESTBROGRECOM201"
 #define KpaymentMerchentURL @"TESTBROGRECOM201"
 #define KPaymentMerchantpassword @"3b97d2fad31be5cd0dae5ada7942b4b5"
 #define KPaymentLink @"https://paymentgateway.commbank.com.au/api/rest/version/44/merchant/"
#define KPaymentPageUrl @"http://staging.sirez.com/BrownAndGreens/Admin/pg.html"
*/


//
//#define kAPIBaseURL @"http://52.62.252.62/"
//#define kOFFERBASEURL @"http://52.62.210.52/avatars/Promotions/";
//#define kProfileImageBaseUrl @"http://52.62.252.62/avatars/Customers/"
//#define kBCatImageUrl @"http://52.62.210.52/avatars/Category/"
//#define kImageUrl @"http://52.62.210.52/avatars/Products/"
//#define kBImageUrlProducts @"http://52.62.210.52/Products"



#define SENDSMSMAIL @"SZOrders.svc/SendSMSNotificationAndMailOnPayment_V4"
#define GETSUMMARYDETAILS @"SZCustomers.svc/GetCustomerAccountSummary"
#define GETCREDITSUMMARY @"IOFCustomers.svc/GetCustomerCreditSummary_V2"
#define GETCREDITDETAILS @"IOFCustomers.svc/GetCustomerCreditDetails"



//#define kBCatImageUrl @"http://staging.sirez.com/IOF/Admin/avatars/Category/"
//#define kBCatImageUrl @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Category/"
//#define kCatImageUrl @"http://www.iorderfresh.com/CONTROLPANEL/avatars/Category/"


////STAGGING
//#ifdef StagingServer
//
//#else
//
//#endif


#define RemovePromoCode @"generics.svc/RemovePromoCode"


#define DATEWISEORDER @"IOFCustomers.svc/getDateWiseOrdeSummaryV2"
#define SIGNUP @"SZCustomers.svc/UserSignUp"
#define SIGNIN @"SZCustomers.svc/CustomerLogin"
#define GETCUTOFFTIME @"generics.svc/GetCutOffTime_V3"
#define GETUPDATEDTABELRECORDS @"generics.svc/GetTableRecords_v6"
#define PLACEORDEROT @"SZOrders.svc/AddCustomerOrderDetails_V7"

#define COLLECTAMMOUNT @"SZOrders.svc/CollectableAmtNotConfirmedOrder_V4"
#define UPDATEONETIMEORDER @"SZOrders.svc/UpdateOneTimeOrder_V6"
#define FAMILYLOGIn @"IOFCustomers.svc/CustomerLoginByFamilyCode"
#define GETUPCOMINGORDER @"IOFCustomers.svc/getCustomerOrderSchedule_V3"
#define GETAUTOSHIPOREDERS @"IOFCustomers.svc/GetMyAutoShipOrder_V2"
#define CANCELORDER @"SZCustomers.svc/CustomerOrderCancelRequestV3"
#define GETMYCREDIT @"SZCustomers.svc/GetMyCreditDetails"
#define GETMULTIORDER @"IOFCustomers.svc/CustomerMultiOrderCancel"
#define GETPAYMENTHISTORY @"IOFCustomers.svc/CustomerPaymentHistoryDetails"
#define CHANGEPASS @"SZCustomers.svc/ResetPassword"
#define VERIFYOTP @"SZCustomers/VerifyPhone"
#define FORGOTPASS @"SZCustomers.svc/ForgotPassword"
#define SENDOTP @"SZCustomers.svc/ResendActivationCode"
#define ACTIVATECUSTOMERACC @"SZCustomers.svc/ActivateCustomerAccount"
#define ORDERBYMSG @"IOFCustomers.svc/UpdateContacts"
#define UPDATEPROFILE @"SZCustomers.svc/CustomerEditProfile"
#define GETINVOICE @"IOFOrders.svc/GetInvoiceByUserv2"
#define GETINVOICEDETAIL @"SZOrders.svc/GetInvoiceDetailsByUser"
#define GETCHECKUSEREXISTANCE @"SZCustomers.svc/ISCustomerExistsSM"
#define AUTOSHIPORDERQUNTUPDATE @"IOFCustomers.svc/UpdateAutoshipProduct_V3"
#define OFFER @"Generics.svc/GetPromotion"
#define BANNER @"Generics.svc/GetBanners"
#define AUTOSHIPPRODUCTADD @"IOFProducts.svc/AddAutoShipProduct"
#define CUSTOMERONETIMEORDER @"IOFOrders.svc/CustomerOneTimeOrder"
#define UPDATEAUTOSHIPDAYS @"IOFOrders.svc/UpdateAutoshipDay"
#define GETNOTIFICATION @"generics.svc/GetIOSNotification"
#define GETACCDETAILS @"SZCustomers.svc/GetCustomerAccountDetails"
#define GERNERATECHECKSUMURL @"http://staging.sirez.com/IOF/Admin/AdminAccount/GenerateChecksum.aspx"
#define CHECKORDERSTATUS @"IOFOrders.svc/CheckOrderStatus"
#define GetCustomer @"SZCustomers.svc/GetCustomerUsingId"
#define GetOrderFeedback @"IOFCustomers.svc/OrderFeedback"
#define VERIFYCHECKSUMURL @"http://staging.sirez.com/IOF/Admin/AdminAccount/VerifyCheckSum.aspx"
#define GETREFFERALAMOUNT @"IOFCustomers.svc/CustomerReferralDetails"
#define getAppVersion @"generics.svc/GetAppVersion"
#define getAppVersionV2 @"generics.svc/GetAppVersionV2"
#define GetPayUHash @"IOFCustomers.svc/GeneratePayUChecksum"
#define GetPayUProviders @"IOFCustomers.svc/GetPGProvider"
#define PROFILEIMAGEURL @"avatars/Customers/"
#define GetMobileNotification @"generics.svc/GetMobileNotification"
#define kPaymentUpdateCommBank @"SZCustomers.svc/PaymentUpdateCommBank"
#define KPaymentVerifyCommBank @"SZCustomers.svc/PaymentVerifyCommBank"
#define CODE @"Code"
#define OK @"OK"
#define ERRORMSG @"Message"
#define STATUS @"Status"
#define PayUPaymentResponse @"IOFCustomers.svc/PayUPaymentResponse"


#define kAPIResponseTimeout 60

//FONTS

#define kFontSFUITextRegular @"SFUIText-Regular"
#define kFontSFUITextRegularBold @"SFUIText-Bold"
#define kFontSFUITextSemibold @"SFUIText-Semibold"
#define kFontSFUITextLight @"SFUIText-Light"
#define kFontSFUITextMedium @"SFUIText-Medium"
#define kDefaultFontForTextField [UIFont fontWithName:@"SFUIText-Light" size:14]
#define kDefaultFontForTextFieldMeium [UIFont fontWithName:@"SFUIText-Medium" size:14]
#define kDefaultFontForApp kDefaultFontForTextField
#define kDefaultFontForNavigationBarTitle [UIFont fontWithName:@"SFUIText-Medium" size:17]

//Dictionary Options
#define kTextFeildOptionPlaceholder @"placeholder"
#define kTextFeildOptionFont @"font"
#define kTextFeildOptionKeyboardType @"keyboardtype"
#define kTextFeildOptionReturnType @"returntype"
#define kTextFeildOptionAutocorrectionType @"autocorrectiontype"
#define kTextFeildOptionAutocapitalizationType @"autocapitalizationtype"
#define kTextFeildOptionIsPassword @"secureField"
#define BGError @""
#define kUNKCUSTOMError @"Brown & Green Custom Error"

#define kDefaultLightGreen [UIColor colorWithRed:143.0f/255.0f green:193.0f/255.0f blue:21.0f/255.0f alpha:1.0]


#define kAPICode @"Code"
#define kAPIPayload @"Payload"
#define kAPIErrorCode @"errorCode"
#define kAPIMessage @"Message"
#define kAPISuccess @"Success"
#define kAPIError @"Error"
#define kTempId @"tempId"
#define kGuestUser @"guestUser"
#define kGuestUserInComingScreen @"GuestUserInComingScreen"



// Login and register
#define kGender @"gender"
#define kimage_url @"image_url"
#define kSocialId @"socialid"
#define kfirstname  @"FirstName"
#define klastname @"LastName"
#define kMobileNumber @"MobileNumber"
#define kEmail @"Email"
#define kPassword @"Password"
#define kCountry @"country"
#define kCity @"city"
#define kRegister_type @"register_type"
#define kStype  @"stype"
#define kDeviceToken  @"deviceToken"
#define kDeviceType  @"DeviceType"
#define kProfileImage @"profileImage"
#define KDOB @"DOB"
#define KOTP @"otp"
#define Kuser_name @"user_name"
#define Kusername @"username"
#define Kuserid @"userid"
#define kProfile_image @"profile_image"
#define kSocial @"social"
#define kMyProfile @"My Profile"
#define kLoginStatus @"LoginStatus"
#define klogin @"login"
#define kdeviceId @"DeviceId"
#define krememberMe @"rememberMe"
#define kCityId @"CityId"
#define kLoginInfo @"LoginInfo"
#define kFamilyCode @"FamilyCode"
#define kReferralCode @"ReferralCode"
#define kImageName @"ImageName"
#define kAddress1 @"Address1"
#define kAddress2 @"Address2"
#define kZipCode @"ZipCode"
#define kZipcode @"Zipcode"
#define kRegistration @"Registration"
#define kLocalityId @"LocalityId"
#define kOtherState @"OtherState"
#define kOtherCity @"OtherCity"
#define kOtherLocation @"OtherLocation"
#define kFbUserID @"FbUserID"
#define kGoogleUserID @"GoogleUserID"
#define kTwitterUserID @"TwitterUserID"
#define kCityList @"cityList"
#define kStateList @"stateList"
#define kLocationName @"LocationName"
#define kRefCityName @"RefCityName"
#define kRefCountryId @"RefCountryId"
#define kRefStateId @"RefStateId"
#define kRefStateName @"RefStateName"

#define kTrakingID @"UA-97530226-1"

typedef enum _UNKWebViewMode {
    BGScholarShip = 101,
    BGAboutUs = 102,
    BGTermAndConditions = 103,
    BGNews = 104,
    BGImportantLink = 105,
    BGFeturedDestination = 106,
    BGContactUs = 107,
    BGFoodLegislation = 108
} UNKWebViewMode;

#define kCatList @"CategoryList"
#define kSubCatList @"SubCategoryList"
#define kProductList @"ProductsList"
#define kPriceList @"ProductPriceList"
#define kLocationList @"LocationList"
#define kIORDERFRESHTRAIL @"SZTrail"
#define kCatID @"CategoryID"
#define kCatParentID @"ParentCategoryID"
#define kCatName @"CategoryName"
#define kCatDesc @"CategoryDesc"
#define kCatImage @"CategoryImage"
#define kCatType @"CategoryType"
#define kCatActive @"IsActive"
#define kCatDeleted @"IsDeleted"
#define kCatDate @"CreatedOn"
#define kSubCatID @"CategoryID"
#define kCatParentID @"ParentCategoryID"
#define kCatName @"CategoryName"
#define kCatDesc @"CategoryDesc"
#define kCatImage @"CategoryImage"
#define kCatType @"CategoryType"
#define kCatActive @"IsActive"
#define kCatDeleted @"IsDeleted"
#define kCatDate @"CreatedOn"
#define kActivationCode @"ActivationCode"

#define kFirstName @"FirstName"
#define kMobileNumber @"MobileNumber"
#define kCustomerEmail @"CustomerEmail"
#define kCustomerID @"CustomerID"
#define kCreditLimit @"CreditLimit"
#define kCityId @"CityId"
#define kCityName @"CityName"
#define  kCustomerType @"CustomerType"
#define kIsFirstLogin @"IsFirstLogin"
#define kmemberStatus @"memberStatus"

#pragma mark - Facebook Notification
#define GetFacebookUserInfoNotification               @"GetFacebookUserInfoNotification"
#define GetFacebookAccessToken @"GetFacebookAccessToken"


#pragma mark NewApis
#define GetDeliverySlot @"generics.svc/GetDeliverySlot"


#define kViwMode @"viewMode"
#define kEditMode @"editMode"
#define kMyProfile @"My Profile"
#define kForgotPassword @"forgotPassword"
#define kOrderSummary @"OrderSummary"
#define kOffer @"Offer"
#define kProduct @"Product"
#define kGlobalSearch @"globalSearch"
#define kRevealMenu @"revealMenu"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#define kChangePassword @"ChangePassword"

#define kEditMyOrder @"editMyOrder"
#define kReOrder @"reOrder"
#define kContactUs @"contactUs"
#define kFood Legislation @"Food Legislation"
#define kfromKramPoint @"fromKarmaPoint"
#define kFoodLegislation @"Food Legislation"

//segues identifier

#define kverifyOTPSegueIdentifier @"verifyOTPSegueIdentifier"
#define ksetPasswordSegueIdentifier @"setPasswordSegueIdentifier"
#define kregistrationSegueIdentifier @"registrationSegueIdentifier"
#define kuserSelectionSegueIdentifier @"userSelectionSegueIdentifier"
#define khomeSegueIdentifier @"homeSegueIdentifier"
#define kSignInViewSegueIdentifier @"SignInViewSegueIdentifier"
#define kproductDetailSegueIdentifier @"productDetailSegueIdentifier"
#define kdeliveyScheduleSegueIdentifier @"deliveyScheduleSegueIdentifier"
#define korderSummarySegueIdentifier @"orderSummarySegueIdentifier"
#define ksettingSegueIdentifier @"settingSegueIdentifier"
#define kwebviewSegueIdentifier @"webViewSegueIdentifier"
#define kcontactUSegueIdentifier @"contactUSegueIdentifier"
#define knotificationSegueIdentifier @"notificationSegueIdentifier"
#define kofferSegueIdentifier @"offerSegueIdentifier"
#define kPaymentOptionSegueIdentifier @"PaymentOptionSegueIdentifier"
#define kthankyouSegueIdentifier @"thankyouSegueIdentifier"
#define kMyCartStoryBoardID @"MyCartStoryBoardID"
#define kmyCartSegueIdentifier @"myCartSegueIdentifier"
#define kDonateVCSegueIdentifier @"DonateVCSegueIdentifier"
#define ktopDonorSegueIdentifier @"topDonorSegueIdentifier"
#define kMyOrderSegueIdentifier @"MyOrderSegueIdentifier"
#define kMyDonationSegueIdentifier @"MyDonationSegueIdentifier"
#define kkarmaPointSegueidentifier @"karmaPointSegueidentifier"
#define kfeedbackIdentifier @"feedbackIdentifier"
#define kVerify @"verifySegueidentifier"
#define KproductDetail @"VerifyToProductDetailSegueidentifier"

// otp verify
#define kmembershipId @"membershipId"
#define kproductCount @"productCount"
#define kAddItemPrice @"AddItemPrice"
#define kRequestTextField @"RequestTextField"
#define ApplyPromoCodeAPI @"generics.svc/ApplyPromoCode"
#define ViewPromoCodeAPI @"generics.svc/GetPromoOfferList"

// notification
#define kType @"type"
#define kNotificationMsg @"NotificationMsg"
#define kReadStatus @"readStatus"
#define kNotificationId @"notificationId"
#define kTotal @"total"
#define kTotalUnread @"totalUnread"
#define kNotifications @"notifications"
#define kCreatedOn @"CreatedOn"
#define kMyCartInGuestUser @"MyCartInGuestUser"

#define KAge @"Age"

#define kTutorial @"Tutorial"
#define kguestLoginTutorial @"guestLoginTutorial"
#define khomeTutorial @"homeTutorial"
#define kscheduleTutorial @"scheduleTutorial"
#define kkramTutorial @"krmaTutorial"
#define kMyOrderTutorial @"MyOrderTutorial"

#endif /* UNKConstant_h */

