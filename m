From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 14/29] scsi: aacraid: Move function around to match
 existing code
Date: Wed, 27 Dec 2017 01:23:49 +0000
Message-ID: <1e93087ad2a24b879c65b1c9cd95f9b4@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-15-RaghavaAditya.Renukunta@microsemi.com>
 <1513881591.2931.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0072.outbound.protection.outlook.com ([104.47.34.72]:60401
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751163AbdL0BYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 20:24:20 -0500
In-Reply-To: <1513881591.2931.21.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, Tom White <tom.white@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IFttYWlsdG86QmFydC5WYW5Bc3NjaGVAd2RjLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIERlY2Vt
YmVyIDIxLCAyMDE3IDEwOjQwIEFNDQo+IFRvOiBqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbTsgUmFn
aGF2YSBBZGl0eWEgUmVudWt1bnRhDQo+IDxSYWdoYXZhQWRpdHlhLlJlbnVrdW50YUBtaWNyb3Nl
bWkuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1hcnRpbi5wZXRlcnNlbkBv
cmFjbGUuY29tDQo+IENjOiBkbC1lc2MtQWFjcmFpZCBMaW51eCBEcml2ZXIgPGFhY3JhaWRAbWlj
cm9zZW1pLmNvbT47DQo+IGdwaWNjb2xpQGxpbnV4LnZuZXQuaWJtLmNvbTsgVG9tIFdoaXRlIDx0
b20ud2hpdGVAbWljcm9zZW1pLmNvbT47DQo+IFNjb3R0IEJlbmVzaCA8c2NvdHQuYmVuZXNoQG1p
Y3Jvc2VtaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMTQvMjldIHNjc2k6IGFhY3JhaWQ6
IE1vdmUgZnVuY3Rpb24gYXJvdW5kIHRvIG1hdGNoDQo+IGV4aXN0aW5nIGNvZGUNCj4gDQo+IEVY
VEVSTkFMIEVNQUlMDQo+IA0KPiANCj4gT24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjM0IC0wODAw
LCBSYWdoYXZhIEFkaXR5YSBSZW51a3VudGEgd3JvdGU6DQo+ID4gKy8qKg0KPiA+ICsgKiAgIGFh
Y19nZXRfc2Fmd19jaXNzX2x1bnMoKSAgICAgICAgUHJvY2VzcyB0b3BvbG9neSBjaGFuZ2UNCj4g
PiArICogICBAZGV2OiAgICAgICAgICAgYWFjX2RldiBzdHJ1Y3R1cmUNCj4gPiArICogICBAcmVz
Y2FuICAgICAgICAgSW5kaWNhdGVzIHJlc2Nhbg0KPiA+ICsgKg0KPiA+ICsgKiAgIEV4ZWN1dGUg
YSBDSVNTIFJFUE9SVCBQSFlTIExVTlMgYW5kIHByb2Nlc3MgdGhlIHJlc3VsdHMgaW50bw0KPiA+
ICsgKiAgIHRoZSBjdXJyZW50IGhiYV9tYXAuDQo+ID4gKyAqLw0KPiANCj4gVGhlIGFib3ZlIGZ1
bmN0aW9uIGhlYWRlciBpcyBub3QgZm9sbG93aW5nIHRoZSBrZXJuZWwtZG9jIHN5bnRheDogYSBj
b2xvbiBpcw0KPiBtaXNzaW5nLiBIYXZlIHlvdSB0cmllZCB0byBidWlsZCB5b3VyIGRyaXZlciB3
aXRoIFc9MT8gVGhhdCBzaG91bGQgYmUNCj4gc3VmZmljaWVudA0KPiB3aXRoIGtlcm5lbCB2ZXJz
aW9uIHY0LjE1LXJjMSBvciBsYXRlciB0byByZXBvcnQga2VybmVsLWRvYyBoZWFkZXIgaXNzdWVz
Lg0KPiANCj4gQmFydC4NCg0KSSB3YXMgbm90IGF3YXJlIG9mIHRoYXQgb3B0aW9uIEkgd2lsbCBm
aXggaXQgaW4gdGhlIG15IG5leHQgdmVyc2lvbi4NClJlZ2FyZHMsDQpSYWdoYXZhIEFkaXR5YQ0K
