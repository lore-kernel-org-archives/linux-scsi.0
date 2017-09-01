From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 7/8] scsi: sd_zbc: Disable zone write locking with scsi-mq
Date: Fri, 1 Sep 2017 16:26:46 +0000
Message-ID: <1504283205.14386.36.camel@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
         <20170901113631.12323-8-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901113631.12323-8-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <D5073DBFCBDE394D8800AE105392C263@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDIwOjM2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gSW4gdGhlIGNhc2Ugb2YgYSBaQkMgZGlzayB1c2VkIHdpdGggc2NzaS1tcSwgem9uZSB3cml0
ZSBsb2NraW5nIGRvZXMNCj4gbm90IHByZXZlbnQgd3JpdGUgcmVvcmRlcmluZyBpbiBzZXF1ZW50
aWFsIHpvbmVzLiBVbmxpa2UgdGhlIGxlZ2FjeQ0KPiBjYXNlLCB6b25lIGxvY2tpbmcgY2FuIG9u
bHkgYmUgZG9uZSBhZnRlciB0aGUgY29tbWFuZCByZXF1ZXN0IGlzDQo+IHJlbW92ZWQgZnJvbSB0
aGUgc2NoZWR1bGVyIGRpc3BhdGNoIHF1ZXVlLiBUaGF0IGlzLCBhdCB0aGUgdGltZSBvZg0KPiB6
b25lIGxvY2tpbmcsIHRoZSB3cml0ZSBjb21tYW5kIG1heSBhbHJlYWR5IGJlIG91dCBvZiBvcmRl
ci4NCj4gDQo+IERpc2FibGUgem9uZSB3cml0ZSBsb2NraW5nIGluIHNkX3piY193cml0ZV9sb2Nr
X3pvbmUoKSBpZiB0aGUgZGlzayBpcw0KPiB1c2VkIHdpdGggc2NzaS1tcS4gV3JpdGUgb3JkZXIg
Z3VhcmFudGVlcyBjYW4gYmUgcHJvdmlkZWQgYnkgYW4NCj4gYWRhcHRlZCBJL08gc2NoZWR1bGVy
Lg0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29t
Pg0KDQo=
