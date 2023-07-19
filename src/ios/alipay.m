/********* alipay.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AlipaySDK/AlipaySDK.h>

@interface alipay : CDVPlugin {
    // Member variables go here.
    NSString *app_id;
    NSString *callbackId;
}

- (void)payment:(CDVInvokedUrlCommand*)command;
@end

@implementation alipay

#pragma mark "API"
- (void)pluginInitialize {
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    app_id = [viewController.settings objectForKey:@"alipayid"];
}

- (void)payment:(CDVInvokedUrlCommand*)command
{
    callbackId = command.callbackId;
    NSString* orderString = [command.arguments objectAtIndex:0];
    NSString* appScheme = [NSString stringWithFormat:@"ali%@", app_id];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        CDVPluginResult* pluginResult;
        
        if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        }
        
    }];
}

- (void)handleOpenURL:(NSNotification *)notification {
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:[NSString stringWithFormat:@"ali%@", app_id]])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            CDVPluginResult* pluginResult;
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqual: @"9000"]) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            }
        }];
    }
}

- (void)isAliPayInstalled:(CDVInvokedUrlCommand*)command
{
    callbackId = command.callbackId;
    CDVPluginResult* pluginResult;
    NSURL * url = [NSURL URLWithString:@"alipay://"];//注意设置白名单
    if ([[UIApplication sharedApplication] canOpenURL:url]) { // 安装
        //自己的代码逻辑处理
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool: 1];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        return;
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool: 0];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        return;
    }
}

@end
