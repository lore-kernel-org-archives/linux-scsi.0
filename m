From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC] sg3_utils: sgp_dd: work around on pthread_cancel for
 android
Date: Sat, 23 Dec 2017 13:29:51 +0000
Message-ID: <1514035791.2965.3.camel@wdc.com>
References: <dcd86d371fd742c693eac4db5f9335f9@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12856 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdLWN34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Dec 2017 08:29:56 -0500
In-Reply-To: <dcd86d371fd742c693eac4db5f9335f9@SIWEX5A.sing.micron.com>
Content-Language: en-US
Content-ID: <3D927B1574146041811B31FAD325C873@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "hare@suse.de" <hare@suse.de>

T24gU2F0LCAyMDE3LTEyLTIzIGF0IDEwOjE5ICswMDAwLCBCZWFuIEh1byAoYmVhbmh1bykgd3Jv
dGU6DQo+IERvdWcgd3JvdGU6DQo+ID4gVGhpcyBzZWVtcyB0byB3b3JrIGluIExpbnV4IGJ1dCBt
YXkgbm90IHdvcmsgaW4gQW5kcm9pZDoNCj4gPiBBQ19TRUFSQ0hfTElCUyhbcHRocmVhZF9jYW5j
ZWxdLCBbcHRocmVhZF0sDQo+ID4gW0FDX0RFRklORShIQVZFX1BUSFJFQURfQ0FOQ0VMLCAxLCBb
Rm91bmQgcHRocmVhZF9jYW5jZWxdKV0sIFtdKQ0KPiA+IA0KPiA+IEJlYW4sIGNvdWxkIHlvdSBj
aGVjaz8NCj4gPiANCj4gDQo+IERvdWcsIEkgaGFkIHRyaWVkIHRoYXQsIGl0IHdvcmtzLCBidXQg
dGhpcyBpcyBmb3IgQyBjb2RlcyBtYWNybyBkZWZpbml0aW9uIGluIHRoZSBjb25maWcuaC4NCj4g
SG93IGNhbiBJIGZpZ3VyZSBvdXQgaW4gdGhlIC9zcmMvTWFrZWZpbGUuYWMgYmV0d2VlbiBBbmRy
b2lkIE9TIGFuZCBub24tQW5kcm9pZD8NCj4gQ2FuIHlvdSBnaXZlIG1lIHNvbWUgc3VnZ2VzdGlv
bnM/IExpa2UgdGhpczoNCj4gICAgICBpZiBPU19BTkRST0lEDQo+ICAgICAgc2dwX2RkX0xEQURE
ID0gLi4vbGliL2xpYnNndXRpbHMyLmxhIEBvc19saWJzQA0KPiAgICAgZWxzZQ0KPiAgICAgc2dw
X2RkX0xEQUREID0gLi4vbGliL2xpYnNndXRpbHMyLmxhIEBvc19saWJzQCAtbHB0aHJlYWQNCj4g
ICAgIGVuZGlmDQoNCkhvdyBhYm91dCBsZWF2aW5nIG91dCB0aGUgZm9sbG93aW5nOg0KLSBVc2Ug
QUNfU0VBUkNIX0xJQlMoW3B0aHJlYWRfY2FuY2VsXSwgW3B0aHJlYWRdKSBhbmQgQUNfQ0hFQ0tf
RlVOQyhbcHRocmVhZF9jYW5jZWxdKSBpbg0KICBjb25maWd1cmUuYWMuIA0KLSBVc2UgQExJQlNA
IGluIE1ha2VmaWxlLmFtLg0KDQpGcm9tIGh0dHBzOi8vd3d3LmdudS5vcmcvc29mdHdhcmUvYXV0
b2NvbmYvbWFudWFsL2F1dG9jb25mLTIuNjYvaHRtbF9ub2RlL0xpYnJhcmllcy5odG1sOg0KIklm
IGFjdGlvbi1pZi1mb3VuZCBpcyBub3Qgc3BlY2lmaWVkLCB0aGUgZGVmYXVsdCBhY3Rpb24gcHJl
cGVuZHMgLWxsaWJyYXJ5IHRvIExJQlMgWy4uLl0iLg0KDQpCYXJ0Lg0KDQo=
