From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Thu, 8 Feb 2018 15:25:51 +0000
Message-ID: <1518103548.6826.2.camel@wdc.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
         <20180205152035.15016-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31846 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbeBHPZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2018 10:25:55 -0500
In-Reply-To: <20180205152035.15016-3-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <AFC12A461DD545469C2AD1FDAB780514@namprd04.prod.outlook.com>
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
CXJldHVybiBibGtfbXFfcnVuX2h3X3F1ZXVlKGhjdHgsIHRydWUpOw0KPiAgfQ0KDQpJdCBzZWVt
cyB3ZWlyZCB0byBtZSB0aGF0IG5vIG1hdHRlciBmb3Igd2hpY2ggaGFyZHdhcmUgcXVldWUgYSBy
ZXN0YXJ0IGlzDQpyZXF1ZXN0ZWQgKHRoZSBoY3R4IGFyZ3VtZW50KSB0aGF0IHRoZSBhYm92ZSBs
b29wIHN0YXJ0cyB3aXRoIGV4YW1pbmluZw0KdGhlIGhhcmR3YXJlIHF1ZXVlIHdpdGggaW5kZXgg
MC4gV2lsbCB0aGlzIGNhdXNlIGZhaXJuZXNzIGFuZC9vciBjYWNoZQ0KbGluZSBib3VuY2luZyBw
cm9ibGVtcz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCg0KDQo=
