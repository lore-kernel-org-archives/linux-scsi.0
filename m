From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 4/7] qla2xxx: Added change to enable ZIO for FC-NVMe
 devices
Date: Thu, 20 Jul 2017 16:55:42 +0000
Message-ID: <AE3FEFA9-EC96-4C12-99DA-80DDF0FC9FFB@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
 <20170719185151.8564-5-himanshu.madhani@cavium.com>
 <20170720070016.GE5240@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0071.outbound.protection.outlook.com ([104.47.32.71]:32627
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934871AbdGTQzp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Jul 2017 12:55:45 -0400
In-Reply-To: <20170720070016.GE5240@linux-x5ow.site>
Content-Language: en-US
Content-ID: <D1D00A565C3FF840994DA0A6D421053B@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQo+IE9uIEp1bCAyMCwgMjAxNywgYXQgMTI6MDAgQU0sIEpvaGFubmVzIFRodW1zaGlybiA8anRo
dW1zaGlybkBzdXNlLmRlPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgSnVsIDE5LCAyMDE3IGF0IDEx
OjUxOjQ4QU0gLTA3MDAsIEhpbWFuc2h1IE1hZGhhbmkgd3JvdGU6DQo+PiArCW1jcC0+b3V0X21i
ID0gTUJYXzJ8TUJYXzF8TUJYXzA7DQo+PiArCW1jcC0+aW5fbWIgPSBNQlhfMnxNQlhfMDsNCj4g
DQo+IFBsZWFzZSBhZGQgc3BhY2VzIGFyb3VuZCB0aGUgJ3wnLiBDaGVja3BhdGNoIHNob3VsZCd2
ZSB3YXJuZWQgeW91IGFib3V0IHRoYXQuDQo+IA0KDQpTdXJlLiANCg0KPj4gKwltY3AtPnRvdiA9
IE1CWF9UT1ZfU0VDT05EUzsNCj4+ICsJbWNwLT5mbGFncyA9IDA7DQo+PiArDQo+PiArCXJ2YWwg
PSBxbGEyeDAwX21haWxib3hfY29tbWFuZCh2aGEsIG1jcCk7DQo+PiArCWlmIChydmFsICE9IFFM
QV9TVUNDRVNTKSB7DQo+PiArCQlxbF9kYmcocWxfZGJnX21ieCwgdmhhLCAweDEyMDEsICJGYWls
ZWQ9JXguXG4iLCBydmFsKTsNCj4+ICsJfSBlbHNlIHsNCj4+ICsJCXFsX2RiZyhxbF9kYmdfbWJ4
ICsgcWxfZGJnX3ZlcmJvc2UsIHZoYSwgMHgxMjAyLA0KPj4gKwkJICAgICJEb25lICVzLlxuIiwg
X19mdW5jX18pOw0KPj4gKwl9DQo+IA0KPiBJbiBwYXRjaCAxIHlvdSBjaGFuZ2UgYWxsIHRoZSAN
Cj4gaWYgKHJ2YWwgIT0gUUxBX1NVQ0NFU1MpIHsNCj4gCXFsYV9kYmcoKTsNCj4gfSBlbHNlIHsN
Cj4gCXFsYV9kYmcoKTsNCj4gfQ0KPiBpbnRvIGEgc2luZ2xlIHFsYV9kYmcuIE5vdyB5b3UgcmUt
aW50cm9kdWNlIHRoZSBwYXR0ZXJuIGhlcmUuDQo+IA0KDQpHb29kIGNhdGNoLi4gc29tZWhvdyB0
aGlzIG1pc3NlZCBteSBleWUuIEnigJlsbCBmaXggaW4gdjIgb2YgdGhpcyBzZXJpZXMuIA0KDQo+
IA0KPj4gK2ludCBxbGEyN3h4X2dldF96aW9fdGhyZXNob2xkKHNjc2lfcWxhX2hvc3RfdCAqdmhh
LCB1aW50MTZfdCAqdmFsdWUpDQo+IA0KPiBTZWUgYWJvdmUgY29tbWVudA0KPiANCj4gVGhhbmtz
LAkNCj4gCUpvaGFubmVzDQo+IC0tIA0KPiBKb2hhbm5lcyBUaHVtc2hpcm4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTdG9yYWdlDQo+IGp0aHVtc2hpcm5Ac3VzZS5k
ZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODkNCj4gU1VT
RSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcNCj4gR0Y6IEZlbGl4
IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbg0KPiBIUkIgMjEyODQg
KEFHIE7DvHJuYmVyZykNCj4gS2V5IGZpbmdlcnByaW50ID0gRUMzOCA5Q0FCIEMyQzQgRjI1RCA4
NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1MA0KDQpUaGFua3MsDQotIEhpbWFuc2h1DQoNCg==
