From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 16:20:08 +0000
Message-ID: <1510071607.2656.17.camel@wdc.com>
References: <20171104015534.32684-1-ming.lei@redhat.com>
         <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
         <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171107021125.GB15090@ming.t460p>
Content-Language: en-US
Content-ID: <CC0BE78F1BF06048BE95C2642441DC16@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTExLTA3IGF0IDEwOjExICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gSWYg
eW91IGNhbiByZXByb2R1Y2UsIHBsZWFzZSBwcm92aWRlIG1lIGF0IGxlYXN0IHRoZSBmb2xsb3dp
bmcgbG9nDQo+IGZpcnN0Og0KPiANCj4gCWZpbmQgL3N5cy9rZXJuZWwvZGVidWcvYmxvY2sgLW5h
bWUgdGFncyB8IHhhcmdzIGNhdCB8IGdyZXAgYnVzeQ0KPiANCj4gSWYgYW55IHBlbmRpbmcgcmVx
dWVzdHMgYXJuJ3QgY29tcGxldGVkLCBwbGVhc2UgcHJvdmlkZSB0aGUgcmVsYXRlZA0KPiBpbmZv
IGluIGRiZ2ZzIGFib3V0IHdoZXJlIGlzIHRoZSByZXF1ZXN0Lg0KDQpFdmVyeSB0aW1lIEkgcmFu
IHRoZSBhYm92ZSBvciBhIHNpbWlsYXIgY29tbWFuZCBpdHMgb3V0cHV0IHdhcyBlbXB0eS4gSQ0K
YXNzdW1lIHRoYXQncyBiZWNhdXNlIHRoZSBoYW5nIHVzdWFsbHkgb2NjdXJzIGluIGEgcGhhc2Ug
d2hlcmUgdGhlc2UgZGVidWdmcw0KYXR0cmlidXRlcyBlaXRoZXIgaGF2ZSBub3QgeWV0IGJlZW4g
Y3JlYXRlZCBvciBoYXZlIGFscmVhZHkgZGlzYXBwZWFyZWQuDQoNCkJhcnQu
