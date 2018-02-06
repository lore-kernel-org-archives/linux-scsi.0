From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2 1/2] qedi: Fix truncation of CHAP name and secret
Date: Tue, 6 Feb 2018 15:23:41 +0000
Message-ID: <1517930620.3934.12.camel@wdc.com>
References: <20180206131219.18184-1-nilesh.javali@cavium.com>
         <20180206131219.18184-2-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49562 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbeBFPXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 10:23:45 -0500
In-Reply-To: <20180206131219.18184-2-nilesh.javali@cavium.com>
Content-Language: en-US
Content-ID: <1DC38CD6C3109B499E310AD932FAD2C5@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "nilesh.javali@cavium.com" <nilesh.javali@cavium.com>, "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

T24gVHVlLCAyMDE4LTAyLTA2IGF0IDA1OjEyIC0wODAwLCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0K
PiBGcm9tOiBBbmRyZXcgVmFzcXVleiA8YW5kcmV3LnZhc3F1ZXpAY2F2aXVtLmNvbT4NCj4gDQo+
IFRoZSBkYXRhIGluIE5WUkFNIGlzIG5vdCBndWFyYW50ZWVkIHRvIGJlIE5VTCB0ZXJtaW5hdGVk
Lg0KPiBDb3B5IHRoZSBkYXRhIHVwdG8gdGhlIGVsZW1lbnQgc2l6ZSBvciB0byB0aGUgZmlyc3Qg
TlVMDQo+IGluIHRoZSBieXRlLXN0cmVhbSBhbmQgdGhlbiBhcHBlbmQgYSBOVUwuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBBbmRyZXcgVmFzcXVleiA8YW5kcmV3LnZhc3F1ZXpAY2F2aXVtLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogTmlsZXNoIEphdmFsaSA8bmlsZXNoLmphdmFsaUBjYXZpdW0uY29t
Pg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9xZWRpL3FlZGlfbWFpbi5jIHwgNDUgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMz
IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9xZWRpL3FlZGlfbWFpbi5jIGIvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9tYWluLmMN
Cj4gaW5kZXggODgwOGYwZC4uZjNkZDQzOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Fl
ZGkvcWVkaV9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9tYWluLmMNCj4g
QEAgLTE3MDUsNiArMTcwNSwyNyBAQCB2b2lkIHFlZGlfcmVzZXRfaG9zdF9tdHUoc3RydWN0IHFl
ZGlfY3R4ICpxZWRpLCB1MTYgbXR1KQ0KPiAgCXFlZGlfb3BzLT5sbDItPnN0YXJ0KHFlZGktPmNk
ZXYsICZwYXJhbXMpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgc3NpemVfdA0KPiArcWVkaV9zaG93
X2NvcHlfZGF0YShjaGFyICpidWYsIHNpemVfdCBzaXplLCB1OCAqZGF0YSkNCj4gK3sNCj4gKwlz
aXplX3QgaTsNCj4gKw0KPiArCWlmICghZGF0YSkNCj4gKwkJcmV0dXJuIHNwcmludGYoYnVmLCAi
XG4iKTsNCj4gKw0KPiArCS8qDQo+ICsJICogRGF0YSBub3QgZ3VhcmFudGVlZCB0byBiZSBOVUwg
dGVybWluYXRlZC4gQ29weSB1bnRpbCBOVUwgZm91bmQgb3INCj4gKwkgKiBjb21wbGV0ZSBjb3B5
IGRvbmUuDQo+ICsJICovDQo+ICsJZm9yIChpID0gMDsgaSA8IHNpemUgJiYgZGF0YVtpXTsgaSsr
KQ0KPiArCQlidWZbaV0gPSBkYXRhW2ldOw0KPiArCS8qIERhdGEgY29weSBjb21wbGV0ZSwgYXBw
ZW5kIE5FV0xJTkUgYW5kIE5VTCB0ZXJtaW5hdG9yLiAqLw0KPiArCWJ1ZltpXSA9ICdcbic7DQo+
ICsJYnVmW2kgKyAxXSA9ICdcMCc7DQo+ICsJcmV0dXJuIHN0cmxlbihidWYpOw0KPiArfQ0KDQpD
YW4gdGhlIGJvZHkgb2YgdGhlIGFib3ZlIGZ1bmN0aW9uIGJlIGNoYW5nZWQgaW50byB0aGUgZm9s
bG93aW5nLCB3aGljaCBpcyBtdWNoDQpzaG9ydGVyPw0KDQpzcHJpbnRmKGJ1ZiwgIiUuKnMiLCAo
aW50KXNpemUsIGRhdGEgPyA6ICIiKQ0KDQpBZGRpdGlvbmFsbHksIGFyZSB5b3UgYXdhcmUgdGhh
dCBzeXNmcyBzaG93IGNhbGxiYWNrcyBkbyBub3QgaGF2ZSB0byB0ZXJtaW5hdGUNCmRhdGEgd2l0
aCAnXDAnPw0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0K
