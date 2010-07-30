From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 2/6] scsi_dh : increment the refcounts while calling
 activate
Date: Fri, 30 Jul 2010 12:15:38 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D0663A34@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC422@cosmail01.lsi.com>
 <1280448520.4441.930.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:46447 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760118Ab0G3SPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 14:15:53 -0400
In-Reply-To: <1280448520.4441.930.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21h
aWx0bzpKYW1lcy5Cb3R0b21sZXlAc3VzZS5kZV0NCj4gU2VudDogVGh1cnNkYXksIEp1bHkgMjks
IDIwMTAgNzowOSBQTQ0KPiBUbzogTW9nZXIsIEJhYnUNCj4gQ2M6IGRldmljZS1tYXBwZXIgZGV2
ZWxvcG1lbnQ7IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBRaSwgWWFubGluZzsNCj4gQ2hh
dWhhbiwgVmlqYXk7IFN0YW5rZXksIFJvYmVydDsgRGFjaGVwYWxsaSwgU3VkaGlyDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggMi82XSBzY3NpX2RoIDogaW5jcmVtZW50IHRoZSByZWZjb3VudHMgd2hp
bGUNCj4gY2FsbGluZyBhY3RpdmF0ZQ0KPiANCj4gT24gV2VkLCAyMDEwLTA3LTI4IGF0IDE2OjU5
IC0wNjAwLCBNb2dlciwgQmFidSB3cm90ZToNCj4gPiBIb2xkIHRoZSByZWZjb3VudHMgZm9yIGRl
dmljZSBhbmQgc2NzaV9kaF9kYXRhIHdoaWxlIGNhbGxpbmcNCj4gaGFuZGxlcidzDQo+ID4gYWN0
aXZhdGUuIFRoaXMgd2lsbCBtYWtlIHN1cmUgdGhhdCBkZXZpY2VzIGFuZCBzY3NpX2RoX2RhdGEg
YXJlIG5vdA0KPiA+IHJlbW92ZWQgd2hpbGUgYWN0aXZhdGUgaXMgc3RpbGwgaW4gcHJvZ3Jlc3Mu
IE1ha2Ugc3VyZSB0byBjYWxsDQo+ID4gcHV0X2RldmljZSBhbmQga3JlZl9wdXQgaW4gdGhlIGhh
bmRsZXIgYWZ0ZXIgYWN0aXZhdGUgaXMgY29tcGxldGUuDQo+IA0KPiBUaGlzIGlzIGEgY29tcGxl
dGUgbm8tbm8uICBZb3UgY2FuJ3QgdGFrZSB1bnJlbGVhc2VkIHJlZmVyZW5jZXMgaW4gYQ0KPiBz
aW5nbGUgcGF0Y2guICBJIGtub3cgdGhlIHJlbGVhc2VzIGNvbWUgaW4gc3Vic2VxdWVudCBwYXRj
aGVzLCBidXQNCj4gdGhhdCdzIG5vdCB0aGUgd2F5IHRvIGRvIGl0LiAgWW91IGhhdmUgdG8gaGF2
ZSBhbiBhdG9taWMgY2hhbmdlIChhcyBpbg0KPiBhbGwgcmVmY291bnRzIG11c3QgYmFsYW5jZSBv
biBlaXRoZXIgc2lkZSBvZiB0aGUgcGF0Y2gpLiAgSWYgc29tZW9uZQ0KPiBiaXNlY3RlZCBpbnRv
IHRoaXMsIGl0IHdvdWxkIGxpa2VseSBuZXZlciByZWxlYXNlIHN0dWZmIC4uLiB3aGljaCBjb3Vs
ZA0KPiBsZWFkIHRvIHNvbWUgdW5uZWNlc3NhcnkgZGVidWdnaW5nLg0KDQogIFllcy4uIFVuZGVy
c3Rvb2QuIFN0aWxsIGludmVzdGlnYXRpbmcgdG8gc2VlIGlmIEkgY291bGQgYXZvaWQgdGhpcy4u
DQogDQo+IEphbWVzDQo+IA0KDQo=
