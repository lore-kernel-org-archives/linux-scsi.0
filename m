From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Wed, 12 Jul 2017 14:18:14 +0000
Message-ID: <1499869093.8204.2.camel@wdc.com>
References: <20170616082755.22832-1-hch@lst.de>
         <1499701840.3555.7.camel@wdc.com>
         <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
         <1499779970.3345.1.camel@wdc.com>
         <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
         <1499788012.2586.12.camel@wdc.com>
         <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com>
         <581a258d-3da8-5b01-f528-0ce11b74b65e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2218 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdGLOST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 10:18:19 -0400
In-Reply-To: <581a258d-3da8-5b01-f528-0ce11b74b65e@huawei.com>
Content-Language: en-US
Content-ID: <CFDC333A7B419340BA5E8DC617479FDF@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>

T24gV2VkLCAyMDE3LTA3LTEyIGF0IDA5OjI2ICswMTAwLCBKb2huIEdhcnJ5IHdyb3RlOg0KPiA+
ID4gV2hhdCBibG9jayBkcml2ZXIgY29udHJvbHMgdGhlIGJsb2NrIGRldmljZSBmb3Igd2hpY2gg
dGhlIHBlcmZvcm1hbmNlDQo+ID4gPiByZWdyZXNzaW9uDQo+ID4gPiBoYXMgYmVlbiBvYnNlcnZl
ZD8gSG93IG1hbnkgaGFyZHdhcmUgcXVldWVzIHdlcmUgY3JlYXRlZCBieSB0aGF0IGJsb2NrDQo+
ID4gPiBkcml2ZXINCj4gPiA+IChzZWUgYWxzbyAvc3lzL2Jsb2NrLyovbXEvLi4uKT8NCj4gDQo+
IEp1c3QgY29uZmlybWluZyB0aGF0IHdlIGhhdmUgb25seSAxIHF1ZXVlOg0KPiAvc3lzL2Jsb2Nr
L3NkYy9tcS8wIGFzIGV4YW1wbGUNCg0KSGVsbG8gSm9obiwNCg0KQ2FuIHlvdSBhbHNvIGNoZWNr
IHRoZSBJL08gc2NoZWR1bGVyIHRoYXQgaGFzIGJlZW4gc2VsZWN0ZWQ/DQoNClRoYW5rcywNCg0K
QmFydC4=
