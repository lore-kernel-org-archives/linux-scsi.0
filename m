From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 15:52:37 +0000
Message-ID: <1505836356.2671.21.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-2-ming.lei@redhat.com>
         <1505498249.3420.15.camel@wdc.com> <20170917124000.GB6289@ming.t460p>
         <1505747894.2685.6.camel@wdc.com> <20170919054308.GA2517@ming.t460p>
         <20170919154823.GA22809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15346 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdISPwm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 11:52:42 -0400
In-Reply-To: <20170919154823.GA22809@redhat.com>
Content-Language: en-US
Content-ID: <25B5CE69171FD7468AA8059F64742797@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gVHVlLCAyMDE3LTA5LTE5IGF0IDExOjQ4IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IFRoaXMgdGhyZWFkIHByb3ZlcyB0aGF0IGl0IGlzIGRlZmluaXRlbHkgYnJpdHRsZSB0byBiZSBy
ZWx5aW5nIG9uIGZpeGVkDQo+IGRlbGF5cyBsaWtlIHRoaXM6DQo+IGh0dHBzOi8vcGF0Y2h3b3Jr
Lmtlcm5lbC5vcmcvcGF0Y2gvOTcwMzI0OS8NCg0KSGVsbG8gTWlrZSwNCg0KU29ycnkgYnV0IEkg
dGhpbmsgdGhhdCdzIGEgbWlzaW50ZXJwcmV0YXRpb24gb2YgbXkgcGF0Y2guIEkgY2FtZSB1cCB3
aXRoIHRoYXQNCnBhdGNoIGJlZm9yZSBJIGhhZCBmb3VuZCBhbmQgZml4ZWQgdGhlIHJvb3QgY2F1
c2Ugb2YgdGhlIGhpZ2ggc3lzdGVtIGxvYWQuDQpUaGVzZSBmaXhlcyBhcmUgdXBzdHJlYW0gKGtl
cm5lbCB2NC4xMykgd2hpY2ggbWVhbnMgdGhhdCB0aGF0IHBhdGNoIGlzIG5vdw0Kb2Jzb2xldGUu
DQoNCkJhcnQu
