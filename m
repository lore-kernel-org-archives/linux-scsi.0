From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Mon, 21 Aug 2017 19:12:17 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
 <1503092817.2622.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0062.outbound.protection.outlook.com ([104.47.34.62]:14236
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753840AbdHUTMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Aug 2017 15:12:21 -0400
In-Reply-To: <1503092817.2622.19.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgW21h
aWx0bzpCYXJ0LlZhbkFzc2NoZUB3ZGMuY29tXQ0KPiBTZW50OiBGcmlkYXksIEF1Z3VzdCAxOCwg
MjAxNyA0OjQ3IFBNDQo+IFRvOiBoY2hAaW5mcmFkZWFkLm9yZzsgVmlzd2FzIEcgPHZpc3dhcy5n
QG1pY3Jvc2VtaS5jb20+OyBHZXJyeQ0KPiBNb3JvbmcgPGdlcnJ5Lm1vcm9uZ0BtaWNyb3NlbWku
Y29tPjsgTWFoZXNoIFJhamFzaGVraGFyYQ0KPiA8bWFoZXNoLnJhamFzaGVraGFyYUBtaWNyb3Nl
bWkuY29tPjsgUE9TV0FMREBzdXNlLmNvbTsgU2NvdHQNCj4gQmVuZXNoIDxzY290dC5iZW5lc2hA
bWljcm9zZW1pLmNvbT47IERvbiBCcmFjZQ0KPiA8ZG9uLmJyYWNlQG1pY3Jvc2VtaS5jb20+OyBC
YWRlciBBbGkgLSBTYWxlaA0KPiA8YmFkZXIuYWxpc2FsZWhAbWljcm9zZW1pLmNvbT47IEtldmlu
IEJhcm5ldHQNCj4gPGtldmluLmJhcm5ldHRAbWljcm9zZW1pLmNvbT47IGpvc2VwaC5zemN6eXBl
a0BocGUuY29tOyBTY290dCBUZWVsDQo+IDxzY290dC50ZWVsQG1pY3Jvc2VtaS5jb20+OyBqZWpi
QGxpbnV4LnZuZXQuaWJtLmNvbTsgSnVzdGluIExpbmRsZXkNCj4gPGp1c3Rpbi5saW5kbGV5QG1p
Y3Jvc2VtaS5jb20+OyBKb2huIEhhbGwgPEpvaG4uSGFsbEBtaWNyb3NlbWkuY29tPg0KPiBDYzog
bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gc2Q6IHBy
ZXNlcnZlIHN5c2ZzIHVwZGF0ZXMgdG8gbWF4X3NlY3RvcnNfa2INCj4gDQo+IEVYVEVSTkFMIEVN
QUlMDQo+IA0KPiANCj4gT24gRnJpLCAyMDE3LTA4LTE4IGF0IDIxOjI5ICswMDAwLCBEb24gQnJh
Y2Ugd3JvdGU6DQo+ID4gQXMgZmFyIGFzIEkgY2FuIHNlZSwgdWRldiBsb29rcyBmb3IgZmlsZSBh
Y2Nlc3MgaW4gc3lzZnMuDQo+ID4gSSBhbSBub3QgZXhhY3RseSBzdXJlIHdoaWNoIHJ1bGUgY2hh
bmdlcyB0aGlzLiBJdCB3YXMgYWRkZWQgaW4gbW9yZSByZWNlbnQNCj4gPiBkaXN0cm9zLiBDYW4g
c29tZW9uZSBoZWxwIG1lIG91dD8NCj4gDQo+IEhlbGxvIERvbiwNCj4gDQo+IENhbiB5b3UgY2hl
Y2sgb24geW91ciB0ZXN0IHN5c3RlbSB3aGljaCB1ZGV2IHJ1bGUgY2hhbmdlcw0KPiBtYXhfc2Vj
dG9yc19rYj8gSQ0KPiBoYXZlIGNoZWNrZWQgdHdvIHJlY2VudCBMaW51eCBkaXN0cm8ncyBidXQg
aGF2ZW4ndCBiZWVuIGFibGUgdG8gZmluZCBzdWNoIGENCj4gdWRldiBydWxlOg0KPiAkIGdyZXAg
LXJ3IG1heF9zZWN0b3JzX2tiIC91c3IvbGliL3VkZXYvcnVsZXMuZCAvZXRjL3VkZXYvcnVsZXMu
ZCB8IHdjIC1sDQo+IDANCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCk9uIG15IHN5c3Rl
bSBpdCBpcyA2MC1ibG9jay5ydWxlcywgYW5kIGl0IGlzIHRoZSBsYXN0IHJ1bGUgaW4gdGhhdCBy
dWxlIGZpbGUuDQotLQ0KIyBkbyBub3QgZWRpdCB0aGlzIGZpbGUsIGl0IHdpbGwgYmUgb3Zlcndy
aXR0ZW4gb24gdXBkYXRlDQoNCiMgZW5hYmxlIGluLWtlcm5lbCBtZWRpYS1wcmVzZW5jZSBwb2xs
aW5nDQpBQ1RJT049PSJhZGQiLCBTVUJTWVNURU09PSJtb2R1bGUiLCBLRVJORUw9PSJibG9jayIs
IEFUVFJ7cGFyYW1ldGVycy9ldmVudHNfZGZsX3BvbGxfbXNlY3N9PT0iMCIsIFwNCiAgQVRUUntw
YXJhbWV0ZXJzL2V2ZW50c19kZmxfcG9sbF9tc2Vjc309IjIwMDAiDQoNCiMgZm9yd2FyZCBzY3Np
IGRldmljZSBldmVudCB0byBjb3JyZXNwb25kaW5nIGJsb2NrIGRldmljZQ0KQUNUSU9OPT0iY2hh
bmdlIiwgU1VCU1lTVEVNPT0ic2NzaSIsIEVOVntERVZUWVBFfT09InNjc2lfZGV2aWNlIiwgVEVT
VD09ImJsb2NrIiwgQVRUUntibG9jay8qL3VldmVudH09ImNoYW5nZSINCg0KIyB3YXRjaCBtZXRh
ZGF0YSBjaGFuZ2VzLCBjYXVzZWQgYnkgdG9vbHMgY2xvc2luZyB0aGUgZGV2aWNlIG5vZGUgd2hp
Y2ggd2FzIG9wZW5lZCBmb3Igd3JpdGluZw0KQUNUSU9OIT0icmVtb3ZlIiwgU1VCU1lTVEVNPT0i
YmxvY2siLCBLRVJORUw9PSJsb29wKnxudm1lKnxzZCp8dmQqfHh2ZCp8cG1lbSoiLCBPUFRJT05T
Kz0id2F0Y2giDQo=
