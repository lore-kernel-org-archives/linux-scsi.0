From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 1/4] scsi_dh: Change the scsidh_activate interface to	be
 asynchronous
Date: Fri, 2 Oct 2009 17:02:51 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474ED8912@cosmail01.lsi.com>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	 <20090930020817.11455.52042.sendpatchset@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF474ED88E7@cosmail01.lsi.com>
 <1254522985.747.3.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:45526 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbZJBXDL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 19:03:11 -0400
In-Reply-To: <1254522985.747.3.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>

DQo+IE9uIEZyaSwgMjAwOS0xMC0wMiBhdCAxNjowNCAtMDYwMCwgTW9nZXIsIEJhYnUgd3JvdGU6
DQo+ID4gQ2hhbmRyYSwgSSBoYXZlIG9uZSBjb21tZW50IG9uIHRoaXMgcGF0Y2guLg0KPiA+DQo+
ID4gPiAgc3RhdGljIGlubGluZSBpbnQgc2NzaV9kaF9oYW5kbGVyX2V4aXN0KGNvbnN0IGNoYXIg
Km5hbWUpDQo+ID4gPiBJbmRleDogbGludXgtMi42LjMxL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFu
ZGxlci9zY3NpX2RoLmMNCj4gPiA+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiA+IC0tLSBsaW51eC0yLjYuMzEu
b3JpZy9kcml2ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaC5jDQo+ID4gPiArKysgbGlu
dXgtMi42LjMxL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoLmMNCj4gPiA+IEBA
IC0yMTQsNyArMjE0LDcgQEAgc3RvcmVfZGhfc3RhdGUoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1
Yw0KPiA+ID4gIAkJCSAqIEFjdGl2YXRlIGEgZGV2aWNlIGhhbmRsZXINCj4gPiA+ICAJCQkgKi8N
Cj4gPiA+ICAJCQlpZiAoc2NzaV9kaC0+YWN0aXZhdGUpDQo+ID4gPiAtCQkJCWVyciA9IHNjc2lf
ZGgtPmFjdGl2YXRlKHNkZXYpOw0KPiA+ID4gKwkJCQllcnIgPSBzY3NpX2RoLT5hY3RpdmF0ZShz
ZGV2LCBOVUxMLCBOVUxMKTsNCj4gPg0KPiA+DQo+ID4gVGhpcyBtaWdodCBjYXVzZSBwcm9ibGVt
cyBpbiBoYW5kbGVycy4gIFdlIGRvbuKAmXQgZG8gTlVMTCBjaGVjayBpbg0KPiBhdHRhY2ggcm91
dGluZS4NCj4gDQo+IEkgYXNzdW1lIHlvdSBtZWFudCBhY3RpdmF0ZSgpLCB3aGVuIHlvdSBtZW50
aW9uICJhdHRhY2giIGFib3ZlLg0KPiANCj4gQXQgZXZlcnkgcGxhY2Ugd2hlcmUgdGhlIGNhbGxi
YWNrIGZ1bmN0aW9uIGlzIGNhbGxlZCwgd2UgZmlyc3QgY2hlY2sNCj4gdGhhdCB0aGUgY2FsbGJh
Y2sgZnVuY3Rpb24gaXMgbm90IE5VTEwuDQo+IA0KPiBDYW4geW91IHBvaW50IG1lIGlmIEkgbWlz
c2VkIHNvbWUgcGxhY2UuDQo+IA0KDQpTb3JyeSBmb3IgdGhlIGNvbmZ1c2lvbi4uIFllcywgSSBt
ZWFudCBhY3RpdmF0ZS4gDQpZb3UgYXJlIHJpZ2h0LiBBbGwgdGhlIGhhbmRsZXJzIGNoZWNrIGZv
ciBOVUxMIGJlZm9yZSBjYWxsaW5nLiBXZSBhcmUgZ29vZCBoZXJlLi4NCkkgbWlzcmVhZCB0aGUg
Y29kZS4uDQo=
