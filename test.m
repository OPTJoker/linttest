//
//  JZBusinessManager.m
//  Lianjia_Beike_HomeWork_Base
//
//  Created by 战明 on 2022/6/30.
//

#import "JZBusinessManager.h"
#import "JZUtil.h"
#import "LJBaseAPI.h"
#import "JZUserService.h"
#import "JZIMApiService.h"
#import <LJMHLAppGlobal/LJAppConfig.h>
#import "NSDictionary+Safe.h"
#import <LJNetworkService/LJNetworkService.h>
#import <YYModel/YYModel.h>
#import "JZIMBussiness.h"
#import "JZInputAlertViewController.h"
#import "JZAppConfig.h"
#import <LJBaseToolKit/UIColor+LJExtra.h>
#import <Lianjia_DigitalUnionSDK/LJBaseDigitalUnionManager.h>
#import "JZBaseKit.h"
#import <Lianjia_Beike_HomeWork_Base/JZEngineMacroDef.h>
#import "LJBeikeBaseRequest.h"
#import "JZToast.h"
#import <LJProgressHUDHelper/LJProgressHUDHelper.h>
#import "LJRouter.h"
#import "JZStatistics.h"
#import <Lianjia_Beike_Base/LJNavigator.h>
#import <YYModel/NSObject+YYModel.h>
#import <LJBaseToolKit/NSDictionary+LJJSONString.h>
#import <LJBaseRouter/LJRouter.h>
#import "JZPrivateDomainCustomerAssistantDataManager.h"

//*****************************************************************************
//  文档:https://wiki.lianjia.com/pages/viewpage.action?pageId=1099139105
//  UI :https://mark-tree.ke.com/UI-Template/v1/index.html?patchId=3412
//  展位ADID:https://wiki.lianjia.com/pages/viewpage.action?pageId=1102571720
//  埋点:http://compass.ke.com/buryPoint/infoManage/demand/detail/119
//*****************************************************************************

@implementation JZBusinessManager

LJRouterUsePage(login_center, (NSInteger)from, (NSInteger)currentLoginType, (__nullable dispatch_block_t)completeBlock);

/// parametersBlcok 返回格式
/// contentId:页面请求使用的ID
/// contentType:表示哪个页面
/// contentTitle:页面的title
/// pageTitle:页面名称
/// 例如：{@"contentId":@"", @"contentType":@(2), @"pageTitle":@"案例详情页", @"contentTitle":@""}
/// type 1:400  2:IM

    if (type == JZBusinessOpportunity400AndIMType400) {
        [JZBusinessManager request400WithAdId:adId uiCode:uiCode parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
            JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:parametersBlcok?parametersBlcok():@{}];
            return payloadMode;
        } successBlock:nil failureBlock:nil];
    } else {
        [JZBusinessManager requestIMWithAdId:adId uiCode:uiCode parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
            JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:parametersBlcok?parametersBlcok():@{}];
            return payloadMode;
        } IMBlcok:^(IMInfoBlock  _Nonnull infoBlock) {
            JZBusinessOpportunityIMModel *model = [JZBusinessOpportunityIMModel new];
            model.message = IMMsg;
            infoBlock(model);
        } successBlock:nil failureBlock:nil];
    }
}


    [JZBusinessManager requestIMWithAdId:adId uiCode:uiCode parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
        JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:parametersBlcok?parametersBlcok():@{}];
        return payloadMode;
    } IMBlcok:^(IMInfoBlock  _Nonnull infoBlock) {
        JZBusinessOpportunityIMModel *model = [JZBusinessOpportunityIMModel new];
        model.message = IMMsg;
        model.cardId = @2;
        model.cardInfo = IMCardInfo;
        model.webSchema = IMClickUrl;
        infoBlock(model);
    } successBlock:nil failureBlock:nil];
}

/// 跳转装修顾问的开场白为纯文本内容
/// @param adId 展位ID
/// @param uiCode 页面的UICode
/// @param IMMsg 打招呼首句文本信息
/// @param parametersBlcok 参数
    LJRouterRegistAction(@"家装商机IM，纯文本消息", jz_business_IM_Text, void, (NSUInteger)adId, (NSString *)uiCode,(NSString *)IMMsg, (NSDictionary *(^)(void))parametersBlcok) {
    [JZBusinessManager requestIMWithAdId:adId uiCode:uiCode parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
        JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:parametersBlcok?parametersBlcok():@{}];
        return payloadMode;
    } IMBlcok:^(IMInfoBlock  _Nonnull infoBlock) {
        JZBusinessOpportunityIMModel *model = [JZBusinessOpportunityIMModel new];
        model.message = IMMsg;
        infoBlock(model);
    } successBlock:nil failureBlock:nil];
}

LJRouterRegistAction(@"家装商机请求400", decorate_clue_phone, void, (__nullable NSUInteger)adId, (__nullable NSString *)uiCode, (__nullable NSString *)pageTitle) {
    
    [JZBusinessManager request400WithAdId:adId
                                   uiCode:uiCode
                          parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
        JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel new];
        payloadMode.pageTitle = pageTitle;
        return payloadMode;
    } successBlock:nil failureBlock:nil];
}

LJRouterRegistAction(@"家装商机请求接口发消息", decorate_server, void, (__nullable NSUInteger)adId, (__nullable NSString *)action, (__nullable NSString *)params) {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:action forKey:@"action"];
    [parameters setValue:params forKey:@"params"];
    [LJBaseAPI getWithUrl:@"/api/proxy/decor/app/v1/scheme/server" parameters:parameters completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        
    }];
}

LJRouterRegistAction(@"家装商机曝光", jz_business_exposure, void, (NSString *)uiCode, (NSString *)type, (NSString *)btnText) {
    [JZBusinessManager exposureEventWithUiCode:uiCode type:type btnText:btnText BOModel:nil digAction:nil];
}

