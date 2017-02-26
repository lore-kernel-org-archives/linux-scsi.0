From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: remove redundant zero check on ret
Date: Sun, 26 Feb 2017 20:01:22 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A4EF434A6@avsrvexchmbx1.microsemi.net>
References: <20170224144330.6707-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170224144330.6707-1-colin.king@canonical.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBLaW5nIFttYWlsdG86
Y29saW4ua2luZ0BjYW5vbmljYWwuY29tXQ0KPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDI0LCAy
MDE3IDc6NDQgQU0NCj4gVG86IGRsLWVzYy1BYWNyYWlkIExpbnV4IERyaXZlcjsgSmFtZXMgRSAu
IEogLiBCb3R0b21sZXk7IE1hcnRpbiBLIC4NCj4gUGV0ZXJzZW47IGxpbnV4LXNjc2lAdmdlci5r
ZXJuZWwub3JnDQo+IENjOiBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSF0gc2NzaTogYWFjcmFpZDog
cmVtb3ZlIHJlZHVuZGFudCB6ZXJvIGNoZWNrIG9uIHJldA0KPiANCj4gRnJvbTogQ29saW4gSWFu
IEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gDQo+IFRoZSBjaGVjayBmb3IgcmV0
IGJlaW5nIHplcm8gaXMgcmVkdW5kYW50IGFzIGEgZmV3IHN0YXRlbWVudHMgZWFybGllciB3ZQ0K
PiBicmVhayBvdXQgb2YgdGhlIHdoaWxlIGxvb3AgaWYgcmV0IGlzIG5vbi16ZXJvLiAgVGh1cyB3
ZSBjYW4gcmVtb3ZlIHRoZQ0KPiB6ZXJvIGNoZWNrIGFuZCBhbHNvIHRoZSBkZWFkLWNvZGUgbm9u
LXplcm8gY2FzZSB0b28uDQo+IA0KPiBEZXRlY3RlZCBieSBDb3Zlcml0eVNjYW4sIENJRCMxNDEx
NjMyICgiTG9naWNhbGx5IERlYWQgQ29kZSIpDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJ
YW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2Nz
aS9hYWNyYWlkL2NvbW1zdXAuYyB8IDYgKy0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDUgZGVsZXRpb25zKC0pDQoNCkFja2VkLWJ5OiBEYXZlIENhcnJvbGwgPGRhdmlk
LmNhcnJvbGxAbWljcm9zZW1pLmNvbT4NCg==
