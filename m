From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Mon, 18 Sep 2017 15:18:16 +0000
Message-ID: <1505747894.2685.6.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-2-ming.lei@redhat.com>
         <1505498249.3420.15.camel@wdc.com> <20170917124000.GB6289@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23097 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbdIRPST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2017 11:18:19 -0400
In-Reply-To: <20170917124000.GB6289@ming.t460p>
Content-Language: en-US
Content-ID: <2BEB1493B7CA53418C317D2CFF8AE3E0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gU3VuLCAyMDE3LTA5LTE3IGF0IDIwOjQwICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gImlm
IG5vIHJlcXVlc3QgaGFzIGNvbXBsZXRlZCBiZWZvcmUgdGhlIGRlbGF5IGhhcyBleHBpcmVkIiBj
YW4ndCBiZSBhDQo+IHJlYXNvbiB0byByZXJ1biB0aGUgcXVldWUsIGJlY2F1c2UgdGhlIHF1ZXVl
IGNhbiBzdGlsbCBiZSBidXN5Lg0KDQpUaGF0IHN0YXRlbWVudCBvZiB5b3Ugc2hvd3MgdGhhdCB0
aGVyZSBhcmUgaW1wb3J0YW50IGFzcGVjdHMgb2YgdGhlIFNDU0kNCmNvcmUgYW5kIGRtLW1wYXRo
IGRyaXZlciB0aGF0IHlvdSBkb24ndCB1bmRlcnN0YW5kLg0KDQo+IEkgc3VnZ2VzdCB0byB1bmRl
cnN0YW5kIHRoZSByb290IGNhdXNlLCBpbnN0ZWFkIG9mIGtlZXBpbmcgdGhpcw0KPiB1Z2x5IHJh
bmRvbSBkZWxheSBiZWNhdXNlIHJ1biBodyBxdWV1ZSBhZnRlciAxMDBtcyBtYXkgYmUgdXNlbGVz
cw0KPiBpbiA5OS45OSUgdGltZXMuDQoNCklmIHlvdSBhcmUgc3RpbGwgbG9va2luZyBhdCByZW1v
dmluZyB0aGUgYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZSgpIGNhbGxzDQp0aGVuIEkgdGhpbmsg
eW91IGFyZSBsb29raW5nIGluIHRoZSB3cm9uZyBkaXJlY3Rpb24uIFdoYXQga2luZCBvZiBwcm9i
bGVtDQphcmUgeW91IHRyeWluZyB0byBzb2x2ZT8gSXMgaXQgcGVyaGFwcyB0aGF0IHRoZXJlIGNh
biBiZSBhIGRlbGF5IGJldHdlZW4NCmRtLW1wYXRoIHJlcXVlc3QgY29tcGxldGlvbiBhbmQgdGhl
IHF1ZXVlaW5nIG9mIGEgbmV3IHJlcXVlc3Q/IElmIHNvLA0KYWRkaW5nIGEgcXVldWUgcnVuIGNh
bGwgaW50byB0aGUgZG0tbXBhdGggZW5kX2lvIGNhbGxiYWNrIGlzIHByb2JhYmx5DQpzdWZmaWNp
ZW50IGFuZCBwcm9iYWJseSBjYW4gcmVwbGFjZSB0aGlzIGVudGlyZSBwYXRjaCBzZXJpZXMuDQoN
CkJhcnQu
