From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/3] block: Add badblock management for gendisks
Date: Tue, 24 Nov 2015 20:10:39 +0000
Message-ID: <1448395840.14996.8.camel@intel.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
	 <1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
	 <x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
	 <1448391837.27481.16.camel@intel.com>
	 <x498u5n1a7h.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbbKXUKm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 15:10:42 -0500
In-Reply-To: <x498u5n1a7h.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <E4AA963A251B6849ACC3DC10A27A8E9B@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>

T24gVHVlLCAyMDE1LTExLTI0IGF0IDE0OjE0IC0wNTAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiAN
Cj4gSSdtIG5vdCBzdXJlIHdoZXRoZXIgaXQgbWFrZXMgc2Vuc2UgdG8gY29udGludWUgd2l0aG91
dCBiYWRibG9jaw0KPiBtYW5hZ2VtZW50IGZvciB0aGUgUkFJRCBjb2RlLsKgwqBJIHdhcyBob3Bp
bmcgTmVpbCB3b3VsZCBjb21tZW50IG9uDQo+IHRoYXQuDQo+IA0KPiAtSmVmZg0KDQpOb3Qgc3Vy
ZSBJIGZvbGxvdz8gSSBiZWxpZXZlIEkndmUga2VwdCBhbGwgdGhlIGJhZGJsb2NrcyBmdW5jdGlv
bmFsaXR5DQpSQUlEIGFscmVhZHkgaGFkLi4NCg0KDQpPbiBhIHJlbGF0ZWQgbm90ZSwgc29tZXRo
aW5nIEkgb2JzZXJ2ZWQgd2hlbiB0ZXN0aW5nIHdpdGggbWQ6DQoNCm1kJ3MgYmFkYmxvY2sgbGlz
dCBpcyBwZXItZGV2aWNlLCBhbmQgY2FuIGJlIHNlZW4gYXQ6DQoJL3N5cy9ibG9jay9tZDAvbWQv
ZGV2LXBtZW0wL2JhZF9ibG9ja3MNCg0KTm93IGlmIHdlIGhhdmUgYmFkYmxvY2tzIGluIHRoZSBn
ZW5kaXNrcyB0b28sIHRoZXJlIGlzIGFsc286DQoJL3N5cy9ibG9jay9wbWVtMC9iYWRfYmxvY2tz
DQoNClRoZSB0d28gYXJlIHNlcGFyYXRlICdhY2NvdW50cycgbWFpbnRhaW5lZCBieSBzZXBhcmF0
ZSBkcml2ZXJzIChtZCBmb3INCnRoZSBmb3JtZXIsIGFuZCBwbWVtIGZvciB0aGUgbGF0dGVyKS4g
VGhpcyBjYW4gcG90ZW50aWFsbHkgYmUNCmNvbmZ1c2luZy4uDQoNClNob3VsZCB3ZSBjb25zb2xp
ZGF0ZSB0aGUgdHdvLCBpLmUuIG1ha2UgbWQgKHJlKXVzZSB0aGUgZ2VuZGlzaw0KYmFkYmxvY2tz
IGZvciBpdHMgcHVycG9zZXMgdG9vPw0KDQoJLVZpc2hhbA==
