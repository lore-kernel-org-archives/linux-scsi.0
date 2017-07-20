From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 3/7] qla2xxx: Add command completion wq for error path
Date: Thu, 20 Jul 2017 17:17:33 +0000
Message-ID: <0766AAA9-112F-4BF1-A11A-9F7778B18EDC@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
 <20170719185151.8564-4-himanshu.madhani@cavium.com>
 <1500497204.2494.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0057.outbound.protection.outlook.com ([104.47.38.57]:13408
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965883AbdGTRRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Jul 2017 13:17:36 -0400
In-Reply-To: <1500497204.2494.9.camel@wdc.com>
Content-Language: en-US
Content-ID: <72D9C0720F73D24EBFA413DC10B7C279@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQmFydCwgDQoNCg0KPiBPbiBKdWwgMTksIDIwMTcsIGF0IDE6NDYgUE0sIEJhcnQgVmFuIEFz
c2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDIwMTct
MDctMTkgYXQgMTE6NTEgLTA3MDAsIEhpbWFuc2h1IE1hZGhhbmkgd3JvdGU6DQo+PiBGcm9tOiBE
dWFuZSBHcmlnc2J5IDxkdWFuZS5ncmlnc2J5QGNhdml1bS5jb20+DQo+IA0KPiBIZWxsbyBIaW1h
bnNodSBhbmQgRHVhbmUsDQo+IA0KPiBUb28gbWFueSBkcml2ZXJzIGNyZWF0ZSB3b3JrcXVldWVz
IGZvciBhbGwga2luZHMgb2YgcHVycG9zZXMuIFdoeSBpcyBpdA0KPiBuZWNlc3NhcnkgdG8gZXhl
Y3V0ZSBxbGFfbnZtZV9pb193b3JrKCkgb24gdGhlIGNvbnRleHQgb2YgYSBuZXcgd29ya3F1ZXVl
Pw0KPiBJZiBhbnkgb2YgdGhlIGV4aXN0aW5nIHN5c3RlbSB3b3JrcXVldWVzIGNhbiBiZSB1c2Vk
IHBsZWFzZSBtb2RpZnkgdGhlIHBhdGNoDQo+IGFjY29yZGluZ2x5LiBPdGhlcndpc2UgcGxlYXNl
IGV4cGxhaW4gd2h5IGl0IGlzIG5lY2Vzc2FyeSB0byBpbnRyb2R1Y2UgYSBuZXcNCj4gd29ya3F1
ZXVlLg0KPiANCj4gQmFydC4NCg0KR29vZCBwb2ludC4gV2Ugd2VudCB3aXRoIHRoaXMgYXBwcm9h
Y2ggc28gdGhhdCB3ZSBjb3VsZCByZWxlYXNlIHFwYWlyIGxvY2sgb24gYQ0KcGFydGljdWxhciBx
dWV1ZSB3aGVuIHdlIGdldCBlcnJvci4gaG93ZXZlciwgd2XigJlsbCByZXdvcmsgdGhpcyBwYXRj
aCBhbmQgc3VibWl0DQppdCBhZ2FpbiB0byB1c2Ugb25lIG9mIGFscmVhZHkgZXhpc3Rpbmcgd29y
ayBxdWV1ZS4NCg0KVGhhbmtzLA0KLSBIaW1hbnNodQ0KDQo=
