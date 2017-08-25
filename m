From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Fri, 25 Aug 2017 16:26:28 +0000
Message-ID: <1503678387.2680.10.camel@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
         <20170823214009.15015-8-bart.vanassche@wdc.com>
         <8abaa903-7150-b7a0-ffc8-2fb4d2695e6c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5124 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934434AbdHYQ1R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 12:27:17 -0400
In-Reply-To: <8abaa903-7150-b7a0-ffc8-2fb4d2695e6c@suse.de>
Content-Language: en-US
Content-ID: <7F38850223D7484FBE85DAFC404E40D5@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>

T24gRnJpLCAyMDE3LTA4LTI1IGF0IDE3OjQ5ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIDA4LzIzLzIwMTcgMTE6MzkgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2kuYyBiL2RyaXZlcnMvc2NzaS9zY3NpLmMNCj4g
PiBpbmRleCAzZDM4YzZkNDYzYjguLjViYjE1ZTY5ODk2OSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL3Njc2kvc2NzaS5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Njc2kuYw0KPiA+IEBAIC00
MjYsNyArNDI2LDcgQEAgdm9pZCBzY3NpX2F0dGFjaF92cGQoc3RydWN0IHNjc2lfZGV2aWNlICpz
ZGV2KQ0KPiA+ICAJaW50IHZwZF9sZW4gPSBTQ1NJX1ZQRF9QR19MRU47DQo+ID4gIAlpbnQgcGc4
MF9zdXBwb3J0ZWQgPSAwOw0KPiA+ICAJaW50IHBnODNfc3VwcG9ydGVkID0gMDsNCj4gPiAtCXVu
c2lnbmVkIGNoYXIgX19yY3UgKnZwZF9idWYsICpvcmlnX3ZwZF9idWYgPSBOVUxMOw0KPiA+ICsJ
dW5zaWduZWQgY2hhciAqdnBkX2J1ZiwgKm9yaWdfdnBkX2J1ZiA9IE5VTEw7DQo+ID4gIA0KPiA+
ICAJaWYgKCFzY3NpX2RldmljZV9zdXBwb3J0c192cGQoc2RldikpDQo+ID4gIAkJcmV0dXJuOw0K
PiANCj4gV2h5IGRyb3AgdGhlIF9fcmN1IGFubm90YXRpb24gaGVyZT8NCj4gdnBkX2J1ZiBhbmQg
b3JpZ192cGRfYnVmIHNob3VsZCBhbHdheXMgYmUgYWNjZXNzZWQgdmlhIHJjdSBwb2ludGVycy4N
Cj4gRGlkIEkgbWlzdW5kZXJzdG9vZCB0aGUgbWVhbmluZyBvZiB0aGUgX19yY3UgYW5ub3RhdGlv
bj8NCg0KSGVsbG8gSGFubmVzLA0KDQpUaGUgX19yY3UgYW5ub3RhdGlvbiBtdXN0IG9ubHkgYmUg
dXNlZCBmb3IgcG9pbnRlcnMgdGhhdCBhcmUgYWNjZXNzZWQgZnJvbQ0KbXVsdGlwbGUgdGhyZWFk
cy4gVGhlIHZwZF9idWYgcG9pbnRlciBpcyBhIGxvY2FsIHZhcmlhYmxlIHRoYXQgaXMgb25seSB1
c2VkDQpmcm9tIGEgc2luZ2xlIGNvbnRleHQuIFRoZSBmYW1pbHkgb2YgcmN1X2RlcmVmZXJlbmNl
KCkgZnVuY3Rpb25zIGV4cGVjdHMgYW4NCl9fcmN1LWFubm90YXRlZCBwb2ludGVyIGFzIGFyZ3Vt
ZW50IGFuZCByZXR1cm5zIGEgcmVndWxhciBwb2ludGVyLiBTZWUgZS5nLg0KdGhlIGV4YW1wbGUg
aW4gRG9jdW1lbnRhdGlvbi9SQ1Uvd2hhdGlzUkNVLnR4dC4NCg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5jIGIvZHJpdmVycy9zY3NpL3Njc2lfc3lzZnMuYw0KPiA+
IGluZGV4IDVlZDQ3M2E4NzU4OS4uY2Y4YTIwODhhOWJhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvc2NzaS9zY3NpX3N5c2ZzLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5j
DQo+ID4gQEAgLTQ1Niw4ICs0NTYsMTEgQEAgc3RhdGljIHZvaWQgc2NzaV9kZXZpY2VfZGV2X3Jl
bGVhc2VfdXNlcmNvbnRleHQoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+ICAJLyogTlVM
TCBxdWV1ZSBtZWFucyB0aGUgZGV2aWNlIGNhbid0IGJlIHVzZWQgKi8NCj4gPiAgCXNkZXYtPnJl
cXVlc3RfcXVldWUgPSBOVUxMOw0KPiA+ICANCj4gPiAtCWtmcmVlKHNkZXYtPnZwZF9wZzgzKTsN
Cj4gPiAtCWtmcmVlKHNkZXYtPnZwZF9wZzgwKTsNCj4gPiArCW11dGV4X2xvY2soJnNkZXYtPmlu
cXVpcnlfbXV0ZXgpOw0KPiA+ICsJa2ZyZWUocmN1X2RlcmVmZXJlbmNlKHNkZXYtPnZwZF9wZzgz
KSk7DQo+ID4gKwlrZnJlZShyY3VfZGVyZWZlcmVuY2Uoc2Rldi0+dnBkX3BnODApKTsNCj4gPiAr
CW11dGV4X3VubG9jaygmc2Rldi0+aW5xdWlyeV9tdXRleCk7DQo+ID4gKw0KPiA+ICAJa2ZyZWUo
c2Rldi0+aW5xdWlyeSk7DQo+ID4gIAlrZnJlZShzZGV2KTsNCj4gDQo+IEFzIGluZGljYXRlZCBi
eSBTaGFuZSwgSSB0aGluayB1c2luZyAna2ZyZWVfcmN1KCknIGhlcmUgbWlnaHQgbm90IGJlIGEN
Cj4gYmFkIGlkZWEuIFlvdSBuZXZlciBrbm93IC4uLg0KDQpJIHdpbGwgbWFrZSB0aGF0IGNoYW5n
ZS4gVGhhbmtzIGZvciB0aGUgcmV2aWV3cyENCg0KQmFydC4=
