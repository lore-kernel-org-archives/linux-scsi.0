From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH resend 6/6] cdrom: wait for drive to become ready
Date: Mon, 29 Jan 2018 17:11:20 +0000
Message-ID: <1517245879.2687.19.camel@wdc.com>
References: <cover.1516985620.git.msuchanek@suse.de>
         <42c05eb47f17a2942cb107b5ddb2a6bd402b76e7.1516985620.git.msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <42c05eb47f17a2942cb107b5ddb2a6bd402b76e7.1516985620.git.msuchanek@suse.de>
Content-Language: en-US
Content-ID: <D13801D8587B344FA28C532867A9FABE@namprd04.prod.outlook.com>
Sender: linux-doc-owner@vger.kernel.org
To: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "msuchanek@suse.de" <msuchanek@suse.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, davem@davemlof
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTI2IGF0IDE3OjU4ICswMTAwLCBNaWNoYWwgU3VjaGFuZWsgd3JvdGU6
DQo+IFdoZW4gdGhlIGRyaXZlIGNsb3NlcyBpdCBjYW4gdGFrZSB0ZW5zIG9mIHNlY29uZHMgdW50
aWwgdGhlIGRpc2MgaXMNCj4gYW5hbHl6ZWQuIFdhaXQgZm9yIHRoZSBkcml2ZSB0byBiZWNvbWUg
cmVhZHkgb3IgcmVwb3J0IGFuIGVycm9yLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWljaGFsIFN1
Y2hhbmVrIDxtc3VjaGFuZWtAc3VzZS5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL2Nkcm9tL2Nkcm9t
LmMgfCA5ICsrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2Ryb20vY2Ryb20uYyBiL2RyaXZlcnMvY2Ryb20vY2Ry
b20uYw0KPiBpbmRleCA2OWU4NWM5MDIzNzMuLjk5OTQ0NDFmNTA0MSAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9jZHJvbS9jZHJvbS5jDQo+ICsrKyBiL2RyaXZlcnMvY2Ryb20vY2Ryb20uYw0KPiBA
QCAtMTA4Nyw2ICsxMDg3LDE1IEBAIGludCBvcGVuX2Zvcl9jb21tb24oc3RydWN0IGNkcm9tX2Rl
dmljZV9pbmZvICpjZGksIHRyYWNrdHlwZSAqdHJhY2tzKQ0KPiAgCQkJfQ0KPiAgCQkJY2RfZGJn
KENEX09QRU4sICJ0aGUgdHJheSBpcyBub3cgY2xvc2VkXG4iKTsNCj4gIAkJfQ0KPiArCQkvKiB0
aGUgZG9vciBzaG91bGQgYmUgY2xvc2VkIG5vdywgY2hlY2sgZm9yIHRoZSBkaXNjICovDQo+ICsJ
CWlmIChyZXQgPT0gQ0RTX0RSSVZFX05PVF9SRUFEWSkgew0KPiArCQkJaW50IHBvbGxfcmVzID0g
cG9sbF9ldmVudF9pbnRlcnJ1cHRpYmxlKA0KPiArCQkJCUNEU19EUklWRV9OT1RfUkVBRFkgIT0N
Cj4gKwkJCQkocmV0ID0gY2RvLT5kcml2ZV9zdGF0dXMoY2RpLCBDRFNMX0NVUlJFTlQpKSwNCj4g
KwkJCQk1MDApOw0KPiArCQkJaWYgKHBvbGxfcmVzID09IC1FUkVTVEFSVFNZUykNCj4gKwkJCQly
ZXR1cm4gcG9sbF9yZXM7DQo+ICsJCX0NCj4gIAkJaWYgKHJldCAhPSBDRFNfRElTQ19PSykNCj4g
IAkJCXJldHVybiAtRU5PTUVESVVNOw0KPiAgCX0NCg0KU2FtZSBjb21tZW50IGhlcmUgYXMgZm9y
IGEgcHJldmlvdXMgcGF0Y2g6IGFsdGhvdWdoIGludGVycnVwdGlibGUgYnkgYSBzaWduYWwsDQpJ
J20gbm90IHN1cmUgcG90ZW50aWFsbHkgaW5maW5pdGUgbG9vcHMgaW5zaWRlIHRoZSBrZXJuZWwg
YXJlIHJlYWxseSB3ZWxjb21lLg0KDQpUaGFua3MsDQoNCkJhcnQu
