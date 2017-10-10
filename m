From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v8 03/10] md: Neither resync nor reshape while the system
 is frozen
Date: Tue, 10 Oct 2017 23:33:06 +0000
Message-ID: <1507678384.2815.80.camel@wdc.com>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
         <20171010210346.14574-4-bart.vanassche@wdc.com>
         <20171010223025.tda3lx64rdmugm54@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57360 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbdJJXdK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 19:33:10 -0400
In-Reply-To: <20171010223025.tda3lx64rdmugm54@kernel.org>
Content-Language: en-US
Content-ID: <781492102B26794FAA346C34B4DCF367@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "shli@kernel.org" <shli@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>

T24gVHVlLCAyMDE3LTEwLTEwIGF0IDE1OjMwIC0wNzAwLCBTaGFvaHVhIExpIHdyb3RlOg0KPiBP
biBUdWUsIE9jdCAxMCwgMjAxNyBhdCAwMjowMzozOVBNIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUg
d3JvdGU6DQo+ID4gU29tZSBwZW9wbGUgdXNlIHRoZSBtZCBkcml2ZXIgb24gbGFwdG9wcyBhbmQg
dXNlIHRoZSBzdXNwZW5kIGFuZA0KPiA+IHJlc3VtZSBmdW5jdGlvbmFsaXR5LiBTaW5jZSBpdCBp
cyBlc3NlbnRpYWwgdGhhdCBzdWJtaXR0aW5nIG9mDQo+ID4gbmV3IEkvTyByZXF1ZXN0cyBzdG9w
cyBiZWZvcmUgYSBoaWJlcm5hdGlvbiBpbWFnZSBpcyBjcmVhdGVkLA0KPiA+IGludGVycnVwdCB0
aGUgbWQgcmVzeW5jIGFuZCByZXNoYXBlIGFjdGlvbnMgaWYgdGhlIHN5c3RlbSBpcw0KPiA+IGJl
aW5nIGZyb3plbi4gTm90ZTogdGhlIHJlc3luYyBhbmQgcmVzaGFwZSB3aWxsIHJlc3RhcnQgYWZ0
ZXINCj4gPiB0aGUgc3lzdGVtIGlzIHJlc3VtZWQgYW5kIGEgbWVzc2FnZSBzaW1pbGFyIHRvIHRo
ZSBmb2xsb3dpbmcNCj4gPiB3aWxsIGFwcGVhciBpbiB0aGUgc3lzdGVtIGxvZzoNCj4gPiANCj4g
PiBtZDogbWQwOiBkYXRhLWNoZWNrIGludGVycnVwdGVkLg0KPiANCj4gV2hlcmUgZG8gd2UgcmVz
dGFydCByZXN5bmMgYW5kIHJlc2hhcGU/DQoNCkhlbGxvIFNoYW9odWEsDQoNCk15IHVuZGVyc3Rh
bmRpbmcgb2YgdGhlIG1kIGRyaXZlciBpcyBhcyBmb2xsb3dzOg0KLSBCZWZvcmUgYW55IHdyaXRl
IG9jY3VycywgbWRfd3JpdGVfc3RhcnQoKSBpcyBjYWxsZWQuIFRoYXQgZnVuY3Rpb24gY2xlYXJz
DQogIG1kZGV2LT5zYWZlbW9kZSBhbmQgY2hlY2tzIG1kZGV2LT5pbl9zeW5jLiBJZiB0aGF0IHZh
cmlhYmxlIGlzIHNldCwgaXQgaXMNCiAgY2xlYXJlZCBhbmQgbWRfd3JpdGVfc3RhcnQoKSB3YWtl
cyB1cCBtZGRldi0+dGhyZWFkIGFuZCB3YWl0cyB1bnRpbCB0aGUNCiAgc3VwZXJibG9jayBoYXMg
YmVlbiB3cml0dGVuIHRvIGRpc2suDQotIEFsbCBtZGRldi0+dGhyZWFkIGltcGxlbWVudGF0aW9u
cyBjYWxsIG1kX2NoZWNrX3JlY292ZXJ5KCkuIFRoYXQgZnVuY3Rpb24NCiAgdXBkYXRlcyB0aGUg
c3VwZXJibG9jayBieSBjYWxsaW5nIG1kX3VwZGF0ZV9zYigpIGlmIG5lZWRlZC4NCiAgbWRfY2hl
Y2tfcmVjb3ZlcnkoKSBhbHNvIHN0YXJ0cyBhIHJlc3luYyB0aHJlYWQgaWYgdGhlIGFycmF5IGlz
IG5vdCBpbg0KICBzeW5jLiBTZWUgYWxzbyB0aGUgY29tbWVudCBibG9jayBhYm92ZSBtZF9jaGVj
a19yZWNvdmVyeSgpLg0KLSBtZF9kb19zeW5jKCkgcGVyZm9ybXMgdGhlIHJlc3luYy4gSWYgaXQg
Y29tcGxldGVzIHN1Y2Nlc3NmdWxseSB0aGUNCiAgImluX3N5bmMiIHN0YXRlIGlzIHNldCAoc2V0
X2luX3N5bmMoKSkuIElmIGl0IGlzIGludGVycnVwdGVkIHRoZSAiaW5fc3luYyINCiAgc3RhdGUg
aXMgbm90IG1vZGlmaWVkLg0KLSBzdXBlcl85MF9zeW5jKCkgc2V0cyB0aGUgTURfU0JfQ0xFQU4g
ZmxhZyBpbiB0aGUgb24tZGlzayBzdXBlcmJsb2NrIGlmIHRoZQ0KICAiaW5fc3luYyIgZmxhZyBp
cyBzZXQuDQoNCkluIG90aGVyIHdvcmRzOiBpZiB0aGUgYXJyYXkgaXMgaW4gc3luYyB0aGUgTURf
U0JfQ0xFQU4gZmxhZyBpcyBzZXQgaW4gdGhlDQpvbi1kaXNrIHN1cGVyYmxvY2suIElmIGEgcmVz
eW5jIGlzIG5lZWRlZCB0aGF0IGZsYWcgaXMgbm90IHNldC4gVGhlDQpNRF9TQl9DTEVBTiBmbGFn
IGlzIGNoZWNrZWQgd2hlbiB0aGUgc3VwZXJibG9jayBpcyBsb2FkZWQuIElmIHRoYXQgZmxhZyBp
cw0Kbm90IHNldCBhIHJlc3luYyBpcyBzdGFydGVkLg0KDQpCYXJ0Lg0K
