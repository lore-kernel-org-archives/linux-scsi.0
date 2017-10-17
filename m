From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 5/8] target: Use sgl_alloc_order() and sgl_free()
Date: Tue, 17 Oct 2017 14:31:11 +0000
Message-ID: <1508250670.3596.2.camel@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
         <20171016224940.1332-6-bart.vanassche@wdc.com>
         <c5e05f84-2602-5c3f-521e-6f35601011cf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c5e05f84-2602-5c3f-521e-6f35601011cf@suse.de>
Content-Language: en-US
Content-ID: <0A526A2A2C450348B2ACC36910B4F3D2@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTE3IGF0IDA4OjE0ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIDEwLzE3LzIwMTcgMTI6NDkgQU0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBb
IC4uLiBdDQo+ID4gIHZvaWQgdGFyZ2V0X2ZyZWVfc2dsKHN0cnVjdCBzY2F0dGVybGlzdCAqc2ds
LCBpbnQgbmVudHMpDQo+ID4gIHsNCj4gPiAtCXN0cnVjdCBzY2F0dGVybGlzdCAqc2c7DQo+ID4g
LQlpbnQgY291bnQ7DQo+ID4gLQ0KPiA+IC0JZm9yX2VhY2hfc2coc2dsLCBzZywgbmVudHMsIGNv
dW50KQ0KPiA+IC0JCV9fZnJlZV9wYWdlKHNnX3BhZ2Uoc2cpKTsNCj4gPiAtDQo+ID4gLQlrZnJl
ZShzZ2wpOw0KPiA+ICsJc2dsX2ZyZWUoc2dsKTsNCj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9M
KHRhcmdldF9mcmVlX3NnbCk7DQo+ID4gIA0KPiA+IEBAIC0yNDIzLDQyICsyNDE3LDEwIEBAIGlu
dA0KPiA+ICB0YXJnZXRfYWxsb2Nfc2dsKHN0cnVjdCBzY2F0dGVybGlzdCAqKnNnbCwgdW5zaWdu
ZWQgaW50ICpuZW50cywgdTMyIGxlbmd0aCwNCj4gPiAgCQkgYm9vbCB6ZXJvX3BhZ2UsIGJvb2wg
Y2hhaW5hYmxlKQ0KPiA+ICB7DQo+ID4gLQlbIC4uLiBdDQo+ID4gKwkqc2dsID0gc2dsX2FsbG9j
X29yZGVyKGxlbmd0aCwgMCwgY2hhaW5hYmxlLCBnZnAsIG5lbnRzKTsNCj4gPiArCXJldHVybiAq
c2dsID8gMCA6IC1FTk9NRU07DQo+ID4gIH0NCj4gPiAgRVhQT1JUX1NZTUJPTCh0YXJnZXRfYWxs
b2Nfc2dsKTsNCj4gPiAgDQo+ID4gVGhlIGNhbGxpbmcgY29udmVudGlvbiBmcm9tIHRhcmdldF9h
bGxvY19zZ2woKSBpcyBkZWNpZGVkbHkgZG9kZ3kuDQo+IA0KPiBDYW4ndCB3ZSBjb252ZXJ0IGl0
IGludG8gcmV0dXJuaW5nIHRoZSBzZ2wsIGFuZCByZW1vdmUgdGhlIGZpcnN0IHBhcmFtZXRlcj8N
Cg0KSGVsbG8gSGFubmVzLA0KDQpBbm90aGVyIG9wdGlvbiBpcyB0byByZW1vdmUgdGhlIHRhcmdl
dF9hbGxvY19zZ2woKSBhbmQgdGFyZ2V0X2ZyZWVfc2dsKCkgZnVuY3Rpb25zDQphbmQgdG8gbWFr
ZSBMSU8gdGFyZ2V0IGRyaXZlcnMgY2FsbCBzZ2xfYWxsb2Nfb3JkZXIoKSBhbmQgc2dsX2ZyZWVf
b3JkZXIoKSBkaXJlY3RseS4NCkRvIHlvdSBwZXJoYXBzIGhhdmUgYSBwcmVmZXJlbmNlIGZvciBv
bmUgb2YgdGhlc2UgdHdvIGFwcHJvYWNoZXM/DQoNClRoYW5rcywNCg0KQmFydC4=
