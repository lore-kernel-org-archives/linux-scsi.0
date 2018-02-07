From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Wed, 7 Feb 2018 16:59:24 +0000
Message-ID: <1518022762.2870.20.camel@wdc.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
         <20180205152035.15016-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26383 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbeBGQ7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2018 11:59:30 -0500
In-Reply-To: <20180205152035.15016-3-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <EF0F674A2796384D8FE7F0DA79F5C122@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "arun.easi@cavium.com" <arun.easi@cavium.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>

T24gTW9uLCAyMDE4LTAyLTA1IGF0IDIzOjIwICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gZGlm
ZiAtLWdpdCBhL2Jsb2NrL2Jsay1tcS1zY2hlZC5jIGIvYmxvY2svYmxrLW1xLXNjaGVkLmMNCj4g
aW5kZXggNTVjMGE3NDViNDI3Li4zODViYmVjNzM4MDQgMTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2Js
ay1tcS1zY2hlZC5jDQo+ICsrKyBiL2Jsb2NrL2Jsay1tcS1zY2hlZC5jDQo+IEBAIC04MSw2ICs4
MSwxNyBAQCBzdGF0aWMgYm9vbCBibGtfbXFfc2NoZWRfcmVzdGFydF9oY3R4KHN0cnVjdCBibGtf
bXFfaHdfY3R4ICpoY3R4KQ0KPiAgCX0gZWxzZQ0KPiAgCQljbGVhcl9iaXQoQkxLX01RX1NfU0NI
RURfUkVTVEFSVCwgJmhjdHgtPnN0YXRlKTsNCj4gIA0KPiArCS8qIG5lZWQgdG8gcmVzdGFydCBh
bGwgaHcgcXVldWVzIGZvciBnbG9iYWwgdGFncyAqLw0KPiArCWlmIChoY3R4LT5mbGFncyAmIEJM
S19NUV9GX0dMT0JBTF9UQUdTKSB7DQo+ICsJCXN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4MjsN
Cj4gKwkJaW50IGk7DQo+ICsNCj4gKwkJcXVldWVfZm9yX2VhY2hfaHdfY3R4KGhjdHgtPnF1ZXVl
LCBoY3R4MiwgaSkNCj4gKwkJCWlmIChibGtfbXFfcnVuX2h3X3F1ZXVlKGhjdHgyLCB0cnVlKSkN
Cj4gKwkJCQlyZXR1cm4gdHJ1ZTsNCj4gKwkJcmV0dXJuIGZhbHNlOw0KPiArCX0NCj4gKw0KPiAg
CXJldHVybiBibGtfbXFfcnVuX2h3X3F1ZXVlKGhjdHgsIHRydWUpOw0KPiAgfQ0KDQpUaGlzIG5l
dyBsb29wIGxvb2tzIG1pc3BsYWNlZCB0byBtZS4gSWYgYm90aCB0aGUgQkxLX01RX0ZfR0xPQkFM
X1RBR1MgYW5kIHRoZQ0KQkxLX01RX0ZfVEFHX1NIQVJFRCBmbGFncyBhcmUgc2V0IHRoZW4gdGhl
IG91dGVyIGxvb3AgaW4gYmxrX21xX3NjaGVkX3Jlc3RhcnQoKQ0KYW5kIHRoZSBpbm5lciBsb29w
IGluIGJsa19tcV9zY2hlZF9yZXN0YXJ0X2hjdHgoKSB3aWxsIGNhdXNlIG1vcmUgY2FsbHMgb2YN
CmJsa19tcV9ydW5faHdfcXVldWUoKSB0aGFuIG5lY2Vzc2FyeS4gSGF2ZSB5b3UgY29uc2lkZXJl
ZCB0byBtZXJnZSB0aGUgYWJvdmUNCmxvb3AgaW50byBibGtfbXFfc2NoZWRfcmVzdGFydCgpPw0K
DQpUaGFua3MsDQoNCkJhcnQuDQoNCg0K
