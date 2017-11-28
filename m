From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 14/22] qla2xxx: Fix nested spinlock
Date: Tue, 28 Nov 2017 22:27:17 +0000
Message-ID: <1511908033.28512.31.camel@wdc.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
         <20171128193503.13695-15-himanshu.madhani@cavium.com>
         <1511898300.28512.20.camel@wdc.com>
         <F873F5EF-0F1D-4E73-82C4-081D048BAF96@cavium.com>
         <1511906943.28512.28.camel@wdc.com>
         <A933D13D-16D3-4458-B7DE-B992BC615A7E@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62654 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdK1W1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 17:27:19 -0500
In-Reply-To: <A933D13D-16D3-4458-B7DE-B992BC615A7E@cavium.com>
Content-Language: en-US
Content-ID: <5F65A12815F826469877C4B54FD5E9E3@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Himanshu.Madhani@cavium.com" <Himanshu.Madhani@cavium.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gVHVlLCAyMDE3LTExLTI4IGF0IDIyOjIyICswMDAwLCBNYWRoYW5pLCBIaW1hbnNodSB3cm90
ZToNCj4gVGhpcyB3YXMgcmVwb3J0ZWQgYnkgY3VzdG9tZXIgc28gaSBhbSBub3QgdmVyeSBjb25m
aWRlbnQgdGhleSB3b3VsZCBoYXZlIENPTkZJR19QUk9WRV9MT0NLSU5HIGVuYWJsZWQgaW4NCj4g
dGhlaXIgc2V0dXAuIEnigJlsbCBlbmFibGUgdGhpcyBvbiBvdXIgc2V0dXAgYW5kIHdlIGNhbiB0
cnkgdG8gcmVwcm9kdWNlIHRoaXMgaXNzdWUuIA0KPiANCj4gTGV0IG1lIGtub3cgaWYgeW91IHdh
bnQgbWUgdG8gZHJvcCB0aGlzIHBhdGNoIHVudGlsIHdlIGdldCBtb3JlIGRldGFpbHMuDQoNCkhl
bGxvIEhpbWFuc2h1LA0KDQpXaGF0IEkgdGhpbmsgaXMgdGhhdCBhdCBsZWFzdCBhbiBleHBsYW5h
dGlvbiBzaG91bGQgYmUgcHJvdmlkZWQgYWJvdXQgd2h5IGl0DQppcyBzYWZlIHRvIGxlYXZlIG91
dCB0aGUgc3Bpbl9sb2NrKCkgYW5kIHNwaW5fdW5sb2NrKCkgY2FsbHMuIFdoYXQgZG9lcyB0aGUN
CmhhcmR3YXJlIGxvY2sgcHJvdGVjdCBhbmQgd2h5IGlzIGl0IHNhZmUgdG8gbGVhdmUgaXQgb3V0
IGZyb20NCnFsYTJ4MDBfZWxzX2RjbWRfaW9jYl90aW1lb3V0KCk/DQoNClRoYW5rcywNCg0KQmFy
dC4=
