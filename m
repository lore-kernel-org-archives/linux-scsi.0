From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: delay run queue if device is blocked in
 scsi_dev_queue_ready()
Date: Mon, 4 Dec 2017 15:09:20 +0000
Message-ID: <1512400159.23838.1.camel@wdc.com>
References: <20171202163150.1273-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37684 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752716AbdLDPJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 10:09:22 -0500
In-Reply-To: <20171202163150.1273-1-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <CBAB3E1F6BE04A488A0671802BF98FDC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gU3VuLCAyMDE3LTEyLTAzIGF0IDAwOjMxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gRml4
ZXM6IDBkZjIxYzg2YmRiZiAoInNjc2k6IGltcGxlbWVudCAuZ2V0X2J1ZGdldCBhbmQgLnB1dF9i
dWRnZXQgZm9yIGJsay1tcSIpDQoNCkl0IG1pZ2h0IGJlIHNhZmVyIHRvIHJldmVydCBjb21taXQg
MGRmMjFjODZiZGJmIGluc3RlYWQgb2YgdHJ5aW5nIHRvIGZpeCBhbGwNCmlzc3VlcyBpbnRyb2R1
Y2VkIGJ5IHRoYXQgY29tbWl0IGZvciBrZXJuZWwgdmVyc2lvbiB2NC4xNSAuLi4NCg0KQmFydC4=
