From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 01/12] block: Fix declaration of blk-mq debugfs
 functions
Date: Fri, 15 Sep 2017 14:33:17 +0000
Message-ID: <1505485996.2852.4.camel@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
         <20170915100645.17999-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48925 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdIOOeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 10:34:05 -0400
In-Reply-To: <20170915100645.17999-2-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <BEEF95C3CF385A45ACF0D456381105E4@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE5OjA2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gX19ibGtfbXFfZGVidWdmc19ycV9zaG93KCkgYW5kIGJsa19tcV9kZWJ1Z2ZzX3JxX3Nob3co
KSBhcmUgZXhwb3J0ZWQNCj4gc3ltYm9scyBidXQgYXIgZW9ubHkgZGVjbGFyZWQgaW4gdGhlIGJs
b2NrIGludGVybmFsIGZpbGUNCiAgICAgICAgICAgICAgXl5eXl5eXl4NCiAgICAgICAgICAgICAg
YXJlIG9ubHk/DQo+IGJsb2NrL2Jsay1tcS1kZWJ1Z2ZzLmguIHdoaWNoIGlzIG5vdCBjbGVhbmx5
IGFjY2Vzc2libGUgdG8gZmlsZXMgb3V0c2lkZQ0KPiBvZiB0aGUgYmxvY2sgZGlyZWN0b3J5Lg0K
PiBNb3ZlIHRoZSBkZWNsYXJhdGlvbiBvZiB0aGVzZSBmdW5jdGlvbnMgdG8gdGhlIG5ldyBmaWxl
DQo+IGluY2x1ZGUvbGludXgvYmxrLW1xLWRlYnVnZnMuaCBmaWxlIHRvIG1ha2UgdGhlIGRlY2xh
cmF0aW9ucyBjbGVhbmx5DQo+IGF2YWlsYWJsZSB0byBvdGhlciBtb2R1bGVzLg0KPiANCj4gV2hp
bGUgYXQgaXQsIGFsc28gbW92ZSB0aGUgZGVmaW5pdGlvbiBvZiB0aGUgYmxrX21xX2RlYnVnZnNf
YXR0cg0KPiBzdHJ1Y3R1cmUgdG8gYWxsb3cgc2NoZWR1bGVyIG1vZHVsZXMgb3V0c2lkZSBvZiB0
aGUgYmxvY2sgZGlyZWN0b3J5IHRvDQo+IGRlZmluZSBkZWJ1Z2ZzIGF0dHJpYnV0ZXMuDQoNClRo
ZSB0aXRsZSBvZiB0aGlzIHBhdGNoIGlzICJGaXggZGVjbGFyYXRpb24gb2YgLi4uIi4gU2hvdWxk
IHRoZSB0aXRsZSBwZXJoYXBzDQpoYXZlIGJlZW4gIk1vdmUgZGVjbGFyYXRpb25zIG9mIC4uLiI/
DQoNCkFueXdheToNCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3Nj
aGVAd2RjLmNvbT4NCg0K
