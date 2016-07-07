From: David Carroll <david.carroll@microsemi.com>
Subject: RE: Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/commctrl.c
Date: Thu, 7 Jul 2016 22:43:53 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15F9B3D4@avsrvexchmbx1.microsemi.net>
References: <CACxtibTF72YUeOnm2Rsx6odjRXybjbbGbx32-CqAu5u6ahndKg@mail.gmail.com>
 <1461681982.2348.4.camel@HansenPartnership.com>
 <56AE387A-9CCB-4524-A3FB-1DCA24D816E0@gmail.com>
 <CACxtibRmuwx0athffBQ9mNdGPoHDah+UU+FF5fGjPqwzbD3R1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0070.outbound.protection.outlook.com ([104.47.36.70]:1440
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbcGHARq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 20:17:46 -0400
In-Reply-To: <CACxtibRmuwx0athffBQ9mNdGPoHDah+UU+FF5fGjPqwzbD3R1Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pengfei Wang <wpengfeinudt@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1zY3NpLW93bmVyQHZn
ZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXNjc2ktDQo+IG93bmVyQHZnZXIua2VybmVsLm9y
Z10gT24gQmVoYWxmIE9mIFBlbmdmZWkgV2FuZw0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAwNywg
MjAxNiA3OjAwIEFNDQo+IFRvOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogRG91YmxlLUZldGNoIGJ1ZyBpbiBMaW51eC00LjUvZHJpdmVycy9zY3NpL2FhY3JhaWQv
Y29tbWN0cmwuYw0KPiBIaSwNCj4gDQo+IFdpbGwgYW55b25lIGJvdGhlciB0byBjb25maXJtIGFu
ZCBmaXggdGhpcyBwcm9ibGVtIEkgcmVwb3J0ZWQgbGFzdCB0aW1lPyBGcm9tDQo+IHRoZSBwb2lu
dCBvZiB2aWV3IG9mIHNlY3VyaXR5LCBJIHRoaW5rIGl0IHNob3VsZCBiZSBmaXhlZC4NCj4gSSBo
YXZlIGRpc2NvdmVyZWQgc2V2ZXJhbCBjYXNlcyBvZiB0aGUgc2FtZSBraW5kIGFuZCBhbGwgaGF2
ZSBiZWVuIGZpeGVkIGJ5DQo+IHRoZSBtYWludGFpbmVycy4gVGhhbmtzIQ0KPiANCj4gUGVuZ2Zl
aQ0KPiANCg0KSGkgUGVuZ2ZlaSwNCg0KSSdtIGN1cnJlbnRseSB3b3JraW5nIG9uIGEgcGF0Y2gg
c2V0IGZvciB0aGUgSEJBLTEwMDAgY2FyZCwgYW5kIEkgYWdyZWUgd2l0aCB5b3VyIGFzc2Vzc21l
bnQuIFdlIHdpbGwgY2hlY2sgdGhlIHNpemVzIGFuZCByZXR1cm4gYW4gZXJyb3IgaWYgdGhlIHNp
emUgaXMgbGFyZ2VyIHRoYW4gd2hlbiBmaXJzdCBjaGVja2VkOw0KIGkuZS4NCg0KCWlmIChjb3B5
X2Zyb21fdXNlcihrZmliLCBhcmcsIHNpemUpKSB7DQoJCXJldHZhbCA9IC1FRkFVTFQ7DQoJCWdv
dG8gY2xlYW51cDsNCgl9DQoNCglpZiAodW5saWtlbHkoKGxlMTZfdG9fY3B1KGtmaWItPmhlYWRl
ci5TaXplKSArIHNpemVvZihzdHJ1Y3QgYWFjX2ZpYmhkcikpID4gc2l6ZSkpIHsNCgkJcmV0dmFs
ID0gLUVJTlZBTDsNCgkJZ290byBjbGVhbnVwOw0KCX0NCg0KVGhhbmtzLCAtRGF2ZQ0KDQo=
