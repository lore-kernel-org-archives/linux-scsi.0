From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Thu, 14 Sep 2017 13:37:14 +0000
Message-ID: <1505396232.2898.13.camel@wdc.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
         <20170911111021.25810-9-ming.lei@redhat.com>
         <1505145834.2802.17.camel@wdc.com> <20170912034057.GC31533@ming.t460p>
         <20170913164803.GB10407@ming.t460p> <1505323703.2654.3.camel@wdc.com>
         <20170913174759.GB24862@ming.t460p> <1505329670.2404.10.camel@wdc.com>
         <20170914011532.GA16105@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170914011532.GA16105@ming.t460p>
Content-Language: en-US
Content-ID: <26205A36E1B7E84994D229BEFA998CA1@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "cavery@redhat.com" <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTA5LTE0IGF0IDA5OjE1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
V2VkLCBTZXAgMTMsIDIwMTcgYXQgMDc6MDc6NTNQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIFRodSwgMjAxNy0wOS0xNCBhdCAwMTo0OCArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBObywgdGhhdCBwYXRjaCBvbmx5IGNoYW5nZXMgYmxrX2luc2VydF9jbG9uZWRf
cmVxdWVzdCgpIHdoaWNoIGlzIHVzZWQNCj4gPiA+IGJ5IGRtLXJxKG1wYXRoKSBvbmx5LCBub3Ro
aW5nIHRvIGRvIHdpdGggdGhlIHJlcG9ydGVkIGlzc3VlIGR1cmluZw0KPiA+ID4gc3VzcGVuZCBh
bmQgc2VuZGluZyBTQ1NJIERvbWFpbiB2YWxpZGF0aW9uLg0KPiA+IA0KPiA+IFRoZXJlIG1heSBi
ZSBvdGhlciB3YXlzIHRvIGZpeCB0aGUgU0NTSSBkb21haW4gdmFsaWRhdGlvbiBjb2RlLg0KPiAN
Cj4gQWdhaW4gdGhlIGlzc3VlIGlzbid0IGluIGRvbWFpbiB2YWxpZGF0aW9uLCBpdCBpcyBpbiBx
dWllc2NlLA0KPiBzbyB3ZSBuZWVkIHRvIGZpeCBxdWllc2NlLCBpbnN0ZWFkIG9mIHdvcmtpbmcg
YXJvdW5kIHRyYW5zcG9ydF9zcGkuDQo+IA0KPiBBbHNvIFdoYXQgaXMgdGhlIG90aGVyIHdheT8g
V2h5IG5vdCB0aGlzIHBhdGNoc2V0Pw0KDQpTb3JyeSBpZiBJIGhhZCBub3QgbWFkZSB0aGlzIGNs
ZWFyIGVub3VnaCBidXQgSSBkb24ndCBsaWtlIHRoZSBhcHByb2FjaCBvZg0KdGhpcyBwYXRjaCBz
ZXJpZXMgc28gcGxlYXNlIGRvIG5vdCBleHBlY3QgYW55ICJSZXZpZXdlZC1ieSIgdGFncyBmcm9t
IG1lLg0KQXMgdGhlIGRpc2N1c3Npb24gYWJvdXQgdjQgb2YgdGhpcyBwYXRjaCBzZXJpZXMgbWFk
ZSBjbGVhciB0aGUgaW50ZXJhY3Rpb24NCmJldHdlZW4gYmxrX2NsZWFudXBfcXVldWUoKSBhbmQg
dGhlIGNoYW5nZXMgaW50cm9kdWNlZCBieSB0aGlzIHBhdGNoIHNlcmllcw0KaW4gYmxrX2dldF9y
ZXF1ZXN0KCkgaXMgc3VidGxlIGFuZCBoYXJkIHRvIGFuYWx5emUuIFRoZSBibGstbXEgY29yZSBp
cw0KYWxyZWFkeSBjb21wbGljYXRlZC4gSW4gbXkgdmlldyBwYXRjaGVzIHRoYXQgbWFrZSB0aGUg
YmxrLW1xIGNvcmUgc2ltcGxlcg0KYXJlIG11Y2ggbW9yZSB3ZWxjb21lIHRoYW4gcGF0Y2hlcyB0
aGF0IG1ha2UgdGhlIGJsay1tcSBjb3JlIG1vcmUNCmNvbXBsaWNhdGVkLg0KDQpTaW5jZSBJIGV4
cGVjdCB0aGF0IGFueSBmaXggZm9yIHRoZSBpbnRlcmFjdGlvbiBiZXR3ZWVuIGJsay1tcSBhbmQg
cG93ZXINCm1hbmFnZW1lbnQgd2lsbCBiZSBpbnRlZ3JhdGVkIGluIGtlcm5lbCB2NC4xNSBhdCBl
YXJsaWVzdCB0aGVyZSBpcyBubyByZWFzb24NCnRvIHJ1c2guIE15IHByb3Bvc2FsIGlzIHRvIHdh
aXQgYSBmZXcgd2Vla3MgYW5kIHRvIHNlZSB3aGV0aGVyIGFueW9uZSBjb21lcw0KdXAgd2l0aCBh
IGJldHRlciBzb2x1dGlvbi4NCg0KQmFydC4=
