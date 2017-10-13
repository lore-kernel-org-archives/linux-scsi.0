From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 17:47:43 +0000
Message-ID: <1507916862.13345.27.camel@wdc.com>
References: <20171012183704.22326-1-ming.lei@redhat.com>
         <20171012183704.22326-5-ming.lei@redhat.com>
         <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
         <20171013001919.GA24715@ming.t460p>
         <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
         <20171013160731.GA30899@ming.t460p> <1507912260.13345.0.camel@wdc.com>
         <20171013164519.GF30899@ming.t460p> <1507914527.13345.17.camel@wdc.com>
         <20171013172950.GA32319@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013172950.GA32319@ming.t460p>
Content-Language: en-US
Content-ID: <59B6EA3A0E12B7428147CE4C685DCC66@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE3LTEwLTE0IGF0IDAxOjI5ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gLT5j
YW5fcXVldWUgaXMgc2l6ZSBvZiB0aGUgd2hvbGUgdGFnIHNwYWNlIHNoYXJlZCBieSBhbGwgTFVO
cywgbG9va3MgaXQgaXNuJ3QNCj4gcmVhc29uYWJsZSB0byBpbmNyZWFzZSBjbWRfcGVyX2x1biB0
byAuY2FuX3F1ZXVlLg0KDQpTb3JyeSBidXQgSSBkaXNhZ3JlZS4gU2V0dGluZyBjbWRfcGVyX2x1
biB0byBhIHZhbHVlIGxvd2VyIHRoYW4gY2FuX3F1ZXVlDQp3aWxsIHJlc3VsdCBpbiBzdWJvcHRp
bWFsIHBlcmZvcm1hbmNlIGlmIHRoZXJlIGlzIG9ubHkgYSBzaW5nbGUgTFVOIHBlciBTQ1NJDQpo
b3N0LiBJZiB0aGVyZSBhcmUgbXVsdGlwbGUgTFVOcyBwZXIgU0NTSSBob3N0IHRoZW4gdGhlIGJs
ay1tcSBjb3JlIHRyYWNrcw0KdGhlIG51bWJlciBvZiBhY3RpdmUgTFVOcyB0aHJvdWdoIHRoZSBi
bGtfbXFfdGFncy5hY3RpdmVfcXVldWVzIHZhcmlhYmxlLg0KU2VlIGFsc28gaGN0eF9tYXlfcXVl
dWUoKS4gVGhlIGNvbW1lbnQgYWJvdmUgdGhhdCBmdW5jdGlvbiBpcyBhcyBmb2xsb3dzOg0KDQov
Kg0KICogRm9yIHNoYXJlZCB0YWcgdXNlcnMsIHdlIHRyYWNrIHRoZSBudW1iZXIgb2YgY3VycmVu
dGx5IGFjdGl2ZSB1c2Vycw0KICogYW5kIGF0dGVtcHQgdG8gcHJvdmlkZSBhIGZhaXIgc2hhcmUg
b2YgdGhlIHRhZyBkZXB0aCBmb3IgZWFjaCBvZiB0aGVtLg0KICovDQoNCkJUVywgdGhlIGliX3Ny
cCBpbml0aWF0b3IgZHJpdmVyIHNldHMgY21kX3Blcl9sdW4gdG8gY2FuX3F1ZXVlIGFuZCBpcyBh
YmxlDQp0byBhY2hpZXZlIG1vcmUgdGhhbiBvbmUgbWlsbGlvbiBJT1BTIGV2ZW4gaW4gdGVzdHMg
d2l0aCBtdWx0aXBsZSBMVU5zIHBlcg0KU0NTSSBob3N0Lg0KDQpCYXJ0Lg==
