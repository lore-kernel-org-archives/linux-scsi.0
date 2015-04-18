From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH, RFC] scsi: use host wide tags by default
Date: Sat, 18 Apr 2015 04:05:10 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A8B78E7@G9W0745.americas.hpqcorp.net>
References: <1429301471-5666-1-git-send-email-hch@lst.de>
 <1429306960.1079.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42877 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbDREU0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2015 00:20:26 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 4D43160AD3
	for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2015 04:10:32 +0000 (UTC)
In-Reply-To: <1429306960.1079.25.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1zY3NpLW93bmVyQHZn
ZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXNjc2ktDQo+IG93bmVyQHZnZXIua2VybmVsLm9y
Z10gT24gQmVoYWxmIE9mIEphbWVzIEJvdHRvbWxleQ0KPiBTZW50OiBGcmlkYXksIEFwcmlsIDE3
LCAyMDE1IDQ6NDMgUE0NCj4gVG86IENocmlzdG9waCBIZWxsd2lnDQo+IENjOiBsaW51eC1zY3Np
QHZnZXIua2VybmVsLm9yZzsgYXhib2VAa2VybmVsLmRrDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gs
IFJGQ10gc2NzaTogdXNlIGhvc3Qgd2lkZSB0YWdzIGJ5IGRlZmF1bHQNCj4gDQo+IE9uIEZyaSwg
MjAxNS0wNC0xNyBhdCAyMjoxMSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQouLi4N
Cj4gPiArCQlzcGluX2xvY2tfaXJxc2F2ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlLT5xdWV1ZV9sb2Nr
LCBmbGFncyk7DQo+ID4gKwkJc2Rldi0+cXVldWVfZGVwdGggPSBkZXB0aDsNCj4gPiArCQlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKHNkZXYtPnJlcXVlc3RfcXVldWUtPnF1ZXVlX2xvY2ssIGZsYWdz
KTsNCj4gDQo+IFRoaXMgbG9jay91bmxvY2sgaXMgYSBuYXN0eSBnbG9iYWwgc3luYyBwb2ludCB3
aGljaCBjYW4gYmUgZWxpbWluYXRlZDoNCj4gd2UgY2FuIHJlbHkgb24gdGhlIGFyY2hpdGVjdHVy
YWwgYXRvbWljaXR5IG9mIDMyIGJpdCB3cml0ZXMgKG1pZ2h0IG5lZWQNCj4gdG8gbWFrZSBzZGV2
LT5xdWV1ZV9kZXB0aCBhIHUzMiBiZWNhdXNlIEkgc2VlbSB0byByZW1lbWJlciAxNiBiaXQgd3Jp
dGVzDQo+IGhhZCB0byBiZSBkb25lIGFzIHR3byBieXRlIHN0b3JlcyBvbiBzb21lIGFyY2hpdGVj
dHVyZXMpLg0KDQpJZiBzdWNoIGEgY2hhbmdlIGlzIG1hZGUsIGNvbnNpZGVyIHVzaW5nIGF0b21p
Y19zZXQgKGZvciBhbiBpbnQpIG9yDQphdG9taWM2NF9zZXQgKGZvciBhIDY0LWJpdCB2YWx1ZSkg
cGx1cyBhIGJhcnJpZXIgd2hlbiBuZWVkZWQuICBUaGF0DQpjb21tdW5pY2F0ZXMgdGhlIG5lZWQg
Zm9yIGF0b21pY2l0eSBidXQgcmVkdWNlcyB0byBhIHBsYWluIHN0b3JlIGlmDQp0aGUgYXJjaGl0
ZWN0dXJlIGFsd2F5cyBoYW5kbGVzIHRoYXQgd2lkdGggYXRvbWljYWxseS4NCg0KSSBkb24ndCB0
aGluayB0aGVyZSBpcyBhbiBhdG9taWNfc2V0X3Nob3J0IGZvciBhIHNob3J0LCB0aG91Z2guDQoN
Ci0tLQ0KUm9iZXJ0IEVsbGlvdHQsIEhQIFNlcnZlciBTdG9yYWdlDQo=
