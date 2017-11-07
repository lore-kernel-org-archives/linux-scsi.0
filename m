From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 16:17:54 +0000
Message-ID: <1510071472.2656.15.camel@wdc.com>
References: <20171104015534.32684-1-ming.lei@redhat.com>
         <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
         <1509997522.2409.58.camel@wdc.com> <20171107101546.GA2848@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171107101546.GA2848@ming.t460p>
Content-Language: en-US
Content-ID: <6DA9D853D4AAE64B90270A3C0D3BA8B8@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTExLTA3IGF0IDE4OjE1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gTGFz
dCB0aW1lLCB5b3UgZGlkbid0IG1lbnRpb24gdGhlIHRhcmdldCBwYXRjaCBmb3Igc2V0dGluZyBp
dHMNCj4gY2FuX3F1ZXVlIGFzIDEsIHNvIEkgdGhpbmsgeW91IGNhbid0IHJlcHJvZHVjZSB0aGUg
aXNzdWUgb24gdXBzdHJlYW0NCj4ga2VybmVsIHdpdGhvdXQgb3V0LW9mLXRyZWUgcGF0Y2guIFRo
ZW4gbG9va3MgaXQgaXMgYW5vdGhlciBpc3N1ZSwNCj4gYW5kIHdlIGFyZSBtYWtpbmcgcHJvZ3Jl
c3MgYWN0dWFsbHkuDQoNCklmIEkgZG9uJ3QgdHJ1c3QgYSBwYXRjaCBJIGludHJvZHVjZSBhZGRp
dGlvbmFsIHRlc3RzLiBUaGUgZmFjdCB0aGF0IEkNCm1vZGlmaWVkIHRoZSBTUlAgaW5pdGlhdG9y
IGJlZm9yZSB0aGlzIGhhbmcgb2NjdXJyZWQgZG9lcyBub3QgbWVhbiB0aGF0IHRoZQ0KYXBwcm9h
Y2ggb2YgeW91ciBwYXRjaCBpcyBmaW5lLiBXaGF0IHRoaXMgbWVhbnMgaXMgdGhhdCBhbGwgeW91
ciBwYXRjaCBkb2VzDQppcyB0byByZWR1Y2UgdGhlIHJhY2Ugd2luZG93IGFuZCB0aGF0IHRoZXJl
IGlzIHN0aWxsIGEgcmFjZSB3aW5kb3cuDQoNCkJhcnQu
