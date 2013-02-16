From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: avoid usage of WRITE_SAME
Date: Sat, 16 Feb 2013 15:20:54 +0000
Message-ID: <8ba1b86927bf41e8bc29c9f69c19408f@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359557094-13625-1-git-send-email-olaf@aepfle.de>
 <20130211160638.GB15243@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.29]:48634
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab3BPPVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Feb 2013 10:21:12 -0500
Received: from mail25-db3 (localhost [127.0.0.1])	by mail25-db3-R.bigfish.com
 (Postfix) with ESMTP id 75DA04C0191	for
 <linux-scsi@vger.kernel.org.FOPE.CONNECTOR.OVERRIDE>; Sat, 16 Feb 2013
 15:21:06 +0000 (UTC)
In-Reply-To: <20130211160638.GB15243@aepfle.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xhZiBIZXJpbmcgW21h
aWx0bzpvbGFmQGFlcGZsZS5kZV0NCj4gU2VudDogTW9uZGF5LCBGZWJydWFyeSAxMSwgMjAxMyAx
MTowNyBBTQ0KPiBUbzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEphbWVzIEJvdHRvbWxl
eQ0KPiBDYzogS1kgU3Jpbml2YXNhbg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBzY3NpOiBzdG9y
dnNjOiBhdm9pZCB1c2FnZSBvZiBXUklURV9TQU1FDQo+IA0KPiBKYW1lcywNCj4gDQo+IHRoaXMg
cGF0Y2ggZml4ZXMgYSByZWdyZXNzaW9uIGluIDMuOC4gUGxlYXNlIHRyeSB0byBpbmNsdWRlIGl0
IGluIGZpbmFsIDMuOC4NCj4gVGhlcmUgaXMgYWxzbyBhbm90aGVyIG91dHN0YW5kaW5nIGZpeCBy
ZWdhcmRpbmcgc2dsaXN0IGluaXQgZnJvbSBLWS4NCj4gDQo+IE9sYWYNCj4gDQo+IE9uIFdlZCwg
SmFuIDMwLCBPbGFmIEhlcmluZyB3cm90ZToNCj4gDQo+ID4gU2V0IHNjc2lfZGV2aWNlLT5ub193
cml0ZV9zYW1lIGJlY2F1c2UgdGhlIGhvc3QgZG9lcyBub3Qgc3VwcG9ydCBpdC4NCj4gPiBBbHNv
IGJsYWNrbGlzdCBXUklURV9TQU1FIHRvIGF2b2lkIChhbmQgbG9nKSBhY2NpZGVudCB1c2FnZS4N
Cj4gPg0KPiA+IElmIHRoZSBndWVzdCB1c2VzIHRoZSBleHQ0IGZpbGVzeXN0ZW0sIHN0b3J2c2Mg
aGFuZ3Mgd2hpbGUgaXQgcHJpbnRzDQo+ID4gdGhlc2UgbWVzc2FnZXMgaW4gYW4gZW5kbGVzcyBs
b29wOg0KPiANCj4gDQo+ID4gIGRyaXZlcnMvc2NzaS9zdG9ydnNjX2Rydi5jIHwgNCArKysrDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+ID4gKwlzZGV2aWNlLT5u
b193cml0ZV9zYW1lID0gMTsNCj4gDQo+IA0KDQpKYW1lcywNCg0KUGluZy4gQ2FuIHRoZXNlIG1h
a2UgdGhlIDMuOCByZWxlYXNlLg0KDQoNClJlZ2FyZHMsDQoNCksuIFkNCg==

