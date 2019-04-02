From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Reduce default ring buffer size to 128
 Kbytes
Date: Tue, 2 Apr 2019 15:58:57 +0000
Message-ID: <DM6PR21MB1337435B5EBFF250E412C506CA560@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1554154871-10305-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554154871-10305-1-git-send-email-mikelley@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Michael Kelley <mikelley@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtaHlwZXJ2LW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtaHlwZXJ2LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5v
cmc+IE9uIEJlaGFsZiBPZiBNaWNoYWVsIEtlbGxleQ0KPiBTZW50OiBNb25kYXksIEFwcmlsIDEs
IDIwMTkgNTo0MiBQTQ0KPiBUbzogS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+OyBt
YXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgTG9uZyBMaQ0KPiA8bG9uZ2xpQG1pY3Jvc29mdC5j
b20+OyBKYW1lcy5Cb3R0b21sZXlAaGFuc2VucGFydG5lcnNoaXAuY29tOw0KPiBlbWlsbmVAcmVk
aGF0LmNvbTsgbGludXgtaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQo+IENjOiBNaWNoYWVs
IEtlbGxleSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCj4gU3ViamVjdDogW1BBVENIIDEvMV0g
c2NzaTogc3RvcnZzYzogUmVkdWNlIGRlZmF1bHQgcmluZyBidWZmZXIgc2l6ZSB0byAxMjggS2J5
dGVzDQo+IA0KPiBSZWR1Y2UgdGhlIGRlZmF1bHQgVk1idXMgY2hhbm5lbCByaW5nIGJ1ZmZlciBz
aXplIGZvciBzdG9ydnNjIFNDU0kgZGV2aWNlcw0KPiBmcm9tIDEgTWJ5dGUgdG8gMTI4IEtieXRl
cy4gTWVhc3VyZW1lbnRzIHNob3cgdGhhdCByaW5nIGJ1ZmZlciBzaXplcyBhYm92ZQ0KPiAxMjgg
S2J5dGVzIGRvIG5vdCBpbmNyZWFzZSBwZXJmb3JtYW5jZSBldmVuIGF0IHZlcnkgaGlnaCBJT1BT
IHJhdGVzLCBzbyBkb24ndA0KPiB3YXN0ZSB0aGUgbWVtb3J5LiBBbHNvIHJlbW92ZSB0aGUgZGVw
ZW5kZW5jZSBvbiBQQUdFX1NJWkUsIHNpbmNlIHRoZSByaW5nDQo+IGJ1ZmZlciBzaXplIHNob3Vs
ZCBub3QgY2hhbmdlIG9uIGFyY2hpdGVjdHVyZXMgd2hlcmUgUEFHRV9TSVpFIGlzIG5vdCA0IEti
eXRlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNy
b3NvZnQuY29tPg0KDQpSZXZpZXdlZC1ieTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9z
b2Z0LmNvbT4NClRoYW5rIHlvdS4NCg==
