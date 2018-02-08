From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] blk-mq: tags: define several fields of tags as
 pointer
Date: Thu, 8 Feb 2018 17:34:19 +0000
Message-ID: <1518111257.3611.33.camel@wdc.com>
References: <20180203042112.15239-1-ming.lei@redhat.com>
         <20180203042112.15239-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180203042112.15239-2-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <AE7DF10F05096F4CA207DA53772577AD@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "arun.easi@cavium.com" <arun.easi@cavium.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE4LTAyLTAzIGF0IDEyOjIxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gZGlm
ZiAtLWdpdCBhL2Jsb2NrL2Jsay1tcS10YWcuaCBiL2Jsb2NrL2Jsay1tcS10YWcuaA0KPiBpbmRl
eCA2MWRlYWIwYjVhNWEuLmE2ODMyM2ZhMGMwMiAxMDA2NDQNCj4gLS0tIGEvYmxvY2svYmxrLW1x
LXRhZy5oDQo+ICsrKyBiL2Jsb2NrL2Jsay1tcS10YWcuaA0KPiBAQCAtMTEsMTAgKzExLDE0IEBA
IHN0cnVjdCBibGtfbXFfdGFncyB7DQo+ICAJdW5zaWduZWQgaW50IG5yX3RhZ3M7DQo+ICAJdW5z
aWduZWQgaW50IG5yX3Jlc2VydmVkX3RhZ3M7DQo+ICANCj4gLQlhdG9taWNfdCBhY3RpdmVfcXVl
dWVzOw0KPiArCWF0b21pY190ICphY3RpdmVfcXVldWVzOw0KPiArCWF0b21pY190IF9fYWN0aXZl
X3F1ZXVlczsNCj4gIA0KPiAtCXN0cnVjdCBzYml0bWFwX3F1ZXVlIGJpdG1hcF90YWdzOw0KPiAt
CXN0cnVjdCBzYml0bWFwX3F1ZXVlIGJyZXNlcnZlZF90YWdzOw0KPiArCXN0cnVjdCBzYml0bWFw
X3F1ZXVlICpiaXRtYXBfdGFnczsNCj4gKwlzdHJ1Y3Qgc2JpdG1hcF9xdWV1ZSAqYnJlc2VydmVk
X3RhZ3M7DQo+ICsNCj4gKwlzdHJ1Y3Qgc2JpdG1hcF9xdWV1ZSBfX2JpdG1hcF90YWdzOw0KPiAr
CXN0cnVjdCBzYml0bWFwX3F1ZXVlIF9fYnJlc2VydmVkX3RhZ3M7DQo+ICANCj4gIAlzdHJ1Y3Qg
cmVxdWVzdCAqKnJxczsNCj4gIAlzdHJ1Y3QgcmVxdWVzdCAqKnN0YXRpY19ycXM7DQoNClRoaXMg
aXMgZ2V0dGluZyB1Z2x5OiBtdWx0aXBsZSBwb2ludGVycyB0aGF0IGVpdGhlciBhbGwgcG9pbnQg
YXQgYW4gZWxlbWVudA0KaW5zaWRlIHN0cnVjdCBibGtfbXFfdGFncyBvciBhbGwgcG9pbnQgYXQg
YSBtZW1iZXIgb3V0c2lkZSBibGtfbXFfdGFncy4gSGF2ZQ0KeW91IGNvbnNpZGVyZWQgdG8gaW50
cm9kdWNlIGEgbmV3IHN0cnVjdHVyZSBmb3IgdGhlc2UgbWVtYmVycyAoYWN0aXZlX3F1ZXVlcywN
CmJpdG1hcF90YWdzIGFuZCBicmVzZXJ2ZWRfdGFncykgc3VjaCB0aGF0IG9ubHkgYSBzaW5nbGUg
bmV3IHBvaW50ZXIgaGFzIHRvDQpiZSBpbnRyb2R1Y2VkIGluIHN0cnVjdCBibGtfbXFfdGFncz8g
QWRkaXRpb25hbGx5LCB3aHkgZG9lcyBldmVyeQ0KYmxrX21xX3RhZ3MgaW5zdGFuY2UgaGF2ZSBp
dHMgb3duIHN0YXRpY19ycXMgYXJyYXkgaWYgdGFncyBhcmUgc2hhcmVkDQphY3Jvc3MgaGFyZHdh
cmUgcXVldWVzPyBibGtfbXFfZ2V0X3RhZygpIGFsbG9jYXRlcyBhIHRhZyBlaXRoZXIgZnJvbQ0K
Yml0bWFwX3RhZ3Mgb3IgZnJvbSBicmVzZXJ2ZWRfdGFncy4gU28gaWYgdGhlc2UgdGFnIHNldHMg
YXJlIHNoYXJlZCBJDQpkb24ndCB0aGluayB0aGF0IGl0IGlzIG5lY2Vzc2FyeSB0byBoYXZlIG9u
ZSBzdGF0aWNfcnFzIGFycmF5IHBlciBzdHJ1Y3QNCmJsa19tcV90YWdzIGluc3RhbmNlLg0KDQpU
aGFua3MsDQoNCkJhcnQuDQoNCg0KDQo=
