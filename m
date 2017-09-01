From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/8] block: Fix declaration of blk-mq debugfs functions
Date: Fri, 1 Sep 2017 16:00:30 +0000
Message-ID: <1504281628.14386.23.camel@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
         <20170901113631.12323-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43154 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdIAQBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 12:01:18 -0400
In-Reply-To: <20170901113631.12323-2-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <E466AB6A5A168343B1AED5B7940474AD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDIwOjM2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmxrLW1xLmggYi9pbmNsdWRlL2xpbnV4L2Js
ay1tcS5oDQo+IGluZGV4IDE0NTQyMzA4ZDI1Yi4uYTM2OTE3NGE5Njc5IDEwMDY0NA0KPiAtLS0g
YS9pbmNsdWRlL2xpbnV4L2Jsay1tcS5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvYmxrLW1xLmgN
Cj4gQEAgLTUsNiArNSwyMSBAQA0KPiAgI2luY2x1ZGUgPGxpbnV4L3NiaXRtYXAuaD4NCj4gICNp
bmNsdWRlIDxsaW51eC9zcmN1Lmg+DQo+ICANCj4gKyNpZmRlZiBDT05GSUdfQkxLX0RFQlVHX0ZT
DQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9zZXFfZmlsZS5oPg0KPiArDQo+ICtzdHJ1Y3QgYmxr
X21xX2RlYnVnZnNfYXR0ciB7DQo+ICsJY29uc3QgY2hhciAqbmFtZTsNCj4gKwl1bW9kZV90IG1v
ZGU7DQo+ICsJaW50ICgqc2hvdykodm9pZCAqLCBzdHJ1Y3Qgc2VxX2ZpbGUgKik7DQo+ICsJc3Np
emVfdCAoKndyaXRlKSh2b2lkICosIGNvbnN0IGNoYXIgX191c2VyICosIHNpemVfdCwgbG9mZl90
ICopOw0KPiArCS8qIFNldCBlaXRoZXIgLnNob3cgb3IgLnNlcV9vcHMuICovDQo+ICsJY29uc3Qg
c3RydWN0IHNlcV9vcGVyYXRpb25zICpzZXFfb3BzOw0KPiArfTsNCj4gKw0KPiArI2VuZGlmDQo+
ICsNCj4gIHN0cnVjdCBibGtfbXFfdGFnczsNCj4gIHN0cnVjdCBibGtfZmx1c2hfcXVldWU7DQo+
ICANCj4gQEAgLTI4OSw0ICszMDQsOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgKmJsa19tcV9ycV90
b19wZHUoc3RydWN0IHJlcXVlc3QgKnJxKQ0KPiAgCWZvciAoKGkpID0gMDsgKGkpIDwgKGhjdHgp
LT5ucl9jdHggJiYJCQkJXA0KPiAgCSAgICAgKHsgY3R4ID0gKGhjdHgpLT5jdHhzWyhpKV07IDE7
IH0pOyAoaSkrKykNCj4gIA0KPiArI2lmZGVmIENPTkZJR19CTEtfREVCVUdfRlMNCj4gK2ludCBf
X2Jsa19tcV9kZWJ1Z2ZzX3JxX3Nob3coc3RydWN0IHNlcV9maWxlICptLCBzdHJ1Y3QgcmVxdWVz
dCAqcnEpOw0KPiAraW50IGJsa19tcV9kZWJ1Z2ZzX3JxX3Nob3coc3RydWN0IHNlcV9maWxlICpt
LCB2b2lkICp2KTsNCj4gKyNlbmRpZg0KPiArDQo+ICAjZW5kaWYNCg0KSGVsbG8gRGFtaWVuLA0K
DQpTaG91bGQgdGhlc2UgZGVmaW5pdGlvbnMgcGVyaGFwcyBiZSBtb3ZlZCB0byBhIG5ldyBoZWFk
ZXIgZmlsZSwgZS5nLg0KaW5jbHVkZS9saW51eC9ibGstbXEtZGVidWdmcy5oLCBzdWNoIHRoYXQg
dGhlIGludHJvZHVjdGlvbiBvZiBtb3JlICNpZmRlZnMNCmFuZCAjaW5jbHVkZSA8bGludXgvc2Vx
X2ZpbGUuaD4gaW4gaW5jbHVkZS9saW51eC9ibGstbXEuaCBjYW4gYmUgYXZvaWRlZD8NCg0KVGhh
bmtzLA0KDQpCYXJ0Lg==
