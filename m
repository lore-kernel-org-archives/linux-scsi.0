From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Thu, 17 Aug 2017 15:01:51 +0000
Message-ID: <1502982108.2615.1.camel@wdc.com>
References: <20170817024550.9845-1-damien.lemoal@wdc.com>
         <20170817075916.GA28379@infradead.org>
         <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:32677 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdHQPCe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 11:02:34 -0400
In-Reply-To: <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com>
Content-Language: en-US
Content-ID: <072C179519D47148B95C49CC67000633@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

T24gVGh1LCAyMDE3LTA4LTE3IGF0IDIxOjE5ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gOC8xNy8xNyAxNjo1OSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+ID4gT24gVGh1
LCBBdWcgMTcsIDIwMTcgYXQgMTE6NDU6NTBBTSArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6
DQo+ID4gPiBibGstbXEgbWF5IG5vdCBtYWludGFpbiB3cml0ZSByZXF1ZXN0cyBvcmRlciBhdCBk
aXNwYXRjaCB0aW1lLiBTbyBob3N0DQo+ID4gPiBtYW5hZ2VkIGRyaXZlcyB3aWxsIG5vdCByZWxp
YWJseSB3b3JrLiBXb3JzZSwgcG90ZW50aWFsIHJlb3JkZXJpbmcgb2YNCj4gPiA+IHdyaXRlIHJl
cXVlc3RzIG9uIHJlcXVldWUgbWF5IGNhdXNlIHRoZSB6b25lIHdyaXRlIGxvY2tpbmcgY29kZSB0
bw0KPiA+ID4gZGVhZGxvY2sgY29tbWFuZCBkaXNwYXRjaCB0byB0aGUgZGlzay4gU28gZm9yIG5v
dywgdW50aWwgdGhlIHdyaXRlDQo+ID4gPiBvcmRlcmluZyBpc3N1ZSBpcyBmaXhlZCwgZG8gbm90
IHN1cHBvcnQgem9uZWQgYmxvY2sgZGV2aWNlcyB3aXRoDQo+ID4gPiBzY3NpLW1xIGJ5IHNob3dp
bmcgYSAwIExCQSBjYXBhY2l0eSBkaXNrLg0KPiA+IA0KPiA+IE5BSy4gIFBsZWFzZSBmaXggdGhl
IGlzc3VlIGluc3RlYWQgb2YgdGhpcy4NCj4gDQo+IEkgZG8gaGF2ZSBhIGZpeCByZWFkeSB0byBz
ZW5kLiBBbGwgdGhlIGZpeGVzIGFyZSBhdCBibGstbXEgbGV2ZWwgYW5kDQo+IGJhc2ljYWxseSBl
bnN1cmUgdGhhdCBkaXNwYXRjaCBmcm9tIHRoZSBoY3R4LT5kaXNwYXRjaCBsaXN0IGFyZSBpbiBv
cmRlcg0KPiBmb3Igd3JpdGUgY29tbWFuZHMgKHJlZ3VsYXIgd3JpdGVzLCB3cml0ZSBzYW1lIGFu
ZCB3cml0ZSB6ZXJvZXMpLg0KPiBJdCBpcyB3ZWxsIHRlc3RlZCBhbmQgYXQgbGVhc3QgZml4ZXMg
YWxsIHRoZSBwcm9ibGVtcyBJIGhhdmUgc2VlbiB3aXRoDQo+IGRtLXpvbmVkIGFuZCBmMmZzLg0K
DQpIZWxsbyBEYW1pZW4sDQoNCkFub3RoZXIgcG9zc2libGUgYXBwcm9hY2ggaXMgdG8gZml4IHRo
ZSBpcHIgZHJpdmVyIGFuZCB0byByZXN1Ym1pdCB0aGUNCiJzY3NpLW1xOiBBbHdheXMgdW5wcmVw
YXJlIGJlZm9yZSByZXF1ZXVpbmcgYSByZXF1ZXN0IiBhbmQgInNjc2k6IHNkX3piYzoNCldyaXRl
IHVubG9jayB6b25lIGZyb20gc2RfdW5pbml0X2NtbmQoKSIgcGF0Y2hlcy4NCg0KQmFydC4=
