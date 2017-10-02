From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V6 07/14] scsi: sd_zbc: Initialize device request queue
 zoned data
Date: Mon, 2 Oct 2017 16:57:24 +0000
Message-ID: <1506963443.3368.37.camel@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
         <20171002071535.8007-8-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:43251 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdJBQ52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 12:57:28 -0400
In-Reply-To: <20171002071535.8007-8-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <06536C5141710E45BEE4977F5A8594EC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTEwLTAyIGF0IDE2OjE1ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gSW5pdGlhbGl6ZSB0aGUgc2VxX3pvbmVfYml0bWFwIGFuZCBucl96b25lcyBmaWVsZHMgb2Yg
dGhlIGRpc2sgcmVxdWVzdA0KPiBxdWV1ZSBvbiBkaXNrIHJldmFsaWRhdGUuIEFzIHRoZSBzZXFf
em9uZV9iaXRtYXAgYWxsb2NhdGlvbiBpcw0KPiBpZGVudGljYWwgdG8gdGhlIGFsbG9jYXRpb24g
b2YgdGhlIHpvbmUgd3JpdGUgbG9jayBiaXRtYXAsIGludHJvZHVjZQ0KPiB0aGUgaGVscGVyIHNk
X3piY19hbGxvY196b25lX2JpdG1hcCgpLiBVc2luZyB0aGlzIGhlbHBlciwgd2FpdCBmb3IgdGhl
DQo+IGRpc2sgY2FwYWNpdHkgYW5kIG51bWJlciBvZiB6b25lcyB0byBzdGFiaWxpemUgb24gdGhl
IHNlY29uZA0KPiByZXZhbGlkYXRpb24gcGFzcyB0byBhbGxvY2F0ZSBhbmQgaW5pdGlhbGl6ZSB0
aGUgYml0bWFwcy4NCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8QmFydC5WYW5Bc3Nj
aGVAd2RjLmNvbT4=
