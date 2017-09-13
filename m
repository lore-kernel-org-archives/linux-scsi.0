From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Wed, 13 Sep 2017 17:28:24 +0000
Message-ID: <1505323703.2654.3.camel@wdc.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
         <20170911111021.25810-9-ming.lei@redhat.com>
         <1505145834.2802.17.camel@wdc.com> <20170912034057.GC31533@ming.t460p>
         <20170913164803.GB10407@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7590 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbdIMR3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 13:29:15 -0400
In-Reply-To: <20170913164803.GB10407@ming.t460p>
Content-Language: en-US
Content-ID: <EFEB4D82EFE9234AA4A91FE711BA792E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "cavery@redhat.com" <cavery@redhat.com>

T24gVGh1LCAyMDE3LTA5LTE0IGF0IDAwOjQ4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQ291
bGQgeW91IHBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3VyIGNvbmNlcm4gYWJvdXQgcmFjZSBiZXR3
ZWVuDQo+IHByZWVtcHQgZnJlZXplIGFuZCBibGtfY2xlYW51cF9xdWV1ZSgpIGlzIGFkZHJlc3Nl
ZCBpbiBteSBsYXN0DQo+IHJlcGx5Pw0KDQpTaG91bGRuJ3Qgd2Ugd2FpdCB1bnRpbCB2NC4xMy1y
YzEgaGFzIGJlZW4gcmVsZWFzZWQgYmVmb3JlIHNwZW5kaW5nIG1vcmUNCmVuZXJneSBvbiB0aGlz
PyBDZXJ0YWluIHBhdGNoZXMgdGhhdCBoYXZlIGJlZW4gc2VudCB0byBMaW51cywgZS5nLiBjb21t
aXQNCjE1N2YzNzdiZWI3MSAoImJsb2NrOiBkaXJlY3RseSBpbnNlcnQgYmxrLW1xIHJlcXVlc3Qg
ZnJvbQ0KYmxrX2luc2VydF9jbG9uZWRfcmVxdWVzdCgpIiksIG1heSBhZmZlY3QgdGhlIHRlc3Qg
cmVzdWx0cy4gSSBoYXZlIG5vdA0KYmVlbiBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgaGFuZyBkdXJp
bmcgcmVzdW1lIHdpdGggSmVucycgbGF0ZXN0IGZvci1uZXh0DQpicmFuY2guDQoNCkJhcnQu
