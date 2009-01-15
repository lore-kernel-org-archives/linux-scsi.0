From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 11:46:50 -0700
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1232028766.5966.10.camel@localhost.localdomain>
	 <20090115094442.b6394544.akpm@linux-foundation.org>
	 <20090115180052.GG29283@parisc-linux.org>
 <1232043287.21980.65.camel@localhost.localdomain>
 <496F8421.3070703@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41296 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZAOSra (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 13:47:30 -0500
In-Reply-To: <496F8421.3070703@novell.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gregory Haskins <ghaskins@novell.com>, Steven Rostedt <srostedt@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Ma, Chinang" <chinang.ma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

R3JlZ29yeSBIYXNraW5zIFttYWlsdG86Z2hhc2tpbnNAbm92ZWxsLmNvbV0gd3JvdGU6DQo+ID4g
T24gVGh1LCAyMDA5LTAxLTE1IGF0IDExOjAwIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gPj4gU28gaWYgdGhlIHJlc2NoZWR1bGUgaW50ZXJydXB0IGlzIGhhcHBlbmluZyB0d2ljZSBh
cyBvZnRlbiwgYW5kIHRoZQ0KPiA+PiBjb250ZXh0IHN3aXRjaCByYXRlIGlzIGJhc2ljYWxseSB1
bmNoYW5nZWQsIEkgZ3Vlc3MgdGhhdCBtZWFucyB0aGUNCj4gPj4gc2NoZWR1bGVyIGlzIGRvaW5n
IGEgbG90IG1vcmUgd29yayB0byBnZXQgYXBwcm94aW1hdGVseSB0aGUgc2FtZQ0KPiA+PiByZXN1
bHRzLiAgQW5kIHRoYXQgc2VlbXMgbGlrZSBhIGJhZCB0aGluZy4NCj4gDQo+IEkgd291bGQgYmUg
dmVyeSBpbnRlcmVzdGVkIGluIGdhdGhlcmluZyBzb21lIGRhdGEgaW4gdGhpcyBhcmVhLiAgT25l
DQo+IHRoaW5nIHRoYXQgcG9wcyB0byBtaW5kIGlzIHRvIGluc3RydW1lbnQgdGhlIHJlc2NoZWQt
aXBpIHdpdGgNCj4gZnRyYWNlX3ByaW50aygpIGFuZCBnYXRoZXIgYSB0cmFjZSBvZiB0aGlzIHN5
c3RlbSBpbiBhY3Rpb24uICBJIGFzc3VtZQ0KPiB0aGF0IEkgd291bGRuJ3QgaGF2ZSBhY2Nlc3Mg
dG8gdGhpcyBPTFRQIHN1aXRlLCBzbyBJIG1heSBuZWVkIGENCj4gdm9sdW50ZWVyIHRvIHRyeSB0
aGlzIGZvciBtZS4gIEkgY291bGQgcHV0IHRvZ2V0aGVyIGFuIGluc3RydW1lbnRhdGlvbg0KPiBw
YXRjaCBmb3IgdGhlIHRlc3RlcnMgY29udmVuaWVuY2UgaWYgdGhleSBwcmVmZXIuDQoNCkkgZG9u
J3Qga25vdyB3aGV0aGVyIE5vdmVsbCBoYXZlIGFuIGFycmFuZ2VtZW50IHdpdGggdGhlIFdlbGwt
S25vd24gQ29tbWVyY2lhbCBEYXRhYmFzZSBhbmQgdGhlIFdlbGwtS25vd24gT0xUUCBCZW5jaG1h
cmsgdG8gZG8gcnVucyBsaWtlIHRoaXMuICBDaGluYW5nIGlzIG5vcm1hbGx5IG9ubHkgdG9vIGhh
cHB5IHRvIGJ1aWxkIGhpcyBvd24ga2VybmVscyB3aXRoIHBhdGNoZXMgZnJvbSBwZW9wbGUgd2hv
IGFyZSBpbnRlcmVzdGVkIGluIGhlbHBpbmcsIHNvIHRoYXQncyBwcm9iYWJseSB0aGUgYmVzdCB3
YXkgdG8gZG8gaXQuDQoNCkknbSBsZWF2aW5nIGZvciBMQ0EgaW4gYW4gaG91ciBvciBzbywgc28g
ZnVydGhlciByZXNwb25zZXMgZnJvbSBtZSB0byB0aGlzIHRocmVhZCBhcmUgdW5saWtlbHkgOy0p
DQo=
