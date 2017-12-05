From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Tue, 5 Dec 2017 17:51:11 +0000
Message-ID: <1512496270.2660.23.camel@wdc.com>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
         <20171205003809.1705-2-bart.vanassche@wdc.com>
         <20171205011536.GC8365@ming.t460p> <1512439190.2739.0.camel@wdc.com>
         <20171205050008.GA9989@ming.t460p> <1512490952.2660.18.camel@wdc.com>
         <20171205163824.GB23788@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:39559 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbdLERvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 12:51:16 -0500
In-Reply-To: <20171205163824.GB23788@ming.t460p>
Content-Language: en-US
Content-ID: <B9C1B3689CA37A4CB5F66AD6487CFF8C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

T24gV2VkLCAyMDE3LTEyLTA2IGF0IDAwOjM4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VHVlLCBEZWMgMDUsIDIwMTcgYXQgMDQ6MjI6MzNQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIFR1ZSwgMjAxNy0xMi0wNSBhdCAxMzowMCArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBObywgZG8gbm90IG1peCB0d28gZGlmZmVyZW50IHRoaW5ncyBpbiBvbmUgcGF0
Y2gsIGVzcGVjaWFsbHkgdGhlIGZpeCBwYXJ0DQo+ID4gPiBuZWVkIHRvIGJlIGJhY2twb3J0ZWQg
dG8gc3RhYmxlLg0KPiA+ID4gDQo+ID4gPiBUaGUgZml4IHBhcnQgc2hvdWxkIGFpbSBhdCBWNC4x
NSwgYW5kIHRoZSBvdGhlciBwYXJ0IGNhbiBiZSBhIFY0LjE2DQo+ID4gPiBzdHVmZi4NCj4gPiAN
Cj4gPiBEb2VzIHRoaXMgbWVhbiB0aGF0IHlvdSBkbyBub3QgcGxhbiB0byBwb3N0IGEgdjUgb2Yg
eW91ciBwYXRjaCBhbmQgdGhhdCB5b3UNCj4gPiB3YW50IG1lIHRvIHJld29yayB0aGlzIHBhdGNo
IHNlcmllcz8gSSBjYW4gZG8gdGhhdC4NCj4gDQo+IEkgYmVsaWV2ZSBWNCBoYXMgYmVlbiBPSyBm
b3IgbWVyZ2UsIGFjdHVhbGx5IHRoZSBvbmx5IGNvbmNlcm4gZnJvbSBKYW1lcw0KPiBpcyB0aGF0
ICdzZXQgdGhlIGNtbmQgdG8gTlVMTCAqYmVmb3JlKiBjYWxsaW5nIGZyZWUgc28gd2UgbmFycm93
IHRoZSByYWNlDQo+IHdpbmRvdy4nLCBidXQgdGhhdCBpc24ndCByZXF1aXJlZCBhcyBJIGV4cGxh
aW5lZCwgZXZlbiB0aG91Z2ggeW91IGRvbid0IGRvDQo+IHRoYXQgaW4gdGhpcyBwYXRjaCB0b28u
DQoNClRoZSBuZXh0IHZlcnNpb24gb2YgdGhpcyBwYXRjaCBzZXJpZXMgd2lsbCBpbmNsdWRlIHRo
ZSBzZCBkcml2ZXIgY2hhbmdlIHJlcXVlc3RlZA0KYnkgSmFtZXMuDQoNCkJhcnQu
