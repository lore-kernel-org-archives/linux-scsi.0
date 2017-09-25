From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: fc: check for rport presence in fc_block_scsi_eh
Date: Mon, 25 Sep 2017 23:29:07 +0000
Message-ID: <1506382146.2641.61.camel@wdc.com>
References: <20170925120049.19689-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170925120049.19689-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <55FAF15C62D8C14C81FDE6D45A3AEB8B@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDE0OjAwICswMjAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IENvdmVyaXR5LXNjYW4gcmVjZW50bHkgZm91bmQgYSBwb3NzaWJsZSBOVUxMIHBvaW50
ZXIgZGVyZWZlcmVuY2UgaW4NCj4gZmNfYmxvY2tfc2NzaV9laCgpIGFzIHN0YXJnZXRfdG9fcnBv
cnQoKSBlaXRoZXIgcmV0dXJucyB0aGUgcnBvcnQgZm9yDQo+IHRoZSBzdGFydGdldCBvciBOVUxM
Lg0KPiANCj4gV2hpbGUgaXQgaXMgcmF0aGVyIHVubGlrZWx5IHRvIGhhdmUgZmNfYmxvY2tfc2Nz
aV9laCgpIGNhbGxlZCB3aXRob3V0DQo+IGFuIHJwb3J0IGFzc29jaWF0ZWQgaXQncyBhIGdvb2Qg
aWRlYSB0byBjYXRjaCBwb3RlbnRpYWwgbWlzdXNlcyBvZiB0aGUNCj4gQVBJIGdyYWNlZnVsbHku
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5Ac3Vz
ZS5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfZmMuYyB8IDMgKysr
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV90cmFu
c3BvcnRfZmMuYw0KPiBpbmRleCBiYTlkNzBmOGE2YTEuLjgzMGNlNTNmMzBmYiAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMNCj4gKysrIGIvZHJpdmVycy9z
Y3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMNCj4gQEAgLTMzMjgsNiArMzMyOCw5IEBAIGludCBmY19i
bG9ja19zY3NpX2VoKHN0cnVjdCBzY3NpX2NtbmQgKmNtbmQpDQo+ICB7DQo+ICAJc3RydWN0IGZj
X3Jwb3J0ICpycG9ydCA9IHN0YXJnZXRfdG9fcnBvcnQoc2NzaV90YXJnZXQoY21uZC0+ZGV2aWNl
KSk7DQo+ICANCj4gKwlpZiAoV0FSTl9PTighcnBvcnQpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0K
PiAgCXJldHVybiBmY19ibG9ja19ycG9ydChycG9ydCk7DQo+ICB9DQo+ICBFWFBPUlRfU1lNQk9M
KGZjX2Jsb2NrX3Njc2lfZWgpOw0KDQpEaWQgeW91IHBlcmhhcHMgaW50ZW5kIHRvIHVzZSBXQVJO
X09OX09OQ0UoKSBpbnN0ZWFkIG9mIFdBUk5fT04oKT8gQW55d2F5Og0KDQpSZXZpZXdlZC1ieTog
QmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29tPg0K
