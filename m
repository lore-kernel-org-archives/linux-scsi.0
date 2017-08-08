From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Tue, 8 Aug 2017 15:07:50 +0000
Message-ID: <1502204867.2250.1.camel@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41109 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdHHPIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 11:08:45 -0400
In-Reply-To: <20170808041746.31341-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <A49632C8638F874EB662110573395419@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

T24gVHVlLCAyMDE3LTA4LTA4IGF0IDEzOjE3ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gUmVsZWFzaW5nIHRoZSB3cml0ZSBsb2NrIG9mIGEgem9uZSB3aGVuIHRoZSB3cml0ZSBjb21t
bmFuZCB0aGF0DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgXl5eXl5eXl4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBjb21tYW5kPw0KPiBhY3F1aXJlZCB0aGUgbG9jayBjb21wbGV0ZXMgY2FuIGNh
dXNlIGRlYWRsb2NrcyB3aXRoIHNjc2ktbXEgZHVlIHRvDQo+IHBvdGVudGlhbCBxdWV1ZSByZW9y
ZGVyaW5nIGlmIHRoZSBsb2NrIG93bmluZyByZXF1ZXN0IGlzIHJlcXVldWVkIGFuZA0KPiBub3Qg
ZXhlY3V0ZWQuDQoNClBsZWFzZSBub3RlIHRoYXQgZXZlbiB3aXRoIHNjc2ktc3EgcmVxdWV1ZWlu
ZyBjYW4gY2F1c2UgcmVxdWVzdCByZW9yZGVyaW5nLg0KDQo+IFNpbmNlIHNkX3VuaW5pdF9jbW5k
KCkgaXMgYWx3YXlzIGNhbGxlZCB3aGVuIGEgcmVxdWVzdCBpcyByZXF1ZXVlZCwNCj4gY2FsbCBz
ZF96YmNfd3JpdGVfdW5sb2NrX3pvbmUoKSBmcm9tIHRoYXQgZnVuY3Rpb24gZm9yIHdyaXRlIHJl
cXVlc3RzDQo+IHRoYXQgYWNxdWlyZWQgYSB6b25lIGxvY2suIEFjcXVpc2l0aW9uIG9mIGEgem9u
ZSBsb2NrIGJ5IGEgd3JpdGUgY29tbWFuZA0KPiBpcyBpbmRpY2F0ZWQgdXNpbmcgdGhlIG5ldyBj
b21tYW5kIGZsYWcgU0NNRF9aT05FX1dSSVRFX0xPQ0suDQoNCkhlbGxvIERhbWllbiwNCg0KU2lu
Y2UgdGhpcyBwYXRjaCBkaWZmZXJzIHNsaWdodGx5IGZyb20gdGhlIHZlcnNpb24gdGhhdCB3YXMg
cG9zdGVkIGEgZmV3DQpkYXlzIGFnbywgc2hvdWxkIGEgInYyIiBsYWJlbCBoYXZlIGJlZW4gYWRk
ZWQgdG8gdGhlIHN1YmplY3QgYW5kIHNob3VsZCBhDQpjaGFuZ2Vsb2cgaGF2ZSBiZWVuIGluY2x1
ZGVkPyBBbnl3YXk6DQoNClJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNz
Y2hlQHdkYy5jb20+DQoNCg==
