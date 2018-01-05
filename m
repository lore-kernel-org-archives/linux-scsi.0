From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH][scsi-next] scsi: aacraid: remove redundant setting of
 variable c
Date: Fri, 5 Jan 2018 16:42:25 +0000
Message-ID: <461db48ecc3c479c9789340bf3608e8b@microsemi.com>
References: <20180105153106.17605-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180105153106.17605-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgW21haWx0
bzpjb2xpbi5raW5nQGNhbm9uaWNhbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSA1LCAy
MDE4IDc6MzEgQU0NCj4gVG86IGRsLWVzYy1BYWNyYWlkIExpbnV4IERyaXZlciA8YWFjcmFpZEBt
aWNyb3NlbWkuY29tPjsgSmFtZXMgRSAuIEogLg0KPiBCb3R0b21sZXkgPGplamJAbGludXgudm5l
dC5pYm0uY29tPjsgTWFydGluIEsgLiBQZXRlcnNlbg0KPiA8bWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb20+OyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBDYzoga2VybmVsLWphbml0b3Jz
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBbUEFUQ0hdW3Njc2ktbmV4dF0gc2NzaTogYWFjcmFpZDogcmVtb3ZlIHJlZHVuZGFudCBzZXR0
aW5nIG9mDQo+IHZhcmlhYmxlIGMNCj4gDQo+IEVYVEVSTkFMIEVNQUlMDQo+IA0KPiANCj4gRnJv
bTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gDQo+IEEgcHJl
dmlvdXMgY29tbWl0IG5vIGxvbmdlciBzdG9yZXMgdGhlIGNvbnRlbnRzIG9mIGMsIHNvIHdlIG5v
dyBoYXZlDQo+IGEgc2l0dWF0aW9uIHdoZXJlIGMgaXMgYmVpbmcgdXBkYXRlZCBidXQgdGhlIHZh
bHVlIGlzIG5ldmVyIHJlYWQuIENsZWFuDQo+IHVwIHRoZSBjb2RlIGJ5IHJlbW92aW5nIHRoZSBu
b3cgcmVkdW5kYW50IHNldHRpbmcgb2YgdmFyaWFibGUgYy4NCj4gDQo+IENsZWFucyB1cCBjbGFu
ZyB3YXJuaW5nOg0KPiBkcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYzo5NDM6Mzogd2Fybmlu
ZzogVmFsdWUgc3RvcmVkIHRvICdjJyBpcw0KPiBuZXZlciByZWFkDQo+IA0KPiBGaXhlczogZjRl
ODcwOGQzMTA0ICgic2NzaTogYWFjcmFpZDogRml4IHVkZXYgaW5xdWlyeSByYWNlIGNvbmRpdGlv
biIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNh
bC5jb20+DQo+IC0tLQ0KUmV2aWV3ZWQtYnkgOlJhZ2hhdmEgQWRpdHlhIFJlbnVrdW50YSA8UmFn
aGF2YUFkaXR5YS5SZW51a3VudGFAbWljcm9zZW1pLmNvbT4NCg==