/// paramMap 可扩展的自定义参数（后端需要的字段）
/// parametersBlcok 返回格式
/// contentId:页面请求使用的ID
/// contentType:表示哪个页面
/// contentTitle:页面的title
/// pageTitle:页面名称
/// 例如：{@"contentId":@"", @"contentType":@(2), @"pageTitle":@"案例详情页", @"contentTitle":@""}
LJRouterRegistAction(@"请求接口留资——支持传入城市id+自定义参数", jz_business_clue, void, (NSUInteger)adId, (NSString *)uiCode, (_Nullable NSString *)cityId, (NSDictionary *)paramMap, (NSDictionary *(^)(void))parametersBlcok, (__nullable void(^)(void))successBlcok, (__nullable void(^)(NSError * _Nonnull error))failureBlock) {
    [JZBusinessManager requestClueWithAdId:adId uiCode:uiCode cityId:cityId paramMap:paramMap parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
        
        JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:parametersBlcok?parametersBlcok():@{}];
        return payloadMode;
    } successBlock:^{
        
        if (successBlcok) {
            successBlcok();
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

LJRouterRegistAction(@"请求接口留资-带自定义参数", jz_business_clue, void, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *)paramMap, (NSDictionary *(^)(void))parametersBlcok, (__nullable void(^)(void))successBlcok, (__nullable void(^)(NSError * _Nonnull error))failureBlock) {
    [self action_jz_business_clue_with_adId:adId uiCode:uiCode cityId:nil paramMap:paramMap parametersBlcok:parametersBlcok successBlcok:successBlcok failureBlock:failureBlock];
}

LJRouterRegistAction(@"请求接口留资", jz_business_clue, void, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *(^)(void))parametersBlcok, (__nullable void(^)(void))successBlcok, (__nullable void(^)(NSError * _Nonnull error))failureBlock) {
    [self action_jz_business_clue_with_adId:adId uiCode:uiCode paramMap:nil parametersBlcok:parametersBlcok successBlcok:successBlcok failureBlock:failureBlock];
}

/// 废弃!!! 请统一使用 jz_present_clue_pop action
LJRouterRegistAction(@"废弃，请使用jz_present_clue_pop", jz_business_clue_pop, void, (NSDictionary *)clueTextInfoDic, (NSString *)btnText, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *(^)(void))parametersBlcok) {
    JZBusinessOpportunityBounceContentModel *contentModel = [JZBusinessOpportunityBounceContentModel yy_modelWithJSON:clueTextInfoDic];
    [JZBusinessManager cluePopWithClueTextInfo:contentModel btnText:btnText adId:adId uiCode:uiCode parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
        JZBusinessOpportunityPayloadModel *payloadMode = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:parametersBlcok?parametersBlcok():@{}];
        return payloadMode;
    }];
}

/*
 在TOPVC展示家装留资弹窗
 - Parameters:
 - adId: pm申请的展位ID，可在精卫平台查询
 - uiCode: uiCode
 - uiConfig: 字典，包含如下字段：String *[title, subTitle, buttonText, toastText]
 - paramMap: 后端无特殊要求，传空就行。这是之前家装后端要求我们给IM透传数据用的
 - payloadMap: 字典，包含如下字段：String [contentId, contentTitle, *pageTitle]

 - * * * 使用方法：* * *
 
 第1步 在.m UseAction：
 LJRouterUseAction(jz_present_clue_pop, void, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *)uiConfig, (NSDictionary *)paramMap, (NSDictionary *)payloadMap);
 
 第2步 构建参数并调用action：
 
 NSDictionary *config = @{
     @"title": @"预约上门量房服务",
     @"subTitle": @"与装修顾问沟通，预约上门服务时间",
     @"buttonText": @"立即咨询",
     @"toastText": @"预约成功，装修顾问会在24小时内联系您，请保持电话畅通",
 };

 NSDictionary *payLoad = @{
     @"contentId": @"", //可为空
     @"contentTitle": @"", //可为空
     @"pageTitle": @"小区详情页-家装聚焦盘",
     @"gbCode": CHECK_VALID_STRING(self.infoModel.cityId) ? self.infoModel.cityId : LJ_APP_CONFIG.setting.cityId // 支持跨城cityId
 };
 
 action_jz_present_clue_pop_with_adId_uiCode_uiConfig_paramMap_payloadMap(10086, @"uiCode", config, nil, payLoad);
 
*/
LJRouterRegistAction(@"家装留电话咨询弹窗", jz_present_clue_pop, void, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *)uiConfig, (NSDictionary *)paramMap, (NSDictionary *)payloadMap) {
    
    NSDictionary *uiConfigJson = [self convertJsonStr:uiConfig];
    NSDictionary *paramJson = [self convertJsonStr:paramMap];
    NSDictionary *payloadJson = [self convertJsonStr:payloadMap];
    
    
    JZBusinessOpportunityBounceContentModel *uiInfo = [JZBusinessOpportunityBounceContentModel yy_modelWithDictionary:uiConfigJson];
    
    [JZBusinessManager cluePopWithBOModel:nil BtnModel:nil btnText:uiInfo.buttonText clueTextInfo:uiInfo adId:adId uiCode:uiCode isWorkTime:NO paramMap:paramJson parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
        JZBusinessOpportunityPayloadModel *pm = [JZBusinessOpportunityPayloadModel yy_modelWithDictionary:payloadJson];
        return pm;
    }];
}

LJRouterRegistAction(@"自动上报留资", jz_present_clue_report, void, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *)uiConfig, (NSDictionary *)paramMap, (NSDictionary *)payloadMap) {
    
    [JZUserService checkLogin:^(BOOL direct) {
        NSDictionary *uiConfigJson = [self convertJsonStr:uiConfig];
        NSDictionary *paramJson = [self convertJsonStr:paramMap];
        NSDictionary *payloadJson = [self convertJsonStr:payloadMap];
        __block NSString *toast = uiConfigJson[@"toastText"];
        
        JZBusinessOpportunityBounceContentModel *uiInfo = [JZBusinessOpportunityBounceContentModel yy_modelWithDictionary:uiConfigJson];
        
        JZBusinessOpportunityPayloadModel *pm = [JZBusinessOpportunityPayloadModel yy_modelWithDictionary:payloadJson];
        [JZBusinessManager requestClueWithAdId:adId uiCode:uiCode cityId:nil paramMap:paramJson parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
            return pm;
        } successBlock:^{
            if (!IsStrEmpty(toast)) {
                [JZToast showMessage:toast];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
#ifdef DEBUG
            [JZToast showMessage:[NSString stringWithFormat:@"留资失败\n%@", error]];
#else
            [JZToast showMessage:@"出错啦~"];
#endif
        }];
    }];
}



LJRouterRegistAction(@"家装打开微信APP", jz_business_open_wechat, BOOL, (NSString *)wxLink) {
    NSURL *tempUrl = [NSURL URLWithString:wxLink];
    if ([[UIApplication sharedApplication] canOpenURL:tempUrl]) {
        [[UIApplication sharedApplication] openURL:tempUrl options:nil completionHandler:^(BOOL success) {
            
        }];
        return YES;
    } else {
        return NO;
    }
}

LJRouterRegistAction(@"跨端-打开微信APP，带返回值", lj_open_wechat, BOOL, (NSString *)wxLink, (LJRouterCallbackBlock) callBack) {
    NSURL *tempUrl = [NSURL URLWithString:wxLink];
    if ([[UIApplication sharedApplication] canOpenURL:tempUrl]) {
        [[UIApplication sharedApplication] openURL:tempUrl options:nil completionHandler:^(BOOL success) {
            callBack(success ? @"1" : @"0", success);
        }];
        return YES;
    } else {
        callBack(@"0", NO);
        return NO;
    }
}

