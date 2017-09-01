From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 6/8] scsi: sd_zbc: Limit zone write locking to sequential
 zones
Date: Fri, 1 Sep 2017 16:25:56 +0000
Message-ID: <1504283155.14386.35.camel@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
         <20170901113631.12323-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901113631.12323-7-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <8E93BFD59D63854C9D44E035746EA0CD@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDIwOjM2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gWm9uZWQgYmxvY2sgZGV2aWNlcyBoYXZlIG5vIHdyaXRlIGNvbnN0cmFpbnRzIGZvciBjb252
ZW50aW9uYWwgem9uZXMNCj4gc28gd3JpdGUgbG9ja2luZyBvZiBjb252ZW50aW9uYWwgem9uZXMg
aXMgbm90IG5lY2Vzc2FyeSBhbmQgY2FuIGh1cnQNCj4gcGVyZm9ybWFuY2UuIFRvIGF2b2lkIHRo
aXMsIGludHJvZHVjZSB0aGUgc2VxX3pvbmVzIGJpdG1hcCB0byBpbmRpY2F0ZQ0KPiBpZiBhIHpv
bmUgaXMgYSBzZXF1ZW50aWFsIG9uZS4gVXNlIHRoaXMgaW5mb3JtYXRpb24gdG8gYWxsb3cgYW55
IHdyaXRlDQo+IHRvIGJlIGlzc3VlZCB0byBjb252ZW50aW9uYWwgem9uZXMsIGxvY2tpbmcgb25s
eSBzZXF1ZW50aWFsIHpvbmVzLg0KPiANCj4gQXMgdGhlIHpvbmUgYml0bWFwIGFsbG9jYXRpb24g
Zm9yIHNlcV96b25lcyBpcyBpZGVudGljYWwgdG8gdGhlIHpvbmVzDQo+IHdyaXRlIGxvY2sgYml0
bWFwLCBpbnRyb2R1Y2UgdGhlIGhlbHBlciBzZF96YmNfYWxsb2Nfem9uZV9iaXRtYXAoKS4NCj4g
VXNpbmcgdGhpcyBoZWxwZXIsIHdhaXQgZm9yIHRoZSBkaXNrIGNhcGFjaXR5IGFuZCBudW1iZXIg
b2Ygem9uZXMgdG8NCj4gc3RhYmlsaXplIG9uIHRoZSBzZWNvbmQgcmV2YWxpZGF0aW9uIHBhc3Mg
dG8gYWxsb2NhdGUgYW5kIGluaXRpYWxpemUNCj4gdGhlIGJpdG1hcHMuDQoNClJldmlld2VkLWJ5
OiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+
