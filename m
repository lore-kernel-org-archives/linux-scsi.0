From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/4] sd: Check if parent is still present before
 proceeding with probing
Date: Thu, 14 Dec 2017 22:02:26 +0000
Message-ID: <1513288945.2475.81.camel@sandisk.com>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
         <1513069072-32514-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:58765 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753375AbdLNWC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 17:02:28 -0500
In-Reply-To: <1513069072-32514-3-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <614F320CE0E26F4D98AFE46EE96F01C9@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gVHVlLCAyMDE3LTEyLTEyIGF0IDA5OjU3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQo+
IGluZGV4IGFiNzVlYmQuLjIyOGIwYjYyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvc2Qu
Yw0KPiArKysgYi9kcml2ZXJzL3Njc2kvc2QuYw0KPiBAQCAtMzM5OSw2ICszMzk5LDEwIEBAIHN0
YXRpYyBpbnQgc2RfcHJvYmUoc3RydWN0IGRldmljZSAqZGV2KQ0KPiAgCX0NCj4gIA0KPiAgCWRl
dmljZV9pbml0aWFsaXplKCZzZGtwLT5kZXYpOw0KPiArDQo+ICsJaWYgKCFnZXRfZGV2aWNlKGRl
dikpDQo+ICsJCWdvdG8gb3V0X2ZyZWVfaW5kZXg7DQoNCmdldF9kZXZpY2UoZGV2KSByZXR1cm5z
IHRoZSB2YWx1ZSBvZiB0aGUgJ2RldicgYXJndW1lbnQuIEFyZSB5b3Ugc3VyZSB0aGUNCmlmLXRl
c3QgaXMgdXNlZnVsPyBEaWQgeW91IHBlcmhhcHMgd2FudCB0byBjaGVjayBzZHAtPnNkZXZfc3Rh
dGUgbGlrZQ0Kc2NzaV9kZXZpY2VfZ2V0KCkgZG9lcz8NCg0KPiAgCXNka3AtPmRldi5wYXJlbnQg
PSBkZXY7DQo+ICAJc2RrcC0+ZGV2LmNsYXNzID0gJnNkX2Rpc2tfY2xhc3M7DQo+ICAJZGV2X3Nl
dF9uYW1lKCZzZGtwLT5kZXYsICIlcyIsIGRldl9uYW1lKGRldikpOw0KPiBAQCAtMzQwNyw3ICsz
NDExLDYgQEAgc3RhdGljIGludCBzZF9wcm9iZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICAJaWYg
KGVycm9yKQ0KPiAgCQlnb3RvIG91dF9mcmVlX2luZGV4Ow0KPiAgDQo+IC0JZ2V0X2RldmljZShk
ZXYpOw0KPiAgCWRldl9zZXRfZHJ2ZGF0YShkZXYsIHNka3ApOw0KPiAgDQo+ICAJZ2V0X2Rldmlj
ZSgmc2RrcC0+ZGV2KTsJLyogcHJldmVudCByZWxlYXNlIGJlZm9yZSBhc3luY19zY2hlZHVsZSAq
Lw0KDQpTaW5jZSB0aGUgZ2V0X2RldmljZSgpIGNhbGwgaGFzIGJlZW4gbW92ZWQgdXAsIGFyZSB0
aGVyZSBhbnkgZXJyb3IgcGF0aHMgdGhhdA0KaGF2ZSB0byBiZSBhZGp1c3RlZD8NCg0KQmFydC4=
