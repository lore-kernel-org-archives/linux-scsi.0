From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH resend 1/6] delay: add poll_event_interruptible
Date: Mon, 29 Jan 2018 17:00:14 +0000
Message-ID: <1517245212.2687.13.camel@wdc.com>
References: <cover.1516985620.git.msuchanek@suse.de>
         <a26ef20e6ff686573a0af16435f20aba186746af.1516985620.git.msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <a26ef20e6ff686573a0af16435f20aba186746af.1516985620.git.msuchanek@suse.de>
Content-Language: en-US
Content-ID: <B77D2EA9D59D624F8DAF10C10224ECB8@namprd04.prod.outlook.com>
Sender: linux-ide-owner@vger.kernel.org
To: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "msuchanek@suse.de" <msuchanek@suse.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, davem@davemlof
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTI2IGF0IDE3OjU4ICswMTAwLCBNaWNoYWwgU3VjaGFuZWsgd3JvdGU6
DQo+IEFkZCBjb252ZW5pZW5jZSBtYWNybyBmb3IgcG9sbGluZyBhbiBldmVudCB0aGF0IGRvZXMg
bm90IGhhdmUgYQ0KPiB3YWl0cXVldWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgU3Vj
aGFuZWsgPG1zdWNoYW5la0BzdXNlLmRlPg0KPiAtLS0NCj4gIGluY2x1ZGUvbGludXgvZGVsYXku
aCB8IDEyICsrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2RlbGF5LmggYi9pbmNsdWRlL2xpbnV4
L2RlbGF5LmgNCj4gaW5kZXggYjc4YmFiNDM5NWQ4Li4zYWU5ZmEzOTU2MjggMTAwNjQ0DQo+IC0t
LSBhL2luY2x1ZGUvbGludXgvZGVsYXkuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2RlbGF5LmgN
Cj4gQEAgLTY0LDQgKzY0LDE2IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBzc2xlZXAodW5zaWduZWQg
aW50IHNlY29uZHMpDQo+ICAJbXNsZWVwKHNlY29uZHMgKiAxMDAwKTsNCj4gIH0NCj4gIA0KPiAr
I2RlZmluZSBwb2xsX2V2ZW50X2ludGVycnVwdGlibGUoZXZlbnQsIGludGVydmFsKSAoeyBcDQo+
ICsJaW50IHJldCA9IDA7IFwNCj4gKwl3aGlsZSAoIShldmVudCkpIHsgXA0KPiArCQlpZiAoc2ln
bmFsX3BlbmRpbmcoY3VycmVudCkpIHsgXA0KPiArCQkJcmV0ID0gLUVSRVNUQVJUU1lTOyBcDQo+
ICsJCQlicmVhazsgXA0KPiArCQl9IFwNCj4gKwkJbXNsZWVwX2ludGVycnVwdGlibGUoaW50ZXJ2
YWwpOyBcDQo+ICsJfSBcDQo+ICsJcmV0OyBcDQo+ICt9KQ0KPiArDQo+ICAjZW5kaWYgLyogZGVm
aW5lZChfTElOVVhfREVMQVlfSCkgKi8NCg0KU29ycnkgYnV0IEknbSBub3Qgc3VyZSB3ZSBzaG91
bGQgZW5jb3VyYWdlIG90aGVyIGtlcm5lbCBkZXZlbG9wZXJzIHRvIHVzZQ0KYnVzeS13YWl0aW5n
IGJ5IGFkZGluZyB0aGUgcG9sbF9ldmVudF9pbnRlcnJ1cHRpYmxlKCkgbWFjcm8gdG8gYSBzeXN0
ZW0td2lkZQ0KaGVhZGVyIGZpbGUuIENhbiB0aGF0IG1hY3JvIGJlIG1vdmVkIGludG8gYSBDRFJP
TS1zcGVjaWZpYyAuYyBvciAuaCBmaWxlPw0KDQpUaGFua3MsDQoNCkJhcnQu
