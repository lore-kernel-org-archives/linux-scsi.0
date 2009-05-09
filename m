From: Ying Chu <jasonchu@marvell.com>
Subject: RE: [PATCH 4/4] mvsas: Fine-tuned tags array for alignment
Date: Fri, 8 May 2009 23:59:21 -0700
Message-ID: <B610F018B81B3143B10B3A7DC04C693E185056A0AC@SC-VEXCH2.marvell.com>
References: <20090508061852.GA1893@jason.marvell.com>
 <1241795999.3327.38.camel@mulgrave.int.hansenpartnership.com>
 <4A045C62.50404@garzik.org>
 <B610F018B81B3143B10B3A7DC04C693E185056A0AA@SC-VEXCH2.marvell.com>
 <4A052820.3080802@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:4093 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbZEIG7W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 May 2009 02:59:22 -0400
In-Reply-To: <4A052820.3080802@garzik.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jeff Garzik' <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>

V2VsbCwgdGhhbmsgeW91Lg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmVm
ZiBHYXJ6aWsgW21haWx0bzpqZWZmQGdhcnppay5vcmddIA0KU2VudDogMjAwOcTqNdTCOcjVIDE0
OjUyDQpUbzogWWluZyBDaHUNCkNjOiBKYW1lcyBCb3R0b21sZXk7IGxpbnV4LXNjc2lAdmdlci5r
ZXJuZWwub3JnOyBBbmR5IFlhbjsgS2UgV2VpDQpTdWJqZWN0OiBSZTogW1BBVENIIDQvNF0gbXZz
YXM6IEZpbmUtdHVuZWQgdGFncyBhcnJheSBmb3IgYWxpZ25tZW50DQoNCllpbmcgQ2h1IHdyb3Rl
Og0KPiBIaSwgSmFtZXMNCj4gDQo+IERFQ0xBUkVfQklUTUFQIGlzbid0IGEgZ29vZCBvcHRpb24g
Zm9yIG12c2FzLCBzaW5jZSB0aGUgdGFncyBhcnJheSBjb3VsZG4ndCBiZSBnbG9iYWwoaXQncyBj
aGlwLXJlbGF0ZWQpIGFuZCBldmVuIGlmIHdlIGRlZmluZSB0aGUgc3RhdGljIHRhZyBhcnJheSBi
b3RoIGluIG12NjR4eC5jIGFuZCBtdjk0eHguYywgaXQgc3RpbGwgY291bGRuJ3QgaG9ub3IgODhT
RTk0ODAgYXMgdGhlcmUgYXJlIDIgc2VwYXJhdGUgY29yZXMuIFNvIGlmIHdlIHVzZSBERUNMQVJF
X0JJVE1BUCwgaXQncyBoYXJkIHRvIG1haW50YWluIHRoZSBjb3JyZXNwb25kaW5nIHRhZyBmb3Ig
ZGlmZmVyZW50IGNvcmUuICANCj4gDQo+IENhbiB3ZSB1c2UgdGhlIGZvbGxvd2luZyByZXBsYWNl
bWVudDoNCj4gIC0JdTggdGFnc1tNVlNfU0xPVFMgPj4gM107DQo+ICArCXVuc2lnbmVkIGxvbmcg
dGFnc1tNVlNfU0xPVFMgLyBCSVRTX1BFUl9MT05HXTsNCg0KWW91IGFyZSBkb2luZyBleGFjdGx5
IHRoZSBzYW1lIHRoaW5nIGFzIERFQ0xBUkVfQklUTUFQIGhlcmUsIHNvIGp1c3QgdXNlIERFQ0xB
UkVfQklUTUFQIDopDQoNCmluY2x1ZGUvbGludXgvdHlwZXMuaDoNCgkjZGVmaW5lIERFQ0xBUkVf
QklUTUFQKG5hbWUsYml0cykgXA0KCSAgICAgICAgdW5zaWduZWQgbG9uZyBuYW1lW0JJVFNfVE9f
TE9OR1MoYml0cyldDQoNClJlZ2FyZHMsDQoNCglKZWZmDQoNCg0KDQo=
