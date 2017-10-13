From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 17:08:52 +0000
Message-ID: <1507914527.13345.17.camel@wdc.com>
References: <20171012183704.22326-1-ming.lei@redhat.com>
         <20171012183704.22326-5-ming.lei@redhat.com>
         <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
         <20171013001919.GA24715@ming.t460p>
         <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
         <20171013160731.GA30899@ming.t460p> <1507912260.13345.0.camel@wdc.com>
         <20171013164519.GF30899@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013164519.GF30899@ming.t460p>
Content-Language: en-US
Content-ID: <37B5F4E9924F7E46BBAEF13697FC56A3@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE3LTEwLTE0IGF0IDAwOjQ1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
RnJpLCBPY3QgMTMsIDIwMTcgYXQgMDQ6MzE6MDRQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIFNhdCwgMjAxNy0xMC0xNCBhdCAwMDowNyArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBBY3R1YWxseSBpdCBpcyBpbiBob3QgcGF0aCwgZm9yIGV4YW1wbGUsIGxwZmMg
YW5kIHFsYTJ4eCdzIHF1ZXVlIGRlcHRoIGlzIDMsDQo+ID4gDQo+ID4gU29ycnkgYnV0IEkgZG91
YnQgd2hldGhlciB0aGF0IGlzIGNvcnJlY3QuIE1vcmUgaW4gZ2VuZXJhbCwgSSBkb24ndCBrbm93
IGFueSBtb2Rlcm4NCj4gPiBzdG9yYWdlIEhCQSBmb3Igd2hpY2ggdGhlIGRlZmF1bHQgcXVldWUg
ZGVwdGggaXMgc28gbG93Lg0KPiANCj4gWW91IGNhbiBncmVwOg0KPiANCj4gW21pbmdAbWluZyBs
aW51eF0kIGdpdCBncmVwIC1uIGNtZF9wZXJfbHVuIC4vZHJpdmVycy9zY3NpLyB8IGdyZXAgLUUg
InFsYTJ4eHh8bHBmYyINCg0KU3VjaCBhIGxvdyBxdWV1ZSBkZXB0aCB3aWxsIHJlc3VsdCBpbiBz
dWJvcHRpbWFsIHBlcmZvcm1hbmNlIGZvciBhZGFwdGVycw0KdGhhdCBjb21tdW5pY2F0ZSBvdmVy
IGEgc3RvcmFnZSBuZXR3b3JrLiBJIHRoaW5rIHRoYXQncyBhIGJ1ZyBhbmQgdGhhdCBib3RoDQph
ZGFwdGVycyBzdXBwb3J0IG11Y2ggaGlnaGVyIGNtZF9wZXJfbHVuIHZhbHVlcy4NCg0KKCtKYW1l
cyBTbWFydCkNCg0KSmFtZXMsIGNhbiB5b3UgZXhwbGFpbiB1cyB3aHkgY29tbWl0IDQ0NWNmNGY0
ZDJhYSBkZWNyZWFzZWQgTFBGQ19DTURfUEVSX0xVTg0KZnJvbSAzMCB0byAzPyBXYXMgdGhhdCBw
ZXJoYXBzIGEgd29ya2Fyb3VuZCBmb3IgYSBidWcgaW4gYSBzcGVjaWZpYyB0YXJnZXQNCmltcGxl
bWVudGF0aW9uPw0KDQooK0hpbWFuc2h1IE1hZGhhbmkpDQoNCkhpbWFuc2h1LCBkbyB5b3UgcGVy
aGFwcyBrbm93IHdoZXRoZXIgaXQgaXMgc2FmZSB0byBpbmNyZWFzZSBjbWRfcGVyX2x1biBmb3IN
CnRoZSBxbGEyeHh4IGluaXRpYXRvciBkcml2ZXIgdG8gdGhlIHNjc2lfaG9zdC0+Y2FuX3F1ZXVl
IHZhbHVlPw0KDQo+IEV2ZW4gU1JQL0lCIGlzbid0IGJpZyB0b28sIGp1c3QgMzIuDQoNClRoZSBk
ZWZhdWx0IHZhbHVlIGZvciBpYl9zcnAgZm9yIGNtZF9wZXJfbHVuIGlzIDYyIGJ1dCB0aGF0IHZh
bHVlIGNhbiBiZQ0Kb3ZlcnJpZGRlbiBieSBzZWxlY3RpbmcgYW5vdGhlciB2YWx1ZSBpbiAvZXRj
L2RlZmF1bHQvc3JwX2RhZW1vbi5jb25mLiBOb3RlOg0KYSBsb3dlciB2YWx1ZSBpcyBzZWxlY3Rl
ZCBpZiBhZnRlciBTUlAgbG9naW4gaXQgYmVjb21lcyBjbGVhciB0aGF0IHRoZSB0YXJnZXQNCnF1
ZXVlIGRlcHRoIGlzIGxvd2VyIHRoYW4gdGhlIGNtZF9wZXJfbHVuIHZhbHVlIHJlcXVlc3RlZCBi
eSB0aGUgdXNlci4gVGhpcw0KaXMgYSBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb24gYW5kIGF2b2lk
cyB0aGF0IHRoZSBTUlAgdGFyZ2V0IHN5c3RlbSBoYXMgdG8NCnNlbmQgYmFjayBCVVNZIHJlc3Bv
bnNlcyB0byB0aGUgaW5pdGlhdG9yLg0KDQpCYXJ0Lg==
