From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Date: Mon, 31 Mar 2014 08:54:49 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB20842693@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: intel-linux-scu <intel-linux-scu@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0dXJkYXksIE1hcmNoIDI5LCAyMDE0IDc6MDQgUE0gUmFzaGlrYSBLaGVyaWEgPHJhc2hp
a2Eua2hlcmlhQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBNYXJrIGZ1bmN0aW9uIGFzIHN0YXRp
YyBpbiBpc2NpL3BoeS5jIGJlY2F1c2UgaXQgaXMgbm90IHVzZWQgb3V0c2lkZQ0KPiB0aGlzIGZp
bGUuDQo+IA0KPiBUaGlzIGVsaW1pbmF0ZXMgdGhlIGZvbGxvd2luZyB3YXJuaW5nIGluIGlzY2kv
cGh5LmM6DQo+IGRyaXZlcnMvc2NzaS9pc2NpL3BoeS5jOjY3Mjo2OiB3YXJuaW5nOiBubyBwcmV2
aW91cyBwcm90b3R5cGUgZm9yDQo+IOKAmHNjdV9saW5rX2xheWVyX3NldF90eGNvbXNhc190aW1l
b3V04oCZIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJhc2hp
a2EgS2hlcmlhIDxyYXNoaWthLmtoZXJpYUBnbWFpbC5jb20+DQo+IFJldmlld2VkLWJ5OiBKb3No
IFRyaXBsZXR0IDxqb3NoQGpvc2h0cmlwbGV0dC5vcmc+DQoNCkFja2VkLWJ5OiBMdWthc3ogRG9y
YXUgPGx1a2Fzei5kb3JhdUBpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvaXNj
aS9waHkuYyB8ICAgIDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2lzY2kvcGh5LmMg
Yi9kcml2ZXJzL3Njc2kvaXNjaS9waHkuYw0KPiBpbmRleCBjYjg3YjJlLi44ZTIxMDIyIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvaXNjaS9waHkuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kv
aXNjaS9waHkuYw0KPiBAQCAtNjY5LDcgKzY2OSw4IEBAIHN0YXRpYyBjb25zdCBjaGFyICpwaHlf
ZXZlbnRfbmFtZSh1MzIgZXZlbnRfY29kZSkNCj4gIAkJcGh5X3N0YXRlX25hbWUoc3RhdGUpLCBw
aHlfZXZlbnRfbmFtZShjb2RlKSwgY29kZSkNCj4gDQo+IA0KPiAtdm9pZCBzY3VfbGlua19sYXll
cl9zZXRfdHhjb21zYXNfdGltZW91dChzdHJ1Y3QgaXNjaV9waHkgKmlwaHksIHUzMiB0aW1lb3V0
KQ0KPiArc3RhdGljIHZvaWQgc2N1X2xpbmtfbGF5ZXJfc2V0X3R4Y29tc2FzX3RpbWVvdXQoc3Ry
dWN0IGlzY2lfcGh5ICppcGh5LA0KPiArCQkJCQkJdTMyIHRpbWVvdXQpDQo+ICB7DQo+ICAJdTMy
IHZhbDsNCj4gDQo+IC0tDQo+IDEuNy45LjUNCg0K
