From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Ensure that the SCSI error handler gets woken up
Date: Tue, 28 Nov 2017 15:33:45 +0000
Message-ID: <1511883224.2664.3.camel@wdc.com>
References: <4549fca5-5d83-2e0f-195f-4460d9febc5f@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63046 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdK1Pds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 10:33:48 -0500
In-Reply-To: <4549fca5-5d83-2e0f-195f-4460d9febc5f@virtuozzo.com>
Content-Language: en-US
Content-ID: <54CF1D4A43880D4DA872C44EBAE0B57C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gVHVlLCAyMDE3LTExLTI4IGF0IDEyOjA0ICswMzAwLCBQYXZlbCBUaWtob21pcm92IHdyb3Rl
Og0KPiAxLXN0LCBTdHVhcnQgLSB0aGFua3MgZm9yIGFkZGluZyBtZSB0byBDQywgMi1uZCBCYXJ0
IC0gbm8gaWRlYSB3aHkgeW91IA0KPiBkaWRuJ3Q/ID0pDQoNClRoYXQgbXVzdCBoYXZlIGJlZW4g
YW4gb3ZlcnNpZ2h0LiBTb3JyeSB0aGF0IEkgaGFkIG5vdCBhZGRlZCB5b3UgdG8gdGhlDQpDYy1s
aXN0LiBJIHdpbGwgYWRkIHlvdSB0byB0aGUgQ2MtbGlzdCB3aGVuIEkgcG9zdCB0aGUgbmV4dCB2
ZXJzaW9uIG9mIHRoaXMNCnBhdGNoLg0KDQo+IEkgZG9uJ3Qgc2VlIGFub3RoZXIgd2F5IHRvIGZp
eCB0aGVzZSBwcm9ibGVtLg0KDQpUaGF0IGRvZXNuJ3QgbWVhbiB0aGF0IHRoZXJlIGlzIG5vIG90
aGVyIHdheSA6LSkgSSBpbXBsZW1lbnRlZCBhbiBhbHRlcm5hdGl2ZQ0KYXBwcm9hY2ggeWVzdGVy
ZGF5IGFuZCBJIGhhdmUgc3RhcnRlZCB0ZXN0aW5nIGl0LiBJIHdpbGwgcG9zdCB0aGF0IHBhdGNo
IGFzDQpzb29uIGFzIG15IHRlc3RzIGhhdmUgZmluaXNoZWQuDQoNCkJhcnQu
