From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 21/29] scsi: aacraid: Refactor resolve luns code and scsi
 functions
Date: Wed, 27 Dec 2017 01:25:21 +0000
Message-ID: <f67f21315d524c9e85970efbb68f2c27@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-22-RaghavaAditya.Renukunta@microsemi.com>
 <1513881757.2931.23.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0044.outbound.protection.outlook.com ([104.47.38.44]:24043
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751163AbdL0BZZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 20:25:25 -0500
In-Reply-To: <1513881757.2931.23.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, Tom White <tom.white@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IFttYWlsdG86QmFydC5WYW5Bc3NjaGVAd2RjLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIERlY2Vt
YmVyIDIxLCAyMDE3IDEwOjQzIEFNDQo+IFRvOiBqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbTsgUmFn
aGF2YSBBZGl0eWEgUmVudWt1bnRhDQo+IDxSYWdoYXZhQWRpdHlhLlJlbnVrdW50YUBtaWNyb3Nl
bWkuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1hcnRpbi5wZXRlcnNlbkBv
cmFjbGUuY29tDQo+IENjOiBkbC1lc2MtQWFjcmFpZCBMaW51eCBEcml2ZXIgPGFhY3JhaWRAbWlj
cm9zZW1pLmNvbT47DQo+IGdwaWNjb2xpQGxpbnV4LnZuZXQuaWJtLmNvbTsgVG9tIFdoaXRlIDx0
b20ud2hpdGVAbWljcm9zZW1pLmNvbT47DQo+IFNjb3R0IEJlbmVzaCA8c2NvdHQuYmVuZXNoQG1p
Y3Jvc2VtaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMjEvMjldIHNjc2k6IGFhY3JhaWQ6
IFJlZmFjdG9yIHJlc29sdmUgbHVucyBjb2RlIGFuZCBzY3NpDQo+IGZ1bmN0aW9ucw0KPiANCj4g
RVhURVJOQUwgRU1BSUwNCj4gDQo+IA0KPiBPbiBUaHUsIDIwMTctMTItMjEgYXQgMDk6MzQgLTA4
MDAsIFJhZ2hhdmEgQWRpdHlhIFJlbnVrdW50YSB3cm90ZToNCj4gPiArICAgICBpZiAoYnVzID09
IENPTlRBSU5FUl9DSEFOTkVMKQ0KPiA+ICsgICAgICAgICAgICAgYnVzID0gQ09OVEFJTkVSX0NI
QU5ORUw7DQo+IA0KPiBTb3JyeSBidXQgSSBkb24ndCBzZWUgaG93IHRoZSBhYm92ZSBjb2RlIGNh
biBiZSB1c2VmdWw/DQoNCkkgYWdyZWUsIEkgZGlkIG5vdCB3YW50IHRvIGNoYW5nZSBsZWdhY3kg
Y29kZSBhIGJpdCB0b28gbXVjaC4gSSB3aWxsIHJlZmFjdG9yIHRoaXMgaW4gdGhlIG5leHQgaXRl
cmF0aW9uLg0KDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
