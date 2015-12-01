From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 3/3] md: convert to use the generic badblocks code
Date: Tue, 1 Dec 2015 19:52:05 +0000
Message-ID: <1448999525.5911.8.camel@intel.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-4-git-send-email-vishal.l.verma@intel.com>
	 <20151201185518.GA13926@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151201185518.GA13926@kernel.org>
Content-Language: en-US
Content-ID: <8231BB9FFCA6C343A6E7F8CF2D19F04B@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "shli@kernel.org" <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, "axboe@fb.com" <axboe@fb.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE1LTEyLTAxIGF0IDEwOjU1IC0wODAwLCBTaGFvaHVhIExpIHdyb3RlOg0KPiBP
biBXZWQsIE5vdiAyNSwgMjAxNSBhdCAxMTo0MzozM0FNIC0wNzAwLCBWaXNoYWwgVmVybWEgd3Jv
dGU6DQo+ID4gUmV0YWluIGJhZGJsb2NrcyBhcyBwYXJ0IG9mIHJkZXYsIGJ1dCB1c2UgdGhlIGFj
Y2Vzc29yIGZ1bmN0aW9ucw0KPiA+IGZyb20NCj4gPiBpbmNsdWRlL2xpbnV4L2JhZGJsb2NrcyBm
b3IgYWxsIG1hbmlwdWxhdGlvbi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgVmVy
bWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMvbWQv
bWQuYyB8IDUwNyArKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ID4gLS0tLS0tLS0tLS0tLQ0KPiA+IMKgZHJpdmVycy9tZC9tZC5oIHzCoMKgNDAgKy0tLS0NCj4g
PiDCoDIgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgNTI0IGRlbGV0aW9ucygtKQ0K
PiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMN
Cj4gPiBpbmRleCBjNzAyZGUxLi42M2VhYjIwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbWQv
bWQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbWQvbWQuYw0KPiA+IEBAIC0zNCw2ICszNCw3IEBADQo+
ID4gwqANCj4gPiDCoCNpbmNsdWRlIDxsaW51eC9rdGhyZWFkLmg+DQo+ID4gwqAjaW5jbHVkZSA8
bGludXgvYmxrZGV2Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9iYWRibG9ja3MuaD4NCj4gPiDC
oCNpbmNsdWRlIDxsaW51eC9zeXNjdGwuaD4NCj4gPiDCoCNpbmNsdWRlIDxsaW51eC9zZXFfZmls
ZS5oPg0KPiA+IMKgI2luY2x1ZGUgPGxpbnV4L2ZzLmg+DQo+ID4gQEAgLTcwNyw4ICs3MDgsNyBA
QCB2b2lkIG1kX3JkZXZfY2xlYXIoc3RydWN0IG1kX3JkZXYgKnJkZXYpDQo+ID4gwqAJCXB1dF9w
YWdlKHJkZXYtPmJiX3BhZ2UpOw0KPiA+IMKgCQlyZGV2LT5iYl9wYWdlID0gTlVMTDsNCj4gPiDC
oAl9DQo+ID4gLQlrZnJlZShyZGV2LT5iYWRibG9ja3MucGFnZSk7DQo+ID4gLQlyZGV2LT5iYWRi
bG9ja3MucGFnZSA9IE5VTEw7DQo+ID4gKwliYWRibG9ja3NfZnJlZSgmcmRldi0+YmFkYmxvY2tz
KTsNCj4gPiDCoH0NCj4gDQo+IHdoeSBkb2VzIHJkZXYgaGF2ZSBleHRyYSBiYWRibG9ja3M/IHRo
ZSBnZW5kaXNrIGFscmVhZHkgaGFkIG9uZS4NCg0KcmRldiBvcmlnaW5hbGx5IGhhZCBiYWRibG9j
a3MsIGFuZCB0aGlzIHBhdGggc2V0IGFkZHMgYmFkYmxvY2tzIHRvDQpnZW5kaXNrLiBJdCBkb2Vz
IGFwcGVhciB0aGF0IG1kJ3MgYmFkYmxvY2sgdHJhY2tpbmcgd2lsbCBiZSBhIGJpdA0KcmVkdW5k
YW50IGlmL29uY2UgZ2VuZGlzayBoYXMgYmFkYmxvY2tzIHN1cHBvcnQgLSBzZWUgdGhlIGRpc2N1
c3Npb24NCmhlcmU6DQpodHRwczovL2xpc3RzLjAxLm9yZy9waXBlcm1haWwvbGludXgtbnZkaW1t
LzIwMTUtTm92ZW1iZXIvMDAyOTgwLmh0bWwNCg0KCS1WaXNoYWw=
