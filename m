From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] sd_zbc: Disable zone locking with scsi-mq enabled
Date: Tue, 1 Aug 2017 13:46:08 +0000
Message-ID: <1501595166.2800.1.camel@wdc.com>
References: <20170801093917.4131-1-damien.lemoal@wdc.com>
         <20170801093917.4131-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:17178 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbdHANq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 09:46:57 -0400
In-Reply-To: <20170801093917.4131-3-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <7FDE5DCEEBE11645B750FA9082F98BD5@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

T24gVHVlLCAyMDE3LTA4LTAxIGF0IDE4OjM5ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZF96YmMuYyBiL2RyaXZlcnMvc2NzaS9zZF96
YmMuYw0KPiBpbmRleCA5Njg1NWRmOWY0OWQuLjc4ZmI1MWEzN2U4NiAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9zY3NpL3NkX3piYy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zZF96YmMuYw0KPiBA
QCAtNTI4LDE1ICs1MjgsMjAgQEAgc3RhdGljIGludCBzZF96YmNfY2hlY2tfem9uZV9zaXplKHN0
cnVjdCBzY3NpX2Rpc2sgKnNka3ApDQo+ICANCj4gIHN0YXRpYyBpbnQgc2RfemJjX3NldHVwKHN0
cnVjdCBzY3NpX2Rpc2sgKnNka3ApDQo+ICB7DQo+ICsJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEg
PSBzZGtwLT5kaXNrLT5xdWV1ZTsNCj4gIA0KPiAgCS8qIGNodW5rX3NlY3RvcnMgaW5kaWNhdGVz
IHRoZSB6b25lIHNpemUgKi8NCj4gLQlibGtfcXVldWVfY2h1bmtfc2VjdG9ycyhzZGtwLT5kaXNr
LT5xdWV1ZSwNCj4gKwlibGtfcXVldWVfY2h1bmtfc2VjdG9ycyhxLA0KPiAgCQkJbG9naWNhbF90
b19zZWN0b3JzKHNka3AtPmRldmljZSwgc2RrcC0+em9uZV9ibG9ja3MpKTsNCj4gIAlzZGtwLT56
b25lX3NoaWZ0ID0gaWxvZzIoc2RrcC0+em9uZV9ibG9ja3MpOw0KPiAgCXNka3AtPm5yX3pvbmVz
ID0gc2RrcC0+Y2FwYWNpdHkgPj4gc2RrcC0+em9uZV9zaGlmdDsNCj4gIAlpZiAoc2RrcC0+Y2Fw
YWNpdHkgJiAoc2RrcC0+em9uZV9ibG9ja3MgLSAxKSkNCj4gIAkJc2RrcC0+bnJfem9uZXMrKzsN
Cj4gIA0KPiArCS8qIERvIG5vdCB1c2Ugem9uZSBsb2NraW5nIGluIG1xIGNhc2UgKi8NCj4gKwlp
ZiAocS0+bXFfb3BzKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiAgCWlmICghc2RrcC0+em9uZXNf
d2xvY2spIHsNCj4gIAkJc2RrcC0+em9uZXNfd2xvY2sgPSBrY2FsbG9jKEJJVFNfVE9fTE9OR1Mo
c2RrcC0+bnJfem9uZXMpLA0KPiAgCQkJCQkgICAgc2l6ZW9mKHVuc2lnbmVkIGxvbmcpLA0KDQpI
ZWxsbyBEYW1pZW4sDQoNCkFyZSB5b3UgYXdhcmUgdGhhdCB0aGUgYmxrLXNxIC8gc2NzaS1zcSBj
b2RlIHdpbGwgYmUgcmVtb3ZlZCBvbmNlIGFsbCBibG9jaw0KZHJpdmVycyBoYXZlIGJlZW4gY29u
dmVydGVkPyBBcmUgeW91IGF3YXJlIHRoYXQgd2UgZG9uJ3Qgd2FudCBhbnkgZGlmZmVyZW5jZXMN
CmluIGJlaGF2aW9yIGxpa2UgdGhlIGFib3ZlIGJldHdlZW4gdGhlIHNpbmdsZSBxdWV1ZSBhbmQg
bXVsdGlxdWV1ZSBwYXRocz8gQ2FuDQp5b3UgY2hlY2sgd2hldGhlciB0aGUgcGF0Y2ggc2VyaWVz
IE1pbmcgTGVpIHBvc3RlZCBlYXJsaWVyIHRoaXMgd2VlayBzb2x2ZXMNCnRoZSBmcmVxdWVudCBy
ZXF1ZXVlaW5nPyBTZWUgYWxzbyAiW1BBVENIIDAwLzE0XSBibGstbXEtc2NoZWQ6IGZpeCBTQ1NJ
LU1RDQpwZXJmb3JtYW5jZSByZWdyZXNzaW9uIiAoaHR0cDovL21hcmMuaW5mby8/bD1saW51eC1i
bG9jayZtPTE1MDE1MTk4OTkxNTc3NikuDQoNClRoYW5rcywNCg0KQmFydC4=
