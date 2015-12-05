From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Sat, 5 Dec 2015 00:11:22 +0000
Message-ID: <1449274282.16905.107.camel@intel.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
	 <1449271801.27077.25.camel@HansenPartnership.com>
	 <1449273524.16905.103.camel@intel.com>
	 <1449273995.27077.32.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449273995.27077.32.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <5241250A30FA2A47B745697897F6A4D0@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "neilb@suse.com" <neilb@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE1LTEyLTA0IGF0IDE2OjA2IC0wODAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IE9uIEZyaSwgMjAxNS0xMi0wNCBhdCAyMzo1OCArMDAwMCwgVmVybWEsIFZpc2hhbCBMIHdy
b3RlOg0KPiA+IE9uIEZyaSwgMjAxNS0xMi0wNCBhdCAxNTozMCAtMDgwMCwgSmFtZXMgQm90dG9t
bGV5IHdyb3RlOg0KPiA+IFsuLi5dDQo+ID4gPiA+ICsgKiBXZSByZXR1cm4NCj4gPiA+ID4gKyAq
wqDCoDAgaWYgdGhlcmUgYXJlIG5vIGtub3duIGJhZCBibG9ja3MgaW4gdGhlIHJhbmdlDQo+ID4g
PiA+ICsgKsKgwqAxIGlmIHRoZXJlIGFyZSBrbm93biBiYWQgYmxvY2sgd2hpY2ggYXJlIGFsbCBh
Y2tub3dsZWRnZWQNCj4gPiA+ID4gKyAqIC0xIGlmIHRoZXJlIGFyZSBiYWQgYmxvY2tzIHdoaWNo
IGhhdmUgbm90IHlldCBiZWVuDQo+ID4gPiA+IGFja25vd2xlZGdlZA0KPiA+ID4gPiBpbiBtZXRh
ZGF0YS4NCj4gPiA+ID4gKyAqIHBsdXMgdGhlIHN0YXJ0L2xlbmd0aCBvZiB0aGUgZmlyc3QgYmFk
IHNlY3Rpb24gd2Ugb3ZlcmxhcC4NCj4gPiA+ID4gKyAqLw0KPiA+ID4gDQo+ID4gPiBUaGlzIGNv
bW1lbnQgc2hvdWxkIGJlIGRvY2Jvb2suDQo+ID4gDQo+ID4gQXBwbGljYWJsZSB0byBhbGwgeW91
ciBjb21tZW50cyAtIChhbmQgdGhleSBhcmUgYWxsIHZhbGlkKSwgSSBzaW1wbHkNCj4gPiBjb3Bp
ZWQgb3ZlciBhbGwgdGhpcyBmcm9tIG1kLiBJJ20gaGFwcHkgdG8gbWFrZSB0aGUgY2hhbmdlcyB0
bw0KPiA+IGNvbW1lbnRzLA0KPiA+IGFuZCB0aGUgb3RoZXIgdHdvIHRoaW5ncyAoc2VlIGJlbG93
KSBpZiB0aGF0J3MgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvDQo+ID4gLS0NCj4gPiBJIGp1c3QgdHJp
ZWQgdG8ga2VlcCBteSBvd24gY2hhbmdlcyB0byB0aGUgb3JpZ2luYWwgbWQgYmFkYmxvY2tzDQo+
ID4gY29kZQ0KPiA+IG1pbmltYWwuDQo+ID4gV291bGQgaXQgYmUgYmV0dGVyIChmb3IgcmV2aWV3
LWFiaWxpdHkpIGlmIEkgbWFkZSB0aGVzZSBjaGFuZ2VzIGluIGENCj4gPiBuZXcNCj4gPiBwYXRj
aCBvbiB0b3Agb2YgdGhpcywgb3Igc2hvdWxkIEkganVzdCBzcXVhc2ggdGhlbSBpbnRvIHRoaXMg
b25lPw0KPiANCj4gSWYgeW91IHdlcmUgbW92aW5nIGl0LCB0aGF0IG1pZ2h0IGJlIGFwcHJvcHJp
YXRlLsKgwqBIb3dldmVyLCB0aGlzIGlzDQo+IGVmZmVjdGl2ZWx5IG5ldyBjb2RlIGJlY2F1c2Ug
eW91J3JlIG5vdCByZW1vdmluZyB0aGUgb3JpZ2luYWwsIHNvIHdlDQo+IHNob3VsZCBiZWdpbiBh
dCBsZWFzdCB3aXRoIGEgY29oZXJlbnQgQVBJLiAoaS5lLiBjb3JyZWN0aW9ucyB0byB0aGUNCj4g
b3JpZ2luYWwgcGF0Y2ggcmF0aGVyIHRoYW4gaW5jcmVtZW50YWwpLg0KPiANCg0KUGF0Y2ggMyBk
b2VzIHJlbW92ZSB0aGUgb3JpZ2luYWwgY29kZSwgYnV0IHllcywgSSBhZ3JlZS4gV2lsbCBzZW5k
DQphbm90aGVyIHZlcnNpb24uDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KCS1WaXNoYWw=
