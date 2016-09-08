From: Scott Benesh <scott.benesh@microsemi.com>
Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Thu, 8 Sep 2016 18:33:52 +0000
Message-ID: <48C22F0C33E45A4F83E15DF49719341D38F495F6@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
         <146706367078.29152.14405582249219794335.stgit@brunhilda>
         <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
         <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net>
 <1473359114.2781.38.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0050.outbound.protection.outlook.com ([104.47.33.50]:5188
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932233AbcIHWJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 18:09:38 -0400
In-Reply-To: <1473359114.2781.38.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiANCj4gT24gVGh1LCAyMDE2LTA5LTA4IGF0IDE4OjE1ICswMDAwLCBEb24gQnJhY2Ugd3JvdGU6
DQo+ID4gPiA+IC0gICAgeyAweDkwMDUsIDB4MDI4ZiwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgNjUgfSwgLyoNCj4gPiA+ID4gQWRhcHRlYyBQTUMNCj4gPiA+ID4gU2VyaWVzIDkgKi8N
Cj4gPiA+ID4NCj4gPiA+ID4gSG93IGFyZSBwZW9wbGUgdGhhdCBsb2FkIGFhY3JhaWQgaW4gdGhl
aXIgaW5pdHJkIGdvaW5nIHRvIGJvb3QNCj4gPiA+ID4gYWZ0ZXIgdGhpcz8NCj4gPiA+ID4NCj4g
PiA+ID4gLS0NCj4gPiA+ID4gTWFydGluIEsuIFBldGVyc2VuICAgICAgT3JhY2xlIExpbnV4IEVu
Z2luZWVyaW5nDQo+ID4gPg0KPiA+ID4gSSB1cGRhdGVkIHNtYXJ0cHFpL0tjb25maWcgYW5kIGFk
ZGVkIERvY3VtZW50YXRpb24vc2NzaS9zbWFydHBxaS50eHQNCj4gPiA+IHRvIGluZm9ybSB1c2Vy
cyBvZiB0aGUgbmVlZCB0byBjb25maWd1cmUgdGhlIHNtYXJ0cHFpIGRyaXZlciBtb3ZpbmcNCj4g
PiA+IGZvcndhcmQgZm9yIGFhY3JhaWQgU2VyaWVzIDkgY29udHJvbGxlcnMuDQo+ID4gPg0KPiA+
ID4gSG9wZSB0aGlzIGhlbHBzLg0KPiANCj4gVGhhdCdzIG5vdCBnb2luZyB0byBiZSBlbm91Z2g6
IHRoaXMgSUQgaGFzIGJlZW4gaW4gdGhlIGFhY3JpYWQgZHJpdmVyIHNpbmNlDQo+IDIwMTEuICBU
aGF0IG1lYW5zIGFueW9uZSB3aG8gZmluYWxseSBnZXRzIGhvbGQgb2Ygb25lIG9mIHRoZXNlIG5l
dyBjYXJkcw0KPiBidXQgdXNlcyBhIGRpc3RybyB0aGF0IGRvZXNuJ3QgaGF2ZSB0aGUgbmV3IHNt
YXJ0cHFpIGRyaXZlciB3aWxsIGJlIGF0dGFjaGVkDQo+IHZpYSB0aGUgYWFjcmFpZCBvbmUuDQo+
IA0KDQpUaGF0J3Mgb2sgYmVjYXVzZSBmb3IgcHJldmlvdXMgZGlzdHJvcyB0aGUgbmV3IGNvbnRy
b2xsZXIgd2lsbCB3b3JrIHdpdGggdGhlIHByZXZpb3VzIGFhY3JhaWQgZHJpdmVyLCBhbHRob3Vn
aCB3aXRoIG5vbi1vcHRpbWFsIHBlcmZvcm1hbmNlLg0KDQpXaGF0IHdlIHdhbnQgdG8gZG8gaXMg
c3luYyB1cCBhdCA0Ljkgc28gZ29pbmcgZm9yd2FyZCBvbmx5IHRoZSBuZXcgc21hcnRwcWkgZHJp
dmVyIHdpbGwgYXR0YWNoIHRvIHRoZXNlIG5ldyBjb250cm9sbGVycy4NCg0KU2NvdHQNCg0KPiBH
aXZlbiB0aGF0IHRoZSBsaWZlIHRpbWVzIG9mIGVudGVycHJpc2UgZGlzdHJpYnV0aW9ucyBpcyB0
d28geWVhcnMgYW5kIHlvdSdyZQ0KPiByZWxlYXNpbmcgdGhpcyBzbWFydHBxaSBzb29uLCB0aGUg
b3ZlcmxhcCBpcyB1bmF2b2lkYWJsZS4NCj4gDQo+IEphbWVzDQo+IA0KDQo=
