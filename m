From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 16:49:15 +0000
Message-ID: <1505839754.2671.42.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-2-ming.lei@redhat.com>
         <1505498249.3420.15.camel@wdc.com> <20170917124000.GB6289@ming.t460p>
         <1505747894.2685.6.camel@wdc.com> <20170919054308.GA2517@ming.t460p>
         <1505835394.2671.18.camel@wdc.com> <20170919155603.GB22809@redhat.com>
         <20170919160401.GC19830@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47117 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdISQtT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 12:49:19 -0400
In-Reply-To: <20170919160401.GC19830@ming.t460p>
Content-Language: en-US
Content-ID: <65E0B0232B112440949EED09200096F6@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gV2VkLCAyMDE3LTA5LTIwIGF0IDAwOjA0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gUnVu
IHF1ZXVlIGF0IGVuZF9pbyBpcyBkZWZpbml0ZWx5IHdyb25nLCBiZWNhdXNlIGJsay1tcSBoYXMg
U0NIRURfUkVTVEFSVA0KPiB0byBkbyB0aGF0IGFscmVhZHkuDQoNClNvcnJ5IGJ1dCBJIGRpc2Fn
cmVlLiBJZiBTQ0hFRF9SRVNUQVJUIGlzIHNldCB0aGF0IGNhdXNlcyB0aGUgYmxrLW1xIGNvcmUg
dG8NCnJlZXhhbWluZSB0aGUgc29mdHdhcmUgcXVldWVzIGFuZCB0aGUgaGN0eCBkaXNwYXRjaCBs
aXN0IGJ1dCBub3QgdGhlIHJlcXVldWUNCmxpc3QuIElmIGEgYmxvY2sgZHJpdmVyIHJldHVybnMg
QkxLX1NUU19SRVNPVVJDRSB0aGVuIHJlcXVlc3RzIGVuZCB1cCBvbiB0aGUNCnJlcXVldWUgbGlz
dC4gSGVuY2UgdGhlIGZvbGxvd2luZyBjb2RlIGluIHNjc2lfZW5kX3JlcXVlc3QoKToNCg0KCWlm
IChzY3NpX3RhcmdldChzZGV2KS0+c2luZ2xlX2x1biB8fCAhbGlzdF9lbXB0eSgmc2Rldi0+aG9z
dC0+c3RhcnZlZF9saXN0KSkNCgkJa2Jsb2NrZF9zY2hlZHVsZV93b3JrKCZzZGV2LT5yZXF1ZXVl
X3dvcmspOw0KCWVsc2UNCgkJYmxrX21xX3J1bl9od19xdWV1ZXMocSwgdHJ1ZSk7DQoNCkJhcnQu
