From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Wed, 10 Sep 2014 15:06:48 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C70F51@G9W0745.americas.hpqcorp.net>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com>
 <540F22A2.3040906@redhat.com>
 <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:15425 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIJPHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 11:07:50 -0400
In-Reply-To: <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "aradford@gmail.com" <aradford@gmail.com>, Michal Schmidt <mschmidt@redhat.com>, "amirv@mellanox.com" <amirv@mellanox.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>, "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>

PiBGcm9tOiBsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXNj
c2ktDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIFN1bWl0IFNheGVuYQ0K
PiANCj4gPkZyb206IFRvbWFzIEhlbnpsIFttYWlsdG86dGhlbnpsQHJlZGhhdC5jb21dDQo+ID4N
Cj4gPldpdGggc2V2ZXJhbCBjb250cm9sbGVycyBpbiBhIHN5c3RlbSB0aGlzIG1heSB0YWtlIGEg
bG90IG1lbW9yeSwNCj4gPiBjb3VsZCB5b3UgYWxzbyBpbiBjYXNlIHdoZW4gYSBrZHVtcCBrZXJu
ZWwgaXMgcnVubmluZyBsb3dlciBpdCwNCj4gPiBieSBub3QgdXNpbmcgdGhpcyBmZWF0dXJlPw0K
PiA+DQo+IEFncmVlZCwgd2Ugd2lsbCBkaXNhYmxlIHRoaXMgZmVhdHVyZSBmb3Iga2R1bXAga2Vy
bmVsIGJ5IGFkZGluZw0KPiAicmVzZXRfZGV2aWNlcyIgZ2xvYmFsIHZhcmFpYWJsZS4NCj4gVGhh
dCBjaGVjayBpcyByZXF1aXJlZCBmb3Igb25seSBvbmUgcGxhY2UsIHRocm91Z2hvdXQgdGhlIGNv
ZGUsIHRoaXMNCj4gZmVhdHVyZSB3aWxsIHJlbWFpbiBkaXNhYmxlZC4gIENvZGUgc25pcHBldCBm
b3IgdGhlIHNhbWUtDQo+IA0KPiAgICAgICAgIGluc3RhbmNlLT5jcmFzaF9kdW1wX2Rydl9zdXBw
b3J0ID0gKCFyZXNldF9kZXZpY2VzKSAmJg0KPiBjcmFzaGR1bXBfZW5hYmxlICYmDQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgaW5zdGFuY2UtPmNyYXNoX2R1bXBfZndfc3VwcG9y
dCAmJg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGluc3RhbmNlLT5jcmFzaF9k
dW1wX2J1Zik7DQo+ICAgICAgICAgaWYoaW5zdGFuY2UtPmNyYXNoX2R1bXBfZHJ2X3N1cHBvcnQp
IHsNCj4gICAgICAgICAgICAgICAgIHByaW50ayhLRVJOX0lORk8gIm1lZ2FyYWlkX3NhczogRlcg
Q3Jhc2ggZHVtcCBpcw0KPiBzdXBwb3J0ZWRcbiIpOw0KPiAgICAgICAgICAgICAgICAgbWVnYXNh
c19zZXRfY3Jhc2hfZHVtcF9wYXJhbXMoaW5zdGFuY2UsDQo+IE1SX0NSQVNIX0JVRl9UVVJOX09G
Rik7DQo+IA0KPiAgICAgICAgIH0gZWxzZSB7DQo+IC4uDQo+ICAgICAgICAgfQ0KDQpOZXR3b3Jr
IGRyaXZlcnMgaGF2ZSBiZWVuIHJ1bm5pbmcgaW50byBzaW1pbGFyIHByb2JsZW1zLg0KDQpUaGVy
ZSdzIGEgbmV3IHBhdGNoIGZyb20gQW1pciBjb21pbmcgdGhyb3VnaCBuZXQtbmV4dCB0byBtYWtl
IA0KaXNfa2R1bXBfa2VybmVsKCkgKGluIGNyYXNoX2R1bXAuaCkgYWNjZXNzaWJsZSB0byBtb2R1
bGVzLg0KVGhhdCBtYXkgYmUgYSBiZXR0ZXIgc2lnbmFsIHRoYW4gcmVzZXRfZGV2aWNlcyB0aGF0
IHRoZQ0KZHJpdmVyIHNob3VsZCB1c2UgbWluaW1hbCByZXNvdXJjZXMuDQoNCmh0dHA6Ly9jb21t
ZW50cy5nbWFuZS5vcmcvZ21hbmUubGludXgubmV0d29yay8zMjQ3MzcNCg0KSSdtIG5vdCBzdXJl
IGFib3V0IHRoZSBsb2dpc3RpY3Mgb2YgYSBTQ1NJIHBhdGNoIGRlcGVuZGluZw0Kb24gYSBuZXQt
bmV4dCBwYXRjaC4NCg0KLS0tDQpSb2IgRWxsaW90dCAgICBIUCBTZXJ2ZXIgU3RvcmFnZQ0KDQoN
Cg0KDQo=
