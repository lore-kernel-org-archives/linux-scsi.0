From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] drivers/scsi/qla2xxx: fix double free bug after firmware
 timeout
Date: Thu, 18 Jan 2018 01:02:30 +0000
Message-ID: <E5BBC14A-A0AD-43E1-987E-FA0B17BD9816@cavium.com>
References: <151603716189.28707.13105191089826357709.stgit@rabbit.intern.cm-ag>
 <13B82B86-8810-4722-97F9-EC5B862ECC76@cavium.com>
 <20180115203726.b7igf7rajczllcv7@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:18476
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753054AbeARBCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jan 2018 20:02:33 -0500
In-Reply-To: <20180115203726.b7igf7rajczllcv7@rabbit.intern.cm-ag>
Content-Language: en-US
Content-ID: <C153222926540F43853CAD754EF330D4@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Max Kellermann <mk@cm4all.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "max.kellermann@gmail.com" <max.kellermann@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

TWF4LA0KDQo+IE9uIEphbiAxNSwgMjAxOCwgYXQgMTI6MzcgUE0sIE1heCBLZWxsZXJtYW5uIDxt
a0BjbTRhbGwuY29tPiB3cm90ZToNCj4gDQo+IE9uIDIwMTgvMDEvMTUgMjA6NTgsICJNYWRoYW5p
LCBIaW1hbnNodSIgPEhpbWFuc2h1Lk1hZGhhbmlAY2F2aXVtLmNvbT4gd3JvdGU6DQo+PiBXZSBo
YXZlIHBhdGNoIHRvIHByZXZlbnQgdGhpcyBkb3VibGUgZnJlZSBpbiA0LjE2L3Njc2ktcXVldWUN
Cj4+IGFscmVhZHkuDQo+IA0KPiBObywgbGV0IG1lIHJlcGVhdDogdGhpcyBpcyBhIGRpZmZlcmVu
dCBidWchDQo+IA0KPiBZb3VyIGJ1ZyBpcyBhYm91dCB0aGUgZnJlZSBjYWxsIGFmdGVyIHdhaXRp
bmcgZm9yIGNvbXBsZXRpb24NCj4gc3luY2hyb25vdXNseSBpbiBxbGEyNHh4X2Vsc19kY21kX2lv
Y2IoKSwgYWZ0ZXIgaXQgd2FzIGFscmVhZHkgZnJlZWQNCj4gYnkgcWxhMngwMF9zcF90aW1lb3V0
KCkuDQo+IA0KPiBNeSBidWcgaXMgYWJvdXQgZnJlZSBpbiBxbGEyeDAwXypfc3BfZG9uZSgpIGFu
ZCBhZ2FpbiBpbg0KPiBxbGEyeDAwX3NwX3RpbWVvdXQoKS4gIE15IHBhdGNoIGRlc2NyaXB0aW9u
IGRlc2NyaWJlcyBleGFjdGx5IHRoYXQuDQo+IA0KPiBBbmQgeW91IGtub3cgd2hhdD8gIE15IHBh
dGNoIGZpeGVzIGJvdGggYnVncy4gIEl0IGlzIHN1cGVyaW9yIHRvIHRoZQ0KPiBvbmUgdGhhdCB3
YXMgbWVyZ2VkIDQgd2Vla3MgbGF0ZXIsIGlzbid0IGl0Pw0KPiANCj4gWW91IE5BQ0tlZCBteSBw
YXRjaCA1IHdlZWtzIGFnbywgYW5kIEkgZXhwbGFpbmVkIHRvIHlvdSB0aGF0IHlvdSB3ZXJlDQo+
IHRhbGtpbmcgYWJvdXQgYSBkaWZmZXJlbnQgYnVnLCBidXQgeW91IG5ldmVyIHJlcGxpZWQgdG8g
dGhhdC4NCj4gDQo+IE1heA0KDQpKdXN0IHRvIHVwZGF0ZSB5b3UsIHdlIGFyZSB3b3JraW5nIG9u
IGZpeGluZyB0aGlzIGludGVybmFsbHkgYW5kIHdpbGwgcG9zdA0KcGF0Y2ggc29vbi4gDQoNCkni
gJlsbCBhZGQgeW91IGFyZSBSZXBvcnRlciBhbmQgcGxlYXNlIHJldmlldyBhbmQgbGV0IHVzIGtu
b3cgeW91ciBjb21tZW50cy4NCg0KVGhhbmtzLA0KLSBIaW1hbnNodQ0KDQo=
