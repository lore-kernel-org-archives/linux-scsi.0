From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v2 8/8] scsi: ufs: connect to RPMB subsystem
Date: Fri, 8 Apr 2016 20:33:28 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B54225677@hasmsx108.ger.corp.intel.com>
References: <1459768284-26997-1-git-send-email-tomas.winkler@intel.com>
 <1459768284-26997-9-git-send-email-tomas.winkler@intel.com>
 <5704CE0B.2010700@synopsys.com> <1460063682.4468.7.camel@intel.com>
 <5707EA97.2050408@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916AbcDHUdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 16:33:41 -0400
In-Reply-To: <5707EA97.2050408@synopsys.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "luto@kernel.org" <luto@kernel.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Usyskin, Alexander" <alexander.usyskin@intel.com>

PiANCj4gT24gNC83LzIwMTYgMTA6MTUgUE0sIFdpbmtsZXIsIFRvbWFzIHdyb3RlOg0KPiA+IE9u
IFdlZCwgMjAxNi0wNC0wNiBhdCAwOTo1MSArMDEwMCwgSm9hbyBQaW50byB3cm90ZToNCj4gPj4g
SGkhDQo+ID4+DQo+ID4+IE9uIDQvNC8yMDE2IDEyOjExIFBNLCBUb21hcyBXaW5rbGVyIHdyb3Rl
Og0KPiA+Pj4gUmVnaXN0ZXIgVUZTIFJQTUIgTFVOIHdpdGggdGhlIFJQTUIgc3Vic3lzdGVtIGFu
ZCBwcm92aWRlDQo+ID4+PiBpbXBsZW1lbnRhdGlvbiBmb3IgdGhlIFJQTUIgYWNjZXNzIG9wZXJh
dGlvbnMuIFJQTUIgcGFydGl0aW9uIGlzDQo+ID4+PiBhY2Nlc3NlZCB2aWEgYSBzZXF1ZW5jZSBv
ZiBzZWN1cml0eSBwcm90b2NvbCBpbiBhbmQgc2VjdXJpdHkNCj4gPj4+IHByb3RvY29sIG91dCBj
b21tYW5kcyB3aXRoIFVGUyBzcGVjaWZpYyBwYXJhbWV0ZXJzLiBUaGlzIG11bHRpIHN0ZXANCj4g
Pj4+IHByb2Nlc3MgaXMgYWJzdHJhY3RlZCBpbnRvIDQgYmFzaWMgUlBNQiBjb21tYW5kcy4NCj4g
Pj4NCj4gPj4gW3NuaXBdDQo+ID4+DQo+ID4+PiAgCSAqICJVRlMgZGV2aWNlIiBXLUxVLg0KPiA+
Pj4gIAkgKi8NCj4gPj4+ICAJc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2X3Vmc19kZXZpY2U7DQo+
ID4+PiArCXN0cnVjdCBzY3NpX2RldmljZSAqc2Rldl91ZnNfcnBtYjsNCj4gPj4+DQo+ID4+PiAg
CWVudW0gdWZzX2Rldl9wd3JfbW9kZSBjdXJyX2Rldl9wd3JfbW9kZTsNCj4gPj4+ICAJZW51bSB1
aWNfbGlua19zdGF0ZSB1aWNfbGlua19zdGF0ZTsNCj4gPj4+DQo+ID4+DQo+ID4+IEkgaGF2ZSBh
IFVGUyBkZXZpY2UgZW11bGF0b3IgdGhhdCBoYXMgdGhlIFJQTUIgY2FwYWJpbGl0eS4gV2hhdCBh
cmUNCj4gPj4gdGhlIGV4cGVjdGVkIGdvb2QgcmVzdWx0cyBmb3IgbWUgdG8gdmFsaWRhdGU/DQo+
ID4NCj4gPiBIaSBKb2FvLCB0aGFua3MgZm9yIHRoYXQuIEknbSBhdHRhY2hpbmcgYW4gYXJjaGl2
ZSB3aXRoIGZldyBiYXNpYw0KPiA+IHNhbXBsZXMgdmlhIHVzZXIgc3BhY2UgaW50ZXJmYWNlLg0K
PiA+IFlvdSBzaG91bGQgcnVuIHRoZSBwcm9ncmFtIGtleSBmaXJzdCAocHJvZ3JhbS1rZXkuc2gp
LCBqdXN0IGRvbid0IGRvDQo+ID4gaXQgb24gYSByZWFsIGRldmljZSBpdCdzIG9uZSBpbiBsaWZl
IHRpbWUgb3BlcmF0aW9uLg0KPiA+DQo+IA0KPiBNYW5hZ2VkIHRvIGNyb3NzLWNvbXBpbGUgdG8g
QVJDIGFuZCBleGVjdXRlIHlvdXIgdGVzdCBhcHAgaW4gbXkgcGxhdGZvcm0uDQo+IEkgbWFkZSBp
dCBpbiBCdWlsZHJvb3QsIHNvIEkgaGF2ZSB0aGUgcGF0Y2hlcyB0byBlbmFibGUgdGhlIHRvb2wg
Y3Jvc3MtDQo+IGNvbXBpbGF0aW9uIGlmIG5lY2Vzc2FyeSBpbiB0aGUgZnV0dXJlLg0KPg0KDQpT
b3VuZHMgbGlrZSBmdW4gOikgIA0KSSd2ZSBqdXN0IHRyaWVkIHRvIGZvbGxvdyB0aGUgc3RhbmRh
cmQgdW5kZXIgdG9vbHMsIHRob3VnaCB0aGlzIGl0J3Mgbm90IHNvbWV0aGluZyByZWFsbHkgZ2Vu
ZXJpYyB3aGljaCB3YXMgc3VycGlzaW5nIHRvIG1lIGFzIHRoaXMgaXMgaW4gdGhlIGtlcm5lbCB0
cmVlLg0KDQo+IFRoZSB0b29sIGV4ZWN1dGlvbiBnaXZlcyBubyBlcnJvcnMsIGJ1dCBhbHNvIG5v
IGluZm8uIEkgc3VnZ2VzdCB5b3UgaGFkIHN1Y2Nlc3MNCj4gaW5mbyBhbmQgbWF5YmUgc29tZSBz
dGF0aXN0aWMgKGUuZy4gYnl0ZXMgcmVhZCBvciB3cml0dGVuKS4NCg0KSXQgZGlkIGhhdmUgc29t
ZSB2ZXJib3NlIHByaW50IG91dHMgb24gYm90aCBlbmRzLCBidXQgSSd2ZSBjbGVhbmVkIGl0IG91
dC4gSXQgd2FzIG1lYW50IHRvIGJlIGFuIGV4YW1wbGUgcmF0aGVyIHRoYW4gdW5pdCB0ZXN0aW5n
IHRvb2wsIGJ1dCB3ZSBjYW4gcmVwdXJwb3NlIGl0Lg0KDQpUaGFua3MNClRvbWENCiANClRoYW5r
cw0KVG9tYXMNCg==
