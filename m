From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 03/14] scsi: sd_zbc: Rearrange code
Date: Mon, 25 Sep 2017 21:02:28 +0000
Message-ID: <1506373347.2641.15.camel@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
         <20170925061454.5533-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54852 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934095AbdIYVCb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 17:02:31 -0400
In-Reply-To: <20170925061454.5533-4-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <4BB455498874F342B79946FA1ED6B267@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDE1OjE0ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gUmVhcnJhbmdlIHNkX3piY19zZXR1cCgpIHRvIGluY2x1ZGUgdXNlXzE2X2Zvcl9ydyBhbmQg
dXNlXzEwX2Zvcl9ydw0KPiBhc3NpZ25tZW50cyBhbmQgbW92ZSB0aGUgY2FsY3VsYXRpb24gb2Yg
c2RrcC0+em9uZV9zaGlmdCB0b2dldGhlcg0KPiB3aXRoIHRoZSBhc3NpZ25tZW50IG9mIHRoZSB2
ZXJpZmllZCB6b25lX2Jsb2NrcyB2YWx1ZSBpbg0KPiBzZF96YmNfY2hlY2tfem9uZV9zaXplKCku
DQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpcyBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2gu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMu
Y29tPg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQoNClJl
dmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPEJhcnQuVmFuQXNzY2hlQHdkYy5jb20+DQoNCg==