LJRouterUseAction(lj_open_wechat,  BOOL, (NSString *)wxLink, (LJRouterCallbackBlock)callBack);
LJRouterRegistAction(@"跨端-家装打开微信加私或只打开微信", jz_open_wechat_private_domain, void, (NSString *)contentType, (__nullable NSString *)cityId, (NSString *)defaultUrl, (LJRouterCallbackBlock)callback) {

    // 打开默认路由 block
    void (^openDefaultSchemaBlock)(NSString *) = ^(NSString *schema) {
        BOOL complete = [[LJRouter sharedInstance] routerUrlString:schema sender:nil callback:^(id mess, BOOL complete) {} resultBlock:^(id  _Nullable result, LJRouterServiceType type) {}];
        if (callback) {
            // 0：打开失败，2：打开默认路由
            callback(complete ? @"2" : @"0", complete);
        }
    };
    
    // 直接打开微信私域 block
    void (^openWechatPrivateDomainBlock)(NSString *) = ^(NSString *wxLink) {
        action_lj_open_wechat_with_wxLink_callBack(wxLink, ^(id mess, BOOL complete){
            if (callback) {
                // 0：打开失败，1：打开私域
                callback(complete ? @"1" : @"0", complete);
            }
        });
    };
    
    contentType = JZ_ValidString(contentType);
    // cityId 支持兜底
    cityId = JZ_IsEmptyString(cityId) ? JZEngineConfigDef.cityCode : cityId;
    // 根据 contentType 和 cityId 请求微信私域链接, 根据请求结果来决定直接打开微信私域还是打开默认路由。
    [[JZPrivateDomainCustomerAssistantDataManager new] requestCustomerAssistantLinkWithContentType:contentType cityId:cityId completion:^(NSString * _Nonnull customerAssistantLink) {
        if (!JZ_IsEmptyString(customerAssistantLink)) {
            openWechatPrivateDomainBlock(customerAssistantLink);
        } else {
            openDefaultSchemaBlock(defaultUrl);
        }
    } failed:^(NSString * _Nonnull reason) {
        openDefaultSchemaBlock(defaultUrl);
    }];
}

LJRouterUseAction(jz_present_clue_pop, void, (NSUInteger)adId, (NSString *)uiCode, (NSDictionary *)uiConfig, (NSDictionary *)paramMap, (NSDictionary *)payloadMap);

+ (void)requestBottomViewInfoWithAdId:(NSUInteger)adId parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok successBlock:(void(^)(NSDictionary *data))successBlock failureBlock:(void(^)(NSError *error))failureBlock {
    // 接口 http://weapons.ke.com/project/15032/interface/api/1287554
    NSMutableDictionary *commonParameters = [NSMutableDictionary new];
    [commonParameters setValue:IS_BEIKE_APP?@(200000002):@(200000001) forKey:@"mediumId"];
    [commonParameters setValue:@(adId) forKey:@"adId"];
    [commonParameters setValue:LJ_APP_CONFIG.setting.cityId forKey:@"hdicCityId"];
    
    NSMutableDictionary *commonPayloadParameters = [NSMutableDictionary new];
    [commonPayloadParameters setValue:IS_BEIKE_APP?@"keapp":@"ljapp" forKey:@"channelType"];
    //    [commonPayloadParameters setValue:LJ_APP_CONFIG.setting.cityId forKey:@"gbCode"];
    
    JZBusinessOpportunityPayloadModel *payloadModel = parametersBlcok?parametersBlcok():nil;
    NSDictionary *parameters = [payloadModel yy_modelToJSONObject]?:@{};
    [commonPayloadParameters addEntriesFromDictionary:parameters];
    [commonParameters setValue:commonPayloadParameters forKey:@"payload"];
    //    NSString *urlString = @"/api/proxy/decor/app/v1/adx/sdk/recommend";
    NSString *url = @"/api/proxy/decor/app/v1/adx/sdk/v2recommend";
    [LJBaseAPI postJSONBodyWithUrl:url parameters:commonParameters completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            if ([data isKindOfClass:NSDictionary.class]) {
                NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                successBlock(dataDic);
            } else {
                if (failureBlock) {
                    failureBlock(nil);
                }
            }
        }
    }];
}


/// IM消息-静态展位（静态展位 会请求固定接口来获取商机展位信息，接口为：adx/sdk/v2recommend）
/// @param [adId] 广告位ID
/// @param [uiCode] 页面标识
///
/// @param [imConfig] 请求IM卡片用的，是个字典
/// @param [imConfig.imText] 纯文本IM消息时要用的字段
/// @param [imConfig.type] packages:套餐、 albumcase:案例、 constructionsite:工地、 frameAI:3D方案页在用
/// @param [imConfig.schema] IM卡片点击跳转的schema
/// @param [imConfig.id] 当type不为frameAI时，需要该字段，该字段为要请求的卡片的ID，可能为styleId、frameId or caseId等
/// @param [imConfig.paramsJson] MapStr格式，当type为frameAI时，原来的id字段不够用了，后端改用paramsJson字段
/// @param paramsJson 具体内容为：{"styleId":1545,"frameId":"1120040524249306","cityId":"110000"}.toString()
///
/// @param [payloadMap] 留资用的，是个字典
/// @param [payloadMap.contentId] 内容ID
/// @param [payloadMap.contentType] 内容类型 1=户型ID、2=案例ID、3=套餐ID、4=工地ID、5=文章ID、6=视频ID
/// @param [payloadMap.contentTitle] 商机展位平台配的：内容标题
/// @param [payloadMap.pageTitle] 商机展位平台配的：页面标题
///
/// Flutter 调用示例：
/// JZCommonTools.jzSendIMMsgStatic(
///     adId: JZBussinessAdidConst.getJZADIDCaseDetailAsk(),
///     uiCode: RealShootingCaseDetailPage.uiCode,
///     imConfig: {"imText": text, "type": "albumcase", "schema": "lianjiabeike://decorate/case/detail?caseId=${caseId}", "id": caseId},
///     payloadMap: {"contentId": caseId, "contentType": 2, "contentTitle": text, "contentTitle": "实拍案例详情页", "uiCode": RealShootingCaseDetailPage.uiCode}
/// );
///
LJRouterRegistAction(@"家装IM路由通用方法-静态商机展位", jz_send_im_msg_static, void, (NSString *)adId, (NSString *)uiCode, (NSString *)imConfig, (NSString *)payloadMap) {
    
    [JZUserService checkLogin:^(BOOL direct) {
        NSDictionary *imConfigJson = [JZUtil objectFromJSONString:imConfig];
        NSDictionary *payloadJson = [JZUtil objectFromJSONString:payloadMap];
        NSString *type = imConfigJson[@"type"];
        NSInteger intAdId = [adId integerValue];
        [self requestIMWithAdId:intAdId uiCode:uiCode parametersBlcok:^JZBusinessOpportunityPayloadModel * _Nonnull{
            JZBusinessOpportunityPayloadModel *pm = [JZBusinessOpportunityPayloadModel yy_modelWithJSON:payloadJson];
            return pm;
        } IMBlcok:^(IMInfoBlock  _Nonnull infoBlock) {
            JZBusinessOpportunityIMModel *model = [JZBusinessOpportunityIMModel new];
            model.message = imConfigJson[@"imText"] ?: nil;
            if (JZ_IsEmptyString(type)) { // 没有type，就是纯文本消息
                infoBlock(model);
                return;
            }
            NSMutableDictionary *paramsDic = [imConfigJson copy];
            NSString *type = imConfigJson[@"type"];
            NSString *paramsJsonStr = imConfigJson[@"paramsJson"];
            NSDictionary *paramsJson = [self convertJsonStr:paramsJsonStr];
            if (IsDicEmpty(paramsJson)) { //单一ID场景
                NSString *idStr = imConfigJson[@"id"];
                [JZIMApiService getFullCardInfoWithId:idStr type:type block:^(NSDictionary * _Nonnull data) {
                    model.cardInfo = data[@"jsonForIm"];
                    model.cardId = @2;
                    model.webSchema = data[@"schema"];
                    infoBlock(model);
                }];
            } else { //需要多个ID场景：即需要paramJson参数
                [JZIMApiService getFullCardInfoWithParamsJson:paramsDic type:type block:^(NSDictionary * _Nonnull data) {
                    model.cardInfo = data[@"imPayload"];
                    model.cardId = @2;
                    model.webSchema = data[@"schema"];
                    infoBlock(model);
                }];
            }
        } successBlock:^{
            JZ_Log(@"%s: success", __FUNCTION__);
        } failureBlock:^{
            JZ_Log(@"%s: fail", __FUNCTION__);
        }];
    }];
}

