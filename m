From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/3] block: Add badblock management for gendisks
Date: Wed, 25 Nov 2015 17:55:42 +0000
Message-ID: <1448474142.5911.4.camel@intel.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
	 <1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
	 <x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
	 <1448391837.27481.16.camel@intel.com>
	 <x498u5n1a7h.fsf@segfault.boston.devel.redhat.com>
	 <1448395840.14996.8.camel@intel.com>
	 <x49h9kanl7t.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51916 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbbKYRzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2015 12:55:44 -0500
In-Reply-To: <x49h9kanl7t.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <BDF92552422772439882C4AA6EE4EC61@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>

T24gV2VkLCAyMDE1LTExLTI1IGF0IDEwOjM3IC0wNTAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiAi
VmVybWEsIFZpc2hhbCBMIiA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPiB3cml0ZXM6DQo+IA0K
PiA+IE9uIFR1ZSwgMjAxNS0xMS0yNCBhdCAxNDoxNCAtMDUwMCwgSmVmZiBNb3llciB3cm90ZToN
Cj4gPiA+IA0KPiA+ID4gSSdtIG5vdCBzdXJlIHdoZXRoZXIgaXQgbWFrZXMgc2Vuc2UgdG8gY29u
dGludWUgd2l0aG91dCBiYWRibG9jaw0KPiA+ID4gbWFuYWdlbWVudCBmb3IgdGhlIFJBSUQgY29k
ZS7CoMKgSSB3YXMgaG9waW5nIE5laWwgd291bGQgY29tbWVudCBvbg0KPiA+ID4gdGhhdC4NCj4g
PiA+IA0KPiA+ID4gLUplZmYNCj4gPiANCj4gPiBOb3Qgc3VyZSBJIGZvbGxvdz8gSSBiZWxpZXZl
IEkndmUga2VwdCBhbGwgdGhlIGJhZGJsb2Nrcw0KPiA+IGZ1bmN0aW9uYWxpdHkNCj4gPiBSQUlE
IGFscmVhZHkgaGFkLi4NCj4gDQo+IFdoYXQgSSBtZWFuIHRvIHNheSBpcyB0aGF0IHRoZSBSQUlE
IGNvZGUgaGFkIHByZXZpb3VzbHkgZW1iZWRkZWQgdGhlDQo+IGJhZGJsb2NrcyBzdHJ1Y3R1cmUg
aW4gb25lIG9mIGl0cyBvdGhlciBkYXRhIHN0cnVjdHVyZXMuwqDCoEFzIGEgcmVzdWx0LA0KPiB5
b3Ugd291bGQgbmV2ZXIgZ2V0IGFuIGFsbG9jYXRpb24gZmFpbHVyZSBmb3IgaXQuDQo+IA0KQWgg
SSBzZWUgLSBJIGRvbid0IHRoaW5rIHRoYXQgaGFzIGVmZmVjdGl2ZWx5IGNoYW5nZWQuICdyZGV2
JyBzdGlsbA0KY29udGFpbnMgYSBzdGF0aWNhbGx5IGFsbG9jYXRlZCBiYWRibG9ja3Mgc3RydWN0
dXJlIChhcyBvcHBvc2VkIHRvDQpnZW5kaXNrLCB3aGljaCBqdXN0IHN0b3JlcyBhIHBvaW50ZXIp
LiBtZCB1c2VkIHRvIGR5bmFtaWNhbGx5IGFsbG9jYXRlDQp0aGUgc3RvcmFnZSBzcGFjZSBpbnNp
ZGUgYmFkYmxvY2tzIChiYi0+cGFnZSksIGFuZCB0aGF0IGlzIHN0aWxsIHRoZQ0KY2FzZSB1c2lu
ZyBiYWRibG9ja3NfaW5pdC4NCg0KCS1WaXNoYWw=
