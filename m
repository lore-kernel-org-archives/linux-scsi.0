From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 02/43] qla2xxx: Fix NULL pointer access for fcport
 structure
Date: Wed, 20 Dec 2017 16:26:33 +0000
Message-ID: <1513787192.2603.12.camel@wdc.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
         <20171220065644.21511-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:36520 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754544AbdLTQ0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2017 11:26:35 -0500
In-Reply-To: <20171220065644.21511-3-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <1C08F7DFE4F9464F86CD583BDA523658@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTEyLTE5IGF0IDIyOjU2IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBGcm9tOiBRdWlubiBUcmFuIDxxdWlubi50cmFuQGNhdml1bS5jb20+DQo+IA0KPiB3aGVu
IHByZW9jZXNzaW5nIGlvY2IgaW4gYSB0aW1lb3V0IGNhc2UsIGRyaXZlciB3YXMgdHJ5aW5nIHRv
IGxvZyBtZXNzYWdlcw0KICAgICAgIF5eXl5eXl5eXl5eDQogICAgICAgcHJvY2Vzc2luZz8NCg0K
QmFydC4=
