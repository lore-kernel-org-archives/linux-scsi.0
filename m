From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: RE: [PATCH] scsi: qedf: NULL check before some freeing functions is
 not needed.
Date: Mon, 3 Dec 2018 05:57:42 +0000
Message-ID: <MW2PR07MB4042B569F3E1BD643DE67022E3AE0@MW2PR07MB4042.namprd07.prod.outlook.com>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
 <1543760930052-271366275-12-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930052-271366275-12-diffsplit-thomas@m3y3r.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRob21hcyBNZXllciA8dGhv
bWFzQG0zeTNyLmRlPg0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDMsIDIwMTggMjoyMiBBTQ0K
PiBUbzogRGVwdC1FbmcgUUxvZ2ljIFN0b3JhZ2UgVXBzdHJlYW0gPFFMb2dpYy1TdG9yYWdlLQ0K
PiBVcHN0cmVhbUBjYXZpdW0uY29tPjsgamVqYkBsaW51eC52bmV0LmlibS5jb207DQo+IG1hcnRp
bi5wZXRlcnNlbkBvcmFjbGUuY29tOyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgbGludXgt
DQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BBVENIXSBzY3NpOiBxZWRm
OiBOVUxMIGNoZWNrIGJlZm9yZSBzb21lIGZyZWVpbmcgZnVuY3Rpb25zIGlzIG5vdA0KPiBuZWVk
ZWQuDQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gTlVMTCBjaGVjayBiZWZvcmUgc29tZSBm
cmVlaW5nIGZ1bmN0aW9ucyBpcyBub3QgbmVlZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVGhv
bWFzIE1leWVyIDx0aG9tYXNAbTN5M3IuZGU+DQo+IC0tLQ0KPiANCj4gZGlmZiAtdSAtcCBhL2Ry
aXZlcnMvc2NzaS9xZWRmL3FlZGZfbWFpbi5jIGIvZHJpdmVycy9zY3NpL3FlZGYvcWVkZl9tYWlu
LmMNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3FlZGYvcWVkZl9tYWluLmMNCj4gKysrIGIvZHJpdmVy
cy9zY3NpL3FlZGYvcWVkZl9tYWluLmMNCj4gQEAgLTI5MzUsOCArMjkzNSw3IEBAIHN0YXRpYyB2
b2lkIHFlZGZfZnJlZV9mY29lX3BmX3BhcmFtKHN0cnUNCj4gDQo+ICAgICAgICAgcWVkZl9mcmVl
X2dsb2JhbF9xdWV1ZXMocWVkZik7DQo+IA0KPiAtICAgICAgIGlmIChxZWRmLT5nbG9iYWxfcXVl
dWVzKQ0KPiAtICAgICAgICAgICAgICAga2ZyZWUocWVkZi0+Z2xvYmFsX3F1ZXVlcyk7DQo+ICsg
ICAgICAga2ZyZWUocWVkZi0+Z2xvYmFsX3F1ZXVlcyk7DQo+ICB9DQo+IA0KPiAgLyoNCg0KVGhh
bmtzDQpBY2tlZC1ieTogTWFuaXNoIFJhbmdhbmthciA8TWFuaXNoLlJhbmdhbmthckBjYXZpdW0u
Y29tPg0K
