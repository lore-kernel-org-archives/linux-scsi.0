From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V7 2/6] block: tracking request allocation with
 q_usage_counter
Date: Mon, 2 Oct 2017 16:01:34 +0000
Message-ID: <1506960093.3368.21.camel@wdc.com>
References: <20170930061214.10622-1-ming.lei@redhat.com>
         <20170930061214.10622-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930061214.10622-3-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <7FF5B73D0B66DC47B4ABED19655D30E2@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "cavery@redhat.com" <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE3LTA5LTMwIGF0IDE0OjEyICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQEAg
LTEzOTUsMTYgKzE0MDEsMjEgQEAgc3RhdGljIHN0cnVjdCByZXF1ZXN0ICpibGtfb2xkX2dldF9y
ZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLA0KPiAgCQkJCQkgICB1bnNpZ25lZCBpbnQg
b3AsIGdmcF90IGdmcF9tYXNrKQ0KPiAgew0KPiAgCXN0cnVjdCByZXF1ZXN0ICpycTsNCj4gKwlp
bnQgcmV0ID0gMDsNCj4gIA0KPiAgCVdBUk5fT05fT05DRShxLT5tcV9vcHMpOw0KPiAgDQo+ICAJ
LyogY3JlYXRlIGlvYyB1cGZyb250ICovDQo+ICAJY3JlYXRlX2lvX2NvbnRleHQoZ2ZwX21hc2ss
IHEtPm5vZGUpOw0KPiAgDQo+ICsJcmV0ID0gYmxrX3F1ZXVlX2VudGVyKHEsICEoZ2ZwX21hc2sg
JiBfX0dGUF9ESVJFQ1RfUkVDTEFJTSkpOw0KPiArCWlmIChyZXQpDQo+ICsJCXJldHVybiBFUlJf
UFRSKHJldCk7DQoNCkNhbiB0aGUgYWJvdmUgYmxrX3F1ZXVlX2VudGVyKCkgY2FsbCBibG9jayBp
ZiB0aGUgUkVRX05PV0FJVCBmbGFnIGhhcyBiZWVuDQpzZXQgaW4gdGhlIG9wIGFyZ3VtZW50IGFu
ZCBlLmcuIGdmcF9tYXNrID09IEdGUF9LRVJORUw/IElmIHNvLCBpc24ndCB0aGF0IGENCmJ1Zz8N
Cg0KQmFydC4=
