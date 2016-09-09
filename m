From: Scott Benesh <scott.benesh@microsemi.com>
Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Fri, 9 Sep 2016 16:06:29 +0000
Message-ID: <48C22F0C33E45A4F83E15DF49719341D38F4BC95@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
 <146706367078.29152.14405582249219794335.stgit@brunhilda>
 <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
 <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
 <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net>
 <1473359114.2781.38.camel@linux.vnet.ibm.com>
 <48C22F0C33E45A4F83E15DF49719341D38F495F6@avsrvexchmbx1.microsemi.net>
 <ea9150f3-de17-4baf-b8f2-2fb1e8f9b990@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:3984
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751212AbcIIQGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 12:06:49 -0400
In-Reply-To: <ea9150f3-de17-4baf-b8f2-2fb1e8f9b990@email.android.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@Hansenpartnership.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiANCj4gT24gU2VwdGVtYmVyIDgsIDIwMTYgMjozMzo1MiBQTSBFRFQsIFNjb3R0IEJlbmVzaA0K
PiA8c2NvdHQuYmVuZXNoQG1pY3Jvc2VtaS5jb20+IHdyb3RlOg0KPiA+Pg0KPiA+PiBPbiBUaHUs
IDIwMTYtMDktMDggYXQgMTg6MTUgKzAwMDAsIERvbiBCcmFjZSB3cm90ZToNCj4gPj4gPiA+ID4g
LSAgICB7IDB4OTAwNSwgMHgwMjhmLCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAwLCA2NSB9
LCAvKg0KPiA+PiA+ID4gPiBBZGFwdGVjIFBNQw0KPiA+PiA+ID4gPiBTZXJpZXMgOSAqLw0KPiA+
PiA+ID4gPg0KPiA+PiA+ID4gPiBIb3cgYXJlIHBlb3BsZSB0aGF0IGxvYWQgYWFjcmFpZCBpbiB0
aGVpciBpbml0cmQgZ29pbmcgdG8gYm9vdA0KPiA+PiA+ID4gPiBhZnRlciB0aGlzPw0KPiA+PiA+
ID4gPg0KPiA+PiA+ID4gPiAtLQ0KPiA+PiA+ID4gPiBNYXJ0aW4gSy4gUGV0ZXJzZW4gICAgICBP
cmFjbGUgTGludXggRW5naW5lZXJpbmcNCj4gPj4gPiA+DQo+ID4+ID4gPiBJIHVwZGF0ZWQgc21h
cnRwcWkvS2NvbmZpZyBhbmQgYWRkZWQNCj4gPkRvY3VtZW50YXRpb24vc2NzaS9zbWFydHBxaS50
eHQNCj4gPj4gPiA+IHRvIGluZm9ybSB1c2VycyBvZiB0aGUgbmVlZCB0byBjb25maWd1cmUgdGhl
IHNtYXJ0cHFpIGRyaXZlcg0KPiA+bW92aW5nDQo+ID4+ID4gPiBmb3J3YXJkIGZvciBhYWNyYWlk
IFNlcmllcyA5IGNvbnRyb2xsZXJzLg0KPiA+PiA+ID4NCj4gPj4gPiA+IEhvcGUgdGhpcyBoZWxw
cy4NCj4gPj4NCj4gPj4gVGhhdCdzIG5vdCBnb2luZyB0byBiZSBlbm91Z2g6IHRoaXMgSUQgaGFz
IGJlZW4gaW4gdGhlIGFhY3JpYWQgZHJpdmVyDQo+ID5zaW5jZQ0KPiA+PiAyMDExLiAgVGhhdCBt
ZWFucyBhbnlvbmUgd2hvIGZpbmFsbHkgZ2V0cyBob2xkIG9mIG9uZSBvZiB0aGVzZSBuZXcNCj4g
PmNhcmRzDQo+ID4+IGJ1dCB1c2VzIGEgZGlzdHJvIHRoYXQgZG9lc24ndCBoYXZlIHRoZSBuZXcg
c21hcnRwcWkgZHJpdmVyIHdpbGwgYmUNCj4gPmF0dGFjaGVkDQo+ID4+IHZpYSB0aGUgYWFjcmFp
ZCBvbmUuDQo+ID4+DQo+ID4NCj4gPlRoYXQncyBvayBiZWNhdXNlIGZvciBwcmV2aW91cyBkaXN0
cm9zIHRoZSBuZXcgY29udHJvbGxlciB3aWxsIHdvcmsNCj4gPndpdGggdGhlIHByZXZpb3VzIGFh
Y3JhaWQgZHJpdmVyLCBhbHRob3VnaCB3aXRoIG5vbi1vcHRpbWFsDQo+ID5wZXJmb3JtYW5jZS4N
Cj4gDQo+IE5vdCBhZnRlciB0aGlzIGNoYW5nZSBoaXRzLiBUaGVuIHN5c3RlbXMgdGhhdCBvbmx5
IGhhdmUgYWFjcmFpZCBpbiB0aGUgaW5pdHJkDQo+IHdpbGwgZmFpbCB0byBib290Lg0KPiANCg0K
VW5kZXJzdG9vZC4gQWx0aG91Z2ggd2UgYmVsaWV2ZSB0aGF0IHRoaXMgY2hhbmdlIHNob3VsZCBi
ZSBpbiBzeW5jIHdpdGggdGhlIGFkZGl0aW9uIG9mIHRoZSBuZXcgc21hcnRwcWkgZHJpdmVyLiAN
CkJvdGggZHJpdmVycyB3b3VsZCBiZSBpbmNsdWRlZCBpbiB0aGUgaW5pdHJkIHNvIHRoZSBib290
IHdvcmtzLiAgQWdhaW4sIHdlIGFyZSBtb3N0bHkgY29uY2VybmVkIGFib3V0IHRoZSA0Ljkga2Vy
bmVsIGdvaW5nIGZvcndhcmQuDQoNCj4gPldoYXQgd2Ugd2FudCB0byBkbyBpcyBzeW5jIHVwIGF0
IDQuOSBzbyBnb2luZyBmb3J3YXJkIG9ubHkgdGhlIG5ldw0KPiA+c21hcnRwcWkgZHJpdmVyIHdp
bGwgYXR0YWNoIHRvIHRoZXNlIG5ldyBjb250cm9sbGVycy4NCj4gDQo+IFNvIHlvdSBoYXZlIGEg
cGxhbiBpbiBwbGFjZSB3aXRoIHRoZSBkaXN0cm9zIHRvIG1pZ3JhdGUgdGhlIGluaXRyZCBpbWFn
ZXM/DQo+IFdpdGhvdXQgYmVpbmcgdG9sZCwgc29tZSB3aWxsIG9ubHkgaW5zdGFsbCB0aGUgbW9k
dWxlcyB0aGUgcHJldmlvdXMgaW5pdHJkICB3YXMNCj4gY29uZmlndXJlZCBmb3IuDQoNClRoYXQg
d2FzIHRoZSBwdXJwb3NlIG9mIHRoZSBzbWFydHBxaS50eHQgZmlsZS4gUGx1cyB3ZSBhcmUgcGxh
bm5pbmcgYWRkaXRpb25hbCBkb2N1bWVudGF0aW9uIHdoZW4gdGhlIG5ldyBjb250cm9sbGVycyBh
cmUgYXZhaWxhYmxlIHRvIGhlbHAgd2l0aCB0aGUNCm1pZ3JhdGlvbi4gQW5kIHdlIGFyZSB3b3Jr
aW5nIHdpdGggdGhlIGRpc3Ryb3MgYmVmb3JlaGFuZCB0byBtYWtlIHN1cmUgdGhlIG5ldyBkcml2
ZXJzIGFyZSBpbiB0aGUgcmlnaHQgcGxhY2UuIA0KDQpUaGFua3MsDQpTY290dA0KDQo=
