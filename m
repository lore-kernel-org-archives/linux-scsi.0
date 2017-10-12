From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/8] lib: Introduce sgl_alloc() and sgl_free()
Date: Thu, 12 Oct 2017 23:00:10 +0000
Message-ID: <1507849209.14112.1.camel@wdc.com>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
         <20171012224550.25440-2-bart.vanassche@wdc.com>
         <ee12eeaf-9848-478d-4ebe-9d3497e248e0@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ee12eeaf-9848-478d-4ebe-9d3497e248e0@kernel.dk>
Content-Language: en-US
Content-ID: <D3C3237E2349BF488AF8C41C133AABDC@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTEwLTEyIGF0IDE2OjUyIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMC8xMi8yMDE3IDA0OjQ1IFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gKysrIGIv
aW5jbHVkZS9saW51eC9zZ2xfYWxsb2MuaA0KPiA+IEBAIC0wLDAgKzEsMTYgQEANCj4gPiArI2lm
bmRlZiBfU0dMX0FMTE9DX0hfDQo+ID4gKyNkZWZpbmUgX1NHTF9BTExPQ19IXw0KPiA+ICsNCj4g
PiArI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+IC8qIGJvb2wsIGdmcF90ICovDQo+ID4gKw0KPiA+
ICtzdHJ1Y3Qgc2NhdHRlcmxpc3Q7DQo+ID4gKw0KPiA+ICtzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNn
bF9hbGxvY19vcmRlcih1bnNpZ25lZCBsb25nIGxvbmcgbGVuZ3RoLA0KPiA+ICsJCQkJICAgIHVu
c2lnbmVkIGludCBvcmRlciwgdW5zaWduZWQgaW50ICpuZW50X3AsDQo+ID4gKwkJCQkgICAgZ2Zw
X3QgZ2ZwLCBib29sIGNoYWluYWJsZSk7DQo+ID4gK3N0cnVjdCBzY2F0dGVybGlzdCAqc2dsX2Fs
bG9jKHVuc2lnbmVkIGxvbmcgbG9uZyBsZW5ndGgsIHVuc2lnbmVkIGludCAqbmVudF9wLA0KPiA+
ICsJCQkgICAgICBnZnBfdCBnZnApOw0KPiA+ICt2b2lkIHNnbF9mcmVlX29yZGVyKHN0cnVjdCBz
Y2F0dGVybGlzdCAqc2dsLCBpbnQgb3JkZXIpOw0KPiA+ICt2b2lkIHNnbF9mcmVlKHN0cnVjdCBz
Y2F0dGVybGlzdCAqc2dsKTsNCj4gPiArDQo+ID4gKyNlbmRpZiAvKiBfU0dMX0FMTE9DX0hfICov
DQo+IA0KPiBTaG91bGQgdGhpcyBqdXN0IGdvIGludG8gbGludXgvc2NhdHRlcmxpc3QuaCBpbnN0
ZWFkIG9mIGNyZWF0aW5nIGEgbmV3IGhlYWRlcg0KPiBmaWxlPw0KDQpUaGF0J3Mgc29tZXRoaW5n
IEkgY2FuIGNoYW5nZS4gSSBkb24ndCBoYXZlIGEgc3Ryb25nIG9waW5pb24gYWJvdXQgd2hldGhl
cg0KdGhlc2UgZGVjbGFyYXRpb25zIHNob3VsZCBnbyBpbnRvIGEgbmV3IGhlYWRlciBmaWxlIG9y
IGludG8gbGludXgvc2NhdHRlcmxpc3QuaC4NCg0KQmFydC4=
