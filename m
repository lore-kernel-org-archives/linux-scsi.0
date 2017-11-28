From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 14/22] qla2xxx: Fix nested spinlock
Date: Tue, 28 Nov 2017 22:22:49 +0000
Message-ID: <A933D13D-16D3-4458-B7DE-B992BC615A7E@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
 <20171128193503.13695-15-himanshu.madhani@cavium.com>
 <1511898300.28512.20.camel@wdc.com>
 <F873F5EF-0F1D-4E73-82C4-081D048BAF96@cavium.com>
 <1511906943.28512.28.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0086.outbound.protection.outlook.com ([104.47.40.86]:14528
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751867AbdK1WWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 17:22:53 -0500
In-Reply-To: <1511906943.28512.28.camel@wdc.com>
Content-Language: en-US
Content-ID: <0C4E9B37BA2F7D4AA644461395CF7911@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

SGkgQmFydCwgDQoNCj4gT24gTm92IDI4LCAyMDE3LCBhdCAyOjA5IFBNLCBCYXJ0IFZhbiBBc3Nj
aGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+IHdyb3RlOg0KPiANCj4gSGVsbG8gSGltYW5zaHUs
DQo+IA0KPiBEbyB5b3UgZW5hYmxlIENPTkZJR19QUk9WRV9MT0NLSU5HIGluIGFueSBvZiB5b3Vy
IHRlc3RzPyBJZiB0aGlzIGJ1ZyBjb3VsZA0KPiBiZSByZXByb2R1Y2VkIHdpdGggQ09ORklHX1BS
T1ZFX0xPQ0tJTkcgdGhlbiB0aGF0IHdvdWxkIHByb3ZpZGUgdmVyeSB2YWx1YWJsZQ0KPiBpbmZv
cm1hdGlvbiBhYm91dCB0aGUgcm9vdCBjYXVzZSBvZiB0aGUgZGVhZGxvY2suDQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiBCYXJ0Lg0KDQpUaGlzIHdhcyByZXBvcnRlZCBieSBjdXN0b21lciBzbyBpIGFt
IG5vdCB2ZXJ5IGNvbmZpZGVudCB0aGV5IHdvdWxkIGhhdmUgQ09ORklHX1BST1ZFX0xPQ0tJTkcg
ZW5hYmxlZCBpbg0KdGhlaXIgc2V0dXAuIEnigJlsbCBlbmFibGUgdGhpcyBvbiBvdXIgc2V0dXAg
YW5kIHdlIGNhbiB0cnkgdG8gcmVwcm9kdWNlIHRoaXMgaXNzdWUuIA0KDQpMZXQgbWUga25vdyBp
ZiB5b3Ugd2FudCBtZSB0byBkcm9wIHRoaXMgcGF0Y2ggdW50aWwgd2UgZ2V0IG1vcmUgZGV0YWls
cy4NCg0KVGhhbmtzLA0KLSBIaW1hbnNodQ0KDQo=
