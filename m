From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V6 12/14] block: mq-deadline: Introduce zone locking
 support
Date: Mon, 2 Oct 2017 23:12:44 +0000
Message-ID: <1506985963.3368.60.camel@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
         <20171002071535.8007-13-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171002071535.8007-13-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <2325C7815BC8B447B3D37B28F9A1F707@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE3LTEwLTAyIGF0IDE2OjE1ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gRm9yIGEgd3JpdGUgcmVxdWVzdCB0byBhIHpvbmVkIGJsb2NrIGRldmljZSwgbG9jayB0aGUg
cmVxdWVzdCB0YXJnZXQNCj4gem9uZSB1cG9uIHJlcXVlc3QgZGlzcGxhdGNoLiBUaGUgem9uZSBp
cyB1bmxvY2tlZCBlaXRoZXIgd2hlbiB0aGUNCiAgICAgICAgICAgICAgICAgICAgXl5eXl5eXl5e
DQogICAgICAgICAgICAgICAgICAgIGRpc3BhdGNoPw0KPiByZXF1ZXN0IGNvbXBsZXRlcyBvciB3
aGVuIHRoZSByZXF1ZXN0IGlzIHJlcXVldWVkIChpbnNlcnRlZCkuDQoNCkFueXdheToNCg0KUmV2
aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8QmFydC5WYW5Bc3NjaGVAd2RjLmNvbT4NCg==
