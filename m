From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 3/4] scsi: Avoid that .queuecommand() gets called for a
 quiesced SCSI device
Date: Thu, 25 Jan 2018 17:07:00 +0000
Message-ID: <1516900017.2726.1.camel@wdc.com>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
         <20180110181817.25166-4-bart.vanassche@wdc.com>
         <20180111022341.GA7290@ming.t460p> <1515797155.2396.86.camel@wdc.com>
         <20180113155431.GG8013@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180113155431.GG8013@ming.t460p>
Content-Language: en-US
Content-ID: <FF66AA69D53CD34EA9A5C2252209DB46@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "jgg@mellanox.com" <jgg@mellanox.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE4LTAxLTEzIGF0IDIzOjU0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gVGhh
bmtzIGZvciB5b3VyIG1lbnRpb25pbmcsIHRoZW4gSSBjYW4gZmluZCB0aGUgZm9sbG93aW5nIGNv
bW1lbnQgaW4NCj4gc3JwX3F1ZXVlY29tbWFuZCgpOg0KPiANCj4gCQkvKg0KPiAJCSAqIFRoZSBT
Q1NJIEVIIHRocmVhZCBpcyB0aGUgb25seSBjb250ZXh0IGZyb20gd2hpY2ggc3JwX3F1ZXVlY29t
bWFuZCgpDQo+IAkJICogY2FuIGdldCBpbnZva2VkIGZvciBibG9ja2VkIGRldmljZXMgKFNERVZf
QkxPQ0sgLw0KPiAJCSAqIFNERVZfQ1JFQVRFRF9CTE9DSykuIEF2b2lkIHJhY2luZyB3aXRoIHNy
cF9yZWNvbm5lY3RfcnBvcnQoKSBieQ0KPiAJCSAqIGxvY2tpbmcgdGhlIHJwb3J0IG11dGV4IGlm
IGludm9rZWQgZnJvbSBpbnNpZGUgdGhlIFNDU0kgRUguDQo+IAkJICovDQo+IA0KPiBUaGF0IG1l
YW5zIEVIIHJlcXVlc3QgaXMgYWxsb3dlZCB0byBzZW5kIHRvIGJsb2NrZWQgZGV2aWNlLg0KDQpO
byB3YXkuIFRoYXQncyBhIGJ1ZyBhbmQgYSBidWcgdGhhdCBuZWVkcyB0byBiZSBmaXhlZC4NCg0K
QmFydC4=
