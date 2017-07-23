From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: 4.12 NULL pointer dereference in kmem_cache_free on USB storage
 removal
Date: Sun, 23 Jul 2017 03:35:20 +0000
Message-ID: <1500780919.3155.3.camel@wdc.com>
References: <726b4c5d-610d-4d74-28e3-bfbc4fad06e0@gmail.com>
         <1500779301.3155.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16240 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbdGWDgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2017 23:36:09 -0400
In-Reply-To: <1500779301.3155.1.camel@wdc.com>
Content-Language: en-US
Content-ID: <EEDD9AA9CCAFDA4BB11FCC8903177935@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yagmur.oymak@gmail.com" <yagmur.oymak@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gU3VuLCAyMDE3LTA3LTIzIGF0IDAzOjA4ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIFNhdCwgMjAxNy0wNy0yMiBhdCAxMTo1OCArMDMwMCwgWWFnbXVyIE95bWFrIHdyb3Rl
Og0KPiA+IFRoaXMgcHJvYmxlbSB3YXMgcmVwb3J0ZWQgaW4gdGhlIGxpbnV4LWtlcm5lbCBsaXN0
LCBoZXJlOg0KPiA+IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE3LzcvMTMvNzEwLCBhbmQgaXQg
aXMgc2FpZCB0aGF0IGNvbW1pdA0KPiA+IDhlNjg4MjU0NWQ4YyAoInNjc2k6IEF2b2lkDQo+ID4g
dGhhdCBzY3NpX2V4aXRfcnEoKSB0cmlnZ2VycyBhIHVzZS1hZnRlci1mcmVlIikgZml4ZXMgaXQu
IEl0IGluZGVlZA0KPiA+IGZpeGVzIGl0IGFzIHRoZSBwcm9ibGVtIGRvZXMgbm90IGV4aXN0IG9u
IDQuMTMtcmMxICh3aGljaCBpbmNsdWRlcyB0aGUNCj4gPiBjb21taXQpIGFuZCBvbiA0LjEyLngg
aWYgdGhlIHBhdGNoIGlzIGFwcGxpZWQuIEhvd2V2ZXIsIG5vbmUgb2YgdGhlIDQuMTINCj4gPiBy
ZWxlYXNlcyBzaW5jZSB0aGF0IGRpc2N1c3Npb24gaW5jbHVkZXMgdGhlIHBhdGNoLCBzbyB0aGUg
cHJvYmxlbSBpcw0KPiA+IHN0aWxsIHRoZXJlLiBDYW4gdGhhdCBiZSBpbmNsdWRlZCBpbiB0aGUg
bmV4dCBzdGFibGUgcmVsZWFzZT8NCj4gDQo+ICgrR3JlZykNCj4gDQo+IEhpIEdyZWcsDQo+IA0K
PiBJdCBzZWVtcyB0byBtZSBsaWtlIHRoYXQgY29tbWl0IGhhcyBub3QgYmVlbiBpbmNsdWRlZCBp
biBrZXJuZWwgdjQuMTIuMz8NCj4gV2lsbCBpdCBiZSBpbmNsdWRlZCBpbiBhIGxhdGVyIHN0YWJs
ZSB2NC4xMi54IGtlcm5lbD8NCg0KKHJlcGx5aW5nIHRvIG15IG93biBlLW1haWwpDQoNCkFjY29y
ZGluZyB0byB0aGlzIG1lc3NhZ2UgYSB2NC4xMi54IGtlcm5lbCB0aGF0IGluY2x1ZGVzIHRoZSBh
Zm9yZW1lbnRpb25lZA0KY29tbWl0IHdpbGwgYmUgcmVsZWFzZWQgc29vbjogaHR0cHM6Ly93d3cu
c3Bpbmljcy5uZXQvbGlzdHMvc3RhYmxlL21zZzE4MjAwMi5odG1sLg0KDQpCYXJ0Lg==
