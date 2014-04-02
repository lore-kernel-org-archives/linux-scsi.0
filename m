From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 0/7] Performance improvements for LSI SCSI cards
Date: Wed, 2 Apr 2014 08:06:57 +0000
Message-ID: <eb6899b878154c2ba7ed7932e7fcde10@BN1PR07MB247.namprd07.prod.outlook.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
 <1396245285.22255.52.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:47869
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757462AbaDBIXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2014 04:23:05 -0400
In-Reply-To: <1396245285.22255.52.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "Krishnamoorthy, Praveen" <Praveen.Krishnamoorthy@lsi.com>

Q0MgZmV3IG1vcmUgTFNJIGRyaXZlciBkZXZlbG9wZXJzLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+IEZyb206IE5pY2hvbGFzIEEuIEJlbGxpbmdlciBbbWFpbHRvOm5hYkBsaW51
eC1pc2NzaS5vcmddDQo+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMzEsIDIwMTQgMTE6MjUgQU0NCj4g
VG86IE1hdHRoZXcgV2lsY294DQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgd2ls
bHlAbGludXguaW50ZWwuY29tOyBEZXNhaSwgS2FzaHlhcDsNCj4gU2F4ZW5hLCBTdW1pdDsgSmFt
ZXMgQm90dG9tbGV5DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMC83XSBQZXJmb3JtYW5jZSBpbXBy
b3ZlbWVudHMgZm9yIExTSSBTQ1NJIGNhcmRzDQo+IA0KPiBIaSBNYXR0aGV3LA0KPiANCj4gT24g
VGh1LCAyMDE0LTAzLTI3IGF0IDE2OjQwIC0wNDAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToNCj4g
PiBUaGUgaG9zdCBsb2NrIGlzIGEgc2VyaW91cyBzY2FsYWJpbGl0eSBwcm9ibGVtIG9uIDItc29j
a2V0IGFuZCBsYXJnZXINCj4gPiBzeXN0ZW1zIHdoaWNoIGFyZSBkb2luZyBhIGxvdCBvZiBJL08u
ICBCZWZvcmUgcmVtb3ZpbmcgdGhlIHRlbXBvcmFyeQ0KPiA+IHVzZ2FlIG9mIERFRl9TQ1NJX1FD
TUQsIHdlIG5lZWQgdG8gcmVtb3ZlIGFsbCB1c2VzIG9mIHNlcmlhbF9udW1iZXIuDQo+ID4NCj4g
PiBBbiB1bnJlbGF0ZWQgcGVyZm9ybWFuY2UgaXNzdWUgaXMgdGhhdCByZXVzaW5nIHRoZSBtb3N0
IHJlY2VudA0KPiA+IGRyaXZlci1zcGVjaWZpYyBkYXRhIHN0cnVjdHVyZSB0byB0cmFjayB0aGUg
SS9PIGluc3RlYWQgb2YgdGhlIGxlYXN0DQo+ID4gcmVjZW50bHkgdXNlZCBrZWVwcyB0aGUgY2Fj
aGUtaG90IGxpbmVzIGluIHVzZSwgd2hpY2ggaXMgYSBuaWNlDQo+ID4gcGVyZm9ybWFuY2UgaW1w
cm92ZW1lbnQuICBJdCdzIGFscmVhZHkgcHJlc2VudCBpbiB0aGUgbXB0M3NhcyBkcml2ZXIsDQo+
ID4gaXQganVzdCBkaWRuJ3QgbWFrZSBpdCBpbnRvIHRoZSBmdXNpb24gb3IgbXB0MnNhcyBkcml2
ZXJzIHlldC4NCj4gPg0KPiA+IE1hdHRoZXcgV2lsY294ICg3KToNCj4gPiAgIG1wdDNzYXM6IFJl
bW92ZSB1c2VzIG9mIHNlcmlhbF9udW1iZXINCj4gPiAgIG1wdDNzYXM6IFJlbW92ZSB1c2Ugb2Yg
REVGX1NDU0lfUUNNRA0KPiA+ICAgbXB0MnNhczogUmVtb3ZlIHVzZXMgb2Ygc2VyaWFsX251bWJl
cg0KPiA+ICAgbXB0MnNhczogUmVtb3ZlIHVzZSBvZiBERUZfU0NTSV9RQ01EDQo+ID4gICBtcHQy
c2FzOiBBZGQgZnJlZSBzbWlkcyB0byB0aGUgaGVhZCwgbm90IHRhaWwgb2YgbGlzdA0KPiA+ICAg
ZnVzaW9uOiBBZGQgZnJlZSBtc2cgZnJhbWVzIHRvIHRoZSBoZWFkLCBub3QgdGFpbCBvZiBsaXN0
DQo+ID4gICBmdXNpb246IFJlbW92ZSB1c2Ugb2YgREVGX1NDU0lfUUNNRA0KPiA+DQo+ID4NCj4g
DQo+ICsxIHRvIHRoaXMgbG9uZyBvdmVyZHVlIHNlcmllcyB0byBlbmFibGUgaG9zdF9sb2NrLWxl
c3MgbW9kZSB3aXRoDQo+IG1wdCpzYXMgKyBmdXNpb24uICAoQ0MnaW5nIExTSSBmb2xrcyArIGpl
amIpDQo+IA0KPiBSZXZpZXdlZC1ieTogTmljaG9sYXMgQmVsbGluZ2VyIDxuYWJAbGludXgtaXNj
c2kub3JnPg0KPiANCg0K
