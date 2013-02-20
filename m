From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: avoid usage of WRITE_SAME
Date: Wed, 20 Feb 2013 21:48:24 +0000
Message-ID: <5634aede223b4b388846e08010ef2483@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1359557094-13625-1-git-send-email-olaf@aepfle.de>
 <20130211160638.GB15243@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.55.169.28] ([65.55.169.28]:12633 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab3BTVx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2013 16:53:59 -0500
Received: from mail127-tx2 (localhost [127.0.0.1])	by
 mail127-tx2-R.bigfish.com (Postfix) with ESMTP id 6A7EC180239	for
 <linux-scsi@vger.kernel.org.FOPE.CONNECTOR.OVERRIDE>; Wed, 20 Feb 2013
 21:49:22 +0000 (UTC)
In-Reply-To: <20130211160638.GB15243@aepfle.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KY Srinivasan <kys@microsoft.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xhZiBIZXJpbmcgW21h
aWx0bzpvbGFmQGFlcGZsZS5kZV0NCj4gU2VudDogTW9uZGF5LCBGZWJydWFyeSAxMSwgMjAxMyAx
MTowNyBBTQ0KPiBUbzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEphbWVzIEJvdHRvbWxl
eQ0KPiBDYzogS1kgU3Jpbml2YXNhbg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBzY3NpOiBzdG9y
dnNjOiBhdm9pZCB1c2FnZSBvZiBXUklURV9TQU1FDQo+IA0KPiBKYW1lcywNCj4gDQo+IHRoaXMg
cGF0Y2ggZml4ZXMgYSByZWdyZXNzaW9uIGluIDMuOC4gUGxlYXNlIHRyeSB0byBpbmNsdWRlIGl0
IGluIGZpbmFsIDMuOC4NCj4gVGhlcmUgaXMgYWxzbyBhbm90aGVyIG91dHN0YW5kaW5nIGZpeCBy
ZWdhcmRpbmcgc2dsaXN0IGluaXQgZnJvbSBLWS4NCj4gDQo+IE9sYWYNCg0KUGluZy4NCg0KSy4g
WQ0KPiANCj4gT24gV2VkLCBKYW4gMzAsIE9sYWYgSGVyaW5nIHdyb3RlOg0KPiANCj4gPiBTZXQg
c2NzaV9kZXZpY2UtPm5vX3dyaXRlX3NhbWUgYmVjYXVzZSB0aGUgaG9zdCBkb2VzIG5vdCBzdXBw
b3J0IGl0Lg0KPiA+IEFsc28gYmxhY2tsaXN0IFdSSVRFX1NBTUUgdG8gYXZvaWQgKGFuZCBsb2cp
IGFjY2lkZW50IHVzYWdlLg0KPiA+DQo+ID4gSWYgdGhlIGd1ZXN0IHVzZXMgdGhlIGV4dDQgZmls
ZXN5c3RlbSwgc3RvcnZzYyBoYW5ncyB3aGlsZSBpdCBwcmludHMNCj4gPiB0aGVzZSBtZXNzYWdl
cyBpbiBhbiBlbmRsZXNzIGxvb3A6DQo+IA0KPiANCj4gPiAgZHJpdmVycy9zY3NpL3N0b3J2c2Nf
ZHJ2LmMgfCA0ICsrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gPiArCXNkZXZpY2UtPm5vX3dyaXRlX3NhbWUgPSAxOw0KPiANCj4gDQoNCg==

