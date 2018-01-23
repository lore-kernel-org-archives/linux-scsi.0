From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 16:54:02 +0000
Message-ID: <1516726441.3339.16.camel@wdc.com>
References: <20180122033550.27855-1-ming.lei@redhat.com>
         <20180122033550.27855-2-ming.lei@redhat.com>
         <1516639793.2545.14.camel@sandisk.com> <20180123005728.GB4411@ming.t460p>
         <54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
         <20180123162605.GD13277@ming.t460p>
         <4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
         <20180123164109.GF13277@ming.t460p> <1516726030.3339.14.camel@wdc.com>
         <20180123164951.GG13277@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180123164951.GG13277@ming.t460p>
Content-Language: en-US
Content-ID: <5234ECADC9B1AE48988FCE389E9E3048@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDAwOjQ5ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VHVlLCBKYW4gMjMsIDIwMTggYXQgMDQ6NDc6MTFQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIFdlZCwgMjAxOC0wMS0yNCBhdCAwMDo0MSArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBDb3VsZCB5b3UgZXhwbGFpbiB3aGVyZSB0byBjYWxsIGNhbGxfcmN1KCk/ICBj
YWxsX3JjdSgpIGNhbid0IGJlIHVzZWQgaW4NCj4gPiA+IElPIHBhdGggYXQgYWxsLg0KPiA+IA0K
PiA+IENhbiB5b3UgZXhwbGFpbiB3aGF0IG1ha2VzIHlvdSB0aGluayB0aGF0IGNhbGxfcmN1KCkg
Y2FuJ3QgYmUgdXNlZCBpbiB0aGUNCj4gPiBJL08gcGF0aD8gQXMgeW91IGtub3cgY2FsbF9yY3Uo
KSBpbnZva2VzIGEgZnVuY3Rpb24gYXN5bmNocm9ub3VzbHkuIEZyb20NCj4gPiBEb2N1bWVudGF0
aW9uL1JDVS9EZXNpZ24vUmVxdWlyZW1lbnRzL1JlcXVpcmVtZW50cy5odG1sOg0KPiA+IA0KPiA+
ICAgVGhlIDx0dD5jYWxsX3JjdSgpPC90dD4gZnVuY3Rpb24gbWF5IGJlIHVzZWQgaW4gYSBudW1i
ZXIgb2YNCj4gPiAgIHNpdHVhdGlvbnMgd2hlcmUgbmVpdGhlciA8dHQ+c3luY2hyb25pemVfcmN1
KCk8L3R0PiBub3INCj4gPiAgIDx0dD5zeW5jaHJvbml6ZV9yY3VfZXhwZWRpdGVkKCk8L3R0PiB3
b3VsZCBiZSBsZWdhbCwNCj4gPiAgIGluY2x1ZGluZyB3aXRoaW4gcHJlZW1wdC1kaXNhYmxlIGNv
ZGUsIDx0dD5sb2NhbF9iaF9kaXNhYmxlKCk8L3R0PiBjb2RlLA0KPiA+ICAgaW50ZXJydXB0LWRp
c2FibGUgY29kZSwgYW5kIGludGVycnVwdCBoYW5kbGVycy4NCj4gDQo+IE9LLCBzdXBwb3NlIGl0
IGlzIHRydWUsIGRvIHlvdSB3YW50IHRvIGNoYW5nZSBtb3N0IG9mIFNUU19SRVNPVVJDRSBpbg0K
PiBhbGwgZHJpdmVycyB0byB0aGlzIHdheT8gV2h5IGNhbid0IHdlIHVzZSB0aGUgZ2VuZXJpYyBh
bmQgc2ltcGxlIGFwcHJvYWNoDQo+IGluIHRoaXMgcGF0Y2g/DQoNClBsZWFzZSByZXJlYWQgbXkg
cHJvcG9zYWwuIEkgZGlkIG5vdCBwcm9wb3NlIHRvIGNoYW5nZSBhbnkgYmxvY2sgZHJpdmVycy4N
CldoYXQgSSBwcm9wb3NlZCBpcyB0byBjaGFuZ2UgdGhlIGJsa19tcV9kZWxheV9ydW5faHdfcXVl
dWUoKSBpbXBsZW1lbnRhdGlvbg0Kc3VjaCB0aGF0IGl0IHVzZXMgY2FsbF9yY3UoKSBpbnN0ZWFk
IG9mIGtibG9ja2RfbW9kX2RlbGF5ZWRfd29ya19vbigpLg0KVGhhdCdzIGEgZ2VuZXJpYyBhbmQg
c2ltcGxlIGFwcHJvYWNoLg0KDQpCYXJ0Lg==
