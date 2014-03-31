From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Date: Mon, 31 Mar 2014 09:47:18 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB208427B7@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
 <D9FFE20C522965449E182ACE73889AEB20842693@IRSMSX105.ger.corp.intel.com>
 <af1d52ad252849d6a8c5d5b09fa93d17@fmsmsx103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaCaJrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 05:47:22 -0400
In-Reply-To: <af1d52ad252849d6a8c5d5b09fa93d17@fmsmsx103.amr.corp.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, intel-linux-scu <intel-linux-scu@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>

T24gTW9uZGF5LCBNYXJjaCAzMSwgMjAxNCAxMTozNiBBTSBKb3NoIFRyaXBsZXR0IDxqb3NoQGpv
c2h0cmlwbGV0dC5vcmc+IHdyb3RlOg0KPiBPbiBNb24sIE1hciAzMSwgMjAxNCBhdCAwODo1NDo0
OUFNICswMDAwLCBEb3JhdSwgTHVrYXN6IHdyb3RlOg0KPiA+IE9uIFNhdHVyZGF5LCBNYXJjaCAy
OSwgMjAxNCA3OjA0IFBNIFJhc2hpa2EgS2hlcmlhDQo+IDxyYXNoaWthLmtoZXJpYUBnbWFpbC5j
b20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IE1hcmsgZnVuY3Rpb24gYXMgc3RhdGljIGluIGlzY2kv
cGh5LmMgYmVjYXVzZSBpdCBpcyBub3QgdXNlZCBvdXRzaWRlDQo+ID4gPiB0aGlzIGZpbGUuDQo+
ID4gPg0KPiA+ID4gVGhpcyBlbGltaW5hdGVzIHRoZSBmb2xsb3dpbmcgd2FybmluZyBpbiBpc2Np
L3BoeS5jOg0KPiA+ID4gZHJpdmVycy9zY3NpL2lzY2kvcGh5LmM6NjcyOjY6IHdhcm5pbmc6IG5v
IHByZXZpb3VzIHByb3RvdHlwZSBmb3INCj4gPiA+IOKAmHNjdV9saW5rX2xheWVyX3NldF90eGNv
bXNhc190aW1lb3V04oCZIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gPiA+DQo+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBSYXNoaWthIEtoZXJpYSA8cmFzaGlrYS5raGVyaWFAZ21haWwuY29tPg0KPiA+
ID4gUmV2aWV3ZWQtYnk6IEpvc2ggVHJpcGxldHQgPGpvc2hAam9zaHRyaXBsZXR0Lm9yZz4NCj4g
Pg0KPiA+IEFja2VkLWJ5OiBMdWthc3ogRG9yYXUgPGx1a2Fzei5kb3JhdUBpbnRlbC5jb20+DQo+
IA0KPiBTaW5jZSB5b3UncmUgYSBtYWludGFpbmVyIG9mIHRoZSBkcml2ZXIgaW4gcXVlc3Rpb24s
IGNhbiB5b3UgYWNjZXB0IHRoZQ0KPiB0aHJlZSBwYXRjaGVzIHlvdSBhY2tlZCwgb3Igd291bGQg
eW91IHN1Z2dlc3QgdGhhdCB0aGV5IGdvIHRocm91Z2gNCj4gYW5vdGhlciB0cmVlPw0KPiANCj4g
LSBKb3NoIFRyaXBsZXR0DQoNCkhpIEpvc2gsDQoNClRoZSBpc2NpIHBhdGNoZXMgc2hvdWxkIGJl
IGFjY2VwdGVkIGJ5IEphbWVzIEJvdHRvbWxleS4NCg0KTHVrYXN6DQoNCg==
