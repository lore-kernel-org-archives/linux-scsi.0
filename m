From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 03/12] block: Add zoned block device information to
 request queue
Date: Fri, 15 Sep 2017 14:38:56 +0000
Message-ID: <1505486334.2852.8.camel@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
         <20170915100645.17999-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-4-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <94574B3ACA6EEE4CA39480AF40B3D5E0@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE5OjA2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gQEAgLTQ5Miw2ICs0OTcsMTAgQEAgc3RydWN0IHJlcXVlc3RfcXVldWUgew0KPiAgCXN0cnVj
dCBibGtfaW50ZWdyaXR5IGludGVncml0eTsNCj4gICNlbmRpZgkvKiBDT05GSUdfQkxLX0RFVl9J
TlRFR1JJVFkgKi8NCj4gIA0KPiArI2lmZGVmIENPTkZJR19CTEtfREVWX1pPTkVEDQo+ICsJc3Ry
dWN0IGJsa196b25lZAl6b25lZDsNCj4gKyNlbmRpZg0KPiArDQo+ICAjaWZkZWYgQ09ORklHX1BN
DQo+ICAJc3RydWN0IGRldmljZQkJKmRldjsNCj4gIAlpbnQJCQlycG1fc3RhdHVzOw0KPiBAQCAt
Nzg1LDYgKzc5NCwxMSBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBibGtfcXVldWVfem9u
ZV9zZWN0b3JzKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQ0KPiAgCXJldHVybiBibGtfcXVldWVf
aXNfem9uZWQocSkgPyBxLT5saW1pdHMuY2h1bmtfc2VjdG9ycyA6IDA7DQo+ICB9DQo+ICANCj4g
K3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGJsa19xdWV1ZV9ucl96b25lcyhzdHJ1Y3QgcmVx
dWVzdF9xdWV1ZSAqcSkNCj4gK3sNCj4gKwlyZXR1cm4gYmxrX3F1ZXVlX2lzX3pvbmVkKHEpID8g
cS0+em9uZWQubnJfem9uZXMgOiAwOw0KPiArfQ0KDQpEb2VzIHRoaXMgY29kZSBjb21waWxlIGNv
cnJlY3RseSBpZiBDT05GSUdfQkxLX0RFVl9aT05FRCBpcyBkaXNhYmxlZD8gU2hvdWxkDQp0aGUg
ZGVmaW5pdGlvbiBvZiBibGtfcXVldWVfbnJfem9uZXMoKSBwZXJoYXBzIGJlIHN1cnJvdW5kZWQg
YnkgI2lmZGVmDQpDT05GSUdfQkxLX0RFVl9aT05FRCAvICNlbmRpZj8NCg0KVGhhbmtzLA0KDQpC
YXJ0Lg==
