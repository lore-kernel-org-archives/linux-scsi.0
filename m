From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 16:24:20 +0000
Message-ID: <1516724659.3339.7.camel@sandisk.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59224 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAWQYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 11:24:24 -0500
In-Reply-To: <20180123161613.14214-1-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <794A651350C10F4BAB4BF4AC195A0D68@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDAwOjE2ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQEAg
LTEyODAsMTAgKzEyODIsMTggQEAgYm9vbCBibGtfbXFfZGlzcGF0Y2hfcnFfbGlzdChzdHJ1Y3Qg
cmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGxpc3RfaGVhZCAqbGlzdCwNCj4gIAkJICogLSBTb21l
IGJ1dCBub3QgYWxsIGJsb2NrIGRyaXZlcnMgc3RvcCBhIHF1ZXVlIGJlZm9yZQ0KPiAgCQkgKiAg
IHJldHVybmluZyBCTEtfU1RTX1JFU09VUkNFLiBUd28gZXhjZXB0aW9ucyBhcmUgc2NzaS1tcQ0K
PiAgCQkgKiAgIGFuZCBkbS1ycS4NCj4gKwkJICoNCj4gKwkJICogSWYgZHJpdmVycyByZXR1cm4g
QkxLX1NUU19SRVNPVVJDRSBhbmQgU19TQ0hFRF9SRVNUQVJUDQo+ICsJCSAqIGJpdCBpcyBzZXQs
IHJ1biBxdWV1ZSBhZnRlciAxMG1zIGZvciBhdm9pZGluZyBJTyBoYW5nDQo+ICsJCSAqIGJlY2F1
c2UgdGhlIHF1ZXVlIG1heSBiZSBpZGxlIGFuZCB0aGUgUkVTVEFSVCBtZWNoYW5pc20NCj4gKwkJ
ICogY2FuJ3Qgd29yayBhbnkgbW9yZS4NCj4gIAkJICovDQo+IC0JCWlmICghYmxrX21xX3NjaGVk
X25lZWRzX3Jlc3RhcnQoaGN0eCkgfHwNCj4gKwkJbmVlZHNfcmVzdGFydCA9IGJsa19tcV9zY2hl
ZF9uZWVkc19yZXN0YXJ0KGhjdHgpOw0KPiArCQlpZiAoIW5lZWRzX3Jlc3RhcnQgfHwNCj4gIAkJ
ICAgIChub190YWcgJiYgbGlzdF9lbXB0eV9jYXJlZnVsKCZoY3R4LT5kaXNwYXRjaF93YWl0LmVu
dHJ5KSkpDQo+ICAJCQlibGtfbXFfcnVuX2h3X3F1ZXVlKGhjdHgsIHRydWUpOw0KPiArCQllbHNl
IGlmIChuZWVkc19yZXN0YXJ0ICYmIChyZXQgPT0gQkxLX1NUU19SRVNPVVJDRSkpDQo+ICsJCQli
bGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKGhjdHgsIDEwKTsNCj4gIAl9DQoNCk15IG9waW5pb24g
YWJvdXQgdGhpcyBwYXRjaCBpcyBhcyBmb2xsb3dzOg0KKiBDaGFuZ2luZyBhIGJsa19tcV9kZWxh
eV9ydW5faHdfcXVldWUoKSBjYWxsIGZvbGxvd2VkIGJ5IHJldHVybg0KICBCTEtfU1RTX0RFVl9S
RVNPVVJDRSBpbnRvIHJldHVybiBCTEtfU1RTX1JFU09VUkNFIGlzIHdyb25nIGJlY2F1c2UgaXQg
Y2hhbmdlcw0KICBhIGd1YXJhbnRlZWQgcXVldWUgcmVydW4gaW50byBhIHF1ZXVlIHJlcnVuIHRo
YXQgbWF5IG9yIG1heSBub3QgaGFwcGVuDQogIGRlcGVuZGluZyBvbiB3aGV0aGVyIG9yIG5vdCBt
dWx0aXBsZSBxdWV1ZSBydW5zIGhhcHBlbiBzaW11bHRhbmVvdXNseS4NCiogVGhpcyBjaGFuZ2Ug
bWFrZXMgYmxvY2sgZHJpdmVycyBsZXNzIHJlYWRhYmxlIGJlY2F1c2UgYW55b25lIHdobyBlbmNv
dW50ZXJzDQogIEJMS19TVFNfREVWX1JFU09VUkNFIHdpbGwgaGF2ZSB0byBsb29rIHVwIGl0cyBk
ZWZpbml0aW9uIHRvIGZpZ3VyZSBvdXQgd2hhdA0KICBpdCdzIG1lYW5pbmcgaXMuDQoqIFdlIGRv
bid0IG5lZWQgdGhlIG5ldyBzdGF0dXMgY29kZSBCTEtfU1RTX0RFVl9SRVNPVVJDRSBiZWNhdXNl
IGEgZGVsYXllZA0KICBxdWV1ZSBydW4gY2FuIGJlIGltcGxlbWVudGVkIGVhc2lseSB3aXRoIHRo
ZSBleGlzdGluZyBibG9jayBsYXllciBBUEkuDQoNCkJhcnQu
