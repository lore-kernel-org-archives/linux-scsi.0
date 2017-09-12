From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 1/2] scsi: sd: Fix sd_config_write_same()
Date: Tue, 12 Sep 2017 23:13:08 +0000
Message-ID: <1505257987.2537.37.camel@wdc.com>
References: <20170905115536.2896-1-damien.lemoal@wdc.com>
         <20170905115536.2896-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23141 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdILXN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2017 19:13:59 -0400
In-Reply-To: <20170905115536.2896-2-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <3FFB15B1FEB2F8489A9AC3A724A92827@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>

T24gVHVlLCAyMDE3LTA5LTA1IGF0IDIwOjU1ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gUmVwb3J0aW5nIGEgbWF4aW11bSBudW1iZXIgb2YgYmxvY2tzIHRoYXQgaXMgbm90IGFsaWdu
ZWQgb24gdGhlIGRldmljZQ0KPiBwaHlzaWNhbCBzaXplIHdvdWxkIGNhdXNlIGEgbGFyZ2Ugd3Jp
dGUgc2FtZSByZXF1ZXN0IHRvIGJlIHNwbGl0IGludG8NCj4gcGh5c2ljYWxseSB1bmFsaWduZWQg
Y2h1bmtzIGJ5IF9fYmxrZGV2X2lzc3VlX3dyaXRlX3plcm9lcygpIGFuZA0KPiBfX2Jsa2Rldl9p
c3N1ZV93cml0ZV9zYW1lKCksIGV2ZW4gaWYgdGhlIGNhbGxlciBvZiB0aGVzZSBmdW5jdGlvbnMg
dG9vaw0KPiBjYXJlIHRvIGFsaWduIGl0cyByZXF1ZXN0IHRvIHBoeXNpY2FsIHNlY3RvcnMuDQo+
IA0KPiBTbyBtYWtlIHN1cmUgdGhlIG1heGltdW0gcmVwb3J0ZWQgaXMgYWxpZ25lZCB0byB0aGUg
ZGV2aWNlIHBoeXNpY2FsDQo+IGJsb2NrIHNpemUuIFRoaXMgaXMgb25seSBhbiBvcHRpb25hbCBv
cHRpbWl6YXRpb24gZm9yIHJlZ3VsYXIgZGlza3MsDQo+IGJ1dCB0aGlzIGlzIG1hbmRhdG9yeSB0
byBhdm9pZCBmYWlsdXJlIG9mIGxhcmdlIHdyaXRlIHNhbWUgcmVxdWVzdHMNCj4gZGlyZWN0ZWQg
YXQgc2VxdWVudGlhbCB3cml0ZSByZXF1aXJlZCB6b25lcyBvZiBob3N0LW1hbmFnZWQgWkJDIGRp
c2tzLg0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMu
Y29tPg==