+ (void)requestClueWithAdId:(NSUInteger)adId parameters:(NSDictionary *)parameters digV:(NSDictionary *)digV successBlock:(void(^)(NSDictionary *data))successBlock failureBlock:(void(^)(NSError *error))failureBlock {
    [self requestClueWithAdId:adId parameters:parameters paramMap:nil digV:digV successBlock:successBlock failureBlock:failureBlock];
}

+ (void)requestClueWithAdId:(NSUInteger)adId parameters:(NSDictionary *)parameters paramMap:(NSDictionary *)paramMap digV:(NSDictionary *)digV successBlock:(void(^)(NSDictionary *data))successBlock failureBlock:(void(^)(NSError *error))failureBlock {
    // 接口 http://weapons.ke.com/project/15032/interface/api/1287561
    NSMutableDictionary *commonParameters = [NSMutableDictionary new];
    [commonParameters setValue:IS_BEIKE_APP?@(200000002):@(200000001) forKey:@"mediumId"];
    [commonParameters setValue:@(adId) forKey:@"adId"];
    [commonParameters setValue:CHECK_VALID_STRING(parameters[@"gbCode"]) ? parameters[@"gbCode"] : LJ_APP_CONFIG.setting.cityId forKey:@"hdicCityId"];
    [commonParameters setValue:digV forKey:@"digV"];
    [commonParameters setValue:parameters forKey:@"payload"];
    [self setParamMap:paramMap forMutDic:commonParameters];
    NSString *url = @"/api/proxy/decor/app/v1/adx/api/clue";
    [LJBaseAPI postJSONBodyWithUrl:url parameters:commonParameters completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            if ([data isKindOfClass:NSDictionary.class]) {
                NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                successBlock(dataDic);
            } else {
                if (failureBlock) {
                    failureBlock(nil);
                }
            }
        }
    }];
}
// 400
+ (void)request400WithAdId:(NSUInteger)adId uiCode:(NSString *)uiCode parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok successBlock:(void(^)(void))successBlock failureBlock:(void(^)(void))failureBlock {
    // http://weapons.ke.com/project/15032/interface/api/1298142
    [[LJProgressHUDHelper getInstance] showThemeLoadingOnView:nil];
    NSMutableDictionary *commonParameters = [NSMutableDictionary new];
    [commonParameters setValue:IS_BEIKE_APP?@(200000002):@(200000001) forKey:@"mediumId"];
    [commonParameters setValue:@(adId) forKey:@"adId"];
    [commonParameters setValue:[NSNumber numberWithBool:YES] forKey:@"renovationRequired400"];
    [commonParameters setValue:LJ_APP_CONFIG.setting.cityId forKey:@"hdicCityId"];
    JZBusinessOpportunityPayloadModel *payloadModel = parametersBlcok?parametersBlcok():nil;
    NSDictionary *parameters = [payloadModel yy_modelToJSONObject]?:@{};
    [commonParameters setValue:parameters forKey:@"payload"];
    
    NSString *url = @"/api/proxy/decor/app/v1/adx/api/v2recommend";
    [LJBaseAPI postJSONBodyWithUrl:url parameters:commonParameters completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        [[LJProgressHUDHelper getInstance] dismissOnView:nil];
        if (error) {
            if (failureBlock) {
                failureBlock();
            }
        } else {
            if ([data isKindOfClass:NSDictionary.class]) {
                NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                if ([data isKindOfClass:NSDictionary.class]) {
                    NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                    JZBusinessOpportunityModel *model = [JZBusinessOpportunityModel yy_modelWithJSON:dataDic];
                    if (model) {
                        if ([self isWorkTimeWithExtraModel:model.extra]) {
                            [self cluePhoneWithPhoneNum:model.recommendDataList.firstObject.phone400];
                            [self clickEventWithUiCode:uiCode type:JZBusinessOpportunity400 btnText:@"" BOModel:model];
                        } else {
                            JZBusinessOpportunityBounceContentModel *clueTextInfo = [JZBusinessOpportunityBounceContentModel new];
                            clueTextInfo.title = @"预约回电";
                            clueTextInfo.buttonText = @"立即预约";
                            clueTextInfo.toastText = @"预约成功，装修顾问会在24小时内联系您，请保持电话畅通";
                            [self cluePopWithBOModel:model
                                            BtnModel:nil
                                             btnText:@"非工作时间"
                                        clueTextInfo:clueTextInfo
                                                adId:adId
                                              uiCode:uiCode
                                          isWorkTime:YES
                                     parametersBlcok:parametersBlcok];
                        }
                        if (successBlock) {
                            successBlock();
                        }
                        
                    } else {
                        if (failureBlock) {
                            failureBlock();
                        }
                    }
                }
            }
        }
    }];
}
// IM
+ (void)requestIMWithAdId:(NSUInteger)adId uiCode:(NSString *)uiCode parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok IMBlcok:(void(^)(IMInfoBlock infoBlock))IMBlcok successBlock:(void(^)(void))successBlock failureBlock:(void(^)(void))failureBlock {
    // 接口 http://weapons.ke.com/project/15032/interface/api/1290190
    [[LJProgressHUDHelper getInstance] showThemeLoadingOnView:nil];
    NSMutableDictionary *commonParameters = [NSMutableDictionary new];
    [commonParameters setValue:IS_BEIKE_APP?@(200000002):@(200000001) forKey:@"mediumId"];
    [commonParameters setValue:@(adId) forKey:@"adId"];
    [commonParameters setValue:LJ_APP_CONFIG.setting.cityId forKey:@"hdicCityId"];
    JZBusinessOpportunityPayloadModel *payloadModel = parametersBlcok?parametersBlcok():nil;
    NSDictionary *parameters = [payloadModel yy_modelToJSONObject]?:@{};
    [commonParameters setValue:parameters forKey:@"payload"];
    
    NSString *url = @"/api/proxy/decor/app/v1/adx/api/v2recommend";
    [LJBaseAPI postJSONBodyWithUrl:url parameters:commonParameters completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        [[LJProgressHUDHelper getInstance] dismissOnView:nil];
        if (error) {
            if (failureBlock) {
                failureBlock();
            }
        } else {
            if ([data isKindOfClass:NSDictionary.class]) {
                NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                if ([data isKindOfClass:NSDictionary.class]) {
                    NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                    JZBusinessOpportunityModel *model = [JZBusinessOpportunityModel yy_modelWithJSON:dataDic];
                    if (model) {
                        NSString *pageTitle = [parameters stringForKey:@"pageTitle"];
                        [self clueIMWithBOModel:model uiCode:uiCode pageTitle:pageTitle IMBlcok:IMBlcok];
                        [self clickEventWithUiCode:uiCode type:JZBusinessOpportunityIM btnText:@"" BOModel:model];
                        if (successBlock) {
                            successBlock();
                        }
                    } else {
                        if (failureBlock) {
                            failureBlock();
                        }
                    }
                }
            }
        }
    }];
}

