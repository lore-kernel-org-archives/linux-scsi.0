From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable
 check
Date: Mon, 31 Aug 2015 08:07:42 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B3D43282E@hasmsx108.ger.corp.intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	 <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
	 <1440532371.23183.81.camel@localhost.localdomain>
	 <5B8DA87D05A7694D9FA63FD143655C1B3D42E9D0@hasmsx108.ger.corp.intel.com>
	 <1440632280.2196.94.camel@HansenPartnership.com>
	 <1440705369.23183.142.camel@localhost.localdomain>
	 <5B8DA87D05A7694D9FA63FD143655C1B3D432483@hasmsx108.ger.corp.intel.com>
 <1440953692.2204.35.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:7163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbbHaIHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2015 04:07:48 -0400
In-Reply-To: <1440953692.2204.35.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "emilne@redhat.com" <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

PiANCj4gT24gU3VuLCAyMDE1LTA4LTMwIGF0IDEwOjM2ICswMDAwLCBXaW5rbGVyLCBUb21hcyB3
cm90ZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSSdtIGp1c3Qgbm90IHN1cmUg
d2h5IHRoZSBwYXRjaGVzIGFyZSBub3QgbWVyZ2VkIG9yIGV2ZW4gcmVqZWN0ZWQuDQo+ID4gPiA+
DQo+ID4gPiA+IEJlY2F1c2UgaWRlYWxseSBJIHdhbnQgYSBNYWludGFpbmVyIGFjay4gIFRoYXQn
cyBEb3VnIEdpbGJlcnQuDQo+ID4NCj4gPiBKYW1lcw0KPiA+IFRoZSBwYXRjaGVzIHdlcmUgZGlz
Y3Vzc2VkIGFuZCB0aGUgQUNrZWQgYnkgRG91ZyBpbiBGZWJydWFyeQ0KPiANCj4gNy83IHdhc24n
dC4NCkphbWVzLCBmYWlyIGVub3VnaCwgIHRoZSByZXNldCB0aG91Z2ggY2FuIGJlIG1lcmdlZCwg
cmlnaHQgPyANCg0KPiANCj4gPiAgYW5kIHJldmlld2VkIGFnYWluIGFmdGVyIHJlc2VuZCAgYnkg
TWFydGluIFBldGVyc2VuDQo+IA0KPiBZZXMsIHRoYXQncyB3aHkgSSdtIHdpbGxpbmcgdG8gb3Zl
cnJpZGUgdGhlIGxhY2sgb2YgbWFpbnRhaW5lciBhY2suDQo+IEknbGwgZ2l2ZSBEb3VnIHVudGls
IE1vbmRheSBmaXJzdC4NCg0KT2theS4NCg0KVGhhbmtzDQpUb21hcw0KDQoNCg==
