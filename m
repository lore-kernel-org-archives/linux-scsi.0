From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 01:11:22 +0000
Message-ID: <1517274681.2687.68.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
         <1516726653.3339.20.camel@wdc.com> <20180124033109.GA15945@ming.t460p>
         <20180127190920.GA24759@redhat.com> <1517091161.3055.7.camel@wdc.com>
         <20180127234151.GA21710@ming.t460p> <1517244510.2687.10.camel@wdc.com>
         <20180130010701.GC17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4590 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbeA3BL2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 20:11:28 -0500
In-Reply-To: <20180130010701.GC17176@ming.t460p>
Content-Language: en-US
Content-ID: <921CD6628F535F4994D90070E1A22F5B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDA5OjA3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
TW9uLCBKYW4gMjksIDIwMTggYXQgMDQ6NDg6MzFQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IC0gSXQgaXMgZWFzeSB0byBmaXggdGhpcyByYWNlIGluc2lkZSB0aGUgYmxvY2sg
bGF5ZXIsIG5hbWVseSBieSB1c2luZw0KPiA+ICAgY2FsbF9yY3UoKSBpbnNpZGUgdGhlIGJsa19t
cV9kZWxheV9ydW5faHdfcXVldWUoKSBpbXBsZW1lbnRhdGlvbiB0bw0KPiA+ICAgcG9zdHBvbmUg
dGhlIHF1ZXVlIHJlcnVubmluZyB1bnRpbCBhZnRlciB0aGUgcmVxdWVzdCBoYXMgYmVlbiBhZGRl
ZCBiYWNrIHRvDQo+ID4gICB0aGUgZGlzcGF0Y2ggbGlzdC4NCj4gDQo+IEl0IGlzIGp1c3QgZWFz
eSB0byBzYXksIGNhbiB5b3UgY29vayBhIHBhdGNoIGFuZCBmaXggYWxsIGRyaXZlcnMgZmlyc3Q/
DQoNClBsZWFzZSByZXJlYWQgd2hhdCBJIHdyb3RlLiBJIHByb3Bvc2VkIHRvIGNoYW5nZSB0aGUg
YmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZSgpDQpJTVBMRU1FTlRBVElPTiBzdWNoIHRoYXQgdGhl
IGNhbGxlcnMgZG8gbm90IGhhdmUgdG8gYmUgbW9kaWZpZWQuDQoNCj4gWyAuLi4gXSBMYXRlciwg
eW91IGFkbWl0dGVkIHlvdSB1bmRlcnN0b29kIHRoZSBwYXRjaCB3cm9uZy4gWyAuLi4gXQ0KDQpU
aGF0J3Mgbm9uc2Vuc2UuIEkgbmV2ZXIgd3JvdGUgdGhhdC4NCg0KQmFydC4=
