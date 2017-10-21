From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v10 00/10] block, scsi, md: Improve suspend and resume
Date: Sat, 21 Oct 2017 18:31:08 +0000
Message-ID: <1508610667.9251.9.camel@wdc.com>
References: <20171017232630.4264-1-bart.vanassche@wdc.com>
         <11010777.WJQNYl18e6@natalenko.name> <1508340432.2540.4.camel@wdc.com>
         <3006499.SSja2RFHbQ@natalenko.name> <1508608776.9251.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52694 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932159AbdJUSbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Oct 2017 14:31:12 -0400
In-Reply-To: <1508608776.9251.6.camel@wdc.com>
Content-Language: en-US
Content-ID: <05FE37B553D41E4380FB2AD2D491B852@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>

T24gU2F0LCAyMDE3LTEwLTIxIGF0IDE3OjU5ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIFNhdCwgMjAxNy0xMC0yMSBhdCAxOToyMSArMDIwMCwgT2xla3NhbmRyIE5hdGFsZW5r
byB3cm90ZToNCj4gPiBJJ3ZlIGNoZXJyeS1waWNrZWQgdGhpcyBzZXJpZXMgZm9yIGN1cnJlbnQg
dXBzdHJlYW0vbWFzdGVyIGJyYW5jaCwgYW5kIGdvdA0KPiA+IHRoaXMgd2hpbGUgcGVyZm9ybWlu
ZyBhbm90aGVyIHN1c3BlbmQgdHJ5Og0KPiA+IA0KPiA+ID09PQ0KPiA+IFsgICA2Mi40MTU4OTBd
IEZyZWV6aW5nIG9mIHRhc2tzIGZhaWxlZCBhZnRlciAyMC4wMDcgc2Vjb25kcyAoMSB0YXNrcyBy
ZWZ1c2luZyANCj4gPiB0byBmcmVlemUsIHdxX2J1c3k9MCk6DQo+ID4gWyAgIDYyLjQyMTE1MF0g
eGZzYWlsZC9kbS03ICAgIEQgICAgMCAgIDI4OSAgICAgIDIgMHg4MDAwMDAwMA0KPiA+IFsgICA2
Mi40MjU4MDBdIENhbGwgVHJhY2U6DQo+ID4gWyAgIDYyLjQyODkwMl0gIF9fc2NoZWR1bGUrMHgy
MzkvMHg4NzANCj4gPiBbICAgNjIuNDMxODM0XSAgc2NoZWR1bGUrMHgzMy8weDkwDQo+ID4gWyAg
IDYyLjQzNDE1Nl0gIF94ZnNfbG9nX2ZvcmNlKzB4MTQzLzB4MjgwIFt4ZnNdDQo+ID4gWyAgIDYy
LjQzODc2N10gID8gc2NoZWR1bGVfdGltZW91dCsweDE4OC8weDM5MA0KPiA+IFsgICA2Mi40NDM1
OTJdICA/IHdha2VfdXBfcSsweDgwLzB4ODANCj4gPiBbICAgNjIuNDQ2NTQ1XSAgPyB4ZnNhaWxk
KzB4MThkLzB4NzgwIFt4ZnNdDQo+ID4gWyAgIDYyLjQ0OTcwMl0gIHhmc19sb2dfZm9yY2UrMHgy
Yy8weDkwIFt4ZnNdDQo+ID4gWyAgIDYyLjQ1MzIxN10gIHhmc2FpbGQrMHgxOGQvMHg3ODAgW3hm
c10NCj4gPiBbICAgNjIuNDU2NzE3XSAga3RocmVhZCsweDEyNC8weDE0MA0KPiA+IFsgICA2Mi40
NTkyMzddICA/IGt0aHJlYWQrMHgxMjQvMHgxNDANCj4gPiBbICAgNjIuNDYxODE4XSAgPyB4ZnNf
dHJhbnNfYWlsX2N1cnNvcl9maXJzdCsweDkwLzB4OTAgW3hmc10NCj4gPiBbICAgNjIuNDY1MTQ2
XSAgPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4NzAvMHg3MA0KPiA+IFsgICA2Mi40NjczMzFd
ICByZXRfZnJvbV9mb3JrKzB4MjUvMHgzMA0KPiA+IFsgICA2Mi40NzQzODZdIFJlc3RhcnRpbmcg
a2VybmVsIHRocmVhZHMgLi4uIGRvbmUuDQo+ID4gPT09DQo+IA0KPiBUaGFuayB5b3UgZm9yIGhh
dmluZyB0ZXN0ZWQgdjEwIG9mIHRoaXMgcGF0Y2ggc2VyaWVzLiBUaGlzIHBhdGNoIHNlcmllcyBv
bmx5DQo+IGNoYW5nZXMgdGhlIGJlaGF2aW9yIG9mIHN1c3BlbmRpbmcgZGV2aWNlcyBidXQgbm90
IHRoZSBiZWhhdmlvciBvZiBmcmVlemluZw0KPiB0aGUgWEZTIGtlcm5lbCB0aHJlYWRzLiBEdXJp
bmcgc3VzcGVuZCB0YXNrIGZyZWV6aW5nIG9jY3VycyAqYmVmb3JlKg0KPiBzdXNwZW5kaW5nIGRl
dmljZXMuIEluIG90aGVyIHdvcmRzLCB0aGUgbG9ja3VwIG9jY3VycmVkIGJlZm9yZSB0aGUgY29k
ZSB3YXMNCj4gcmVhY2hlZCB0aGF0IGlzIG1vZGlmaWVkIGJ5IHRoaXMgcGF0Y2ggc2VyaWVzLiBT
byBJIHRoaW5rIHlvdSByYW4gaW50byBhIGJ1Zw0KPiBpbiB0aGUgWEZTIGNvZGUgYW5kIG5vdCBp
bnRvIGEgYnVnIGluIHRoaXMgcGF0Y2ggc2VyaWVzLg0KDQpPbiBzZWNvbmQgdGhvdWdodCwgSSB3
YW50IHRvIHRha2UgYmFjayB3aGF0IEkgd3JvdGUgYWJvdXQgWEZTLiBTaW5jZSB4ZnNhaWxkKCkN
CmNhbiBzdWJtaXQgSS9PLCB3aGF0IG1heSBoYXZlIGhhcHBlbmVkIGlzIHRoYXQgdGhlIG1kIGtl
cm5lbCB0aHJlYWQgZ290IGZyb3plbg0KYmVmb3JlIHRoZSBYRlMga2VybmVsIHRocmVhZC4gSSB3
aWxsIHNlZSB3aGF0IEkgY2FuIGRvIHRvIGF2b2lkIGZyZWV6ZSBmYWlsdXJlcw0KbGlrZSB0aGUg
b25lIHlvdSByZXBvcnRlZC4NCg0KQmFydC4=
