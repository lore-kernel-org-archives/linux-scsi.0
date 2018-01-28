From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sun, 28 Jan 2018 00:54:38 +0000
Message-ID: <1517100877.3055.23.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
         <1516726653.3339.20.camel@wdc.com> <20180124033109.GA15945@ming.t460p>
         <20180127190920.GA24759@redhat.com> <1517091161.3055.7.camel@wdc.com>
         <20180128002356.GA25933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38540 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752864AbeA1Aym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jan 2018 19:54:42 -0500
In-Reply-To: <20180128002356.GA25933@redhat.com>
Content-Language: en-US
Content-ID: <4198532207BA4343B5EAC3B40CF70397@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDE5OjIzIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IFlvdXIgY29udHJpYnV0aW9ucyBkbyBfbm90XyBtYWtlIHVwIGZvciB5b3VyIGluYWJpbGl0eSB0
byB3b3JrIHdlbGwgd2l0aA0KPiBvdGhlcnMuICBUaXJlc29tZSBkb2Vzbid0IGJlZ2luIHRvIGRl
c2NyaWJlIHRoZXNlIGludGVyYWN0aW9ucy4NCj4gDQo+IExpZmUgaXMgdG9vIHNob3J0IHRvIGNv
bnRpbnVlIGVuZHVyaW5nIHlvdXIgYnVsbHNoaXQuDQo+IA0KPiBCdXQgZG8gbGV0IHVzIGtub3cg
d2hlbiB5b3UgaGF2ZSBzb21ldGhpbmcgb2Ygc3Vic3RhbmNlIHRvIGNvbnRyaWJ1dGUNCj4gKGhp
bnQ6IGNvZGUgdGFsa3MpLg0KDQpTb3JyeSBNaWtlIGJ1dCB3aGF0IHlvdSB3cm90ZSBhYm92ZSBp
cyBub3Qgb25seSB2ZXJ5IGdyb3NzIGJ1dCBpdCBpcyBhbHNvDQp3cm9uZy4gV2hhdCBJIGRpZCBp
biBteSBlLW1haWwgaXMgdG8gaWRlbnRpZnkgdGVjaG5pY2FsIHByb2JsZW1zIGluIE1pbmcncw0K
d29yay4gQWRkaXRpb25hbGx5LCBpdCBzZWVtcyBsaWtlIHlvdSBmb3Jnb3QgdGhhdCByZWNlbnRs
eSBJIGhlbHBlZCBNaW5nPw0KTXkgcGF0Y2ggImJsay1tcTogQXZvaWQgdGhhdCBibGtfbXFfZGVs
YXlfcnVuX2h3X3F1ZXVlKCkgaW50cm9kdWNlcw0KdW5pbnRlbmRlZCBkZWxheXMiIGhhcyBiZWVu
IHF1ZXVlZCBieSBKZW5zIGZvciBrZXJuZWwgdjQuMTYgYW5kIHNvbHZlcyBhDQpwcm9ibGVtIHRo
YXQgTWluZyBoYXMgYmVlbiB3b3JraW5nIG9uIGZvciB0d28gbW9udGhzIGJ1dCB0aGF0IGhlIHdh
cw0KdW5hYmxlIHRvIGNvbWUgdXAgd2l0aCBhIHByb3BlciBmaXggZm9yLiBBZGRpdGlvbmFsbHks
IHRoZXJlIGlzIHNvbWV0aGluZw0KdGhhdCB5b3UgaGF2ZSB0byBleHBsYWluOiB0aGUgcGF0Y2gg
ImRtIG1wYXRoOiBkb24ndCBjYWxsDQpibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkgaW4gY2Fz
ZSBvZiBCTEtfU1RTX1JFU09VUkNFIiB0aGF0IHlvdSBoYXZlDQpxdWV1ZWQgaW4geW91ciB0cmVl
IGlzIHdyb25nIGFuZCBpbnRyb2R1Y2VzIGEgcmVncmVzc2lvbg0KKGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NuaXR6ZXIvbGludXguZ2l0L2NvbW1pdC8/
aD1kbS00LjE2JmlkPTMxNmE3OTVhZDM4OGUwYzNjYTYxMzQ1NDg1MWEyODA3OWQ5MTdhOTIpLg0K
SSdtIHN1cnByaXNlZCB0aGF0IHlvdSBoYXZlIG5vdCB5ZXQgcmV2ZXJ0ZWQgdGhhdCBwYXRjaD8g
QlRXLCBpbiBjYXNlIHlvdQ0Kd291bGQgbm90IHlldCBoYXZlIG5vdGljZWQgbXkgcGF0Y2ggImJs
ay1tcTogQXZvaWQgdGhhdA0KYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZSgpIGludHJvZHVjZXMg
dW5pbnRlbmRlZCBkZWxheXMiIGVsaW1pbmF0ZXMgdGhlDQpkZWxheSB5b3UgcmVmZXJyZWQgdG8g
aW4gdGhlIGRlc2NyaXB0aW9uIG9mIHRoYXQgcGF0Y2guDQoNCkluIGNhc2UgdGhlIGFib3ZlIHdv
dWxkIG5vdCB5ZXQgaGF2ZSBhZGRyZXNzZWQgdGhlIHRlY2huaWNhbCBpc3N1ZShzKSB5b3UNCmFy
ZSBmYWNpbmcsIEkgd291bGQgcmVhbGx5IGFwcHJlY2lhdGUgaXQgaWYgeW91IHdvdWxkIHN0b3Ag
dXNpbmcgaW5zdWx0cyBhbmQNCmlmIHlvdSBjb3VsZCBleHBsYWluIHdoYXQgdGVjaG5pY2FsIHBy
b2JsZW1zIHlvdSBhcmUgZmFjaW5nLiBJc24ndCB0aGF0IHdoYXQNCnRoZSBMaW51eCBrZXJuZWwg
aXMgYWJvdXQsIG5hbWVseSBhYm91dCBjb2xsYWJvcmF0aW9uIGJldHdlZW4gdGVjaG5pY2FsDQpw
ZW9wbGUgZnJvbSBkaWZmZXJlbnQgb3JnYW5pemF0aW9ucz8gSXNuJ3QgdGhhdCB3aGF0IG1hZGUg
dGhlIExpbnV4IGtlcm5lbA0KZ3JlYXQ/DQoNCkJhcnQu
