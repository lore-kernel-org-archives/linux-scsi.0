From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] [v2] sbitmap, scsi/target: add seq_file forward
 declaration
Date: Fri, 6 Jul 2018 20:33:55 +0000
Message-ID: <1f0a1f94071fec75f511aeab8d5da15fef68ff69.camel@wdc.com>
References: <20180706201920.2185565-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706201920.2185565-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <97C74474849952488F2E4E6ED8E90F2D@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "arnd@arndb.de" <arnd@arndb.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>, "willy@infradead.org" <willy@infradead.org>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTA3LTA2IGF0IDIyOjE5ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBUaGUgdGFyZ2V0IGNvcmUgcnVucyBpbnRvIGEgd2FybmluZyBpbiB0aGUgbGludXgvc2JpdG1h
cC5oDQo+IGZpbGUgaW4gc29tZSBjb25maWd1cmF0aW9uczoNCj4gDQo+IEluIGZpbGUgaW5jbHVk
ZWQgZnJvbSBpbmNsdWRlL3RhcmdldC90YXJnZXRfY29yZV9iYXNlLmg6NywNCj4gICAgICAgICAg
ICAgICAgICBmcm9tIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2ZhYnJpY19saWIuYzo0MToN
Cj4gaW5jbHVkZS9saW51eC9zYml0bWFwLmg6MzMxOjQ2OiBlcnJvcjogJ3N0cnVjdCBzZXFfZmls
ZScgZGVjbGFyZWQgaW5zaWRlIHBhcmFtZXRlciBsaXN0IHdpbGwgbm90IGJlIHZpc2libGUgb3V0
c2lkZSBvZiB0aGlzIGRlZmluaXRpb24gb3IgZGVjbGFyYXRpb24gWy1XZXJyb3JdDQo+ICB2b2lk
IHNiaXRtYXBfc2hvdyhzdHJ1Y3Qgc2JpdG1hcCAqc2IsIHN0cnVjdCBzZXFfZmlsZSAqbSk7DQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fg0K
PiANCj4gSW4gZ2VuZXJhbCwgaGVhZGVycyBzaG91bGQgbm90IGRlcGVuZCBvbiBvdGhlcnMgYmVp
bmcgaW5jbHVkZWQgZmlyc3QsDQo+IHNvIHRoaXMgZml4ZXMgaXQgd2l0aCBhIGZvcndhcmQgZGVj
bGFyYXRpb24gZm9yIHRoYXQgc3RydWN0IG5hbWUsIGJ1dA0KPiB3ZSBwcm9iYWJseSB3YW50IHRv
IG1lcmdlIHRoZSBwYXRjaCB0aHJvdWdoIHRoZSBzY3NpIHRyZWUgdG8gaGVscA0KPiBiaXNlY3Rp
b24uDQo+IA0KPiBGaXhlczogMTBlOWNiYjZiNTMxICgic2NzaTogdGFyZ2V0OiBDb252ZXJ0IHRh
cmdldCBkcml2ZXJzIHRvIHVzZSBzYml0bWFwIikNCj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJn
bWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gLS0tDQo+IHYyOiBtb3ZlIGRlY2xhcmF0aW9uIHRvIHRo
ZSBzdGFydCBvZiB0aGUgaGVhZGVyLCBhcyBzdWdnZXN0ZWQgYnkgQmFydA0KPiAtLS0NCj4gIGlu
Y2x1ZGUvbGludXgvc2JpdG1hcC5oIHwgMiArKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2JpdG1hcC5oIGIvaW5j
bHVkZS9saW51eC9zYml0bWFwLmgNCj4gaW5kZXggZTY1Mzk1MzZkZWE5Li44MDRhNTA5ODNlYzUg
MTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvc2JpdG1hcC5oDQo+ICsrKyBiL2luY2x1ZGUv
bGludXgvc2JpdG1hcC5oDQo+IEBAIC0yMyw2ICsyMyw4IEBADQo+ICAjaW5jbHVkZSA8bGludXgv
a2VybmVsLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KPiAgDQo+ICtzdHJ1Y3Qgc2Vx
X2ZpbGU7DQo+ICsNCj4gIC8qKg0KPiAgICogc3RydWN0IHNiaXRtYXBfd29yZCAtIFdvcmQgaW4g
YSAmc3RydWN0IHNiaXRtYXAuDQo+ICAgKi8NCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2No
ZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4NCg0KDQoNCg0KDQoNCg==
