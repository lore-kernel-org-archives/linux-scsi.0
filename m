From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V5 07/14] scsi: sd_zbc: Initialize device request queue
 zoned data
Date: Mon, 2 Oct 2017 04:29:43 +0000
Message-ID: <1506918581.24488.0.camel@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
         <20170925061454.5533-8-damien.lemoal@wdc.com>
         <1506374241.2641.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6604 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdJBE3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 00:29:49 -0400
In-Reply-To: <1506374241.2641.20.camel@wdc.com>
Content-Language: en-US
Content-ID: <9AC19408D0C75842A79ABF4568E3AAE3@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDIxOjE3ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIE1vbiwgMjAxNy0wOS0yNSBhdCAxNToxNCArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3Jv
dGU6DQo+ID4gKwlyZXR1cm4ga3phbGxvY19ub2RlKEJJVFNfVE9fTE9OR1Moc2RrcC0+bnJfem9u
ZXMpDQo+ID4gKwkJCSAgICAqIHNpemVvZih1bnNpZ25lZCBsb25nKSwNCj4gDQo+IERvZXMgdGhp
cyBwZXJoYXBzIGZpdCBvbiBvbmUgbGluZT8NCj4gDQo+ID4gKy8qKg0KPiA+ICsgKiBzZF96YmNf
Z2V0X3NlcV96b25lcyAtIFBhcnNlIHJlcG9ydCB6b25lcyByZXBseSB0byBpZGVudGlmeSBzZXF1
ZW50aWFsDQo+ID4gem9uZXMNCj4gPiArICogQHNka3A6IGRpc2sgdXNlZA0KPiA+ICsgKiBAYnVm
OiByZXBvcnQgcmVwbHkgYnVmZmVyDQo+ID4gKyAqIEBzZXFfem9uZV9iaXRhbXA6IGJpdG1hcCBv
ZiBzZXF1ZW50aWFsIHpvbmVzIHRvIHNldA0KPiA+ICsgKiBAem5vOiBab25lIG51bWJlciBvZiB0
aGUgZmlyc3Qgem9uZSBpbiB0aGUgcmVwb3J0DQo+IA0KPiAnem5vJyBpcyBhbiBpbnB1dCBhbmQg
b3V0cHV0IHBhcmFtZXRlciBidXQgdGhlIGFib3ZlIGxpbmUgb25seSBkZXNjcmliZXMNCj4gd2hh
dA0KPiBoYXBwZW5zIHdpdGggdGhlIHZhbHVlIHBhc3NlZCB0byBzZF96YmNfZ2V0X3NlcV96b25l
cygpLiBJIHRoaW5rIHdlIGFsc28NCj4gbmVlZCBhDQo+IGRlc2NyaXB0aW9uIGZvciB0aGUgdmFs
dWUgb2YgJ3pubycgdXBvbiByZXR1cm4uDQoNCnpubyBpcyBub3QgbmVjZXNzYXJ5IHNpbmNlIGl0
IGNhbiBiZSBjYWxjdWxhdGVkIGZyb20gdGhlIHJlcG9ydGVkIHpvbmUgc3RhcnQNCkxCQS4gU28g
SSByZW1vdmVkIGl0IGluIFY2IHRvIHNpbXBsaWZ5Lg0KDQotLSANCkRhbWllbiBMZSBNb2FsDQpX
ZXN0ZXJuIERpZ2l0YWw=
