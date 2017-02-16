From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi_dh: only attach to SCSI devices
Date: Thu, 16 Feb 2017 14:30:34 +0000
Message-ID: <1487255419.2973.1.camel@sandisk.com>
References: <1487230394-84552-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:54825 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754410AbdBPOam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 09:30:42 -0500
In-Reply-To: <1487230394-84552-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <A5D42BBB2B10104BA303E101D7C527FF@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "keith.busch@inter.com" <keith.busch@inter.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gVGh1LCAyMDE3LTAyLTE2IGF0IDA4OjMzICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEFueSBkZXZpY2UgbWlnaHQgYmUgc2V0dGluZyBhIHF1ZXVlZGF0YSBzdHJ1Y3R1cmUsIHNv
IHdlIG5lZWQgdG8NCj4gY2hlY2sgaWYgdGhlIHF1ZXVlZGF0YSByZWFsbHkgYmVsb25ncyB0byBh
IFNDU0kgZGV2aWNlIGJlZm9yZQ0KPiBwcm9jZWVkaW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
SGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9z
Y3NpX2RoLmMgfCA0ICsrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9kaC5jIGIv
ZHJpdmVycy9zY3NpL3Njc2lfZGguYw0KPiBpbmRleCBiOGQzYjk3Li5kYTEwNGVkIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9kaC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zY3Np
X2RoLmMNCj4gQEAgLTIyNiw3ICsyMjYsOSBAQCBzdGF0aWMgc3RydWN0IHNjc2lfZGV2aWNlICpn
ZXRfc2Rldl9mcm9tX3F1ZXVlKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQ0KPiAgDQo+ICAJc3Bp
bl9sb2NrX2lycXNhdmUocS0+cXVldWVfbG9jaywgZmxhZ3MpOw0KPiAgCXNkZXYgPSBxLT5xdWV1
ZWRhdGE7DQo+IC0JaWYgKCFzZGV2IHx8ICFnZXRfZGV2aWNlKCZzZGV2LT5zZGV2X2dlbmRldikp
DQo+ICsJaWYgKCFzZGV2IHx8DQo+ICsJICAgICFzY3NpX2lzX3NkZXZfZGV2aWNlKCZzZGV2LT5z
ZGV2X2dlbmRldikgfHwNCj4gKwkgICAgIWdldF9kZXZpY2UoJnNkZXYtPnNkZXZfZ2VuZGV2KSkN
Cj4gIAkJc2RldiA9IE5VTEw7DQo+ICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShxLT5xdWV1ZV9s
b2NrLCBmbGFncyk7DQoNCkhlbGxvIEhhbm5lcywNCg0KU29ycnkgYnV0IHRoaXMgYXBwcm9hY2gg
bG9va3Mgd3JvbmcgdG8gbWUuIEEgYmxvY2sgZHJpdmVyIGNhbiBzdG9yZSBhbnkgZGF0YQ0KaW4g
LnF1ZXVlZGF0YSwgZXZlbiBkYXRhIHRoYXQgd291bGQgY2F1c2UgdGhlIHNjc2lfaXNfc2Rldl9k
ZXZpY2UoKSBmdW5jdGlvbg0KdG8gY3Jhc2guDQoNCkJhcnQu
