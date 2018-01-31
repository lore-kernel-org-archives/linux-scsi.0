From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] test-case
Date: Wed, 31 Jan 2018 22:50:24 +0000
Message-ID: <1517439022.7325.9.camel@wdc.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
         <1517426684-23050-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:15166 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbeAaWu0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2018 17:50:26 -0500
In-Reply-To: <1517426684-23050-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <93D529441470714BBDDDF41BFD6273CB@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE4LTAxLTMxIGF0IDE3OjI0IC0wMjAwLCBNYXVyaWNpbyBGYXJpYSBkZSBPbGl2
ZWlyYSB3cm90ZToNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNf
c2NzaWguYyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYw0KPiBpbmRleCAz
YzRlNDdjLi42MTFjZWUzMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0
M3Nhc19zY3NpaC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWgu
Yw0KPiBAQCAtMjk5Nyw2ICsyOTk3LDEyIEBAIGludCBtcHQzc2FzX3Njc2loX2lzc3VlX2xvY2tl
ZF90bShzdHJ1Y3QgTVBUM1NBU19BREFQVEVSICppb2MsIHUxNiBoYW5kbGUsDQo+ICAJCSJhdHRl
bXB0aW5nIHRhc2sgYWJvcnQhIHNjbWQoJXApXG4iLCBzY21kKTsNCj4gIAlfc2NzaWhfdG1fZGlz
cGxheV9pbmZvKGlvYywgc2NtZCk7DQo+ICANCj4gKwlpZiAoaW9jLT5sb2dnaW5nX2xldmVsICYg
MHgwMTAwMDAwMCkgew0KPiArCQlwcl9pbmZvKE1QVDNTQVNfRk1UICJmYWlsIHRhc2sgYWJvcnQg
c2NtZCglcClcbiIsIGlvYy0+bmFtZSwgc2NtZCk7DQo+ICsJCXIgPSBGQUlMRUQ7DQo+ICsJCWdv
dG8gb3V0Ow0KPiArCX0NCj4gKw0KPiAgCXNhc19kZXZpY2VfcHJpdl9kYXRhID0gc2NtZC0+ZGV2
aWNlLT5ob3N0ZGF0YTsNCj4gIAlpZiAoIXNhc19kZXZpY2VfcHJpdl9kYXRhIHx8ICFzYXNfZGV2
aWNlX3ByaXZfZGF0YS0+c2FzX3RhcmdldCkgew0KPiAgCQlzZGV2X3ByaW50ayhLRVJOX0lORk8s
IHNjbWQtPmRldmljZSwNCj4gQEAgLTU1ODQsNiArNTU5MCwxMSBAQCBzdGF0aWMgaW50IF9zY3Np
aF9zZXRfc2F0bF9wZW5kaW5nKHN0cnVjdCBzY3NpX2NtbmQgKnNjbWQsIGJvb2wgcGVuZGluZykN
Cj4gIA0KPiAgCXNjc2lfZG1hX3VubWFwKHNjbWQpOw0KPiAgDQo+ICsJaWYgKGlvYy0+bG9nZ2lu
Z19sZXZlbCAmIDB4MTAwMDAwMDAgJiYgc2NtZC0+Y21uZFswXSAhPSAweDM1KSB7DQo+ICsJCXBy
X2luZm8oTVBUM1NBU19GTVQgInNraXAgc2NzaV9kb25lIHNjbWQoJXApXG4iLCBpb2MtPm5hbWUs
IHNjbWQpOw0KPiArCQlyZXR1cm4gMTsNCj4gKwl9DQo+ICsNCj4gIAlzY21kLT5zY3NpX2RvbmUo
c2NtZCk7DQo+ICAJcmV0dXJuIDE7DQo+ICB9DQo+IEBAIC0xMDAxNiw2ICsxMDAyNywxMSBAQCBz
dGF0aWMgdm9pZCBzY3NpaF9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ICANCj4gIAlf
c2NzaWhfaXJfc2h1dGRvd24oaW9jKTsNCj4gIAltcHQzc2FzX2Jhc2VfZGV0YWNoKGlvYyk7DQo+
ICsNCj4gKwl3aGlsZSAoaW9jLT5sb2dnaW5nX2xldmVsICYgMHgxMDAwMDAwMCkgew0KPiArCQlw
cl9pbmZvKE1QVDNTQVNfRk1UICJzbGVlcCBvbiBzaHV0ZG93blxuIiwgaW9jLT5uYW1lKTsNCj4g
KwkJc3NsZWVwKDEpOw0KPiArCX0NCj4gIH0NCg0KSGVsbG8gTWF1cmljaW8sDQoNCkkgdGhpbmsg
aXQgd291bGQgYmUgdXNlZnVsIHRvIGhhdmUgc29tZSB2YXJpYW50IG9mIHRoZSBhYm92ZSBjb2Rl
IGluIHRoZSBrZXJuZWwNCnRyZWUuIEFyZSB5b3UgZmFtaWxpYXIgd2l0aCB0aGUgZmF1bHQgaW5q
ZWN0aW9uIGZyYW1ld29yayAoc2VlIGFsc28NCjxsaW51eC9mYXVsdC1pbmplY3QuaD4gYW5kIERv
Y3VtZW50YXRpb24vZmF1bHQtaW5qZWN0aW9uL2ZhdWx0LWluamVjdGlvbi50eHQpPw0KRG8geW91
IHRoaW5rIHRoYXQgZnJhbWV3b3JrIHdvdWxkIGJlIGFwcHJvcHJpYXRlIGZvciBjb250cm9sbGlu
ZyB3aGV0aGVyIG9yIG5vdA0KdGhlIGFib3ZlIGNvZGUgZ2V0cyBleGVjdXRlZD8NCg0KVGhhbmtz
LA0KDQpCYXJ0Lg==
