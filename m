From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v3 1/2] Ensure that the SCSI error handler gets woken up
Date: Tue, 5 Dec 2017 16:19:50 +0000
Message-ID: <1512490788.2660.16.camel@wdc.com>
References: <20171204180624.18722-1-bart.vanassche@wdc.com>
         <20171204180624.18722-2-bart.vanassche@wdc.com>
         <8514bfc3-4d11-be94-eef4-82f48d436656@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <8514bfc3-4d11-be94-eef4-82f48d436656@virtuozzo.com>
Content-Language: en-US
Content-ID: <AF940AB62725124E864D3A8F052E66A0@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEyLTA1IGF0IDEzOjE4ICswMzAwLCBQYXZlbCBUaWtob21pcm92IHdyb3Rl
Og0KPiBPbiAxMi8wNC8yMDE3IDA5OjA2IFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4g
K3N0YXRpYyB2b2lkIHNjc2lfZWhfaW5jX2hvc3RfZmFpbGVkKHN0cnVjdCByY3VfaGVhZCAqaGVh
ZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QgPSBjb250YWluZXJfb2Yo
aGVhZCwgdHlwZW9mKCpzaG9zdCksIHJjdSk7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0K
PiA+ICsNCj4gPiArCXNwaW5fbG9ja19pcnFzYXZlKHNob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsN
Cj4gPiArCXNob3N0LT5ob3N0X2ZhaWxlZCsrOw0KPiANCj4gTWF5IGJlIHdlIG5lZWQgdG8gaW5j
cmVtZW50IGhvc3RfZmFpbGVkIGJlZm9yZSBjYWxsX3JjdSgpLCBzbyB0aGF0IGFsbCANCj4gcmN1
IHByb3RlY3RlZCByZWFkZXJzIGFscmVhZHkgc2VlIGEgY2hhbmdlIGF0IHRoZXNlIHBvaW50Pw0K
DQpTb3JyeSBidXQgSSBkb24ndCB0aGluayB0aGF0IHdvdWxkIHdvcmsuIElmIGhvc3RfZmFpbGVk
IHdvdWxkIGJlIGNoYW5nZWQgZmlyc3QNCnRoZW4gaXQgY2FuIGhhcHBlbiB0aGF0IHNjc2lfZGVj
X2hvc3RfYnVzeSgpIGVuY291bnRlcnMgdGhhdCB0aGUgaG9zdCBzdGF0ZSBpcw0KInJ1bm5pbmci
IGFuZCBoZW5jZSB0aGF0IGl0IHNraXBzIHRoZSBob3N0X2ZhaWxlZCBjaGVjay4gVGhhdCBjYW4g
cmVzdWx0IGluIGENCm1pc3NlZCBlcnJvciBoYW5kbGVyIHdha2V1cCwgd2hpY2ggaXMgd2hhdCB3
ZSB3YW50IHRvIGF2b2lkLg0KDQpCYXJ0Lg==
