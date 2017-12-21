From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 08/29] scsi: aacraid: Move code to wait for IO completion
 to shutdown func
Date: Thu, 21 Dec 2017 17:59:10 +0000
Message-ID: <1513879148.2931.19.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-9-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:16949 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdLUR7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 12:59:13 -0500
In-Reply-To: <20171221173420.8213-9-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Content-ID: <6D715B10B9467240B13375825BEC1893@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjMzIC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3Vu
dGEgd3JvdGU6DQo+ICtzdGF0aWMgdm9pZCBhYWNfd2FpdF9mb3JfaW9fY29tcGxldGlvbihzdHJ1
Y3QgYWFjX2RldiAqYWFjKQ0KPiArew0KPiArCXVuc2lnbmVkIGxvbmcgZmxhZ3YgPSAwOw0KPiAr
CWludCBpID0gMDsNCj4gKw0KPiArCWZvciAoaSA9IDYwOyBpOyAtLWkpIHsNCj4gKwkJc3RydWN0
IHNjc2lfZGV2aWNlICpkZXY7DQo+ICsJCXN0cnVjdCBzY3NpX2NtbmQgKmNvbW1hbmQ7DQo+ICsJ
CWludCBhY3RpdmUgPSAwOw0KPiArDQo+ICsJCV9fc2hvc3RfZm9yX2VhY2hfZGV2aWNlKGRldiwg
YWFjLT5zY3NpX2hvc3RfcHRyKSB7DQo+ICsJCQlzcGluX2xvY2tfaXJxc2F2ZSgmZGV2LT5saXN0
X2xvY2ssIGZsYWd2KTsNCj4gKwkJCWxpc3RfZm9yX2VhY2hfZW50cnkoY29tbWFuZCwgJmRldi0+
Y21kX2xpc3QsIGxpc3QpIHsNCj4gKwkJCQlpZiAoY29tbWFuZC0+U0NwLnBoYXNlID09IEFBQ19P
V05FUl9GSVJNV0FSRSkgew0KPiArCQkJCQlhY3RpdmUrKzsNCj4gKwkJCQkJYnJlYWs7DQo+ICsJ
CQkJfQ0KPiArCQkJfQ0KPiArCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2LT5saXN0X2xv
Y2ssIGZsYWd2KTsNCj4gKwkJCWlmIChhY3RpdmUpDQo+ICsJCQkJYnJlYWs7DQo+ICsNCj4gKwkJ
fQ0KPiArCQkvKg0KPiArCQkgKiBXZSBjYW4gZXhpdCBJZiBhbGwgdGhlIGNvbW1hbmRzIGFyZSBj
b21wbGV0ZQ0KPiArCQkgKi8NCj4gKwkJaWYgKGFjdGl2ZSA9PSAwKQ0KPiArCQkJYnJlYWs7DQo+
ICsJCXNzbGVlcCgxKTsNCj4gKwl9DQo+ICt9DQoNCkhhdmUgeW91IGNvbnNpZGVyZWQgdG8gY2Fs
bCBzY3NpX3RhcmdldF9ibG9jaygpIGFuZCBzY3NpX3RhcmdldF91bmJsb2NrKCkgaW5zdGVhZA0K
b2YgaW1wbGVtZW50aW5nIGZ1bmN0aW9uYWxpdHkgbGlrZSB0aGUgYWJvdmUgaW4gYSBTQ1NJIExM
RD8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
