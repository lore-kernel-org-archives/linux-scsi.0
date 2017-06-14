From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: mpt3sas: driver got task abort request just after it's
 .shutdown() function is invoked
Date: Wed, 14 Jun 2017 14:29:55 +0000
Message-ID: <1497450593.3896.2.camel@wdc.com>
References: <CAK=zhgqfFhLcpZGYrsBRjCiFRwz_8sf=hEt+Jd1aJEvMd8x61Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:39667 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbdFNO37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2017 10:29:59 -0400
In-Reply-To: <CAK=zhgqfFhLcpZGYrsBRjCiFRwz_8sf=hEt+Jd1aJEvMd8x61Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <CA966D05342FF44C91BED484BAC122EC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jejb@kernel.org" <jejb@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE3LTA2LTE0IGF0IDEyOjIwICswNTMwLCBTcmVla2FudGggUmVkZHkgd3JvdGU6
DQo+IEkgYW0gdXNpbmcgNC45IGtlcm5lbCBhbmQgSSBhbSBvYnNlcnZpbmcgTlVMTCBwb2ludGVy
IGRlZmVyZW5jZSB0eXBlDQo+IGtlcm5lbCBwYW5pYyBpbiB0aGUgYmVsb3cgc2NlbmFyaW8sDQo+
IA0KPiAqIEhvdHBsdWcgKGkuZS4gaG90IGFkZCkgdGhlIEhCQSAod2l0aCBhIHNldCBvZiBkcml2
ZXMgYXR0YWNoZWQgdG8gaXQpDQo+IHRvIHRoZSBzeXN0ZW0ganVzdCBmZXcgc2Vjb25kcyBiZWZv
cmUgaXNzdWluZyAicG93ZXJvZmYiIGNvbW1hbmQuDQo+IA0KPiAqIE9ic2VydmVkIHRoYXQgZHVy
aW5nIGRyaXZlcyBkaXNjb3ZlcnkgcHJvY2VzczsgZm9yIHNvbWUgb2YgdGhlDQo+IGRyaXZlcyAi
TU9ERSBTRU5TRSIgY29tbWFuZCBnb3QgdGltZWQgb3V0Lg0KPiANCj4gKiBBbmQgYXMgInBvd2Vy
b2ZmIiBjb21tYW5kIGlzc3VlZCwgc28ga2VybmVsIGFzIGNhbGxlZCBkcml2ZXIncw0KPiBzaHV0
ZG93bigpIGNhbGxiYWNrIGZ1bmN0aW9uIGFuZCBkcml2ZXIgaGFzIGNsZWFuZWQgdXAgYWxsIHRo
ZSBIQkENCj4gcmVzb3VyY2VzIChzdWNoIGFzIElSUSdzLCBtZW1vcnkgcG9vbHMgZXRjKS4NCj4g
DQo+ICogQnV0IGFzIHRoZSAiTU9ERSBTRU5TRSIgY29tbWFuZCBnb3QgdGltZWQgb3V0LCBzbyBT
Q1NJIEVIIHRocmVhZCBoYXMNCj4gaW52b2tlZCBkcml2ZXIncyAuZWhfYWJvcnRfaGFuZGxlcigp
IGNhbGxiYWNrIGZ1bmN0aW9uLCBidXQgYnkgdGhpcw0KPiB0aW1lIGRyaXZlciBoYXMgYWxyZWFk
eSBjbGVhbmVkIHVwIHRoZSByZXNvdXJjZXMgYW5kIHNvIGl0IGxlYWRzIHRvDQo+IGtlcm5lbCBw
YW5pYyB3aGVuIGl0IHRyeWluZyB0byBhY2Nlc3Mgb25lIG9mIHRoZXNlIHJlc291cmNlcy4NCj4g
DQo+IEkgd2FzIGFzc3VtaW5nIHRoYXQga2VybmVsIHNob3VsZCBub3QgY2FsbCBkcml2ZXIncyBz
aHV0ZG93bigpDQo+IGNhbGxiYWNrIGZ1bmN0aW9uIHVudGlsIGFsbCB0aGUgb3V0c3RhbmRpbmcg
SU9zIGNvdW50IHJlYWNoZXMgdG8gemVybw0KPiAoaS5lLiBrZXJuZWwgc2hvdWxkIGNhbGwgdGhl
IGRyaXZlcidzIHNodXRkb3duKCkgZnVuY3Rpb25zIG9ubHkgYWZ0ZXINCj4gY2xlYXJpbmcgdXAg
YWxsIHRoZSBvdXRzdGFuZGluZyBJT3MpLiBQbGVhc2UgY29ycmVjdCBtZSBpZiBJIGFtIHdyb25n
LA0KPiBhbmQgcGxlYXNlIHN1Z2dlc3QgYmV0dGVyIHdheSB0byBoYW5kbGUgdGhlc2UgdHlwZXMg
b2YgaXNzdWVzLg0KDQpIZWxsbyBTcmVla2FudGgsDQoNClRoZSBTQ1NJIGNvcmUgaXMgbm90IGF3
YXJlIG9mIFBDSWUgKGhvdC0pcmVtb3ZhbCBhbmQgaGVuY2UgY2Fubm90IGhlbHANCmluIHRoaXMg
Y2FzZS4gSSB0aGluayBTQ1NJIExMRHMgYXJlIHJlc3BvbnNpYmxlIHdoZW4gLnNodXRkb3duKCkg
aXMNCmNhbGxlZCBmb3IgMSkgd2FpdGluZyB1bnRpbCBhbnkgb25nb2luZyBzY3NpX3NjYW5fdGFy
Z2V0KCkgY2FsbCBoYXMNCmZpbmlzaGVkIGFuZCAyKSBjYWxsaW5nIHNjc2lfcmVtb3ZlX2hvc3Qo
KSBmcm9tIGluc2lkZSBwY2lfZHJpdmVyLnNodXRkb3duKCkuDQoNCkJhcnQu
