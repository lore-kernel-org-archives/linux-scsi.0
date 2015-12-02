From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 09/10] aacraid: Fix character device re initialization
Date: Wed, 2 Dec 2015 21:59:38 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1EE7AF@BBYEXM01.pmc-sierra.internal>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-11-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1449047907.3103.39.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:51076 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbbLBV7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2015 16:59:40 -0500
In-Reply-To: <1449047907.3103.39.camel@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

DQpIZWxsbyBKb2hhbm5lcywNCg0KPiBIacKgUmFnaGF2YSwNCj4gT24gVHVlLCAyMDE1LTEyLTAx
IGF0IDA0OjM5IC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3VudGEgd3JvdGU6DQo+ID4gRnJv
bTogUmFnaGF2YSBBZGl0eWEgUmVudWt1bnRhIDxyYWdoYXZhYWRpdHlhLnJlbnVrdW50YUBwbWNz
LmNvbT4NCj4gPg0KPiA+IER1cmluZyBFRUggUENJIGhvdHBsdWcgYWN0aXZpdHkga2VybmVsIHVu
bG9hZHMgYW5kIGxvYWRzIHRoZSBkcml2ZXIsDQo+ID4gY2F1c2luZyBjaGFyYWN0ZXIgZGV2aWNl
IHRvIGJlIHVucmVnaXN0ZXJlZChhYWNfcmVtb3ZlX29uZSkuV2hlbiB0aGUNCj4gPiBkcml2ZXIg
aXMgbG9hZGVkIGJhY2sgdXNpbmcgYWFjX3Byb2JlX29uZSB0aGUgY2hhcmFjdGVyIGRldmljZSBu
ZWVkcw0KPiA+IHRvIGJlIHJlZ2lzdGVyZWQgYWdhaW4gZm9yIHRoZSBBSUYgbWFuYWdlbWVudCB0
b29scyB0byB3b3JrLg0KPiA+DQo+ID4gRml4ZWQgYnkgYWRkaW5nIGNvZGUgdG8gcmVnaXN0ZXIg
Y2hhcmFjdGVyIGRldmljZSBpbiBhYWNfcHJvYmVfb25lIGlmDQo+ID4gaXQgaXMgdW5yZWdpc3Rl
cmVkIGluIGFhY19yZW1vdmVfb25lLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUmFnaGF2YSBB
ZGl0eWEgUmVudWt1bnRhDQo+ID4gPHJhZ2hhdmFhZGl0eWEucmVudWt1bnRhQHBtY3MuY29tPg0K
PiANCj4gVGhpcyBvbmUgaXMgZHVwbGljYXRlLCBpc24ndCBpdD8NCg0KWWVzIHRoaXMgb25lIGlz
IGEgZHVwbGljYXRlLg0K