+ (void)requestBottomView400WithAdId:(NSUInteger)adId digV:(NSString *)digV successBlock:(void(^)(void))successBlock failureBlock:(void(^)(void))failureBlock {
    // http://weapons.ke.com/project/15032/interface/api/1298153
    [[LJProgressHUDHelper getInstance] showThemeLoadingOnView:nil];
    NSMutableDictionary *commonParameters = [NSMutableDictionary new];
    [commonParameters setValue:IS_BEIKE_APP?@(200000002):@(200000001) forKey:@"mediumId"];
    [commonParameters setValue:@(adId) forKey:@"adId"];
    [commonParameters setValue:digV forKey:@"digV"];
    [commonParameters setValue:LJ_APP_CONFIG.setting.cityId forKey:@"hdicCityId"];
    
    NSString *url = @"/api/proxy/decor/app/v1/adx/api/phone400";
    [LJBaseAPI postJSONBodyWithUrl:url parameters:commonParameters completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        [[LJProgressHUDHelper getInstance] dismissOnView:nil];
        if (error) {
            if (failureBlock) {
                failureBlock();
            }
        } else {
            if ([data isKindOfClass:NSDictionary.class]) {
                NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                if ([data isKindOfClass:NSDictionary.class]) {
                    NSDictionary *dataDic = [((NSDictionary*)data) dictionaryForKey:@"data"];
                    NSString *phone400 = [dataDic stringForKey:@"phone400"];
                    [self cluePhoneWithPhoneNum:phone400];
                } else {
                    if (failureBlock) {
                        failureBlock();
                    }
                }
            }
        }
    }];
}


+ (void)cluePhoneWithBOModel:(JZBusinessOpportunityModel *)BOModel adId:(NSUInteger)adId uiCode:(NSString *)uiCode parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    if ([self isWorkTimeWithExtraModel:BOModel.extra]) {
        [self requestBottomView400WithAdId:adId digV:BOModel.recommendDataList.firstObject.digV successBlock:nil failureBlock:^{
            
        }];
    } else {
        JZBusinessOpportunityBounceContentModel *clueTextInfo = [JZBusinessOpportunityBounceContentModel new];
        clueTextInfo.title = @"预约回电";
        clueTextInfo.buttonText = @"立即预约";
        clueTextInfo.toastText = @"预约成功，装修顾问会在24小时内联系您，请保持电话畅通";
        [self cluePopWithBOModel:BOModel BtnModel:nil btnText:@"非工作时间" clueTextInfo:clueTextInfo adId:adId uiCode:uiCode isWorkTime:YES parametersBlcok:parametersBlcok];
    }
}

/// 根据model打电话或者弹窗留资
/// - Parameters:
///   - BOModel: model
///   - adId: adId
///   - uiCode: uiCode
///   - parametersBlcok: 回调
+ (void)cluePhoneOrPopWithBOModel:(JZBusinessOpportunityModel *)BOModel
                             adId:(NSUInteger)adId
                           uiCode:(NSString *)uiCode
                  parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    
    if ([self isWorkTimeWithExtraModel:BOModel.extra]) {
        [self cluePhoneWithPhoneNum:BOModel.recommendDataList.firstObject.phone400];
    } else {
        JZBusinessOpportunityBounceContentModel *clueTextInfo = [JZBusinessOpportunityBounceContentModel new];
        clueTextInfo.title = @"预约回电";
        clueTextInfo.buttonText = @"立即预约";
        clueTextInfo.toastText = @"预约成功，装修顾问会在24小时内联系您，请保持电话畅通";
        [self cluePopWithBOModel:BOModel
                        BtnModel:nil
                         btnText:@"非工作时间"
                    clueTextInfo:clueTextInfo
                            adId:adId
                          uiCode:uiCode
                      isWorkTime:YES
                 parametersBlcok:parametersBlcok];
    }
}

+ (void)clueExposureEventWithUiCode:(NSString *)uiCode btnText:(NSString *)btnText {
    [self exposureEventWithUiCode:uiCode type:JZBusinessOpportunityClue btnText:btnText BOModel:nil digAction:nil];
}

/// IM曝光埋点
/// @param uiCode 页面uiCode
+ (void)IMExposureEventWithUiCode:(NSString *)uiCode {
    [self IMExposureEventWithUiCode:uiCode digAction:nil];
}

/// IM曝光埋点
/// @param uiCode    页面uiCode
/// @param digAction 额外参数
+ (void)IMExposureEventWithUiCode:(NSString *)uiCode digAction:(NSDictionary *)digAction {
    [self exposureEventWithUiCode:uiCode type:JZBusinessOpportunityIM btnText:@"" BOModel:nil digAction:digAction];
}

