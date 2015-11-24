From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/3] block: Add badblock management for gendisks
Date: Tue, 24 Nov 2015 19:03:57 +0000
Message-ID: <1448391837.27481.16.camel@intel.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
	 <1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
	 <x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11872 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbbKXTD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 14:03:59 -0500
In-Reply-To: <x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <444DD778B5AABC4F953B4DD77661D08F@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>

T24gVHVlLCAyMDE1LTExLTI0IGF0IDEwOjM0IC0wNTAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiBW
aXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4gd3JpdGVzOg0KPiANCj4gPiBO
VkRJTU0gZGV2aWNlcywgd2hpY2ggY2FuIGJlaGF2ZSBtb3JlIGxpa2UgRFJBTSByYXRoZXIgdGhh
biBibG9jaw0KPiA+IGRldmljZXMsIG1heSBkZXZlbG9wIGJhZCBjYWNoZSBsaW5lcywgb3IgJ3Bv
aXNvbicuIEEgYmxvY2sgZGV2aWNlDQo+ID4gZXhwb3NlZCBieSB0aGUgcG1lbSBkcml2ZXIgY2Fu
IHRoZW4gY29uc3VtZSBwb2lzb24gdmlhIGEgcmVhZCAob3INCj4gPiB3cml0ZSksIGFuZCBjYXVz
ZSBhIG1hY2hpbmUgY2hlY2suIE9uIHBsYXRmb3JtcyB3aXRob3V0IG1hY2hpbmUNCj4gPiBjaGVj
ayByZWNvdmVyeSBmZWF0dXJlcywgdGhpcyB3b3VsZCBtZWFuIGEgY3Jhc2guDQo+ID4gDQo+ID4g
VGhlIGJsb2NrIGRldmljZSBtYWludGFpbmluZyBhIHJ1bnRpbWUgbGlzdCBvZiBhbGwga25vd24g
c2VjdG9ycw0KPiA+IHRoYXQNCj4gPiBoYXZlIHBvaXNvbiBjYW4gZGlyZWN0bHkgYXZvaWQgdGhp
cywgYW5kIGFsc28gcHJvdmlkZSBhIHBhdGggZm9yd2FyZA0KPiA+IHRvIGVuYWJsZSBwcm9wZXIg
aGFuZGxpbmcvcmVjb3ZlcnkgZm9yIERBWCBmYXVsdHMgb24gc3VjaCBhIGRldmljZS4NCj4gPiAN
Cj4gPiBVc2UgdGhlIG5ldyBiYWRibG9jayBtYW5hZ2VtZW50IGludGVyZmFjZXMgdG8gYWRkIGEg
YmFkYmxvY2tzIGxpc3QNCj4gPiB0bw0KPiA+IGdlbmRpc2tzLg0KPiANCj4gQmVjYXVzZSBkaXNr
X2FsbG9jX2JhZGJsb2NrcyBjYW4gZmFpbCwgeW91IG5lZWQgdG8gY2hlY2sgZm9yIGEgTlVMTA0K
PiBkaXNrLT5iYiBpbiBhbGwgb2YgdGhlIHV0aWxpdHkgZnVuY3Rpb25zIHlvdSd2ZSBkZWZpbmVk
Lg0KPiANCg0KVGhhbmtzLCBKZWZmIC0gSSdsbCBmaXggdGhpcy4gSSBoYXZlIGEgaGFuZGZ1bCBv
ZiBvdGhlciBmaXhlcyBxdWV1ZWQgdXANCnRvbywgd2lsbCBzZW5kIG91dCBhIHYyIHNvb24uDQoN
CgktVmlzaGFs
