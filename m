From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/9] percpu-refcount: introduce percpu_ref_is_dead()
Date: Fri, 1 Sep 2017 15:44:56 +0000
Message-ID: <1504280694.14386.18.camel@wdc.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
         <20170831172728.15817-2-ming.lei@redhat.com>
         <20170901135915.GD1599492@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901135915.GD1599492@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <AF69DED1834A2D459F54A4FF0ADDE3AE@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDA2OjU5IC0wNzAwLCBUZWp1biBIZW8gd3JvdGU6DQo+ID4g
Ky8qKg0KPiA+ICsgKiBwZXJjcHVfcmVmX2lzX2RlYWQgLSB0ZXN0IHdoZXRoZXIgYSBwZXJjcHUg
cmVmY291bnQgaXMga2lsbGVkDQo+ID4gKyAqIEByZWY6IHBlcmNwdV9yZWYgdG8gdGVzdA0KPiA+
ICsgKg0KPiA+ICsgKiBSZXR1cm5zICV0cnVlIGlmIEByZWYgaXMgZGVhZA0KPiA+ICsgKg0KPiA+
ICsgKiBUaGlzIGZ1bmN0aW9uIGlzIHNhZmUgdG8gY2FsbCBhcyBsb25nIGFzIEByZWYgaXMgYmV0
d2VlbiBpbml0IGFuZCBleGl0Lg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGlubGluZSBib29sIHBl
cmNwdV9yZWZfaXNfZGVhZChzdHJ1Y3QgcGVyY3B1X3JlZiAqcmVmKQ0KPiA+ICt7DQo+ID4gKwl1
bnNpZ25lZCBsb25nIF9fcGVyY3B1ICpwZXJjcHVfY291bnQ7DQo+ID4gKw0KPiA+ICsJaWYgKF9f
cmVmX2lzX3BlcmNwdShyZWYsICZwZXJjcHVfY291bnQpKQ0KPiA+ICsJCXJldHVybiBmYWxzZTsN
Cj4gPiArCXJldHVybiByZWYtPnBlcmNwdV9jb3VudF9wdHIgJiBfX1BFUkNQVV9SRUZfREVBRDsN
Cj4gPiArfQ0KPiANCj4gQ2FuIHlvdSBwbGVhc2UgZXhwbGFpbiB3aHkgcGVyY3B1X3JlZl9pc19k
eWluZygpIGlzbid0IGVub3VnaCBmb3IgeW91cg0KPiB1c2UgY2FzZT8NCg0KSGVsbG8gVGVqdW4s
DQoNClRoZSBhcHByb2FjaCBvZiB0aGUgd2hvbGUgc2VyaWVzIGlzIHdyb25nIHNvIEkgdGhpbmsg
dGhhdCB5b3UgY2FuIGlnbm9yZSB0aGlzIHBhdGNoLg0KDQpCYXJ0Lg==