+ (void)clueIMWithBOModel:(JZBusinessOpportunityModel *)BOModel uiCode:(NSString *)uiCode pageTitle:(NSString *)pageTitle IMBlcok:(void(^)(IMInfoBlock infoBlock))IMBlcok {
    if(IMBlcok) {
        IMInfoBlock infoBlock = ^(JZBusinessOpportunityIMModel *model) {
            // 发送IM
            NSString *imUserId = BOModel.recommendDataList.firstObject.renovationImAccountId;
            NSString *skillCode = BOModel.recommendDataList.firstObject.renovationSkillCode;
            if (imUserId.length == 0 || skillCode.length == 0) {
                return;
            }
            NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
            [attrDic setValue:skillCode ?: @"" forKey:@"skillCode"];
            [attrDic setValue:IS_BEIKE_APP?@"贝壳家装app":@"链家家装app" forKey:@"endPointName"];
            [attrDic setValue:IS_BEIKE_APP?@"bkjzapp":@"ljjzapp" forKey:@"endPoint"];
            // uidode
            [attrDic setValue:uiCode forKey:@"scene"];
            // 页面名称
            [attrDic setValue:pageTitle forKey:@"sceneName"];
            [attrDic setValue:BOModel.recommendDataList.firstObject.digV forKey:@"business_dig_v"];
            NSString *attrs = [attrDic yy_modelToJSONString];
            
            [[JZIMBussiness getInstance] createConversationByUcid:imUserId
                                                           imPort:uiCode
                                                          imAttrs:attrs
                                                    didCreateChat:^(NSInteger convID) {
                
                [[JZIMBussiness getInstance] sendMessage:model.message
                                                 msgAttr:attrs
                                                  convID:@(convID).stringValue
                                                    ucid:BOModel.recommendDataList.firstObject.designerId
                                                    port:uiCode
                                                 payload: nil//imModel.payload
                                                  cardID:model.cardId ? model.cardId : nil
                                            nativeSchema:nil
                                               webSchema:model.webSchema //imModel.extraSchema
                                                    desc:model.message
                                             pushContent:nil //imModel.pushContent
                                                   uiDic:model.cardInfo];
            }];
        };
        IMBlcok(infoBlock);
    }
}
+ (void)cluePopWithClueTextInfo: (JZBusinessOpportunityBounceContentModel *)clueTextInfo btnText:(NSString *)btnText adId:(NSUInteger)adId uiCode:(NSString *)uiCode parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    [self cluePopWithClueTextInfo:clueTextInfo btnText:btnText adId:adId uiCode:uiCode paramMap:nil parametersBlcok:parametersBlcok];
}
+ (void)cluePopWithClueTextInfo: (JZBusinessOpportunityBounceContentModel *)clueTextInfo btnText:(NSString *)btnText adId:(NSUInteger)adId uiCode:(NSString *)uiCode paramMap:(NSDictionary *)paramMap parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    [self cluePopWithBOModel:nil BtnModel:nil btnText:btnText clueTextInfo:clueTextInfo adId:adId uiCode:uiCode isWorkTime:NO paramMap:paramMap parametersBlcok:parametersBlcok];
}

/// 留资弹框
+ (void)cluePopWithBOModel:(JZBusinessOpportunityModel *)BOModel BtnModel:(JZBusinessOpportunityBtnModel *)model btnText:(NSString *)btnText clueTextInfo: (JZBusinessOpportunityBounceContentModel *)clueTextInfo adId:(NSUInteger)adId uiCode:(NSString *)uiCode parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    [self cluePopWithBOModel:BOModel BtnModel:model btnText:btnText clueTextInfo:clueTextInfo adId:adId uiCode:uiCode isWorkTime:NO parametersBlcok:parametersBlcok];
}

