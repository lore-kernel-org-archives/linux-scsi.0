From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable
 check
Date: Sun, 30 Aug 2015 10:36:52 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B3D432483@hasmsx108.ger.corp.intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	 <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
	 <1440532371.23183.81.camel@localhost.localdomain>
	 <5B8DA87D05A7694D9FA63FD143655C1B3D42E9D0@hasmsx108.ger.corp.intel.com>
	 <1440632280.2196.94.camel@HansenPartnership.com>
 <1440705369.23183.142.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440705369.23183.142.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

PiA+ID4NCj4gPiA+DQo+ID4gPiBJJ20ganVzdCBub3Qgc3VyZSB3aHkgdGhlIHBhdGNoZXMgYXJl
IG5vdCBtZXJnZWQgb3IgZXZlbiByZWplY3RlZC4NCj4gPg0KPiA+IEJlY2F1c2UgaWRlYWxseSBJ
IHdhbnQgYSBNYWludGFpbmVyIGFjay4gIFRoYXQncyBEb3VnIEdpbGJlcnQuDQoNCkphbWVzIA0K
VGhlIHBhdGNoZXMgd2VyZSBkaXNjdXNzZWQgYW5kIHRoZSBBQ2tlZCBieSBEb3VnIGluIEZlYnJ1
YXJ5IGFuZCByZXZpZXdlZCBhZ2FpbiBhZnRlciByZXNlbmQgIGJ5IE1hcnRpbiBQZXRlcnNlbiAN
Cg0KPiA+DQo+ID4gPiBJJ20gc3VibWl0dGluZyBwYXRjaGVzIHRvIHRoZSBMaW51eCBrZXJuZWwg
Zm9yIG1vcmUgdGhhbiAxMCB5ZWFycyB0bw0KPiA+ID4gdmFyaW91cyB0cmVlcyBhbmQgIEkgY2Fu
IGFncmVlIHRoYXQgdGhlc2UgYXJlIG5vdCBzb21lICB1cmdlbnQgZml4ZXMsDQo+ID4gPiBidXQg
IHRoaXMgaXMgdGhlIGZpcnN0IHRpbWUgbXkgZWZmb3J0IGlzIGlnbm9yZWQgZm9yIHN1Y2ggbG9u
ZyB0aW1lIGJ5DQo+ID4gPiB0aGUgbWFpbnRhaW5lci4NCj4gPg0KPiA+IFdlbGwsIE9LLCBJIHRy
dXN0IG1hcnRpbiwgSSdsbCBvdmVycmlkZSB0aGUgbGFjayBvZiBNYWludGFpbmVyIGFjayBpZg0K
PiA+IHlvdSBmaXggYXMgRXdhbiBzdWdnZXN0cy4NCg0KPiANCj4gSnVzdCB0byBjbGFyaWZ5LCBJ
IGRpZG4ndCBoYXZlIGEgcHJvYmxlbSB3aXRoIFRvbWFzJyBwYXRjaCBwZXIgc2UsIGl0J3MNCj4g
anVzdCB0aGF0IG15IHBhdGNoIHdvbid0IGFwcGx5IG9uIHRvcCBvZiBoaXMuICBJJ2xsIHN1Ym1p
dCBhIHYyIGlmIHlvdQ0KPiB3YW50LCBzbyB5b3UgY2FuIGFwcGx5IFRvbWFzJyBwYXRjaCBmaXJz
dC4gIFRoZSBwcm9ibGVtIEknbSBmaXhpbmcgaGFzDQo+IGJlZW4gaW4gdGhlcmUgZm9yIGEgd2hp
bGUuICBMZXQgbWUga25vdyBpZiB5b3Ugd2FudCBtZSB0byBkbyB0aGF0Lg0KPiANCkhvcGVmdWxs
eSB5b3VyIHBhdGNoIHNob3VsZCBiZSBhcHBsaWVkIGFib3ZlIG15IHBhdGNoZXMgYnV0IEkgY2Fu
IG1ha2UgdGhhdCBlZmZvcnQgYW5kIHN0YWNrIHRoZW0gb24gdG9wIG9mIHlvdXJzLg0KVGhhbmtz
DQoNCg==
