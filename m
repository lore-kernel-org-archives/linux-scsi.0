From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] libfc: fix seconds_since_last_reset miscalculation
Date: Tue, 15 Nov 2016 14:50:17 +0000
Message-ID: <1479221415.3426.3.camel@sandisk.com>
References: <1478594694-98847-1-git-send-email-jthumshirn@suse.de>
         <BLUPR02MB16830DECB29262BACBA94FA681A60@BLUPR02MB1683.namprd02.prod.outlook.com>
         <20161115091840.7cldqui4dpi7nrz5@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161115091840.7cldqui4dpi7nrz5@linux-x5ow.site>
Content-Language: en-US
Content-ID: <D1FC0D35B66DEB4A817571E764DC31B2@namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE2LTExLTE1IGF0IDEwOjE4ICswMTAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IE9uIFR1ZSwgTm92IDA4LCAyMDE2IGF0IDAzOjA0OjQzUE0gKzAwMDAsIEJhcnQgVmFu
IEFzc2NoZSB3cm90ZToNCj4gPiBJIHRoaW5rIHRoZSBhYm92ZSBjb2RlIHdpbGwgbWlzY2FsY3Vs
YXRlIHNlY29uZHNfc2luY2VfbGFzdF9yZXNldA0KPiA+IGlmwqANCj4gPiAnamlmZmllcycgd3Jh
cHMgYXJvdW5kIGFmdGVyIGFuIGxwb3J0IGhhcyBiZWVuIGNyZWF0ZWQgYW5kIGJlZm9yZcKgDQo+
ID4gc2Vjb25kc19zaW5jZV9sYXN0X3Jlc2V0IGlzIGNvbXB1dGVkLiBTaG91bGRuJ3QNCj4gPiBz
ZWNvbmRzX3NpbmNlX2xhc3RfcmVzZXTCoA0KPiA+IGJlIGNvbXB1dGVkIGFzIGZvbGxvd3M/DQo+
ID4gDQo+ID4gCWZjX3N0YXRzLT5zZWNvbmRzX3NpbmNlX2xhc3RfcmVzZXQgPSAoamlmZmllcyAt
IGJvb3RfdGltZSkgLw0KPiA+IEhaOw0KPiANCj4gQnV0IHdoYXQgaGFwcGVucyB3aGVuIGppZmZp
ZXMgLSBib290X3RpbWUgYmVjb21lcyBuZWdhdGl2ZT8gVGhlbiB3ZQ0KPiByZWludHJvZHVjZSB0
aGUgYnVnIGFnYWluIGFuZCBoYXZlICdmY29lYWRtIC1zJyBzaG93IHdlaXJkIHZhbHVlcy4NCg0K
SGVsbG8gSm9oYW5uZXMsDQoNCklmIHlvdXIgY29uY2VybiBpcyBhYm91dCAnamlmZmllcycgd3Jh
cHBpbmcgYXJvdW5kIG9uIDMyLWJpdCBzeXN0ZW1zDQp0aGVuIHlvdSBzaG91bGQgdXNlIGdldF9q
aWZmaWVzXzY0KCkuIGdldF9qaWZmaWVzXzY0KCkgLSBib290X3RpbWUNCmNhbid0IGJlY29tZSBu
ZWdhdGl2ZS4gSXQgbmFtZWx5IHRha2VzIHNldmVyYWwgbWlsbGlvbiB5ZWFycyBiZWZvcmUgYQ0K
NjQtYml0IEhaIGNvdW50ZXIgd3JhcHMgYXJvdW5kLg0KDQpCYXJ0Lg==
