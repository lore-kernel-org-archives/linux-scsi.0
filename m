From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/18] bsg: Check private request size before attaching to
 a queue
Date: Sun, 21 May 2017 14:33:05 +0000
Message-ID: <1495377183.3192.1.camel@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
         <20170519183016.12646-3-bart.vanassche@sandisk.com>
         <20170521063237.GE12287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48040 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdEUOdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2017 10:33:08 -0400
In-Reply-To: <20170521063237.GE12287@lst.de>
Content-Language: en-US
Content-ID: <0376D58B615219428EEC6D961DF9B882@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

T24gU3VuLCAyMDE3LTA1LTIxIGF0IDA4OjMyICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gQW5kIGJ0dywgSSBkaWRuJ3QgZ2V0IHlvdXIgY292ZXIgbGV0dGVyIFswLzE4XSwgZGlk
IHRoYXQgZ2V0IGxvc3QNCj4gc29tZXdoZXJlPw0KDQpIZWxsbyBDaHJpc3RvcGgsDQoNClRoYW5r
cyBmb3IgdGhlIHJldmlldyBjb21tZW50cy4gVGhlIGNvdmVyIGxldHRlciBzaG91bGQgaGF2ZSBt
YWRlIGl0IHRvIGF0DQpsZWFzdCB0aGUgbGludXgtc2NzaSBtYWlsaW5nIGxpc3Qgc2luY2UgaXQg
c2hvd3MgdXAgaW4gYXQgbGVhc3Qgb25lIGFyY2hpdmUgb2YNCnRoYXQgbWFpbGluZyBsaXN0OiBo
dHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1zY3NpL21zZzEwODk0MC5odG1sLg0K
DQpCYXJ0Lg==
