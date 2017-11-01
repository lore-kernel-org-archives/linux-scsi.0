From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 2/8] crypto: scompress - use sgl_alloc() and sgl_free()
Date: Wed, 1 Nov 2017 15:45:46 +0000
Message-ID: <1509551145.2530.10.camel@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
         <20171016224940.1332-3-bart.vanassche@wdc.com>
         <1509547836.2530.1.camel@wdc.com>
         <CAKv+Gu_-pqqVn5QeuM_OR0itQS-v5uFATt-ZzNDmPy8CHSLrGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_-pqqVn5QeuM_OR0itQS-v5uFATt-ZzNDmPy8CHSLrGg@mail.gmail.com>
Content-Language: en-US
Content-ID: <C3694A50F4E4A744A51E16BE04F099F0@namprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
To: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTExLTAxIGF0IDE1OjE3ICswMDAwLCBBcmQgQmllc2hldXZlbCB3cm90ZToN
Cj4gT24gMSBOb3ZlbWJlciAyMDE3IGF0IDE0OjUwLCBCYXJ0IFZhbiBBc3NjaGUgPEJhcnQuVmFu
QXNzY2hlQHdkYy5jb20+IHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAxNy0xMC0xNiBhdCAxNTo0OSAt
MDcwMCwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+ID4gVXNlIHRoZSBzZ2xfYWxsb2MoKSBh
bmQgc2dsX2ZyZWUoKSBmdW5jdGlvbnMgaW5zdGVhZCBvZiBvcGVuIGNvZGluZw0KPiA+ID4gdGhl
c2UgZnVuY3Rpb25zLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3Nj
aGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+DQo+ID4gPiBDYzogQXJkIEJpZXNoZXV2ZWwgPGFy
ZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+DQo+ID4gPiBDYzogSGVyYmVydCBYdSA8aGVyYmVydEBn
b25kb3IuYXBhbmEub3JnLmF1Pg0KPiA+IA0KPiA+IEFyZCBhbmQvb3IgSGVyYmVydCwgY2FuIHlv
dSBwbGVhc2UgaGF2ZSBhIGxvb2sgYXQgdGhpcyBwYXRjaCBhbmQgbGV0IHVzIGtub3cNCj4gPiB3
aGV0aGVyIG9yIG5vdCBpdCBsb29rcyBmaW5lIHRvIHlvdT8NCj4gDQo+IFRoZSBwYXRjaCBpdHNl
bGYgZG9lcyBub3QgbG9vayB1bnJlYXNvbmFibGUsIGJ1dCBJIGNhbid0IGZpbmQNCj4gc2dsX2Fs
bG9jKCkgYW55d2hlcmUgaW4gdGhlIHNvdXJjZSB0cmVlLiBHaXZlbiB0aGF0IHlvdSBoYXZlIGNj
J2VkIG1lDQo+IG9uIHRoaXMgcGF0Y2ggb25seSwgSSBjYW4gb25seSBhc3N1bWUgdGhhdCB5b3Ug
YXJlIGFkZGluZyB0aGlzIGFzIHBhcnQNCj4gb2YgdGhlIHNlcmllcywgYnV0IHdpdGhvdXQgYW55
IGNvbnRleHQsIEkgY2FuJ3QgcmVhbGx5IHJldmlldyB0aGlzLA0KPiBzb3JyeS4NCg0KSGVsbG8g
QXJkLA0KDQpEbyB5b3UgZXhwZWN0IHRvIGJlIENjLWVkIHBlcnNvbmFsbHkgb3IgaXMgQ2MtaW5n
IHRoZSBsaW51eC1jcnlwdG8gbWFpbGluZw0KbGlzdCBzdWZmaWNpZW50PyBUaGUgbGludXgtY3J5
cHRvIG1haWxpbmcgbGlzdCB3YXMgQ2MtZWQgZm9yIHRoZSBlbnRpcmUgcGF0Y2gNCnNlcmllcyBh
cyBvbmUgY2FuIHNlZSBoZXJlOg0KaHR0cHM6Ly93d3cubWFpbC1hcmNoaXZlLmNvbS9saW51eC1j
cnlwdG9Admdlci5rZXJuZWwub3JnL21zZzI4NDg1Lmh0bWwuDQoNClRoYW5rcywNCg0KQmFydC4=
