From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 8/9] block: allow to allocate req with REQF_PREEMPT when
 queue is frozen
Date: Thu, 31 Aug 2017 22:50:25 +0000
Message-ID: <1504219824.31872.74.camel@wdc.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
         <20170831172728.15817-9-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170831172728.15817-9-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <C72C391C474E67418BC14ADACAF47A38@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "oleksandr@natalenko.name" <oleksandr@natalenko.name>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDAxOjI3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQEAg
LTE0MTMsOSArMTQxNCwxNyBAQCBzdGF0aWMgc3RydWN0IHJlcXVlc3QgKmJsa19vbGRfZ2V0X3Jl
cXVlc3Qoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsDQo+ICAJLyogY3JlYXRlIGlvYyB1cGZyb250
ICovDQo+ICAJY3JlYXRlX2lvX2NvbnRleHQoZ2ZwX21hc2ssIHEtPm5vZGUpOw0KPiAgDQo+IC0J
cmV0ID0gYmxrX3F1ZXVlX2VudGVyKHEsICEoZ2ZwX21hc2sgJiBfX0dGUF9ESVJFQ1RfUkVDTEFJ
TSkpOw0KPiArCS8qDQo+ICsJICogV2hlbiBxdWV1ZSBpcyBmcm96ZW4sIHdlIHN0aWxsIG5lZWQg
dG8gYWxsb2NhdGUgcmVxIGZvcg0KPiArCSAqIFJFUUZfUFJFRU1QVC4NCj4gKwkgKi8NCj4gKwlp
ZiAoKGZsYWdzICYgQkxLX01RX1JFUV9QUkVFTVBUKSAmJiBibGtfcXVldWVfaXNfZnJvemVuKHEp
KQ0KPiArCQlibGtfcXVldWVfZW50ZXJfbGl2ZShxKTsNCj4gKwllbHNlDQo+ICsJCXJldCA9IGJs
a19xdWV1ZV9lbnRlcihxLCAhKGdmcF9tYXNrICYgX19HRlBfRElSRUNUX1JFQ0xBSU0pKTsNCg0K
SGVsbG8gTWluZywNCg0KU29ycnkgYnV0IEkgZG91YnQgdGhhdCBjYWxsaW5nIGJsa19xdWV1ZV9l
bnRlcl9saXZlKCkgZnJvbSBpbnNpZGUNCmJsa19vbGRfZ2V0X3JlcXVlc3QoKSBpcyBzYWZlLiBD
YWxsaW5nIGJsa19xdWV1ZV9lbnRlcl9saXZlKCkgaXMgb25seSBzYWZlDQpiZWZvcmUgYSByZXF1
ZXN0IHF1ZXVlIGhhcyBiZWVuIG1hcmtlZCBkZWFkLiBXaGF0IHByZXZlbnRzIGEga2VybmVsIHRo
cmVhZA0KdGhhdCBob2xkcyBhIHJlZmVyZW5jZSBvbiBhIHJlcXVlc3QgcXVldWUgYW5kIHRoYXQg
aXMgcnVubmluZyBjb25jdXJyZW50bHkNCndpdGggYmxrX2NsZWFudXBfcXVldWUoKSB0byBjYWxs
IGJsa19vbGRfZ2V0X3JlcXVlc3QoKSBhZnRlciBhIHF1ZXVlIGhhcw0KYmVlbiBtYXJrZWQgZGVh
ZD8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
