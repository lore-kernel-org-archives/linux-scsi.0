From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [PATCH] replace skb_clone with skb_get in fcoe_start_io()
Date: Mon, 18 Oct 2010 12:04:39 -0700
Message-ID: <7C88852EF6F99F4EB538472FCFEBE2220146C68540@orsmsx509.amr.corp.intel.com>
References: <AANLkTimWO2r=KX522JD6iQxxgjpX9XJ5-0CzeqJXv63b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab0JRTEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 15:04:41 -0400
In-Reply-To: <AANLkTimWO2r=KX522JD6iQxxgjpX9XJ5-0CzeqJXv63b@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiANCj4gVGhlcmUgc2VlbXMgdGhhdCBza2JfZ2V0IGNvdWxkIG91dGxpZ2h0IHNrYl9jbG9uZSwg
aWYNCj4gcmV0cmFuc21pdHRpbmcgc2tiIGlzIHRoZSBtYWpvciBjb25jZXJuLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogSGlsbGYgRGFudG9uIDxkaGlsbGZAZ21haWwuY29tPg0KPiAtLS0NCj4gDQo+
IC0tLSBhL2RyaXZlcnMvc2NzaS9mY29lL2Zjb2UuYwkyMDEwLTA5LTEzIDA3OjA3OjM4LjAwMDAw
MDAwMCArMDgwMA0KPiArKysgYi9kcml2ZXJzL3Njc2kvZmNvZS9mY29lLmMJMjAxMC0xMC0xNyAy
MDowMzowOC4wMDAwMDAwMDAgKzA4MDANCj4gQEAgLTEzNzMsMTUgKzEzNzMsMTQgQEAgZXJyMjoN
Cj4gICAqLw0KPiAgc3RhdGljIGlubGluZSBpbnQgZmNvZV9zdGFydF9pbyhzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKQ0KPiAgew0KPiAtCXN0cnVjdCBza19idWZmICpuc2tiOw0KPiAgCWludCByYzsNCj4g
DQo+IC0JbnNrYiA9IHNrYl9jbG9uZShza2IsIEdGUF9BVE9NSUMpOw0KPiAtCXJjID0gZGV2X3F1
ZXVlX3htaXQobnNrYik7DQo+IC0JaWYgKHJjICE9IDApDQo+ICsJc2tiX2dldChza2IpOyAvKiBi
dW1wIHJlZiBjb3VudCBmb3IgcmV0cmFuc21pdHRpbmcgKi8NCj4gKwlyYyA9IGRldl9xdWV1ZV94
bWl0KHNrYik7DQo+ICsJaWYgKHJjICE9IE5FVF9YTUlUX1NVQ0NFU1MpDQo+ICAJCXJldHVybiBy
YzsNCj4gIAlrZnJlZV9za2Ioc2tiKTsNCj4gLQlyZXR1cm4gMDsNCj4gKwlyZXR1cm4gTkVUX1hN
SVRfU1VDQ0VTUzsNCj4gIH0NCj4gDQo+ICAvKioNCg0KTm8sIHRoaXMgd2FzIGR1ZSB0byBkZXZf
cXVldWVfeG1pdCBub3QgbGlraW5nIHNoYXJlZCBza2Igc2luY2UgDQpfX3NrYl9saW5lYXJpemUo
KSB3b3VsZCBidWcgb24sIHNvIHdlIGNsb25lIHRoZSBza2IgaGVyZSB0byBiZQ0KcGFzc2VkIHRv
IGRldl9xdWV1ZV94bWl0KCksIHJlZmVyIHRvIHRoZSBvcmlnaW5hbCBjb21taXQgaWQgYmVsb3cN
CmZvciBtb3JlIGRldGFpbHM6DQoNCjE4ZmExMWVmYzI3OWMyMGFmNWVlZmZmMmJiZTgxNGNhMDY3
ZTUxYWUNCg0KWWkNCg0K
