From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
 queue pointer to blk_rq_init()
Date: Sun, 21 May 2017 16:41:38 +0000
Message-ID: <1495384897.3192.3.camel@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
         <20170519183016.12646-7-bart.vanassche@sandisk.com>
         <20170521065003.GE12891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30142 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdEUQlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2017 12:41:42 -0400
In-Reply-To: <20170521065003.GE12891@lst.de>
Content-Language: en-US
Content-ID: <8E67E06CA87E2F468280F61BDED91744@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gU3VuLCAyMDE3LTA1LTIxIGF0IDA4OjUwICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gQWx0aG91Z2ggd2UgcmVhbGx5IG5lZWQgdG8gc3RvcCBhYnVzaW5nIHJlcXVlc3RzL2Nt
ZHMgZm9yIEVILi4NCj4gKEhhbm5lcywgdGltZSB0byBkdXN0IG9mZiB5b3VyIG9sZCBwYXRjaGVz
ISkNCg0KSGVsbG8gQ2hyaXN0b3BoIGFuZCBIYW5uZXMsDQoNCkhvdyBhYm91dCBwYXNzaW5nIGEg
c3RydWN0IHNjc2lfZGV2aWNlIHBvaW50ZXIgdG8gdGhlIGVoXypfcmVzZXRfaGFuZGxlcg0KY2Fs
bGJhY2tzIGluc3RlYWQgb2YgYSBzdHJ1Y3Qgc2NzaV9jbW5kIHBvaW50ZXI/IE1vc3QgU0NTSSBM
TEQNCmVoXypfcmVzZXRfaGFuZGxlciBpbXBsZW1lbnRhdGlvbnMgZG9uJ3QgZG8gYW55dGhpbmcg
d2l0aCB0aGUgaW5mb3JtYXRpb24NCnBhc3NlZCB0aHJvdWdoIHRoZSBzdHJ1Y3Qgc2NzaV9jbW5k
IHBvaW50ZXIgZXhjZXB0IHJlYWRpbmcgdGhlIFNDU0kgZGV2aWNlDQpwb2ludGVyIGFuZCBsb2dn
aW5nIHRoZSBTQ1NJIGNvbW1hbmQgQ0RCLiBIYW5uZXMsIGlzIHRoaXMgdGhlIHNhbWUgYXMgeW91
cg0KcHJvcG9zYWw/IERvIHlvdSB3YW50IHRvIHdvcmsgb24gdGhpcyBvciBkbyB5b3UgcGVyaGFw
cyBleHBlY3QgbWUgdG8gcHJlcGFyZQ0KcGF0Y2hlcyB0byBpbXBsZW1lbnQgdGhhdCBjaGFuZ2U/
DQoNCkJhcnQu
