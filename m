From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable
 check
Date: Tue, 25 Aug 2015 21:03:55 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B3D42E9D0@hasmsx108.ger.corp.intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	 <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
 <1440532371.23183.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbbHYVEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 17:04:04 -0400
In-Reply-To: <1440532371.23183.81.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

DQo+ID4gKwkvKiB0aGlzIHNob3VsZCBuZXZlciBoYXBwZW4gKi8NCj4gPiArCWlmIChXQVJOX09O
KCFjbW5kKSkNCj4gPiArCQlyZXR1cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsNCj4gPg0KPiA+
IC0JaWYgKE5VTEwgPT0gY21uZCB8fCBOVUxMID09IGRldmlwKSB7DQo+ID4gLQkJcHJfd2Fybigi
Y2FsbGVkIHdpdGggTlVMTCBjbW5kIG9yIGRldmlwIHBvaW50ZXJcbiIpOw0KPiA+ICsJaWYgKE5V
TEwgPT0gZGV2aXApIHsNCj4gPiArCQlwcl93YXJuKCJjYWxsZWQgZGV2aXAgPT0gTlVMTFxuIik7
DQo+ID4gIAkJLyogbm8gcGFydGljdWxhcmx5IGdvb2QgZXJyb3IgdG8gcmVwb3J0IGJhY2sgKi8N
Cj4gPiAgCQlyZXR1cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsNCj4gPiAgCX0NCj4gDQo+IFBs
ZWFzZSByZWZlciB0byB0aGUgcGF0Y2ggSSBqdXN0IHBvc3RlZCwgd2UgY2FuJ3QgcmV0dXJuIF9I
T1NUX0JVU1kgaGVyZQ0KPiBpZiBkZXZpcCA9PSBOVUxMLiAgSSBwb3N0ZWQgYSBmaXggYWdhaW5z
dCB0aGUgY3VycmVudCAibWlzYyIgYnJhbmNoIGFzDQo+IEkgZG9uJ3Qgc2VlIHRoaXMgcGF0Y2gg
YXBwbGllZCwgbGV0IG1lIGtub3cgaWYgSSBuZWVkIHRvIHVwZGF0ZSBpdC4NCg0KDQpJJ20ganVz
dCBub3Qgc3VyZSB3aHkgdGhlIHBhdGNoZXMgYXJlIG5vdCBtZXJnZWQgb3IgZXZlbiByZWplY3Rl
ZC4NCkknbSBzdWJtaXR0aW5nIHBhdGNoZXMgdG8gdGhlIExpbnV4IGtlcm5lbCBmb3IgbW9yZSB0
aGFuIDEwIHllYXJzIHRvIHZhcmlvdXMgdHJlZXMgYW5kICBJIGNhbiBhZ3JlZSB0aGF0IHRoZXNl
IGFyZSBub3Qgc29tZSAgdXJnZW50IGZpeGVzLCBidXQgIHRoaXMgaXMgdGhlIGZpcnN0IHRpbWUg
bXkgZWZmb3J0IGlzIGlnbm9yZWQgZm9yIHN1Y2ggbG9uZyB0aW1lIGJ5IHRoZSBtYWludGFpbmVy
LiANCg0KVGhhbmtzDQpUb21hcw0KDQo=
