From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Thu, 10 Aug 2017 15:35:42 +0000
Message-ID: <1502379340.2309.6.camel@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
         <1502204867.2250.1.camel@wdc.com>
         <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
         <cea78872-8e58-549d-87fc-2897e640c31c@wdc.com>
         <1502251037.2784.2.camel@wdc.com>
         <122fbf61-0de5-fa7e-2024-a0763ad70b13@wdc.com>
         <1502252111.2784.4.camel@wdc.com>
         <0e79dcda-29d8-58e3-ed20-b7b6e8db4b10@wdc.com>
         <1502292282.2356.3.camel@wdc.com>
         <466a3303-a4e4-8998-4d52-91ce6e925992@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:25981 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdHJPga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 11:36:30 -0400
In-Reply-To: <466a3303-a4e4-8998-4d52-91ce6e925992@wdc.com>
Content-Language: en-US
Content-ID: <7F944F4ED448B54E82E22B5FA66A3033@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

T24gVGh1LCAyMDE3LTA4LTEwIGF0IDExOjE0ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gSSBhbSBjdXJyZW50bHkgdHJ5aW5nIGRpZmZlcmVudCBhcHByb2FjaGVzIGZvciB0aGlzLiBJ
biB0aGUgbWVhbiB0aW1lLCBJDQo+IHdvdWxkIGxpa2UgdG8gc2VlIHRoZSB1bmxvY2sgY2hhbmdl
IHBhdGNoIGJlIGFwcGxpZWQgdG8gZml4IHRoZSBkZWFkbG9jaw0KPiBwcm9ibGVtLg0KDQpIZWxs
byBEYW1pZW4sDQoNClRoYXQgYXBwcm9hY2ggc291bmRzIGZpbmUgdG8gbWUuDQoNCkJhcnQu
