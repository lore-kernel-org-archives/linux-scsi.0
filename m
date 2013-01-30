From: KY Srinivasan <kys@microsoft.com>
Subject: RE: storvsc loops with No Sense messages
Date: Wed, 30 Jan 2013 18:16:20 +0000
Message-ID: <c3d77448a4324f8d909046e8a63aae7d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130129152801.GA671@aepfle.de>
 <a120050e059c40c2a1d1be4eadc42dfd@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129185600.GA31738@aepfle.de>
 <05a4f02fe12545f489dd053175990b8d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129212743.GA8052@aepfle.de> <20130130095947.GA6626@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.25]:9442
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab3A3SSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 13:18:20 -0500
Received: from mail210-ch1 (localhost [127.0.0.1])	by
 mail210-ch1-R.bigfish.com (Postfix) with ESMTP id 582793800F5	for
 <linux-scsi@vger.kernel.org.FOPE.CONNECTOR.OVERRIDE>; Wed, 30 Jan 2013
 18:16:28 +0000 (UTC)
In-Reply-To: <20130130095947.GA6626@aepfle.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xhZiBIZXJpbmcgW21h
aWx0bzpvbGFmQGFlcGZsZS5kZV0NCj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDMwLCAyMDEz
IDU6MDAgQU0NCj4gVG86IEtZIFNyaW5pdmFzYW4NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBzdG9ydnNjIGxvb3BzIHdpdGggTm8gU2Vuc2UgbWVzc2Fn
ZXMNCj4gDQo+IE9uIFR1ZSwgSmFuIDI5LCBPbGFmIEhlcmluZyB3cm90ZToNCj4gDQo+ID4gT24g
VHVlLCBKYW4gMjksIEtZIFNyaW5pdmFzYW4gd3JvdGU6DQo+ID4NCj4gPiA+IFdhcyB0aGUgaW5z
dGFsbGF0aW9uIGRvbmUgb24gYSB2aGQgb3IgVkhEWC4gSSBjaGVja2VkIHdpdGggSHlwZXItVg0K
PiA+ID4gZ3V5cyBhbmQgdGhleSBzYXkgdGhleSBuZXZlciBzdXBwb3J0ZWQgV1JJVEVfU0FNRS4g
SSBhbSB3b25kZXJpbmcgaG93DQo+ID4gPiBpdCB3b3JrZWQgb24gd3MyMDA4Lg0KPiA+DQo+ID4g
SXRzIGEgdmhkeCBpbWFnZSwgYm90aCBmaXhlZCBhbmQgZHluYW1pY2FsbHkgc2l6ZSBoYXZlIHRo
ZSBzYW1lIGlzc3VlLg0KPiA+IEkgd2lsbCBzZWUgd2hhdCBoYXBwZW5zIHdpdGggd3MyMDA4LCBh
dCBsZWFzdCB0aGUgaW5zdGFsbCBwcm9jZWVkcw0KPiA+IHdpdGhvdXQgaXNzdWVzLg0KPiANCj4g
SSBzZWUgdGhhdCBXUklURV9TQU1FIGlzIGFsc28gdXNlZCB3aGVuIHJ1bm5pbmcgb24gd3MyMDA4
LCBidXQNCj4gYXBwZWFyZW50bHkgaXQgZG9lcyBub3QgY2F1c2UgYW55IGlzc3Vlcy4NCj4gVGhp
cyB0cmlnZ2VycyBvbmx5IHdoZW4gdGhlIGRlZmF1bHQgZXh0NCBpcyB1c2VkLCBub3Qgd2hlbiBJ
IGZvcmNlIGV4dDMNCj4gZm9yIHRoZSByb290IGZpbGVzeXN0ZW0uDQoNClRhbGtpbmcgdG8gdGhl
IE1TRlQgc3RvcmFnZSBndXlzLCBXUklURV9TQU1FIGhhcyBuZXZlciBiZWVuIHN1cHBvcnRlZCAt
IG5vdA0Kb24gd3MyMDA4IG9yIG9uIHdzMjAxMi4gU28gSSBhbSBub3Qgc3VyZSB3aHkgb3IgaG93
IHRoaXMgd29ya3Mgb24gd3MyMDA4Lg0KDQpLLiBZDQo+IFNvIHRvIG1lIGl0IGxvb2tzIGxpa2Ug
d3MyMDEyIGhhcyBpc3N1ZXMgd2l0aCBXUklURV9TQU1FIGhhbmRsaW5nLg0KPiANCj4gDQo+IElz
IHRoZXJlIGEgd2F5IHRvIG5vdCB1c2UgV1JJVEVfU0FNRSBhdCBhbGw/IFdoaWxlIGJyb3dzaW5n
IHRoZSBjb2RlIGl0cw0KPiBub3QgY2xlYXIgaWYgdGhlcmUgaXMgYSBjb25kaXRpb25hbCBmb3Ig
dGhpcyBjb21tYW5kLg0KPiANCj4gDQo+IE9sYWYNCj4gDQoNCg==

