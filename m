From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH 21/55] scsi: Mark function as static in isci/port.c
Date: Mon, 31 Mar 2014 08:56:30 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB208426C1@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <1a67e2614c800cac379c183e4ff5a6b1eda34f9d.1396114898.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a67e2614c800cac379c183e4ff5a6b1eda34f9d.1396114898.git.rashika.kheria@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: intel-linux-scu <intel-linux-scu@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0dXJkYXksIE1hcmNoIDI5LCAyMDE0IDc6MDcgUE0gUmFzaGlrYSBLaGVyaWEgPHJhc2hp
a2Eua2hlcmlhQGdtYWlsLmNvbT4gd3JvdGU6DQo+IE1hcmsgZnVuY3Rpb24gYXMgc3RhdGljIGlu
IGlzY2kvcG9ydC5jIGJlY2F1c2UgdGhleSBhcmUgbm90IHVzZWQgb3V0c2lkZQ0KPiB0aGlzIGZp
bGUuDQo+IA0KPiBUaGlzIGVsaW1pbmF0ZXMgdGhlIGZvbGxvd2luZyB3YXJuaW5nIGluIGlzY2kv
cG9ydC5jOg0KPiBkcml2ZXJzL3Njc2kvaXNjaS9wb3J0LmM6NjU6MTM6IHdhcm5pbmc6IG5vIHBy
ZXZpb3VzIHByb3RvdHlwZSBmb3INCj4g4oCYcG9ydF9zdGF0ZV9uYW1l4oCZIFstV21pc3Npbmct
cHJvdG90eXBlc10NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJhc2hpa2EgS2hlcmlhIDxyYXNoaWth
LmtoZXJpYUBnbWFpbC5jb20+DQo+IFJldmlld2VkLWJ5OiBKb3NoIFRyaXBsZXR0IDxqb3NoQGpv
c2h0cmlwbGV0dC5vcmc+DQoNCkFja2VkLWJ5OiBMdWthc3ogRG9yYXUgPGx1a2Fzei5kb3JhdUBp
bnRlbC5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvaXNjaS9wb3J0LmMgfCAgICAyICst
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvaXNjaS9wb3J0LmMgYi9kcml2ZXJzL3Njc2kvaXNj
aS9wb3J0LmMNCj4gaW5kZXggMTMwOThiMC4uMjI1ZDM5ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9zY3NpL2lzY2kvcG9ydC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9pc2NpL3BvcnQuYw0KPiBA
QCAtNjIsNyArNjIsNyBAQA0KPiANCj4gICN1bmRlZiBDDQo+ICAjZGVmaW5lIEMoYSkgKCNhKQ0K
PiAtY29uc3QgY2hhciAqcG9ydF9zdGF0ZV9uYW1lKGVudW0gc2NpX3BvcnRfc3RhdGVzIHN0YXRl
KQ0KPiArc3RhdGljIGNvbnN0IGNoYXIgKnBvcnRfc3RhdGVfbmFtZShlbnVtIHNjaV9wb3J0X3N0
YXRlcyBzdGF0ZSkNCj4gIHsNCj4gIAlzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IHN0cmluZ3Nb
XSA9IFBPUlRfU1RBVEVTOw0KPiANCj4gLS0NCj4gMS43LjkuNQ0KDQo=
