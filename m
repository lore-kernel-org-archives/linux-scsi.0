From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_dh_alua: skip RTPG for devices only supporting
 active/optimized
Date: Tue, 12 Dec 2017 00:00:30 +0000
Message-ID: <1513036829.2747.36.camel@wdc.com>
References: <1512728048-84729-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4178 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdLLAAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 19:00:36 -0500
In-Reply-To: <1512728048-84729-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <2B20C786CB074A45A664BCF8BAC5B0CD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gRnJpLCAyMDE3LTEyLTA4IGF0IDExOjE0ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEBAIC01NDEsNiArNTQ0LDIwIEBAIHN0YXRpYyBpbnQgYWx1YV9ydHBnKHN0cnVjdCBzY3Np
X2RldmljZSAqc2Rldiwgc3RydWN0IGFsdWFfcG9ydF9ncm91cCAqcGcpDQo+ICAJcmV0dmFsID0g
c3VibWl0X3J0cGcoc2RldiwgYnVmZiwgYnVmZmxlbiwgJnNlbnNlX2hkciwgcGctPmZsYWdzKTsN
Cj4gIA0KPiAgCWlmIChyZXR2YWwpIHsNCj4gKwkJLyoNCj4gKwkJICogSWYgdGhlIHRhcmdldCBv
bmx5IHN1cHBvcnRzIGFjdGl2ZS9vcHRpbWl6ZWQgdGhlcmUncw0KPiArCQkgKiBub3QgbXVjaCB3
ZSBjYW4gZG87IGl0J3Mgbm90IHRoYXQgd2UgY2FuIHN3aXRjaCBwYXRocw0KPiArCQkgKiBvciBz
b21lc3VjaC4NCj4gKwkJICogU28gaWdub3JlIGFueSBlcnJvcnMgdG8gYXZvaWQgc3B1cmlvdXMg
ZmFpbHVyZXMgZHVyaW5nDQo+ICsJCSAqIHBhdGggZmFpbG92ZXIuDQo+ICsJCSAqLw0KPiArCQlp
ZiAoKHBnLT52YWxpZF9zdGF0ZXMgJiB+VFBHU19TVVBQT1JUX09QVElNSVpFRCkgPT0gMCkgew0K
PiArCQkJc2Rldl9wcmludGsoS0VSTl9JTkZPLCBzZGV2LA0KPiArCQkJCSAgICAiJXM6IGlnbm9y
aW5nIHJ0cGcgcmVzdWx0ICVkXG4iLA0KPiArCQkJCSAgICBBTFVBX0RIX05BTUUsIHJldHZhbCk7
DQo+ICsJCQlrZnJlZShidWZmKTsNCj4gKwkJCXJldHVybiBTQ1NJX0RIX09LOw0KPiArCQl9DQoN
CkhlbGxvIEhhbm5lcywNCg0KU29ycnkgYnV0IHRoaXMgY2hhbmdlIGxvb2tzIHdlaXJkIHRvIG1l
LiBJZiBhbiBSVFBHIGZhaWxzLCBzaG91bGRuJ3QNCmFsdWFfcnRwZygpIHJldHVybiBTQ1NJX0RI
X0lPIGluZGVwZW5kZW50IG9mIHdoYXQgQUxVQSBzdGF0ZXMgdGhlIHRhcmdldA0Kc3VwcG9ydHM/
IEFyZSB5b3UgcGVyaGFwcyB0cnlpbmcgdG8gaW1wbGVtZW50IGEgd29yay1hcm91bmQgZm9yIGFu
IGFycmF5DQp0aGF0IGRvZXMgbm90IHJlc3BvbmQgdG8gUlRQRyBkdXJpbmcgcGF0aCB0cmFuc2l0
aW9ucz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
