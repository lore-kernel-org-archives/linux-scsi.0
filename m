From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 03/43] qla2xxx: Use IOCB path to submit Control VP MBX
 command
Date: Wed, 20 Dec 2017 16:29:26 +0000
Message-ID: <1513787365.2603.15.camel@wdc.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
         <20171220065644.21511-4-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1673 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdLTQ3j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2017 11:29:39 -0500
In-Reply-To: <20171220065644.21511-4-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <8F3F43434376084195D44C94A6AAB6A0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTEyLTE5IGF0IDIyOjU2IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBAQCAtNTM2LDcgKzU0MSw3IEBAIHN0cnVjdCBzcF9uYW1lIHsNCj4gICNkZWZpbmUgU1JC
X05WTUVfQ01ECTE5DQo+ICAjZGVmaW5lIFNSQl9OVk1FX0xTCTIwDQo+ICAjZGVmaW5lIFNSQl9Q
UkxJX0NNRAkyMQ0KPiAtDQo+ICsjZGVmaW5lIFNSQl9DVFJMX1ZQCTIyDQo+ICBlbnVtIHsNCg0K
UGxlYXNlIGtlZXAgdGhlIGJsYW5rIGxpbmUgYmV0d2VlbiB0aGUgI2RlZmluZSBibG9jayBhbmQg
dGhlIGVudW0gZGVmaW5pdGlvbi4NCg0KPiArLyoNCj4gKyAqIHFsYTI0eHhfY29udHJvbF92cA0K
PiArICoJRW5hYmxlIGEgdmlydHVhbCBwb3J0IGZvciBnaXZlbiBob3N0DQo+ICsgKg0KPiArICog
SW5wdXQ6DQo+ICsgKgloYSA9IGFkYXB0ZXIgYmxvY2sgcG9pbnRlci4NCj4gKyAqCXZoYmEgPSB2
aXJ0dWFsIGFkYXB0ZXIgKHVudXNlZCkNCj4gKyAqCWluZGV4ID0gaW5kZXggbnVtYmVyIGZvciBl
bmFibGVkIFZQDQo+ICsgKg0KPiArICogUmV0dXJuczoNCj4gKyAqCXFsYTJ4eHggbG9jYWwgZnVu
Y3Rpb24gcmV0dXJuIHN0YXR1cyBjb2RlLg0KPiArICoNCj4gKyAqIENvbnRleHQ6DQo+ICsgKglL
ZXJuZWwgY29udGV4dC4NCj4gKyAqLw0KPiAraW50DQo+ICtxbGEyNHh4X2NvbnRyb2xfdnAoc2Nz
aV9xbGFfaG9zdF90ICp2aGEsIGludCBjbWQpDQoNCkhhdmUgeW91IGNvbnNpZGVyZWQgdG8gdXNl
IHRoZSBrZXJuZWwtZG9jIHN0eWxlIGZvciB0aGlzIGZ1bmN0aW9uIGhlYWRlcj8gU2VlDQphbHNv
IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL0RvY3VtZW50YXRpb24va2VybmVsLWRvYy1uYW5v
LUhPV1RPLnR4dC4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
