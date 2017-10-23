From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Suppress a kernel warning in case the prep function
 returns BLKPREP_DEFER
Date: Mon, 23 Oct 2017 06:00:13 +0000
Message-ID: <1508738411.2634.1.camel@wdc.com>
References: <20171020184645.4327-1-bart.vanassche@wdc.com>
         <1510de1e-3f52-fa51-8a88-b5e9fc73b15e@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36713 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdJWGAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 02:00:30 -0400
In-Reply-To: <1510de1e-3f52-fa51-8a88-b5e9fc73b15e@wdc.com>
Content-Language: en-US
Content-ID: <7383A1E4D890E642889F33EF0B728131@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gTW9uLCAyMDE3LTEwLTIzIGF0IDA3OjQ1ICswMjAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gMTAvMjAvMTcgMjA6NDYsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBbIC4uLiBd
DQo+ID4gVGhpcyBwYXRjaCBhdm9pZHMgdGhhdCB0aGUgZm9sbG93aW5nIHdhcm5pbmcgaXMgdHJp
Z2dlcmVkIHdoZW4gdXNpbmcNCj4gPiB0aGUgbGVnYWN5IGJsb2NrIGxheWVyOg0KPiA+IFsgLi4u
IF0NCj4gDQo+IFJldmlld2VkLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMu
Y29tPg0KDQpNYXJ0aW4sIGlmIG90aGVycyBhZ3JlZSB3aXRoIHRoaXMgcGF0Y2gsIGNhbiBpdCBi
ZSBxdWV1ZWQgZm9yIGtlcm5lbCB2NC4xND8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
