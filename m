From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Mon, 16 Oct 2017 16:06:32 +0000
Message-ID: <1508169991.2493.17.camel@wdc.com>
References: <20171012183704.22326-1-ming.lei@redhat.com>
         <20171012183704.22326-5-ming.lei@redhat.com>
         <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
         <20171013001919.GA24715@ming.t460p>
         <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
         <20171013160731.GA30899@ming.t460p> <1507912260.13345.0.camel@wdc.com>
         <20171013164519.GF30899@ming.t460p> <1507914527.13345.17.camel@wdc.com>
         <20171013172950.GA32319@ming.t460p>
         <515ca83f-5629-31e2-ef70-1869ae1b75ef@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19357 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdJPQGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 12:06:35 -0400
In-Reply-To: <515ca83f-5629-31e2-ef70-1869ae1b75ef@suse.de>
Content-Language: en-US
Content-ID: <54DC10A5C1C5F54EAAC0C863820E1187@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>

T24gTW9uLCAyMDE3LTEwLTE2IGF0IDEzOjMwICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIEZyaSwgT2N0IDEzLCAyMDE3IGF0IDA1OjA4OjUyUE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiAoK0hpbWFuc2h1IE1hZGhhbmkpDQo+ID4gDQo+ID4gSGltYW5zaHUs
IGRvIHlvdSBwZXJoYXBzIGtub3cgd2hldGhlciBpdCBpcyBzYWZlIHRvIGluY3JlYXNlIGNtZF9w
ZXJfbHVuIGZvcg0KPiA+IHRoZSBxbGEyeHh4IGluaXRpYXRvciBkcml2ZXIgdG8gdGhlIHNjc2lf
aG9zdC0+Y2FuX3F1ZXVlIHZhbHVlPw0KPiANCj4gJzMnIGlzIGp1c3QgYSBzdGFydGluZyBwb2lu
dDsgbGF0ZXIgb24gaXQnbGwgYmUgYWRqdXN0ZWQgdmlhIHNjc2lfY2hhbmdlX2RlcHRoKCkuDQo+
IExvb2tzIGxpa2UgaXQncyBub3Qgd29ya2luZyBjb3JyZWN0bHkgd2l0aCBibGstbXEsIHRob3Vn
aC4NCg0KSGVsbG8gSGFubmVzLA0KDQpJc24ndCB0aGUgcHVycG9zZSBvZiBzY3NpX2NoYW5nZV9x
dWV1ZV9kZXB0aCgpIHRvIGNoYW5nZSB0aGUgc2RldiBxdWV1ZV9kZXB0aA0Kb25seT8gQXMgZmFy
IGFzIEkga25vdyB0aGVyZSBpcyBvbmx5IG9uZSBhc3NpZ25tZW50IG9mIHNob3N0LT5jbWRfcGVy
X2x1biBpbg0KdGhlIFNDU0kgY29yZSBhbmQgdGhhdCdzIHRoZSBmb2xsb3dpbmcgYXNzaWdubWVu
dCBpbiBzY3NpX2hvc3RfYWxsb2MoKToNCg0KCXNob3N0LT5jbWRfcGVyX2x1biA9IHNodC0+Y21k
X3Blcl9sdW47DQoNCkJhcnQu
