//
//  ActivityModel.m
//  ios_3_Acti
//
//  Created by admin1 on 2017/7/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel


- (id) initWhitDictionary: (NSDictionary *)dict{
    //isKindOfClass:判断一个东西是否为空
//    if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]) {
//        _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
//    }else{
//        _imgUrl = dict[@"imgURL"];
//    }
    
    self = [super init];//self调用者本身
    if (self){
        _activityId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
    _imgUrl = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"":dict[@"imgUrl"];
    self.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"活动" :dict[@"name"];
    self.content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"暂无内容" :dict[@"content"];
    self.like = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"reliableNumber"] integerValue];
    self.unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue];
    self.isFavo = [dict[@"isFavo"] isKindOfClass:[NSNull class] ] ? NO :[dict[@"isFavo"] boolValue];
    }
    return self;
}
- (id) initWhitDictionaryDictionary: (NSDictionary *)dict{
    self = [super init];//self调用者本身
    if (self){
        _activityId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        _imgUrl = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"活动"];
        _content = [Utilities nullAndNilCheck:dict[@"content"] replaceBy:@"暂无描述"];
        _like = [[Utilities nullAndNilCheck:dict[@"reliableNumber"] replaceBy:0] integerValue];
        _unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue];
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@"活动地址待定"];
        _applyFee = [Utilities nullAndNilCheck:dict[@"applicationFee"] replaceBy:@"0"];
        _attendence = [Utilities nullAndNilCheck:dict[@"participantsNumber"] replaceBy:@"0"];
        _atype = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@"未知发布者"];
        _issure = [Utilities nullAndNilCheck:dict[@"issuerName"] replaceBy:@""];
        _issurephone = [Utilities nullAndNilCheck:dict[@"issuerPhone"] replaceBy:@""];
        _limitation = [Utilities nullAndNilCheck:dict[@"attendenceAmount"] replaceBy:@"0"];
        _dueTime = [dict[@"applicationExpirationDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"applicationExpirationDate"] integerValue];
        _startTime = [dict[@"startDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"startDate"] integerValue];
        _endTime = [dict[@"endDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"endDate"] integerValue];;
        _status = [[Utilities nullAndNilCheck:dict[@"applyStatus"] replaceBy: @"-1"] integerValue];
    }
    return self;

}
@end
