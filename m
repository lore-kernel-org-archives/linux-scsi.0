From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [patch] [SCSI] scsi_dh: potential null dereference in
 scsi_dh_activate()
Date: Tue, 4 Jan 2011 12:50:33 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F5583074@cosmail01.lsi.com>
References: <20110103054833.GT1886@bicker>
	 <E463DF2B2E584B4A82673F53D62C2EF4F5582F42@cosmail01.lsi.com>
 <1294158279.4726.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:42228 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab1ADTt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 14:49:56 -0500
In-Reply-To: <1294158279.4726.17.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Menny Hamburger <Menny_Hamburger@Dell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEphbWVzIEJvdHRvbWxleSBb
bWFpbHRvOkphbWVzLkJvdHRvbWxleUBzdXNlLmRlXQ0KPiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5
IDA0LCAyMDExIDEwOjI1IEFNDQo+IFRvOiBNb2dlciwgQmFidQ0KPiBDYzogRGFuIENhcnBlbnRl
cjsgTWlrZSBTbml0emVyOyBNZW5ueSBIYW1idXJnZXI7IGxpbnV4LQ0KPiBzY3NpQHZnZXIua2Vy
bmVsLm9yZzsga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTog
W3BhdGNoXSBbU0NTSV0gc2NzaV9kaDogcG90ZW50aWFsIG51bGwgZGVyZWZlcmVuY2UgaW4NCj4g
c2NzaV9kaF9hY3RpdmF0ZSgpDQo+IA0KPiBPbiBUdWUsIDIwMTEtMDEtMDQgYXQgMDk6MTMgLTA3
MDAsIE1vZ2VyLCBCYWJ1IHdyb3RlOg0KPiA+IExvb2tzIGdvb2QgdG8gbWUuDQo+IA0KPiBJdCBk
b2VzPyAgVGhlIGZpcnN0IGNoZWNrIGlzIHRoZSBib2d1cyBvbmUsIHN1cmVseS4gIFRoZSBxdWV1
ZSBpcw0KPiBjcmVhdGVkIGFuZCBkZXN0cm95ZWQgYnkgc2NzaV9hbGxvY19zZGV2KCksIHNvIHF1
ZXVlZGF0YSBjYW4gbmV2ZXIgYmUNCj4gTlVMTCBmb3IgYSBTQ1NJIHF1ZXVlLiAgVGhlcmUncyBu
byBjaGVjayBhbnl3aGVyZSBpbiB0aGUgcmVzdCBvZiBTQ1NJLA0KPiBzbyB0aGVyZSBzaG91bGRu
J3QgYmUgb25lIGhlcmUsIHNob3VsZCB0aGVyZT8NCg0KWW91IGFyZSByaWdodC4gVGhpcyBjaGVj
ayBtYXkgbm90IGJlIHJlcXVpcmVkLg0KDQpCdXQgSSBhbSBub3Qgc3VyZSB3aHkgdGhlcmUgaXMg
YSBjaGVjayBpbiBzY3NpX2RldmljZV9mcm9tX3F1ZXVlLiANCklzIHRoZXJlIGEgcG9zc2liaWxp
dHkgb2YgcmVxdWVzdF9mbiBvdGhlciB0aGFuIHNjc2lfcmVxdWVzdF9mbiBmb3Igc2NzaSBkZXZp
Y2U/ICBJIGRvbuKAmXQga25vdy4gIEhlcmUgaXMgdGhlIGNvZGUuLg0KDQpzdHJ1Y3Qgc2NzaV9k
ZXZpY2UgKnNjc2lfZGV2aWNlX2Zyb21fcXVldWUoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpDQp7
DQogICAgICAgIHN0cnVjdCBzY3NpX2RldmljZSAqc2RldiA9IE5VTEw7DQoNCiAgICAgICAgaWYg
KHEtPnJlcXVlc3RfZm4gPT0gc2NzaV9yZXF1ZXN0X2ZuKQ0KICAgICAgICAgICAgICAgIHNkZXYg
PSBxLT5xdWV1ZWRhdGE7DQoNCiAgICAgICAgcmV0dXJuIHNkZXY7DQp9DQogDQo=
