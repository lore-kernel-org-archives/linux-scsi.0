From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 03/15] mpt3sas: Add sanity checks for scsi tracker before
 accessing it.
Date: Tue, 3 Apr 2018 15:56:25 +0000
Message-ID: <b0c9d6448cd7f47536a86d0608a2a0dde1715573.camel@wdc.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
         <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com>
         <20180330115917.GA30423@infradead.org>
         <CAK=zhgosiBbQbdn2xnAffgRtzMEzp8_FLpSmY3m+XxwHuBCwNg@mail.gmail.com>
         <a4ec673d5dbd62e05bbc8c777de5e4a080c62336.camel@wdc.com>
         <CAK=zhgqoJW0ASfQv4C4J=X9zXyuUhVdk-68xv=vFfHA_NSmLTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgqoJW0ASfQv4C4J=X9zXyuUhVdk-68xv=vFfHA_NSmLTg@mail.gmail.com>
Content-Language: en-US
Content-ID: <5274070D50C35044A955935D4834A4C7@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "hch@infradead.org" <hch@infradead.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTA0LTAzIGF0IDEwOjExICswNTMwLCBTcmVla2FudGggUmVkZHkgd3JvdGU6
DQo+IFtTUl0gTm8sIGRyaXZlciBjYWxscyBfc2NzaWhfZmx1c2hfcnVubmluZ19jbWRzIGR1cmlu
ZyBIb3N0IHJlc2V0IHRpbWUNCj4gYW5kIGR1cmluZyBob3N0IHJlc2V0IHRpbWUgZHJpdmVyIHdp
bGwgc2V0ICdpb2MtPnNob3N0X3JlY292ZXJ5JyBmbGFnLg0KPiBTbyBpbiB0aGUgc2NzaWhfcWNt
ZCgpIGRyaXZlciB3aWxsIHJldHVybiB0aGUgaW5jb21pbmcgU0NTSSBjbWRzIHdpdGgNCj4gIlND
U0lfTUxRVUVVRV9IT1NUX0JVU1kiIHdoZW5ldmVyICdpb2MtPnNob3N0X3JlY292ZXJ5JyBmbGFn
IGlzIHNldCBhcw0KPiBzaG93biBiZWxvdywNCj4gDQo+IC8qIGhvc3QgcmVjb3Zlcnkgb3IgbGlu
ayByZXNldHMgc2VudCB2aWEgSU9DVExzICovDQo+ICAgICAgICAgaWYgKGlvYy0+c2hvc3RfcmVj
b3ZlcnkgfHwgaW9jLT5pb2NfbGlua19yZXNldF9pbl9wcm9ncmVzcykNCj4gICAgICAgICAgICAg
ICAgIHJldHVybiBTQ1NJX01MUVVFVUVfSE9TVF9CVVNZOw0KDQpUaGUgaW9jLT5zaG9zdF9yZWNv
dmVyeSBmbGFnIGlzIGludm9sdmVkIGluIGF0IGxlYXN0IHRoZSBmb2xsb3dpbmcgcmFjZToNCiog
RnJvbSBvbmUgY29udGV4dCBhIFNDU0kgY29tbWFuZCBpcyBzdWJtaXR0ZWQgYW5kIHNjc2loX3Fj
bWQoKSBnZXRzIGNhbGxlZC4NCiogQXQgdGhlIHNhbWUgdGltZSBzZ19yZXNldCBpcyBpbnZva2Vk
IGZyb20gYSBzaGVsbCBhbmQgdHJpZ2dlcnMgYSBjYWxsIHRvDQogIHNjc2loX2hvc3RfcmVzZXQo
KS4gVGhhdCBmdW5jdGlvbiBpbiB0dXJuIHdpbGwgY2FsbA0KICBtcHQzc2FzX2Jhc2VfaGFyZF9y
ZXNldF9oYW5kbGVyKCkuDQoNCkkgdGhpbmsgdGhpcyBzY2VuYXJpbyBjYW4gY2F1c2UgaW9jLT5z
aG9zdF9yZWNvdmVyeSB0byBiZSBzZXQgYnkgdGhlIG1wdDNzYXMNCmRyaXZlciBhZnRlciBpdCBo
YXMgYmVlbiBjaGVja2VkIGJ5IHRoZSBzY3NpaF9xY21kKCkgZnVuY3Rpb24uDQoNCkFueXdheSwg
bGV0J3MgZ2V0IGJhY2sgdG8gcGF0Y2ggMDMvMTUgYXQgdGhlIHN0YXJ0IG9mIHRoaXMgZS1tYWls
IHRocmVhZC4NClRoYXQgcGF0Y2ggbG9va3MgdG8gbWUgbGlrZSBhbiBpbmNvbXBsZXRlIGF0dGVt
cHQgdG8gd29yayBhcm91bmQgYSByYWNlDQpjb25kaXRpb24gaW4gdGhlIG1wdDNzYXMgZHJpdmVy
LiBJIGRvbid0IGV4cGVjdCB0aGF0IGFueW9uZSB3aWxsIHRydXN0IHRoYXQNCnBhdGNoIHdpdGhv
dXQgZnVydGhlciBleHBsYW5hdGlvbi4gV2hpY2ggcmFjZSBjb25kaXRpb24gZG9lcyB0aGF0IHBh
dGNoDQphZGRyZXNzPyBBbmQgd2h5IGRvIHRoZSBtcHQzc2FzIG1haW50YWluZXJzIGJlbGlldmUg
dGhhdCB0aGlzIHBhdGNoIGlzDQpzdWZmaWNpZW50IHRvIGFkZHJlc3MgdGhhdCByYWNlIGNvbmRp
dGlvbj8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQo=
