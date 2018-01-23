From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 22:01:37 +0000
Message-ID: <1516744896.3339.41.camel@wdc.com>
References: <20180122033550.27855-2-ming.lei@redhat.com>
         <1516639793.2545.14.camel@sandisk.com> <20180123005728.GB4411@ming.t460p>
         <54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
         <20180123162605.GD13277@ming.t460p>
         <4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
         <20180123164109.GF13277@ming.t460p> <1516726030.3339.14.camel@wdc.com>
         <20180123164951.GG13277@ming.t460p> <1516726441.3339.16.camel@wdc.com>
         <20180123165914.GH13277@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180123165914.GH13277@ming.t460p>
Content-Language: en-US
Content-ID: <97EF74315CD02B45A5CC56CFFAE8F6D2@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDAwOjU5ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gSG93
IGlzIHRoYXQgZW5vdWdoIHRvIGZpeCB0aGUgSU8gaGFuZyB3aGVuIGRyaXZlciByZXR1cm5zIFNU
U19SRVNPVVJDRQ0KPiBhbmQgdGhlIHF1ZXVlIGlzIGlkbGU/IElmIHlvdSB3YW50IHRvIGZvbGxv
dyBwcmV2aW91cyBkbS1ycSdzIHdheSBvZg0KPiBjYWxsIGJsa19tcV9kZWxheV9ydW5faHdfcXVl
dWUoKSBpbiAucXVldWVfcnEoKSwgdGhlIHNhbWUgdHJpY2sgbmVlZA0KPiB0byBiZSBhcHBsaWVk
IHRvIG90aGVyIGRyaXZlcnMgdG9vLCByaWdodD8NCj4gDQo+IFVuZm9ydHVuYXRlbHkgbW9zdCBv
ZiBTVFNfUkVTT1VSQ0UgZG9uJ3QgdXNlIHRoaXMgdHJpY2ssIGJ1dCB0aGV5IG5lZWQNCj4gdG8g
YmUgaGFuZGxlZC4NCj4gDQo+IFRoZSBwYXRjaCBvZiAnYmxrLW1xOiBpbnRyb2R1Y2UgQkxLX1NU
U19ERVZfUkVTT1VSQ0UnIGNhbiBmaXggYWxsIHRoZXNlDQo+IGNhc2VzLg0KDQpUaGUgZ29hbCBv
ZiBteSBwcm9wb3NhbCB3YXMgdG8gYWRkcmVzcyB0aGUgcmFjZSBiZXR3ZWVuIHJ1bm5pbmcgdGhl
IHF1ZXVlIGFuZA0KYWRkaW5nIHJlcXVlc3RzIGJhY2sgdG8gdGhlIGRpc3BhdGNoIHF1ZXVlIG9u
bHkuIFJlZ2FyZGluZyB0aGUgSS9PIGhhbmdzIHRoYXQNCmNhbiBvY2N1ciBpZiBhIGJsb2NrIGRy
aXZlciByZXR1cm5zIEJMS19TVFNfUkVTT1VSQ0U6IHNpbmNlIGFsbCBvZiB0aGVzZSBjYW4NCmJl
IGFkZHJlc3NlZCBieSBpbnNlcnRpbmcgYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZSgpIGNhbGxz
IGluIHRoZSBhZmZlY3RlZA0KYmxvY2sgZHJpdmVycyBJIHByZWZlciB0byBtb2RpZnkgdGhlIGJs
b2NrIGRyaXZlcnMgaW5zdGVhZCBvZiBtYWtpbmcgdGhlDQpibGstbXEgY29yZSBldmVuIG1vcmUg
Y29tcGxpY2F0ZWQuDQoNClRoYW5rcywNCg0KQmFydC4=
