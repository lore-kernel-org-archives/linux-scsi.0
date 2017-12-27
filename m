From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 15/29] scsi: aacraid: Create helper functions to get lun
 info
Date: Wed, 27 Dec 2017 01:24:21 +0000
Message-ID: <9002e182503e413dbc53f992e95a78bf@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-16-RaghavaAditya.Renukunta@microsemi.com>
 <1513881642.2931.22.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0048.outbound.protection.outlook.com ([104.47.37.48]:47136
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751163AbdL0BY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 20:24:27 -0500
In-Reply-To: <1513881642.2931.22.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, Tom White <tom.white@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IFttYWlsdG86QmFydC5WYW5Bc3NjaGVAd2RjLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIERlY2Vt
YmVyIDIxLCAyMDE3IDEwOjQxIEFNDQo+IFRvOiBqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbTsgUmFn
aGF2YSBBZGl0eWEgUmVudWt1bnRhDQo+IDxSYWdoYXZhQWRpdHlhLlJlbnVrdW50YUBtaWNyb3Nl
bWkuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1hcnRpbi5wZXRlcnNlbkBv
cmFjbGUuY29tDQo+IENjOiBkbC1lc2MtQWFjcmFpZCBMaW51eCBEcml2ZXIgPGFhY3JhaWRAbWlj
cm9zZW1pLmNvbT47DQo+IGdwaWNjb2xpQGxpbnV4LnZuZXQuaWJtLmNvbTsgVG9tIFdoaXRlIDx0
b20ud2hpdGVAbWljcm9zZW1pLmNvbT47DQo+IFNjb3R0IEJlbmVzaCA8c2NvdHQuYmVuZXNoQG1p
Y3Jvc2VtaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMTUvMjldIHNjc2k6IGFhY3JhaWQ6
IENyZWF0ZSBoZWxwZXIgZnVuY3Rpb25zIHRvIGdldCBsdW4NCj4gaW5mbw0KPiANCj4gRVhURVJO
QUwgRU1BSUwNCj4gDQo+IA0KPiBPbiBUaHUsIDIwMTctMTItMjEgYXQgMDk6MzQgLTA4MDAsIFJh
Z2hhdmEgQWRpdHlhIFJlbnVrdW50YSB3cm90ZToNCj4gPiArICAgICByZXR1cm4gKChwaHlzX2x1
bnMtPmxpc3RfbGVuZ3RoWzBdPDwyNCkgKw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAocGh5
c19sdW5zLT5saXN0X2xlbmd0aFsxXTw8MTYpICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
KHBoeXNfbHVucy0+bGlzdF9sZW5ndGhbMl08PDgpICsNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgKHBoeXNfbHVucy0+bGlzdF9sZW5ndGhbM10pKSAvIDI0Ow0KPiANCj4gUGxlYXNlIHVzZSBn
ZXRfdW5hbGlnbmVkX2JlMzIoKSBpbnN0ZWFkIG9mIG9wZW4tY29kaW5nIGl0Lg0KDQpZZXMgV2ls
bCBkbyBCYXJ0Lg0KVGhhbmsgeW91DQpSYWdoYXZhIEFkaXR5YQ0KIA0KDQo+IFRoYW5rcywNCj4g
DQo+IEJhcnQuDQo=
