From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer crash due to active timer for
 ABTS
Date: Tue, 13 Feb 2018 18:13:55 +0000
Message-ID: <8AA80006-774D-4189-9BDF-7410E705D26F@cavium.com>
References: <20180212182814.4541-1-himanshu.madhani@cavium.com>
 <1518518327.3592.6.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0061.outbound.protection.outlook.com ([104.47.32.61]:14698
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965158AbeBMSN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 13:13:57 -0500
In-Reply-To: <1518518327.3592.6.camel@suse.de>
Content-Language: en-US
Content-ID: <581C8692519C4C4FB2DBBF864F24307E@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgSm9oYW5uZXMsIA0KDQo+IE9uIEZlYiAxMywgMjAxOCwgYXQgMjozOCBBTSwgSm9oYW5uZXMg
VGh1bXNoaXJuIDxqdGh1bXNoaXJuQHN1c2UuZGU+IHdyb3RlOg0KPiANCj4gVGhhbmtzIEhpbWFu
c2h1LA0KPiBSZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1bXNoaXJuQHN1c2Uu
ZGU+DQo+IA0KPiBEbyB5b3UgaGFwcGVuIHRvIGtub3cgd2hpY2ggY29tbWl0IGl0IGFjdHVhbGx5
IGZpeGVzPw0KPiANCg0KVGhhbmtzIGZvciBhc2tpbmcgKEkgZGlkIG5vdCBhZGQgZml4ZXMgY29t
bWl0IElEIGJlY2F1c2UgaXQgd2FzIHByZSA0Lngga2VybmVsKSANCg0KSGVyZeKAmXMgY29tbWl0
IGlkIDQ0NDBlNDZkNWRiN2I0NDVhOTYxYTg0NDQ0ODQ5YjJhMzFmYTdmZDEgd2hpY2ggaXMgZml4
ZWQgYnkgdGhpcyBwYXRjaC4NCg0KPiAtLSANCj4gSm9oYW5uZXMgVGh1bXNoaXJuICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU3RvcmFnZQ0KPiBqdGh1DQo+IG1zaGly
bkBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4
OQ0KPiBTVVNFDQo+IExJTlVYIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZw0K
PiBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lDQo+IFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9u
DQo+IEhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQ0KPiBLZXkgZmluZ2VycHJpbnQgPSBFQzM4DQo+
IDlDQUIgQzJDNCBGMjVEIDg2MDAgRDBEMCAwMzkzIDk2OUQgMkQ3NiAwODUwDQoNClRoYW5rcywN
Ci0gSGltYW5zaHUNCg0K
