From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 25/29] scsi: aacraid: Reschedule host scan in case of
 failure
Date: Wed, 27 Dec 2017 01:25:59 +0000
Message-ID: <b61e157673564521a7c045e9c35c69fc@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-26-RaghavaAditya.Renukunta@microsemi.com>
 <1513881887.2931.24.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0081.outbound.protection.outlook.com ([104.47.41.81]:49744
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751211AbdL0B03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 20:26:29 -0500
In-Reply-To: <1513881887.2931.24.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, Tom White <tom.white@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IFttYWlsdG86QmFydC5WYW5Bc3NjaGVAd2RjLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIERlY2Vt
YmVyIDIxLCAyMDE3IDEwOjQ1IEFNDQo+IFRvOiBqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbTsgUmFn
aGF2YSBBZGl0eWEgUmVudWt1bnRhDQo+IDxSYWdoYXZhQWRpdHlhLlJlbnVrdW50YUBtaWNyb3Nl
bWkuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1hcnRpbi5wZXRlcnNlbkBv
cmFjbGUuY29tDQo+IENjOiBkbC1lc2MtQWFjcmFpZCBMaW51eCBEcml2ZXIgPGFhY3JhaWRAbWlj
cm9zZW1pLmNvbT47DQo+IGdwaWNjb2xpQGxpbnV4LnZuZXQuaWJtLmNvbTsgVG9tIFdoaXRlIDx0
b20ud2hpdGVAbWljcm9zZW1pLmNvbT47DQo+IFNjb3R0IEJlbmVzaCA8c2NvdHQuYmVuZXNoQG1p
Y3Jvc2VtaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMjUvMjldIHNjc2k6IGFhY3JhaWQ6
IFJlc2NoZWR1bGUgaG9zdCBzY2FuIGluIGNhc2Ugb2YNCj4gZmFpbHVyZQ0KPiANCj4gRVhURVJO
QUwgRU1BSUwNCj4gDQo+IA0KPiBPbiBUaHUsIDIwMTctMTItMjEgYXQgMDk6MzQgLTA4MDAsIFJh
Z2hhdmEgQWRpdHlhIFJlbnVrdW50YSB3cm90ZToNCj4gPiArICAgICBzdHJ1Y3QgZGVsYXllZF93
b3JrICAgICBzYWZ3X3Jlc2Nhbl93b3JrZXI7DQo+IA0KPiBQbGVhc2UgbWFrZSB0aGUgbmFtZSBv
ZiB0aGlzIG1lbWJlciB2YXJpYWJsZSBjb25zaXN0ZW50IHdpdGggb3RoZXIga2VybmVsDQo+IGNv
ZGUuIFRoYXQNCj4gbWVhbnMgZWl0aGVyIHVzaW5nIGUuZy4gdGhlIG5hbWUgInNhZndfcmVzY2Fu
X3dvcmsiIG9yICJzYWZ3X3Jlc2NhbiIuDQoNClllcywgV2lsbCBEbywNCg0KUmVnYXJkcywNClJh
Z2hhdmEgQWRpdHlhDQoNCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
