From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Wed, 9 Aug 2017 03:57:18 +0000
Message-ID: <1502251037.2784.2.camel@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
         <1502204867.2250.1.camel@wdc.com>
         <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
         <cea78872-8e58-549d-87fc-2897e640c31c@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5763 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdHID6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 23:58:08 -0400
In-Reply-To: <cea78872-8e58-549d-87fc-2897e640c31c@wdc.com>
Content-Language: en-US
Content-ID: <8A1D7319B0683645BCF520423803FEDF@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

T24gV2VkLCAyMDE3LTA4LTA5IGF0IDExOjQ3ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gOC85LzE3IDExOjE5LCBEYW1pZW4gTGUgTW9hbCB3cm90ZToNCj4gPiBPbiA4LzkvMTcg
MDA6MDcsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgMjAxNy0wOC0wOCBh
dCAxMzoxNyArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+ID4gPiA+IGFjcXVpcmVkIHRo
ZSBsb2NrIGNvbXBsZXRlcyBjYW4gY2F1c2UgZGVhZGxvY2tzIHdpdGggc2NzaS1tcSBkdWUgdG8N
Cj4gPiA+ID4gcG90ZW50aWFsIHF1ZXVlIHJlb3JkZXJpbmcgaWYgdGhlIGxvY2sgb3duaW5nIHJl
cXVlc3QgaXMgcmVxdWV1ZWQgYW5kDQo+ID4gPiA+IG5vdCBleGVjdXRlZC4NCj4gPiA+IA0KPiA+
ID4gUGxlYXNlIG5vdGUgdGhhdCBldmVuIHdpdGggc2NzaS1zcSByZXF1ZXVlaW5nIGNhbiBjYXVz
ZSByZXF1ZXN0IHJlb3JkZXJpbmcuDQo+ID4gDQo+ID4gSSBhbSBwYWluZnVsbHkgYXdhcmUgb2Yg
dGhpcyBmYWN0Li4uIEkgd2lsbCB1cGRhdGUgdGhlIGNvbW1pdCBtZXNzYWdlIHRvDQo+ID4gcmVm
bGVjdCB0aGlzLg0KPiANCj4gQ29ycmVjdGlvbjogY2hlY2tpbmcgdGhlIGNvZGUgYWdhaW4sIEkg
anVzdCByZWFsaXplZCB0aGF0IHRoZSBwcmVwX2ZuDQo+IHF1ZXVlIGZ1bmN0aW9uLCB3aGljaCBj
YWxscyBzZF9pbml0X2NtbmQoKSBhbmQgY2F1c2VzIGEgem9uZSB0byBiZQ0KPiB3cml0ZS1sb2Nr
ZWQgaWYgdGhlIHByZXBhcmVkIGNvbW1hbmQgaXMgYSB3cml0ZSwgaXMgY2FsbGVkIHdpdGhpbg0K
PiBibGtfcGVla19yZXF1ZXN0KCkuIFRoYXQgZnVuY3Rpb24gaXMgY2FsbGVkIGluIHNjc2lfcmVx
dWVzdF9mbigpIHdpdGgNCj4gdGhlIHF1ZXVlIGxvY2sgaGVsZC4gU28gZm9yIHRoZSBsZWdhY3kg
c2NzaSBwYXRoLCB0aGlzIG1lYW5zIHRoYXQgZm9yIGENCj4gd3JpdGUgY29tbWFuZCB0byBhIHpv
bmUsIHRoZSBvcGVyYXRpb24gImxvY2sgem9uZSBhbmQgZGVxdWV1ZSBjb21tYW5kIg0KPiBpcyBh
dG9taWMuIFRoYW5rcyB0byB0aGUgem9uZSBsb2NrLCBmdXJ0aGVyIGRlcXVldWUgb2Ygd3JpdGUg
Y29tbWFuZHMNCj4gZm9yIHRoZSBzYW1lIChsb2NrZWQpIHpvbmUgY2Fubm90IGhhcHBlbiBhbmQg
c28gdGhlcmUgaXMgbm8gcmVvcmRlcmluZw0KPiBwb3NzaWJsZSBmb3Igd3JpdGUgY29tbWFuZHMg
ZGlyZWN0ZWQgYXQgdGhlIHNhbWUgem9uZS4gUmVvcmRlcmluZyBmb3INCj4gb3RoZXIgY29tbWFu
ZHMgaXMgcG9zc2libGUsIGJ1dCBzaW1pbGFybHkgdG8gcmVndWxhciBkaXNrcywgdGhpcyBpcyBu
b3QNCj4gYSBwcm9ibGVtIHdpdGggWkJDL1pBQyBkcml2ZXMuDQoNCkhlbGxvIERhbWllbiwNCg0K
VGhlIGxvY2tpbmcgYXBwcm9hY2ggaW4gdGhlIHVwc3RyZWFtIGNvZGUgaW5kZWVkIHByZXZlbnRz
IHJlb3JkZXJpbmcgb2YNCndyaXRlIHJlcXVlc3RzIHRoYXQgYXBwbHkgdG8gdGhlIHNhbWUgem9u
ZS4gSG93ZXZlciwgdGhpcyBwYXRjaCBtb2RpZmllcw0KdGhlIGxvY2tpbmcgYXBwcm9hY2guIEFy
ZSB5b3Ugc3VyZSB0aGF0IHdpdGggdGhpcyBwYXRjaCBhcHBsaWVkIG5vIHJlcXVlc3QNCnJlb3Jk
ZXJpbmcgd2lsbCBvY2N1ciBpZiByZXF1ZXN0cyBhcmUgcmVxdWV1ZWQgc2luY2UgdGhpcyBwYXRj
aCBjYXVzZXMgdGhlDQp6b25lIGxvY2sgdG8gYmUgcmVsZWFzZWQgYmVmb3JlIHJlcXVldWluZyBv
Y2N1cnM/DQoNCkJhcnQu
