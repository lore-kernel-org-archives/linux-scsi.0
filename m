From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 3/8] scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
Date: Fri, 1 Sep 2017 16:08:55 +0000
Message-ID: <1504282134.14386.29.camel@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
         <20170901113631.12323-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901113631.12323-4-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <DC38DD42E1CCBA4290D716F1A21065BD@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDIwOjM2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gKy8qIFpvbmUgdHlwZXMgb2YgUkVQT1JUIFpPTkVTIHpvbmUgZGVzY3JpcHRvcnMgKi8NCj4g
K2VudW0gemJjX3pvbmVfdHlwZSB7DQo+ICsJWkJDX1pPTkVfVFlQRV9DT05WCQk9IDB4MSwNCj4g
KwlaQkNfWk9ORV9UWVBFX1NFUVdSSVRFX1JFUQk9IDB4MiwNCj4gKwlaQkNfWk9ORV9UWVBFX1NF
UVdSSVRFX1BSRUYJPSAweDMsDQo+ICsJLyogMHg0IHRvIDB4ZiBhcmUgcmVzZXJ2ZWQgKi8NCj4g
KwlaQkNfWk9ORV9UWVBFX1JFU0VSVkVECQk9IDB4NCwNCj4gK307DQoNCkhlbGxvIERhbWllbiwN
Cg0KU2luY2Ugbm8gY29kZSBpcyB1c2luZyBaQkNfWk9ORV9UWVBFX1JFU0VSVkVELCBpcyB0aGUg
Y29tbWVudCBhYm91dCByZXNlcnZlZA0KdmFsdWVzIHN1ZmZpY2llbnQgYW5kIGNhbiB0aGUgZGVm
aW5pdGlvbiBvZiBaQkNfWk9ORV9UWVBFX1JFU0VSVkVEIGJlIGxlZnQgb3V0Pw0KDQpBbnl3YXk6
DQoNClJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+
DQoNCg==
