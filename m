From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC] sg3_utils: sgp_dd: work around on pthread_cancel for
 android
Date: Fri, 22 Dec 2017 18:24:51 +0000
Message-ID: <1513967090.2579.13.camel@sandisk.com>
References: <e5c8b6616ea7487d83087da7623576ae@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4327 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756554AbdLVSYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 13:24:55 -0500
In-Reply-To: <e5c8b6616ea7487d83087da7623576ae@SIWEX5A.sing.micron.com>
Content-Language: en-US
Content-ID: <A53BAF75562E55438FE0E6F988BF4D81@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "hare@suse.de" <hare@suse.de>

T24gRnJpLCAyMDE3LTEyLTIyIGF0IDE3OjAwICswMDAwLCBCZWFuIEh1byAoYmVhbmh1bykgd3Jv
dGU6DQo+ICBjYXNlICIke2hvc3R9IiBpbg0KPiArICAgICAgICAqLSotYW5kcm9pZCopDQo+ICsJ
CUFDX0RFRklORV9VTlFVT1RFRChTR19PTl9BTkRST0lELCAxLCBbc2czX3V0aWxzIG9uIGFuZHJv
aWRdKQ0KPiArCQlBQ19ERUZJTkVfVU5RVU9URUQoU0dfTElCX0xJTlVYLCAxLCBbc2czX3V0aWxz
IG9uIGxpbnV4XSkNCj4gKyAgICAgICAgICAgICAgICBBQ19TVUJTVChbb3NfY2ZsYWdzXSwgWycn
XSkNCj4gKyAgICAgICAgICAgICAgICBBQ19TVUJTVChbb3NfbGlic10sIFsnJ10pIDs7DQo+ICAg
ICAgICAgICotKi1saW51eC1nbnUqKQ0KPiAgCQlBQ19ERUZJTkVfVU5RVU9URUQoU0dfTElCX0xJ
TlVYLCAxLCBbc2czX3V0aWxzIG9uIGxpbnV4XSkNCj4gICAgICAgICAgICAgICAgICBBQ19TVUJT
VChbb3NfY2ZsYWdzXSwgWycnXSkNCj4gQEAgLTc5LDYgKzg0LDcgQEAgQU1fQ09ORElUSU9OQUwo
T1NfT1NGLCBbZWNobyAkaG9zdF9vcyB8IGdyZXAgJ15vc2YnID4gL2Rldi9udWxsXSkNCj4gIEFN
X0NPTkRJVElPTkFMKE9TX1NPTEFSSVMsIFtlY2hvICRob3N0X29zIHwgZ3JlcCAnXnNvbGFyaXMn
ID4gL2Rldi9udWxsXSkNCj4gIEFNX0NPTkRJVElPTkFMKE9TX1dJTjMyX01JTkdXLCBbZWNobyAk
aG9zdF9vcyB8IGdyZXAgJ15taW5ndycgPiAvZGV2L251bGxdKQ0KPiAgQU1fQ09ORElUSU9OQUwo
T1NfV0lOMzJfQ1lHV0lOLCBbZWNobyAkaG9zdF9vcyB8IGdyZXAgJ15jeWd3aW4nID4gL2Rldi9u
dWxsXSkNCj4gK0FNX0NPTkRJVElPTkFMKE9TX0FORFJPSUQsIFtlY2hvICRob3N0X29zIHwgZ3Jl
cCAnYW5kcm9pZCcgPiAvZGV2L251bGxdKQ0KDQpIZWxsbyBCZWFuLA0KDQpQbGVhc2UgY29uc2lk
ZXIgdG8gdXNlIEFDX0NIRUNLX0ZVTkMoW3B0aHJlYWRfY2FuY2VsXSkgb3Igc2ltaWxhciB0byBj
aGVjayB0aGUNCmF2YWlsYWJpbGl0eSBvZiBwdGhyZWFkX2NhbmNlbCgpLiBFeHBsaWNpdCBkaXN0
cm8gY2hlY2tzIGFyZSBtdWNoIGhhcmRlciB0byBtYWludGFpbg0KdGhhbiBjaGVja3MgZm9yIGlu
ZGl2aWR1YWwgZnVuY3Rpb25zLg0KDQpUaGFua3MsDQoNCkJhcnQu
