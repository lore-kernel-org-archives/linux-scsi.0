From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [linux-devel:devel-lkp-ib03-powerpc-201501140043 30/31]
 drivers/scsi/scsi_logging.c:254:3: error: format not a string literal and no
 format arguments
Date: Wed, 14 Jan 2015 15:26:22 +0000
Message-ID: <1421249215.2083.7.camel@parallels.com>
References: <201501140133.IhMp3BqI%fengguang.wu@intel.com>
	 <1421170252.2076.9.camel@parallels.com>
	 <20150114094043.GA21820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:60355 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbbANP06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 10:26:58 -0500
In-Reply-To: <20150114094043.GA21820@infradead.org>
Content-Language: en-US
Content-ID: <D852A0C4CCD20F46965AEC682B616E88@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kbuild-all@01.org" <kbuild-all@01.org>, "fengguang.wu@intel.com" <fengguang.wu@intel.com>, "hare@suse.de" <hare@suse.de>

T24gV2VkLCAyMDE1LTAxLTE0IGF0IDAxOjQwIC0wODAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gVHVlLCBKYW4gMTMsIDIwMTUgYXQgMDU6MzA6MjBQTSArMDAwMCwgSmFtZXMgQm90
dG9tbGV5IHdyb3RlOg0KPiA+IEp1c3QgZm9yIGV2ZXJ5b25lJ3Mgc2FrZSB0aGUgcHJvYmxlbSBp
cyBwcmludGsgZm9ybWF0IHN0cmluZ3MgKGFuZCBhbGwNCj4gPiB0aGUgdGhpbmdzIHRoYXQgaW5k
aXJlY3QgdGhlcmUsIGxpa2UgcHJfeHh4IGFuZCBkZXZfcHJpbnRrKS4gIFdlIG11c3QNCj4gPiBu
ZXZlciBwYXNzIGEgbXV0YWJsZSBzdHJpbmcgZGlyZWN0bHkgdG8gcHJpbnRrIGJlY2F1c2Ugb2Yg
dGhlIG1heWhlbQ0KPiA+IHRoYXQgd291bGQgcmVzdWx0IGlmIGl0cyBjb250ZW50cyB3ZXJlIGFs
dGVyZWQgYnkgdGhlIHVzZXIgKGJlY2F1c2Ugc29tZQ0KPiA+IG9mIHRoZSB0aGluZ3Mgd2UgZG8g
aW4gc3RyaW5nIGZvcm1hdCBwYXJzaW5nIGFyZSB2ZXJ5IGRhbmdlcm91cyksIG1ha2luZw0KPiA+
IHRoaXMgYSBwb3RlbnRpYWwgc2VjdXJpdHkgaXNzdWUuICBPbmx5IGV2ZXIgcGFzcyBzdGF0aWMg
c3RyaW5ncyAoaW4gdGhlDQo+ID4gcm8gc2VjdGlvbikgdG8gcHJpbnRrIGZvcm1hdHMuDQo+ID4g
DQo+ID4gU28gdGhpcyBpcyB3cm9uZzoNCj4gPiANCj4gPiBkZXZfcHJpbnRrKEtFUk5fSU5GTywg
ZGV2LCBsb2didWYpOw0KPiA+IA0KPiA+IFRoaXMgaXMgY29ycmVjdDoNCj4gPiANCj4gPiBkZXZf
cHJpbnRrKEtFUk5fSU5GTywgZGV2LCAiJXMiLCBsb2didWYpOw0KPiANCj4gSW4gdGhpcyBjYXNl
IHRoZSBsb2didWcgY29tZXMgZnJvbSBhY3R1YWxseSBkb2luZyBqdXN0IHRoYXQgc3RyaW5nDQo+
IGZvcm1hdHRpbmcgZWFybGllciBpbiB0aGUgZnVuY3Rpb24sIHNvIGl0IHByYWN0aWNlIGl0J3Mg
aGFybWxlcy4NCg0KSG93ZXZlciwgaXQncyBhIHdyb25nIHBhdHRlcm4gd2hpY2ggd2UgbmVlZCB0
byBhdm9pZC4gIE90aGVyd2lzZSB3ZSBnZXQNCm9uZSBwYXRjaCBldmVyeSBmZXcgbW9udGhzICJm
aXhpbmciIGl0IGFuZCBhIGNvdXBsZSBvZiBhbm5veWVkIGVtYWlscw0KZnJvbSBzZWN1cml0eSBw
ZW9wbGUgd2hvIHJlLWRpZCB0aGUgYW5hbHlzaXMuDQoNCj4gSXQgd291bGQgYmUgdXNlZnVsIHRv
IGhhdmUgYSBkZXZfcHV0cyB0byBhdm9pZCB0aGF0IHJlaW50ZXJwcmV0YXRpb24gYWdhaW4sDQo+
IHRob3VnaC4NCg0KSSdtIGZhaXJseSBjZXJ0YWluLCBnaXZlbiBhIGxvdCBvZiB3aGF0IGhhcyBn
b25lIG9uIGluIG91ciBzdHJpbmcNCnByb2Nlc3NvcnMgdGhhdCBkZXZfcHV0cygpIHdvdWxkIGdl
dCBpbXBsZW1lbnRlZCB2aWEgZGV2X3ByaW50ayAuLi4NCg0KSmFtZXMNCg0K
