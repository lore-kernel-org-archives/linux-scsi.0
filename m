From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 14/22] qla2xxx: Fix nested spinlock
Date: Tue, 28 Nov 2017 19:45:01 +0000
Message-ID: <1511898300.28512.20.camel@wdc.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
         <20171128193503.13695-15-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25309 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbdK1TpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 14:45:04 -0500
In-Reply-To: <20171128193503.13695-15-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <855EE31CDEBD614FBD4A972208B850CF@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTExLTI4IGF0IDExOjM0IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBGcm9tOiBRdWlubiBUcmFuIDxxdWlubi50cmFuQGNhdml1bS5jb20+DQoNCk5lc3Rpbmcg
c3BpbmxvY2tzIGlzIGFsbG93ZWQgc28gSSB0aGluayBhIG1vcmUgZGV0YWlsZWQgZGVzY3JpcHRp
b24NCmlzIHJlcXVpcmVkIGZvciB0aGlzIHBhdGNoLiBJdCB3b3VsZCBoZWxwIGUuZy4gdG8gZXhw
bGFpbiB3aHkgdGhpcw0KcGF0Y2ggaXMgYSBidWcgZml4IGFuZCBhbHNvIHdoYXQgaXQgZml4ZXMu
DQoNClRoYW5rcywNCg0KQmFydC4=
