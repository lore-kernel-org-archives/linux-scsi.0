From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] Ensure that the SCSI error handler gets woken up
Date: Fri, 1 Dec 2017 17:40:59 +0000
Message-ID: <1512150058.2520.19.camel@wdc.com>
References: <20171130224456.23100-1-bart.vanassche@wdc.com>
         <20171130224456.23100-2-bart.vanassche@wdc.com>
         <mqd609q4z0k.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:44243 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdLARlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2017 12:41:04 -0500
In-Reply-To: <mqd609q4z0k.fsf@linux-x5ow.site>
Content-Language: en-US
Content-ID: <5FC7699A893A6449B4375B59FEDE9FE1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>
Cc: "hch@lst.de" <hch@lst.de>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>

T24gRnJpLCAyMDE3LTEyLTAxIGF0IDA5OjQ1ICswMTAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4gd3JpdGVzOg0K
PiBbLi4uXQ0KPiANCj4gPiArCWlmIChzaG9zdF9zdGF0ZSAhPSBzaG9zdC0+c2hvc3Rfc3RhdGUp
IHsNCj4gPiArCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKHNob3N0LT5ob3N0X2xvY2ssIGZsYWdz
KTsNCj4gPiArCQlzeW5jaHJvbml6ZV9yY3UoKTsNCj4gPiArCQlzcGluX2xvY2tfaXJxc2F2ZShz
aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gKwl9DQo+IA0KPiBQbGVzZSBjb3JyZWN0IG1l
IGlmIEknbSB3cm9uZywgYnV0IG9uY2UgeW91IGRyb3AgdGhlIGhvc3QgbG9jayBhbGwNCj4gYXNz
dW1wdGlvbnMgYWJvdXQgc3RhdGVzIGl0IHByb3RlY3RzIGFyZSB2b2lkLCBhcmVuJ3QgdGhleT8g
DQoNCkhlbGxvIEpvaGFubmVzLA0KDQpUaGF0J3MgYSBnb29kIHF1ZXN0aW9uLiBJIHRoaW5rIGl0
IGlzIHNhZmUgdG8gZHJvcCB0aGUgaG9zdCBsb2NrIGF0IHRoYXQgcG9pbnQNCmJlY2F1c2Ugd2Fr
aW5nIHVwIHRoZSBlcnJvciBoYW5kbGVyIHRocmVhZCB3aWxsIG9ubHkgaGFwcGVuIGFmdGVyIGhv
c3RfZmFpbGVkDQpoYXMgYmVlbiBpbmNyZW1lbnRlZC4NCg0KQmFydC4=
