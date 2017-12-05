From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Tue, 5 Dec 2017 00:29:59 +0000
Message-ID: <1512433798.2795.45.camel@wdc.com>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
         <20171204224200.GA6888@ming.t460p> <1512427697.2795.14.camel@wdc.com>
         <20171204230151.GD6888@ming.t460p> <1512430346.2795.34.camel@wdc.com>
         <20171205002040.GA8365@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171205002040.GA8365@ming.t460p>
Content-Language: en-US
Content-ID: <C4AAD46528033940830C9C04ECE50BA9@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEyLTA1IGF0IDA4OjIwICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQWxz
byBpdCBpcyBhIGJpdCBvZGQgdG8gc2VlIHJlcXVlc3QgaW4gaGN0eC0+ZGlzcGF0Y2ggbm93LCBh
bmQgaXQgY2FuIG9ubHkNCj4gaGFwcGVuIG5vdyB3aGVuIHNjc2lfdGFyZ2V0X3F1ZXVlX3JlYWR5
KCkgcmV0dXJucyBmYWxzZSwgc28gSSBndWVzcyB5b3UgYXBwbHkNCj4gc29tZSBjaGFuZ2Ugb24g
dGFyZ2V0LT5jYW5fcXVldWUoc3VjaCBhcyBzZXR0aW5nIGl0IGFzIDEgaW4gc3JwL2liIGNvZGUN
Cj4gbWFudWFsbHkpPw0KDQpZZXMsIGJ1dCB0aGF0IGhhZCBhbHJlYWR5IGJlZW4gbWVudGlvbmVk
LiBGcm9tIHRoZSBlLW1haWwgYXQgdGhlIHN0YXJ0IG9mDQp0aGlzIGUtbWFpbCB0aHJlYWQ6ICJD
aGFuZ2UgdGhlIFNSUCBpbml0aWF0b3Igc3VjaCB0aGF0IFNDU0kgdGFyZ2V0IHF1ZXVlDQpkZXB0
aCBpcyBsaW1pdGVkIHRvIDEuIiBUaGUgY2hhbmdlcyBJIG1hZGUgaW4gdGhlIFNSUCBpbml0aWF0
b3IgYXJlIHRoZSBzYW1lDQphcyB0aG9zZSBkZXNjcmliZWQgaW4gdGhlIGZvbGxvd2luZyBtZXNz
YWdlIGZyb20gYWJvdXQgb25lIG1vbnRoIGFnbzoNCmh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xp
c3RzL2xpbnV4LXNjc2kvbXNnMTE0NzIwLmh0bWwuDQoNCkJhcnQu
