From: "Tran, Quinn" <Quinn.Tran@cavium.com>
Subject: Re: [PATCH 20/25] qla2xxx: Remove redundant code
Date: Wed, 31 May 2017 23:44:20 +0000
Message-ID: <5D84054C-13F0-4427-B699-B7134AEA7994@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
 <20170519215344.2168-21-himanshu.madhani@cavium.com>
 <1495237379.2581.19.camel@sandisk.com>
 <1495427279.27407.20.camel@haakon3.risingtidesystems.com>
 <1495477383.1017.3.camel@sandisk.com>
 <71DF2234-3414-4AD7-AE31-E974F92E4708@cavium.com>
 <1496274086.2608.30.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0089.outbound.protection.outlook.com ([104.47.38.89]:52512
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751000AbdEaXoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 19:44:23 -0400
In-Reply-To: <1496274086.2608.30.camel@sandisk.com>
Content-Language: en-US
Content-ID: <02A9CE44AA296B448263CBEE59690429@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

QmFydCwNCg0KV2lsbCBtYWtlIGF2YWlsYWJsZSBpbiB0aGUgbmV4dCB1cHN0cmVhbSwgb25jZSBp
dCBoYXMgYSBjaGFuY2UgdG8gZ28gdGhyb3VnaCBvdXIgaW50ZXJuYWwgdGVzdCBjeWNsZS4gDQoN
ClJlZ2FyZHMsDQpRdWlubiBUcmFuDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9t
OiBCYXJ0IFZhbiBBc3NjaGUgPEJhcnQuVmFuQXNzY2hlQHNhbmRpc2suY29tPg0KRGF0ZTogV2Vk
bmVzZGF5LCBNYXkgMzEsIDIwMTcgYXQgNDo0MSBQTQ0KVG86ICJUcmFuLCBRdWlubiIgPFF1aW5u
LlRyYW5AY2F2aXVtLmNvbT4sIE5pY2hvbGFzIEJlbGxpbmdlciA8bmFiQGxpbnV4LWlzY3NpLm9y
Zz4NCkNjOiAibGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmciIDxsaW51eC1zY3NpQHZnZXIua2Vy
bmVsLm9yZz4sICJKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tIiA8SmFtZXMu
Qm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT4sICJNYWRoYW5pLCBIaW1hbnNodSIgPEhp
bWFuc2h1Lk1hZGhhbmlAY2F2aXVtLmNvbT4sICJtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbSIg
PG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCAyMC8yNV0g
cWxhMnh4eDogUmVtb3ZlIHJlZHVuZGFudCBjb2RlDQoNCiAgICBPbiBNb24sIDIwMTctMDUtMjIg
YXQgMjI6MTQgKzAwMDAsIFRyYW4sIFF1aW5uIHdyb3RlOg0KICAgID4gDQogICAgPiBJIHRoaW5r
IGFuIGluaXRpYXRvciBjb3VsZCBnZXQNCiAgICA+ICAgICByZWFsbHkgY29uZnVzZWQgaWYgaXQg
cmVjZWl2ZXMgdHdvIHJlc3BvbnNlcyBmb3IgdGhlIHNhbWUgZXhjaGFuZ2UuDQogICAgPiANCiAg
ICA+IFFUOiAgSSBkbyBzZWUgdGhlIHdpbmRvdyB5b3XKvHJlIGRlc2NyaWJpbmcgaW4gdGhlIHFs
dF90cnlfdG9fZGVxdWV1ZV91bmtub3duX2F0aW9zKCkuDQogICAgPiBXaWxsIGhhdmUgdG8gZm9s
bG93IHVwIHdpdGggYW5vdGhlciBwYXRjaC4gICBUaGlzIHBhdGNoIGlzIG5vdCBtZWFudCBmb3Ig
dGhpcyB3aW5kb3cNCiAgICA+IHlvdcq8dmUganVzdCBpZGVudGlmeS4NCiAgICANCiAgICBIZWxs
byBRdWlubiwNCiAgICANCiAgICBIYXMgdGhhdCBwYXRjaCBiZWVuIGluY2x1ZGVkIGluIHYyIG9m
IHRoaXMgc2VyaWVzIG9yIHdpbGwgdGhhdCBwYXRjaCBwZXJoYXBzIGJlDQogICAgbWFkZSBhdmFp
bGFibGUgbGF0ZXI/DQogICAgDQogICAgVGhhbmtzLA0KICAgIA0KICAgIEJhcnQuDQoNCg==
