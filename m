From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] qla2xxx: correctly shift host byte
Date: Fri, 6 Apr 2018 15:01:20 +0000
Message-ID: <0753246e70d16062b87930b2b75eec31a4bb88eb.camel@wdc.com>
References: <20180406075222.7358-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180406075222.7358-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <BA62C0CAA3EFE342B049CA7E48FB72C1@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTA0LTA2IGF0IDA5OjUyICswMjAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IFRoZSBob3N0IGJ5dGUgaGFzIHRvIGJlIHNoaWZ0ZWQgYnkgMTYgbm90IDYuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5Ac3VzZS5kZT4N
Cj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgfCAyICstDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfaXNyLmMNCj4gaW5kZXggODlmOTNlYmQ4MTlkLi40OWQ2N2UxZDU3MWYgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0KPiArKysgYi9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaXNyLmMNCj4gQEAgLTIzNjgsNyArMjM2OCw3IEBAIHFsYTI1eHhfcHJv
Y2Vzc19iaWRpcl9zdGF0dXNfaW9jYihzY3NpX3FsYV9ob3N0X3QgKnZoYSwgdm9pZCAqcGt0LA0K
PiAgCWJzZ19qb2ItPnJlcGx5X2xlbiA9IHNpemVvZihzdHJ1Y3QgZmNfYnNnX3JlcGx5KTsNCj4g
IAkvKiBBbHdheXMgcmV0dXJuIERJRF9PSywgYnNnIHdpbGwgc2VuZCB0aGUgdmVuZG9yIHNwZWNp
ZmljIHJlc3BvbnNlDQo+ICAJICogaW4gdGhpcyBjYXNlIG9ubHkgKi8NCj4gLQlzcC0+ZG9uZShz
cCwgRElEX09LIDw8IDYpOw0KPiArCXNwLT5kb25lKHNwLCBESURfT0sgPDwgMTYpOw0KPiAgDQo+
ICB9DQoNClBsZWFzZSBtZW50aW9uIGluIHRoZSBkZXNjcmlwdGlvbiBvZiB0aGlzIHBhdGNoIHRo
YXQgdGhpcyBwYXRjaCBkb2VzIG5vdA0KY2hhbmdlIGFueSBmdW5jdGlvbmFsaXR5IGJlY2F1c2Ug
RElEX09LID09IDAuIEFueXdheToNCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFy
dC52YW5hc3NjaGVAd2RjLmNvbT4NCg0KDQo=
