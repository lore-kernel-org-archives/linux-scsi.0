From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v3 0/2] Ensure that the SCSI error handler gets woken up
Date: Thu, 7 Dec 2017 16:50:04 +0000
Message-ID: <1512665404.2624.13.camel@wdc.com>
References: <20171204180624.18722-1-bart.vanassche@wdc.com>
         <yq1o9nbxpx4.fsf@oracle.com>
         <d408dd47-1706-c448-2b74-cbc91a5f90da@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37827 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754311AbdLGQuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 11:50:07 -0500
In-Reply-To: <d408dd47-1706-c448-2b74-cbc91a5f90da@huawei.com>
Content-Language: en-US
Content-ID: <A297B06D93967E45A60F2F263ADC8573@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "john.garry@huawei.com" <john.garry@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linuxarm@huawei.com" <linuxarm@huawei.com>

T24gVGh1LCAyMDE3LTEyLTA3IGF0IDEyOjAyICswMDAwLCBKb2huIEdhcnJ5IHdyb3RlOg0KPiBP
biAwNy8xMi8yMDE3IDAxOjU1LCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6DQo+ID4gDQo+ID4g
QmFydCwNCj4gPiANCj4gPiA+IEFzIHJlcG9ydGVkIGJ5IFBhdmVsIFRpa2hvbWlyb3YgaXQgY2Fu
IGhhcHBlbiB0aGF0IHRoZSBTQ1NJIGVycm9yDQo+ID4gPiBoYW5kbGVyIGRvZXMgbm90IGdldCB3
b2tlbiB1cC4gVGhpcyBpcyB2ZXJ5IGFubm95aW5nIGJlY2F1c2UgaXQNCj4gPiA+IHJlc3VsdHMg
aW4gYSBxdWV1ZSBzdGFsbC4gVGhlIHR3byBwYXRjaGVzIGluIHRoaXMgc2VyaWVzIGFkZHJlc3Mg
dGhpcw0KPiA+ID4gaXNzdWUgd2l0aG91dCBhY3F1aXJpbmcgdGhlIFNDU0kgaG9zdCBsb2NrIGlu
IHRoZSBob3QgcGF0aC4gUGxlYXNlDQo+ID4gPiBjb25zaWRlciB0aGVzZSBwYXRjaGVzIGZvciBr
ZXJuZWwgdjQuMTYuDQo+ID4gDQo+ID4gQXBwbGllZCB0byA0LjE2L3Njc2ktcXVldWUuIFRoYW5r
IHlvdSENCj4gPiANCj4gDQo+IElzIGFueW9uZSBmaW5kaW5nIGEgYnVpbGQgZXJyb3IgZm9yIHRo
aXMgcGF0Y2g/IEkgYnVpbHQgYWxsbW9kY29uZmlnIG9uIA0KPiBNYXJ0aW4ncyA0LjE2L3Njc2kt
cXVldWUgYW5kIEkgZ2V0IHRoaXM6DQo+IEVSUk9SOiAiaW5pdF9yY3VfaGVhZCIgW2RyaXZlcnMv
c2NzaS9zY3NpX21vZC5rb10gdW5kZWZpbmVkIQ0KPiBFUlJPUjogImRlc3Ryb3lfcmN1X2hlYWQi
IFtkcml2ZXJzL3Njc2kvc2NzaV9tb2Qua29dIHVuZGVmaW5lZCENCj4gDQo+IFJldmVydGluZyBm
aXhlcyBpdC4NCj4gDQo+ICBGcm9tIGEgcXVpY2sgY2hlY2ssIGl0IHNlZW1zIHRoZSByY3UgZnVu
Y2l0b25zIGFyZSBub3QgZXhwb3J0ZWQsIGFuZCANCj4gU0NTST1tIG1lYW5zIGhvc3RzLmMgY2Fu
bm90IHJlZmVyZW5jZSBpdC4NCg0KSGVsbG8gSm9obiwNCg0KQSBkaXNjdXNzaW9uIGlzIG9uZ29p
bmcgYWJvdXQgdGhpcyBpc3N1ZSBvbiB0aGUgbGludXgtbmV4dCBtYWlsaW5nIGxpc3QuDQpQYXVs
IEUuIE1jS2VubmV5IHByb3Bvc2VkIHRvIGV4cG9ydCBib3RoIHRoZSBpbml0X3JjdV9oZWFkKCkg
YW5kDQpkZXN0cm95X3JjdV9oZWFkKCkgZnVuY3Rpb25zLiBTZWUgYWxzbyBodHRwczovL2xrbWwu
b3JnL2xrbWwvMjAxNy8xMi82LzExNTAuDQoNCkJhcnQu