/// 留资弹框
+ (void)cluePopWithBOModel:(JZBusinessOpportunityModel *)BOModel BtnModel:(JZBusinessOpportunityBtnModel *)model btnText:(NSString *)btnText clueTextInfo: (JZBusinessOpportunityBounceContentModel *)clueTextInfo adId:(NSUInteger)adId uiCode:(NSString *)uiCode isWorkTime:(BOOL)isWorkTime parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    [self cluePopWithBOModel:BOModel BtnModel:model btnText:btnText clueTextInfo:clueTextInfo adId:adId uiCode:uiCode isWorkTime:isWorkTime paramMap:nil parametersBlcok:parametersBlcok];
}
+ (void)cluePopWithBOModel:(JZBusinessOpportunityModel *)BOModel BtnModel:(JZBusinessOpportunityBtnModel *)model btnText:(NSString *)btnText clueTextInfo: (JZBusinessOpportunityBounceContentModel *)clueTextInfo adId:(NSUInteger)adId uiCode:(NSString *)uiCode isWorkTime:(BOOL)isWorkTime paramMap:(NSDictionary *)paramMap parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok {
    
    JZBusinessOpportunityPayloadModel *payloadModel = parametersBlcok?parametersBlcok():nil;
    NSString *title = @"";
    NSString *titleDesc = @"";
    NSString *successMsg = @"";
    NSString *actionTitle = @"";
    if (clueTextInfo) {
        title = clueTextInfo.title;
        titleDesc = clueTextInfo.subTitle;
        successMsg = clueTextInfo.toastText;
        actionTitle = clueTextInfo.buttonText;
    } else {
        title = model.bounceContent.title;
        titleDesc = model.bounceContent.subTitle;
        successMsg = model.bounceContent.toastText;
        actionTitle = model.bounceContent.buttonText;
    }
    if (!CHECK_VALID_STRING(titleDesc)) {
        if (CHECK_VALID_STRING(BOModel.extra.customerServiceStartTime) && CHECK_VALID_STRING(BOModel.extra.customerServiceEndTime)) {
            titleDesc = [NSString stringWithFormat:@"现在是非工作时间，您可预约回电\n装修顾问会在工作时间（%@-%@）联系您",BOModel.extra.customerServiceStartTime, BOModel.extra.customerServiceEndTime];
        } else {
            titleDesc = @"现在是非工作时间，您可预约回电\n装修顾问会在工作时间（9:00-20:00）联系您";
        }
    }
    UIColor *actionBGColor = (clueTextInfo.btnBgColor.length > 0) ? [UIColor lj_colorWithHexString:clueTextInfo.btnBgColor] : [UIColor lj_colorWithHexString:@"#9B1C23"];
    UIColor *actionDisableColor = [UIColor lj_colorWithHexString:@"#CCCCCC"];
    void(^alertBlock)() = ^() {
        JZInputAlertViewController *alertViewController = [[JZInputAlertViewController alloc] initWithTitle:title
                                                                                                   subTitle:titleDesc
                                                                                                actionTitle:actionTitle
                                                                                              actionBgColor:actionBGColor
                                                                                         actionDisableColor:actionDisableColor
                                                                                                  inputType:JGInputContentTypePhone
                                                                                                   complete:^(JZInputAlertViewController *alert, NSString * _Nonnull inputContent, NSString * _Nonnull smsCode) {
            // 留资
            NSMutableDictionary *payloadDic = [NSMutableDictionary new];
            [payloadDic setValue:isWorkTime?@(1):@(0) forKey:@"isNonWorkingTime"];
            [payloadDic setValue:inputContent forKey:@"phone"];
            if (JZ_IsEmptyString(payloadModel.gbCode)) {
                [payloadDic setValue:LJ_APP_CONFIG.setting.cityId forKey:@"gbCode"];
            }
            [payloadDic setValue:smsCode forKey:@"smsCode"];
            [payloadDic setValue:@([BOModel.recommendDataList.firstObject.designerId integerValue]) forKey:@"willDesignerId"];
            [payloadDic setValue:IS_BEIKE_APP?@"keapp":@"ljapp" forKey:@"channelType"];
            [payloadDic setValue:BOModel.recommendDataList.firstObject.designerName forKey:@"designerName"];
            [payloadDic setValue:BOModel.recommendDataList.firstObject.designerId forKey:@"designerUcId"];
            [payloadDic setValue:[LJBaseDigitalUnionManager sharedInstance].ljbDUID forKey:@"duid"];
            
           
            [payloadDic addEntriesFromDictionary:[payloadModel yy_modelToJSONObject]?:@{}];
            // 留资-点击埋点
            
            NSMutableDictionary *acton = [NSMutableDictionary new];
            [acton addEntriesFromDictionary:payloadModel.digAction ?:@{}];
            [acton setValue:BOModel.recommendDataList.firstObject.digV?:@"" forKey:@"e_plan"];
            [acton setValue:btnText?:@"" forKey:@"title"];
            
            [JZStatisticsDef elementClick:uiCode?:@"" event:@"52388" action:acton];
            
            [self requestClueWithAdId:adId parameters:payloadDic paramMap:paramMap digV:BOModel.recommendDataList.firstObject.digV successBlock:^(NSDictionary * _Nonnull data) {
                [[LJProgressHUDHelper getInstance] showSuccessWithStatus:successMsg onView:nil];
                [alert dismissAfterTime:0.1];
            } failureBlock:^(NSError * _Nonnull error) {
                [alert actionEnbale:YES];
                [[LJProgressHUDHelper getInstance] showErrorWithStatus:@"预约失败，请重试" onView:nil];
            }];
        }];
        alertViewController.hiddenByTapMask = YES; //点击空白收起弹窗
        alertViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        alertViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        alertViewController.defaultNum = LJ_APP_CONFIG.currentUser.account;
        // 留资-曝光
        NSMutableDictionary *acton = [NSMutableDictionary new];
        [acton addEntriesFromDictionary:payloadModel.digAction ?:@{}];
        [acton setValue:BOModel.recommendDataList.firstObject.digV?:@"" forKey:@"e_plan"];
        [acton setValue:btnText?:@"" forKey:@"title"];
        [JZStatisticsDef elementView:uiCode?:@"" event:@"52387" action:acton];
        [JZ_TOPVC presentViewController:alertViewController animated:YES completion:nil];

    };
    
    if (!LJ_APP_CONFIG.currentUser.isLogin) {
        open_login_center_controller_with_from_currentLoginType_completeBlock([LJ_NAVIGATOR topmostViewController], ELJLoginSourceActiveLogin, ELJLoginTypeOneLogin, alertBlock);
    } else {
        alertBlock();
    }
}

+ (void)requestClueWithAdId:(NSUInteger)adId uiCode:(NSString *)uiCode parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok successBlock:(void(^)(void))successBlock failureBlock:(void(^)(NSError *error))failureBlock {
    [self requestClueWithAdId:adId uiCode:uiCode paramMap:nil parametersBlcok:parametersBlcok successBlock:successBlock failureBlock:failureBlock];
}

+ (void)requestClueWithAdId:(NSUInteger)adId
                     uiCode:(NSString *)uiCode
                   paramMap:(NSDictionary *)paramMap
            parametersBlcok:(JZBusinessOpportunityPayloadModel *(^)(void))parametersBlcok
               successBlock:(void(^)(void))successBlock
               failureBlock:(void(^)(NSError *error))failureBlock {
    [self requestClueWithAdId:adId
                       uiCode:uiCode
                       cityId:nil
                     paramMap:paramMap
              parametersBlcok:parametersBlcok
                 successBlock:successBlock
                 failureBlock:failureBlock];
}

