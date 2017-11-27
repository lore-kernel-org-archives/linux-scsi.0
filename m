From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Ensure that the SCSI error handler gets woken up
Date: Mon, 27 Nov 2017 21:39:07 +0000
Message-ID: <1511818746.2993.14.camel@wdc.com>
References: <20171123010505.9603-1-bart.vanassche@wdc.com>
         <20171123081802.GA20705@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171123081802.GA20705@lst.de>
Content-Language: en-US
Content-ID: <C771531CFB24444CB81BA9D848182F66@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTIzIGF0IDA5OjE4ICswMTAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYyBiL2RyaXZlcnMv
c2NzaS9zY3NpX2Vycm9yLmMNCj4gPiBpbmRleCA1ZTg5MDQ5ZTliNGUuLmY3ZjAxNGM3NTVkNyAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jDQo+ID4gKysrIGIvZHJp
dmVycy9zY3NpL3Njc2lfZXJyb3IuYw0KPiA+IEBAIC02MSw5ICs2MSwxMCBAQCBzdGF0aWMgaW50
IHNjc2lfZWhfdHJ5X3N0dShzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKTsNCj4gPiAgc3RhdGljIGlu
dCBzY3NpX3RyeV90b19hYm9ydF9jbWQoc3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSAqLA0KPiA+
ICAJCQkJIHN0cnVjdCBzY3NpX2NtbmQgKik7DQo+ID4gIA0KPiA+IC0vKiBjYWxsZWQgd2l0aCBz
aG9zdC0+aG9zdF9sb2NrIGhlbGQgKi8NCj4gPiAgdm9pZCBzY3NpX2VoX3dha2V1cChzdHJ1Y3Qg
U2NzaV9Ib3N0ICpzaG9zdCkNCj4gPiAgew0KPiA+ICsJbG9ja2RlcF9hc3NlcnRfaGVsZChzaG9z
dC0+aG9zdF9sb2NrKTsNCj4gPiArDQo+ID4gIAlpZiAoYXRvbWljX3JlYWQoJnNob3N0LT5ob3N0
X2J1c3kpID09IHNob3N0LT5ob3N0X2ZhaWxlZCkgew0KPiA+ICAJCXRyYWNlX3Njc2lfZWhfd2Fr
ZXVwKHNob3N0KTsNCj4gPiAgCQl3YWtlX3VwX3Byb2Nlc3Moc2hvc3QtPmVoYW5kbGVyKTsNCj4g
DQo+IENhbiB5b3Ugc3BsaXQgdGhpcyBjb21tZW50IHRvIGFzc2VydCBjaGFuZ2UgaW50byBhIHNl
cGFyYXRlIHBhdGNoLCBwbGVhc2U/DQoNCkhlbGxvIENocmlzdG9waC4NCg0KVGhhbmtzIGZvciB0
aGUgcmV2aWV3LiBJIHdpbGwgbWFrZSB0aGUgcmVxdWVzdGVkIGNoYW5nZS4NCg0KQmFydC4=
