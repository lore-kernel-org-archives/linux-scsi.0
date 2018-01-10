From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 2/4] block: Introduce blk_wait_if_quiesced() and
 blk_finish_wait_if_quiesced()
Date: Wed, 10 Jan 2018 00:23:33 +0000
Message-ID: <1515543812.2721.35.camel@wdc.com>
References: <20180108185011.30018-1-bart.vanassche@wdc.com>
         <20180108185011.30018-3-bart.vanassche@wdc.com>
         <8dbe62ad-be38-a35d-df3e-b6f5486292ab@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8dbe62ad-be38-a35d-df3e-b6f5486292ab-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-US
Content-ID: <FFF523D3B7B6B6408ECC0131D9A0D865-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hare-l3A5Bk7waGM@public.gmane.org" <hare-l3A5Bk7waGM@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTA5IGF0IDA3OjQxICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEknbSBhbHdheXMgYSBiaXQgY2F1dGlvdXMgd2hlbiBoYXZpbmcgcmN1X3JlYWRfbG9jaygp
IGFuZA0KPiByY3VfcmVhZF91bmxvY2soKSBpbiB0d28gc2VwYXJhdGUgZnVuY3Rpb25zLg0KPiBD
YW4gd2UgbWFrZSB0aGlzIGRlcGVuZGVuY3kgbW9yZSBleHBsaWNpdCBieSByZW5hbWluZyB0aGUg
Zmlyc3QgZnVuY3Rpb24NCj4gdG8gYmxrX3N0YXJ0X3dhaXRfaWZfcXVpZXNjZWQoKSBhbmQgdXBk
YXRpbmcgdGhlIGNvbW1lbnQgdG8gdGhlIGVmZmVjdA0KPiB0aGF0IGJvdGggZnVuY3Rpb25zIG11
c3QgYmUgdXNlZCBpbiB0YW5kZW0/DQoNCkhlbGxvIEhhbm5lcywNCg0KVGhhdCBzb3VuZHMgbGlr
ZSBhIGdvb2QgaWRlYSB0byBtZS4gSSB3aWxsIG1ha2UgdGhlc2UgY2hhbmdlcyBhbmQgcmVwb3N0
IHRoaXMNCnBhdGNoIHNlcmllcy4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
