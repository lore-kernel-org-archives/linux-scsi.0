From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sat, 7 Apr 2018 02:06:39 +0000
Message-ID: <a631d319b0123a0f90b68e44a7df19dffb253751.camel@wdc.com>
References: <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
         <20180331221252.GA25573@animx.eu.org>
         <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
         <20180401113721.GA8471@animx.eu.org> <20180401163604.GB25011@animx.eu.org>
         <20180401182723.GA31755@animx.eu.org>
         <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
         <20180406014644.GA16112@animx.eu.org> <20180406020651.GB16112@animx.eu.org>
         <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
         <20180407010334.GA11092@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180407010334.GA11092@animx.eu.org>
Content-Language: en-US
Content-ID: <1273440D4C884042A0676C85A025C9AE@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "wakko@animx.eu.org" <wakko@animx.eu.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTA0LTA2IGF0IDIxOjAzIC0wNDAwLCBXYWtrbyBXYXJuZXIgd3JvdGU6DQo+
IEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMTgtMDQtMDUgYXQgMjI6MDYg
LTA0MDAsIFdha2tvIFdhcm5lciB3cm90ZToNCj4gPiA+IEkga25vdyBub3cgd2h5IHNjc2lfcHJp
bnRfY29tbWFuZCBpc24ndCBkb2luZyBhbnl0aGluZy4gIGNtZC0+Y21uZCBpcyBudWxsLg0KPiA+
ID4gSSBhZGRlZCBhIGRldl9wcmludGsgaW4gc2NzaV9wcmludF9jb21tYW5kIHdoZXJlIHRoZSAy
IGlmIHN0YXRlbWVudHMgcmV0dXJuLg0KPiA+ID4gTG9nczoNCj4gPiA+IFsgIDI5Ljg2NjQxNV0g
c3IgMzowOjA6MDogY21kLT5jbW5kIGlzIE5VTEwNCj4gPiANCj4gPiBUaGF0J3Mgc29tZXRoaW5n
IHRoYXQgc2hvdWxkIG5ldmVyIGhhcHBlbi4gQXMgb25lIGNhbiBzZWUgaW4NCj4gPiBzY3NpX3Nl
dHVwX3Njc2lfY21uZCgpIGFuZCBzY3NpX3NldHVwX2ZzX2NtbmQoKSBib3RoIGZ1bmN0aW9ucyBp
bml0aWFsaXplDQo+ID4gdGhhdCBwb2ludGVyLiBTaW5jZSBJIGhhdmUgbm90IHlldCBiZWVuIGFi
bGUgdG8gcmVwcm9kdWNlIG15c2VsZiB3aGF0IHlvdQ0KPiA+IHJlcG9ydGVkLCB3b3VsZCBpdCBi
ZSBwb3NzaWJsZSBmb3IgeW91IHRvIGJpc2VjdCB0aGlzIGlzc3VlPyBZb3Ugd2lsbCBuZWVkDQo+
ID4gdG8gZm9sbG93IHNvbWV0aGluZyBsaWtlIHRoZSBmb2xsb3dpbmcgcHJvY2VkdXJlIChzZWUg
YWxzbw0KPiA+IGh0dHBzOi8vZ2l0LXNjbS5jb20vZG9jcy9naXQtYmlzZWN0KToNCj4gPiANCj4g
PiBnaXQgY2xvbmUgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3RvcnZhbGRzL2xpbnV4LmdpdA0KPiA+IGdpdCBiaXNlY3Qgc3RhcnQNCj4gPiBnaXQgYmlzZWN0
IGJhZCB2NC4xMA0KPiA+IGdpdCBiaXNlY3QgZ29vZCB2NC45DQo+ID4gDQo+ID4gYW5kIHRoZW4g
YnVpbGQgdGhlIGtlcm5lbCwgaW5zdGFsbCBpdCwgYm9vdCB0aGUga2VybmVsIGFuZCB0ZXN0IGl0
Lg0KPiA+IERlcGVuZGluZyBvbiB0aGUgcmVzdWx0LCBydW4gZWl0aGVyIGdpdCBiaXNlY3QgYmFk
IG9yIGdpdCBiaXNlY3QgZ29vZCBhbmQNCj4gPiBrZWVwIGdvaW5nIHVudGlsIGdpdCBiaXNlY3Qg
Y29tZXMgdG8gYSBjb25jbHVzaW9uLiBUaGlzIGNhbiB0YWtlIGFuIGhvdXIgb3INCj4gPiBtb3Jl
Lg0KPiANCj4gSSBoYXZlIDEgcXVlc3Rpb24uICBTaG91bGQgbWFrZSBjbGVhbiBiZSBkb25lIGJl
dHdlZW4gdGVzdHM/ICBNeSBib3gNCj4gY29tcGlsZXMgdGhlIHdob2xlIGtlcm5lbCBpbiAyIG1p
bnV0ZXMuDQoNCklmIHlvdSB0cnVzdCB0aGF0IHRoZSBidWlsZCBzeXN0ZW0gd2lsbCBmaWd1cmUg
b3V0IGFsbCBkZXBlbmRlbmNpZXMgdGhlbg0KcnVubmluZyBtYWtlIGNsZWFuIGlzIG5vdCBuZWNl
c3NhcnkuIFBlcnNvbmFsbHkgSSBhbHdheXMgcnVuIG1ha2UgY2xlYW4NCmR1cmluZyBhIGJpc2Vj
dCBiZWZvcmUgcmVidWlsZGluZyB0aGUga2VybmVsIGJlY2F1c2UgaWYgYSBoZWFkZXIgZmlsZSBo
YXMNCmNoYW5nZWQgaW4gZS5nLiB0aGUgYmxvY2sgbGF5ZXIgYSBodWdlIG51bWJlciBvZiBmaWxl
cyBoYXMgdG8gYmUgcmVidWlsdA0KYW55d2F5Lg0KDQpCYXJ0Lg0KDQoNCg==
