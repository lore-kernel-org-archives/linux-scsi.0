From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 7/8] scsi/pmcraid: Remove an unused structure member
Date: Tue, 17 Oct 2017 14:28:29 +0000
Message-ID: <1508250508.3596.0.camel@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
         <20171016224940.1332-8-bart.vanassche@wdc.com>
         <5ea64c10-aa3e-f0ee-cfba-e93b3d8e1428@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11067 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdJQO2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 10:28:32 -0400
In-Reply-To: <5ea64c10-aa3e-f0ee-cfba-e93b3d8e1428@suse.de>
Content-Language: en-US
Content-ID: <E4CCECF6DB6A6F45A4582B095B95CBF0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "anil_ravindranath@pmc-sierra.com" <anil_ravindranath@pmc-sierra.com>

T24gVHVlLCAyMDE3LTEwLTE3IGF0IDA4OjIxICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIDEwLzE3LzIwMTcgMTI6NDkgQU0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBT
aWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+DQo+
ID4gUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8anRodW1zaGlybkBzdXNlLmRlPg0K
PiA+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiA+IENjOiBNYXJ0aW4gSy4gUGV0
ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KPiA+IENjOiBBbmlsIFJhdmluZHJh
bmF0aCA8YW5pbF9yYXZpbmRyYW5hdGhAcG1jLXNpZXJyYS5jb20+DQo+ID4gLS0tDQo+ID4gIGRy
aXZlcnMvc2NzaS9wbWNyYWlkLmggfCAxIC0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRp
b24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtY3JhaWQuaCBiL2Ry
aXZlcnMvc2NzaS9wbWNyYWlkLmgNCj4gPiBpbmRleCA4YmZhYzcyYTI0MmIuLjQ0ZGE5MTcxMjEx
NSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcG1jcmFpZC5oDQo+ID4gKysrIGIvZHJp
dmVycy9zY3NpL3BtY3JhaWQuaA0KPiA+IEBAIC01NDIsNyArNTQyLDYgQEAgc3RydWN0IHBtY3Jh
aWRfc2dsaXN0IHsNCj4gPiAgCXUzMiBvcmRlcjsNCj4gPiAgCXUzMiBudW1fc2c7DQo+ID4gIAl1
MzIgbnVtX2RtYV9zZzsNCj4gPiAtCXUzMiBidWZmZXJfbGVuOw0KPiA+ICAJc3RydWN0IHNjYXR0
ZXJsaXN0IHNjYXR0ZXJsaXN0WzFdOw0KPiA+ICB9Ow0KPiA+ICANCj4gPiANCj4gDQo+IFRoaXMg
YWN0dWFsbHkgaXMgdGhlIHNhbWUgc3RvcnkgdGhhdCB3ZSd2ZSBoYWQgd2l0aCBpcHIgKGFuZCwg
bG9va2luZyBhdA0KPiB0aGUgY29kZSwgdGhvc2UgdHdvIGRyaXZlcnMgbG9vayBhd2Z1bGx5IHNp
bWlsYXIgLi4uKS4NCj4gcG1jcmFpZF9zZ2xpc3QgbG9va3MgYXMgaWYgaXQncyBhIGhhcmR3YXJl
LWRlcGVuZGVudCBzdHJ1Y3R1cmUsIHNvIGp1c3QNCj4gcmVtb3Zpbmcgb25lIGVudHJ5IGZyb20g
dGhlIG1pZGRsZSBvZiBhIHN0cnVjdHVyZSBtaWdodCBub3QgYmUgYSBnb29kIGlkZWEuDQo+IEJ1
dCB0aGlzIGlzIHNvbWV0aGluZyBmb3IgdGhlIHBtY3JhaWQgZm9sa3MgdG8gY2xhcmlmeS4NCg0K
SGVsbG8gSGFubmVzLA0KDQpTb3JyeSBidXQgSSBkb24ndCBzZWUgaG93IGEgc3RydWN0dXJlIHRo
YXQgY29udGFpbnMgYSBzdHJ1Y3Qgc2NhdHRlcmxpc3QNCmNvdWxkIGJlIGhhcmR3YXJlLWRlcGVu
ZGVudD8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