+ (void)requestClueWithAdId:(NSUInteger)adId
                     uiCode:(NSString *)uiCode
                     cityId:(NSString *)cityId
                   paramMap:(NSDictionary *)paramMap
            parametersBlcok:(JZBusinessOpportunityPayloadModel * _Nonnull (^)(void))parametersBlcok
               successBlock:(void (^)(void))successBlock
               failureBlock:(void (^)(NSError * _Nonnull))failureBlock {
    // 留资
    NSMutableDictionary *payloadDic = [NSMutableDictionary new];
    [payloadDic setValue:@(0) forKey:@"isNonWorkingTime"];
    [payloadDic setValue:cityId ?: LJ_APP_CONFIG.setting.cityId forKey:@"gbCode"];
    [payloadDic setValue:@(0) forKey:@"willDesignerId"];
    [payloadDic setValue:IS_BEIKE_APP?@"keapp":@"ljapp" forKey:@"channelType"];
    [payloadDic setValue:@"" forKey:@"designerName"];
    //designerUcId默认值为0 后面如果payloadModel有值，会覆盖默认值
    [payloadDic setValue:@(0) forKey:@"designerUcId"];
    [payloadDic setValue:[LJBaseDigitalUnionManager sharedInstance].ljbDUID forKey:@"duid"];
    
    JZBusinessOpportunityPayloadModel *payloadModel = parametersBlcok?parametersBlcok():nil;
    [payloadDic addEntriesFromDictionary:[payloadModel yy_modelToJSONObject]?:@{}];
    
    [self requestClueWithAdId:adId parameters:payloadDic paramMap:paramMap digV:@"" successBlock:^(NSDictionary * _Nonnull data) {
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

/// 打电话
+ (void)cluePhoneWithPhoneNum:(NSString *)phoneNum {
    if (phoneNum.length == 0) {
        return;
    }
    NSString * serviceNumber = phoneNum;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", serviceNumber]]];
}

/// 判断工作时间
+ (BOOL)isWorkTimeWithExtraModel:(JZBusinessOpportunityExtraModel *)extraModel {
    return [self isBetweenFromHour:extraModel.workStartHour fromMin:extraModel.workStartMinute toHour:extraModel.workEndHour toMin:extraModel.workEndMinute];
}

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour fromMin:(NSInteger)fromMinute toHour:(NSInteger)toHour toMin:(NSInteger)toMinute {
    
    NSDate *dateFrom = [self getCustomDateWithHour:fromHour minute:fromMinute];
    NSDate *dateTo = [self getCustomDateWithHour:toHour minute:toMinute];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:dateFrom] == NSOrderedDescending && [currentDate compare:dateTo] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (NSDate *)getCustomDateWithHour:(NSInteger)hour minute:(NSInteger)minute {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

+ (void)clickEventWithUiCode:(NSString *)uiCode type:(NSString *)type btnText:(NSString *)btnText BOModel:(JZBusinessOpportunityModel *)BOModel digAction:(NSDictionary *)digAction
{
    NSMutableDictionary *digDic = [NSMutableDictionary new];
    [digDic setValue:@"" forKey:@"exhi_source"];
    [digDic setValue:@"" forKey:@"leads_object"];
    
    [digDic setValue:uiCode?:@"" forKey:@"leads_source"];
    [digDic setValue:BOModel.recommendDataList.firstObject.digV?:@"" forKey:@"e_plan"];
    if ([type isEqualToString:JZBusinessOpportunityClue]) {
        [digDic addEntriesFromDictionary:digAction ?:@{}];
        [digDic setValue:btnText?:@"" forKey:@"title"];
        [digDic setValue:@"" forKey:@"button_type"];
        [JZStatisticsDef elementClick:uiCode?:@"" event:@"30657" action:[digDic copy]];
    } else if ([type isEqualToString:JZBusinessOpportunity400]) {
        [digDic addEntriesFromDictionary:digAction ?:@{}];
        [digDic setValue:[self isWorkTimeWithExtraModel:BOModel.extra]?@"working":@"nonworking" forKey:@"status"];
        [digDic setValue:@"" forKey:@"leads_id"];
        [JZStatisticsDef elementClick:uiCode?:@"" event:@"30658" action:[digDic copy]];
    } else if ([type isEqualToString:JZBusinessOpportunityIM]) {
        [digDic addEntriesFromDictionary:digAction ?:@{}];
        [digDic setValue:@"" forKey:@"questionId"];
        [digDic setValue:@"" forKey:@"description"];
        [digDic setValue:BOModel.recommendDataList.firstObject.designerName?:@"" forKey:@"designer_name"];
        [JZStatisticsDef elementClick:uiCode?:@"" event:@"30655" action:[digDic copy]];
    } else if ([type isEqualToString:JZBusinessOpportunityPrivate]) {
        [JZStatisticsDef elementClick:uiCode?:@"" event:@"52348" action:@{@"e_plan":BOModel.recommendDataList.firstObject.digV?:@""}];
    } else if ([type isEqualToString:JZBusinessOpportunityStaticClick]) {
        
    } else if ([type isEqualToString:JZBusinessOpportunityCalClick]) {
        [JZStatisticsDef elementClick:uiCode?:@"" event:@"58325" action:@{@"e_plan":BOModel.recommendDataList.firstObject.digV?:@""}];
    } else if ([type isEqualToString:JZBusinessOpportunityAgent]) {
        [JZStatisticsDef elementClick:uiCode?:@"" event:@"52347" action:@{@"e_plan":BOModel.recommendDataList.firstObject.digV?:@""}];
    }
}


+ (void)clickEventWithUiCode:(NSString *)uiCode type:(NSString *)type btnText:(NSString *)btnText
                     BOModel:(JZBusinessOpportunityModel *)BOModel
{
    [self clickEventWithUiCode:uiCode type:type btnText:btnText BOModel:BOModel digAction:nil];
}


+ (void)exposureEventWithUiCode:(NSString *)uiCode type:(NSString *)type btnText:(NSString *)btnText BOModel:(JZBusinessOpportunityModel *)BOModel digAction:(NSDictionary *)digAction {
    NSMutableDictionary *digDic = [NSMutableDictionary new];
    [digDic setValue:@"" forKey:@"exhi_source"];
    [digDic setValue:@"" forKey:@"leads_object"];
    [digDic setValue:@"" forKey:@"questionId"];
    [digDic setValue:BOModel.recommendDataList.firstObject.designerId?:@"" forKey:@"designer_name"];
    [digDic setValue:uiCode?:@"" forKey:@"leads_source"];
    [digDic setValue:BOModel.recommendDataList.firstObject.digV?:@"" forKey:@"e_plan"];
    if ([type isEqualToString:JZBusinessOpportunityClue]) {
        [digDic addEntriesFromDictionary:digAction ?:@{}];
        [digDic setValue:btnText?:@"" forKey:@"title"];
        [digDic setValue:@"" forKey:@"button_type"];
        [JZStatisticsDef elementView:uiCode?:@"" event:@"52385" action:[digDic copy]];
    } else if ([type isEqualToString:JZBusinessOpportunity400]) {
        [digDic addEntriesFromDictionary:digAction ?:@{}];
        [digDic setValue:[self isWorkTimeWithExtraModel:BOModel.extra]?@"working":@"nonworking" forKey:@"status"];
        [JZStatisticsDef elementView:uiCode?:@"" event:@"52386" action:[digDic copy]];
    } else if ([type isEqualToString:JZBusinessOpportunityIM]) {
        [digDic addEntriesFromDictionary:digAction ?:@{}];
        [digDic setValue:@"" forKey:@"questionId"];
        [digDic setValue:BOModel.recommendDataList.firstObject.designerName?:@"" forKey:@"designer_name"];
        [digDic setValue:@"" forKey:@"description"];
        [JZStatisticsDef elementView:uiCode?:@"" event:@"52384" action:[digDic copy]];
    } else if ([type isEqualToString:JZBusinessOpportunityPrivate]) {
        [JZStatisticsDef elementView:uiCode?:@"" event:@"52378" action:@{@"e_plan":BOModel.recommendDataList.firstObject.digV?:@""}];
    } else if ([type isEqualToString:JZBusinessOpportunityStaticClick]) {
        
    } else if ([type isEqualToString:JZBusinessOpportunityCalClick]) {
        
    } else if ([type isEqualToString:JZBusinessOpportunityAgent]) {
        [JZStatisticsDef elementView:uiCode?:@"" event:@"52381" action:@{@"e_plan":BOModel.recommendDataList.firstObject.digV?:@""}];
    }
}


#pragma mark TOOLs
+ (void)setParamMap:(NSDictionary *)paramMap
          forMutDic:(NSMutableDictionary *)mutDic
{
    if ([paramMap isKindOfClass:[NSDictionary class]] && paramMap.allKeys.count) {
        [mutDic setObjectSafe:paramMap forKey:@"paramMap"];
    }
}

+ (NSDictionary *)convertJsonStr:(NSString *)jsonStr {
    if (!jsonStr) {
        return nil;
    }
    if ([jsonStr isKindOfClass:NSDictionary.class]) {
        return jsonStr;
    }
    NSDictionary *json = [NSDictionary lj_dictFromJSONString:jsonStr];
    return json;
}


@end
