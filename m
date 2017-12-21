From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 01/29] scsi: aacraid: Fix udev inquiry race condition
Date: Thu, 21 Dec 2017 17:54:02 +0000
Message-ID: <1513878840.2931.16.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-2-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8934 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdLURyE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 12:54:04 -0500
In-Reply-To: <20171221173420.8213-2-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Content-ID: <AEE08FFBE514C0469E6B3BE68FB46B00@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjMzIC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3Vu
dGEgd3JvdGU6DQo+ICsJCWNoYXIgKmNwOw0KPiArCQljaGFyICpjbmFtZSA9IGttYWxsb2Moc2l6
ZW9mKHN1cF9hZGFwX2luZm8tPmFkYXB0ZXJfdHlwZV90ZXh0KSwNCj4gKwkJCQkJCQkJR0ZQX0FU
T01JQyk7DQoNCldoeSBkaWQgeW91IGNob29zZSB0byB1c2UgR0ZQX0FUT01JQyBpbnN0ZWFkIG9m
IEdGUF9LRVJORUwgaW4gdGhlIGFib3ZlDQprbWFsbG9jKCkgY2FsbD8NCg0KPiArDQo+ICsJCWlm
ICghY25hbWUpDQo+ICsJCQlyZXR1cm47DQo+ICsNCj4gKwkJY3AgPSBjbmFtZTsNCj4gKwkJbWVt
Y3B5KGNuYW1lLCBzdXBfYWRhcF9pbmZvLT5hZGFwdGVyX3R5cGVfdGV4dCwNCj4gKwkJCXNpemVv
ZihzdXBfYWRhcF9pbmZvLT5hZGFwdGVyX3R5cGVfdGV4dCkpOw0KDQpJcyB0aGUgc3VwX2FkYXBf
aW5mby0+YWRhcHRlcl90eXBlX3RleHQgYSBzdHJpbmcgdGhhdCBpcyBcMC10ZXJtaW5hdGVkPyBJ
ZiBzbywNCmhhdmUgeW91IGNvbnNpZGVyZWQgdG8gdXNlIGttZW1kdXAoKSBpbnN0ZWFkIG9mIGtt
YWxsb2MoKSArIG1lbWNweSgpPw0KDQpUaGFua3MsDQoNCkJhcnQu
