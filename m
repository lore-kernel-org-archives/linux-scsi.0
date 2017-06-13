From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: fix leak of data from stack back to
 userspace
Date: Tue, 13 Jun 2017 21:06:02 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A53045C92@avsrvexchmbx2.microsemi.net>
References: <20170515145605.21461-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170515145605.21461-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBLaW5nIFttYWlsdG86
Y29saW4ua2luZ0BjYW5vbmljYWwuY29tXQ0KPiBTZW50OiBNb25kYXksIE1heSAxNSwgMjAxNyA4
OjU2IEFNDQo+IFRvOiBSYWdoYXZhIEFkaXR5YSBSZW51a3VudGEgPFJhZ2hhdmFBZGl0eWEuUmVu
dWt1bnRhQG1pY3Jvc2VtaS5jb20+Ow0KPiBkbC1lc2MtQWFjcmFpZCBMaW51eCBEcml2ZXIgPGFh
Y3JhaWRAbWljcm9zZW1pLmNvbT47IEphbWVzIEUgLiBKIC4gQm90dG9tbGV5DQo+IDxqZWpiQGxp
bnV4LnZuZXQuaWJtLmNvbT47IE1hcnRpbiBLIC4gUGV0ZXJzZW4NCj4gPG1hcnRpbi5wZXRlcnNl
bkBvcmFjbGUuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1q
YW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogW1BBVENIXSBzY3NpOiBhYWNyYWlkOiBmaXggbGVhayBvZiBkYXRhIGZyb20gc3Rh
Y2sgYmFjayB0byB1c2Vyc3BhY2UNCj4gDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5r
aW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBUaGUgZmllbGRzIHNlbnNlX2RhdGFfc2l6ZSBhbmQg
c2Vuc2VfZGF0YSBhcmUgdW5pdGlhbGl6ZWQgZ2FyYmFnZSBmcm9tIHRoZQ0KPiBzdGFjayBhbmQg
YXJlIGJlaW5nIGNvcGllZCBiYWNrIHRvIHVzZXJzcGFjZS4gIEZpeCB0aGlzIGxlYWsgb2Ygc3Rh
Y2sgaW5mb3JtYXRpb24NCj4gYnkgZW5zdXJpbmcgdGhleSBhcmUgemVybydkLg0KPiANCj4gRGV0
ZWN0ZWQgYnkgQ292ZXJpdHlTY2FuLCBDSUQjMTQzNTQ3MyAoIlVuaW5pdGlhbGl6ZWQgc2NhbGFy
IHZhcmlhYmxlIikNCj4gDQo+IEZpeGVzOiA0MjM0MDBlNjRkMzc3ICgic2NzaTogYWFjcmFpZDog
SW5jbHVkZSBIQkEgZGlyZWN0IGludGVyZmFjZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElh
biBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3Np
L2FhY3JhaWQvY29tbWN0cmwuYyB8IDIgKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKykNCj4gDQpBY2tlZC1ieTogRGF2ZSBDYXJyb2xsIDxkYXZpZC5jYXJyb2xsQG1pY3Jvc2Vt
aS5jb20+DQo=
