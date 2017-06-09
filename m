From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 01/15] qla2xxx: Combine Active command arrays.
Date: Fri, 9 Jun 2017 18:19:07 +0000
Message-ID: <7020B3B0-F85A-4044-98B8-3FDF972ECBB0@cavium.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
 <20170607214333.23110-2-himanshu.madhani@cavium.com>
 <1496875510.27975.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0047.outbound.protection.outlook.com ([104.47.33.47]:45520
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751750AbdFISTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Jun 2017 14:19:15 -0400
In-Reply-To: <1496875510.27975.1.camel@wdc.com>
Content-Language: en-US
Content-ID: <BCEDB69932288541A732B6CD8B9E886B@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQmFydCwgDQoNCj4gT24gSnVuIDcsIDIwMTcsIGF0IDM6NDUgUE0sIEJhcnQgVmFuIEFzc2No
ZSA8YmFydC52YW5hc3NjaGVAc2FuZGlzay5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCAyMDE3
LTA2LTA3IGF0IDE0OjQzIC0wNzAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3RlOg0KPj4gK2VudW0g
ew0KPj4gKwlUWVBFX1NSQiwNCj4+ICsJVFlQRV9UR1RfQ01ELA0KPj4gK307DQo+PiArDQo+PiB0
eXBlZGVmIHN0cnVjdCBzcmIgew0KPj4gKwkvKg0KPj4gKwkgKiBEbyBub3QgbW92ZSBjbWRfdHlw
ZSBmaWVsZCwgaXQgbmVlZHMgdG8NCj4+ICsJICogbGluZSB1cCB3aXRoIHFsYV90Z3RfY21kLT5j
bWRfdHlwZQ0KPj4gKwkgKi8NCj4+ICsJdWludDhfdCBjbWRfdHlwZTsNCj4+ICsJdWludDhfdCBw
YWRbM107DQo+PiAJYXRvbWljX3QgcmVmX2NvdW50Ow0KPj4gCXN0cnVjdCBmY19wb3J0ICpmY3Bv
cnQ7DQo+PiAJc3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYTsNCj4gDQo+IFsgLi4uIF0NCj4gDQo+
PiBzdHJ1Y3QgcWxhX3RndF9jbWQgew0KPj4gKwkvKg0KPj4gKwkgKiBEbyBub3QgbW92ZSBjbWRf
dHlwZSBmaWVsZC4gaXQgbmVlZHMgdG8gbGluZSB1cCB3aXRoIHNyYi0+Y21kX3R5cGUNCj4+ICsJ
ICovDQo+PiArCXVpbnQ4X3QgY21kX3R5cGU7DQo+PiArCXVpbnQ4X3QgcGFkWzddOw0KPj4gCXN0
cnVjdCBzZV9jbWQgc2VfY21kOw0KPj4gCXN0cnVjdCBmY19wb3J0ICpzZXNzOw0KPj4gCWludCBz
dGF0ZTsNCj4gDQo+IEhlbGxvIFF1aW5uIGFuZCBIaW1hbnNodSwNCj4gDQo+IFNvcnJ5IGJ1dCB0
aGlzIGlzIHJlYWxseSBpbmVsZWdhbnQuIEhhdmUgeW91IGNvbnNpZGVyZWQgdGhlIGZvbGxvd2lu
Zz8NCj4gLSBLZWVwIHRoZSBleGlzdGluZyBzcmIgYW5kIHFsYV90Z3RfY21kIGRhdGEgc3RydWN0
dXJlcy4NCj4gLSBJbnRyb2R1Y2UgYSBuZXcgZGF0YSBzdHJ1Y3R1cmUgd2l0aCBlbnVtIGNtZF90
eXBlIGFzIHRoZSBmaXJzdCBtZW1iZXIgYW5kDQo+ICBhIHVuaW9uIG9mIHN0cnVjdCBzcmIgYW5k
IHN0cnVjdCBxbGFfdGd0X2NtZCBhcyB0aGUgc2Vjb25kIG1lbWJlci4NCj4gLSBVc2UgX19hdHRy
aWJ1dGVfXygoYWxpZ25lZCguLi4pKSkgdG8gZXhwcmVzcyBhbGlnbm1lbnQgcmVxdWlyZW1lbnRz
IGluc3RlYWQNCj4gIG9mIGV4cGxpY2l0bHkgaW5zZXJ0aW5nIHBhZGRpbmcgYnl0ZXMuDQo+IA0K
PiBXaXRoIHRoYXQgYXBwcm9hY2ggbm8gY2FzdHMgYXJlIG5lZWRlZCB0byBjb252ZXJ0IGEgcG9p
bnRlciB0byB0aGUgbmV3IGRhdGENCj4gc3RydWN0dXJlIGludG8gYSBzdHJ1Y3Qgc3JiIG9yIHN0
cnVjdCBxbGFfdGd0X2NtZCBwb2ludGVyIC0gYWxsIHRoYXQgd2lsbCBiZQ0KPiBuZWVkZWQgaXMg
dG8gdGFrZSB0aGUgYWRkcmVzcyBvZiB0aGUgYXBwcm9wcmlhdGUgbWVtYmVyIG9mIHRoZSB1bmlv
bi4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCldlIGFyZSB3b3JraW5nIG9uIGFkZHJl
c3NpbmcgdGhpcyByZXZpZXcgY29tbWVudC4gV2XigJlsbCBzZW5kIGl0IGFzIGEgc2VwYXJhdGUN
CnBhdGNoIG9uY2Ugd2UgcnVuIHRocm91Z2ggb3VyIHJlZ3Jlc3Npb24gdGVzdCBjeWNsZS4NCg0K
VGhhbmtzLA0KLSBIaW1hbnNodQ0KDQo=
