From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH 20/55] scsi: Mark function as static in
 isci/remote_device.c
Date: Mon, 31 Mar 2014 08:55:41 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB208426AE@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <ba8bc6c22f1d7949f8a727dfef4262c1336b8a71.1396114898.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ba8bc6c22f1d7949f8a727dfef4262c1336b8a71.1396114898.git.rashika.kheria@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: intel-linux-scu <intel-linux-scu@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0dXJkYXksIE1hcmNoIDI5LCAyMDE0IDc6MDUgUE0gUmFzaGlrYSBLaGVyaWEgPHJhc2hp
a2Eua2hlcmlhQGdtYWlsLmNvbT4gd3JvdGU6DQo+IE1hcmsgZnVuY3Rpb24gYXMgc3RhdGljIGlu
IGlzY2kvcmVtb3RlX2RldmljZS5jIGJlY2F1c2UgaXQgaXMgbm90IHVzZWQNCj4gb3V0c2lkZSB0
aGlzIGZpbGUuDQo+IA0KPiBUaGlzIGVsaW1pbmF0ZXMgdGhlIGZvbGxvd2luZyB3YXJuaW5nIGlu
IGlzY2kvcmVtb3RlX2RldmljZS5jOg0KPiBkcml2ZXJzL3Njc2kvaXNjaS9yZW1vdGVfZGV2aWNl
LmM6MTM4Nzo2OiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yDQo+IOKAmGlzY2lf
cmVtb3RlX2RldmljZV93YWl0X2Zvcl9yZXN1bWVfZnJvbV9hYm9ydOKAmSBbLVdtaXNzaW5nLXBy
b3RvdHlwZXNdDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSYXNoaWthIEtoZXJpYSA8cmFzaGlrYS5r
aGVyaWFAZ21haWwuY29tPg0KPiBSZXZpZXdlZC1ieTogSm9zaCBUcmlwbGV0dCA8am9zaEBqb3No
dHJpcGxldHQub3JnPg0KDQpBY2tlZC1ieTogTHVrYXN6IERvcmF1IDxsdWthc3ouZG9yYXVAaW50
ZWwuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL2lzY2kvcmVtb3RlX2RldmljZS5jIHwg
ICAgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2lzY2kvcmVtb3RlX2RldmljZS5jIGIv
ZHJpdmVycy9zY3NpL2lzY2kvcmVtb3RlX2RldmljZS5jDQo+IGluZGV4IDk2YTI2ZjQuLjMzMDMz
ZmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9pc2NpL3JlbW90ZV9kZXZpY2UuYw0KPiAr
KysgYi9kcml2ZXJzL3Njc2kvaXNjaS9yZW1vdGVfZGV2aWNlLmMNCj4gQEAgLTEzODQsNyArMTM4
NCw3IEBAIHN0YXRpYyBib29sIGlzY2lfcmVtb3RlX2RldmljZV90ZXN0X3Jlc3VtZV9kb25lKA0K
PiAgCXJldHVybiBkb25lOw0KPiAgfQ0KPiANCj4gLXZvaWQgaXNjaV9yZW1vdGVfZGV2aWNlX3dh
aXRfZm9yX3Jlc3VtZV9mcm9tX2Fib3J0KA0KPiArc3RhdGljIHZvaWQgaXNjaV9yZW1vdGVfZGV2
aWNlX3dhaXRfZm9yX3Jlc3VtZV9mcm9tX2Fib3J0KA0KPiAgCXN0cnVjdCBpc2NpX2hvc3QgKmlo
b3N0LA0KPiAgCXN0cnVjdCBpc2NpX3JlbW90ZV9kZXZpY2UgKmlkZXYpDQo+ICB7DQo+IC0tDQo+
IDEuNy45LjUNCg0K
