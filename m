From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 14/22] qla2xxx: Fix nested spinlock
Date: Tue, 28 Nov 2017 22:55:13 +0000
Message-ID: <634CDECC-41DC-4937-B0C3-01E4520BE3F2@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
 <20171128193503.13695-15-himanshu.madhani@cavium.com>
 <1511898300.28512.20.camel@wdc.com>
 <F873F5EF-0F1D-4E73-82C4-081D048BAF96@cavium.com>
 <1511906943.28512.28.camel@wdc.com>
 <A933D13D-16D3-4458-B7DE-B992BC615A7E@cavium.com>
 <1511908033.28512.31.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0073.outbound.protection.outlook.com ([104.47.37.73]:10144
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752674AbdK1WzP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 17:55:15 -0500
In-Reply-To: <1511908033.28512.31.camel@wdc.com>
Content-Language: en-US
Content-ID: <5F87AF6392523749968987C6CC35E021@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

SGkgQmFydCwgDQoNCk9uIE5vdiAyOCwgMjAxNywgYXQgMjoyNyBQTSwgQmFydCBWYW4gQXNzY2hl
IDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29tPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgMjAxNy0xMS0y
OCBhdCAyMjoyMiArMDAwMCwgTWFkaGFuaSwgSGltYW5zaHUgd3JvdGU6DQo+PiBUaGlzIHdhcyBy
ZXBvcnRlZCBieSBjdXN0b21lciBzbyBpIGFtIG5vdCB2ZXJ5IGNvbmZpZGVudCB0aGV5IHdvdWxk
IGhhdmUgQ09ORklHX1BST1ZFX0xPQ0tJTkcgZW5hYmxlZCBpbg0KPj4gdGhlaXIgc2V0dXAuIEni
gJlsbCBlbmFibGUgdGhpcyBvbiBvdXIgc2V0dXAgYW5kIHdlIGNhbiB0cnkgdG8gcmVwcm9kdWNl
IHRoaXMgaXNzdWUuIA0KPj4gDQo+PiBMZXQgbWUga25vdyBpZiB5b3Ugd2FudCBtZSB0byBkcm9w
IHRoaXMgcGF0Y2ggdW50aWwgd2UgZ2V0IG1vcmUgZGV0YWlscy4NCj4gDQo+IEhlbGxvIEhpbWFu
c2h1LA0KPiANCj4gV2hhdCBJIHRoaW5rIGlzIHRoYXQgYXQgbGVhc3QgYW4gZXhwbGFuYXRpb24g
c2hvdWxkIGJlIHByb3ZpZGVkIGFib3V0IHdoeSBpdA0KPiBpcyBzYWZlIHRvIGxlYXZlIG91dCB0
aGUgc3Bpbl9sb2NrKCkgYW5kIHNwaW5fdW5sb2NrKCkgY2FsbHMuIFdoYXQgZG9lcyB0aGUNCj4g
aGFyZHdhcmUgbG9jayBwcm90ZWN0IGFuZCB3aHkgaXMgaXQgc2FmZSB0byBsZWF2ZSBpdCBvdXQg
ZnJvbQ0KPiBxbGEyeDAwX2Vsc19kY21kX2lvY2JfdGltZW91dCgpPw0KPiANCg0KT2theSB3aWxs
IHVwZGF0ZSBwYXRjaCB3aXRoIHRoZSBkZXNjcmlwdGlvbiBhbmQgc3VibWl0IHYyIG9mIHRoaXMg
cGF0Y2guDQoNCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KVGhhbmtzLA0KLSBIaW1hbnNodQ0K
DQo=
