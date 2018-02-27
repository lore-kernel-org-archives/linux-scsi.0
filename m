From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Tue, 27 Feb 2018 03:41:15 +0000
Message-ID: <1519702875.3120.7.camel@wdc.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
         <1519700898.3120.3.camel@wdc.com>
         <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
Content-Language: en-US
Content-ID: <322360C2DDBB3B4AA766D21A646B2FDB@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTAyLTI3IGF0IDExOjI4ICswODAwLCBqaWFuY2hhby53YW5nIHdyb3RlOg0K
PiBJZiB0aGF0IGlzIHRydWUsIHdoYXQgaWYgYWFjcmFpZCBkcml2ZXIgdXNlcyBibG9jayBsZWdh
Y3kgaW5zdGVhZCBvZiBibGstbXEgPw0KPiB3LyBibGstbXEgZGlzYWJsZWQsIF9fc2NzaV9xdWV1
ZV9pbnNlcnQganVzdCByZXF1ZXVlIHRoZSByZXF1ZXN0IHdpdGggYmxrX3JlcXVldWVfcmVxdWVz
dC4NCj4gDQo+IF9fc2NzaV9xdWV1ZV9pbnNlcnQNCj4gLi4uDQo+IAlpZiAocS0+bXFfb3BzKSB7
DQo+IAkJc2NzaV9tcV9yZXF1ZXVlX2NtZChjbWQpOw0KPiAJCXJldHVybjsNCj4gCX0NCj4gCXNw
aW5fbG9ja19pcnFzYXZlKHEtPnF1ZXVlX2xvY2ssIGZsYWdzKTsNCj4gCWJsa19yZXF1ZXVlX3Jl
cXVlc3QocSwgY21kLT5yZXF1ZXN0KTsNCj4gCWtibG9ja2Rfc2NoZWR1bGVfd29yaygmZGV2aWNl
LT5yZXF1ZXVlX3dvcmspOw0KPiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShxLT5xdWV1ZV9sb2Nr
LCBmbGFncyk7DQo+IC4uLg0KPiANCj4gbm8gcHJlcC91bnByZXAgY29kZSB0aGVyZSBmb3IgYmxv
Y2sgbGVnYWN5IGNvZGUuDQoNCkhlbGxvIEppYW5jaGFvLA0KDQpGb3IgdGhlIGxlZ2FjeSBibG9j
ayBsYXllciBwcmVwYXJpbmcgYW5kIHVucHJlcGFyaW5nIGEgcmVxdWVzdCBoYXBwZW5zIGZyb20N
Cmluc2lkZSB0aGUgYmxvY2sgbGF5ZXIgY29yZS4gUGxlYXNlIGhhdmUgYSBsb29rIGF0IGJsb2Nr
L2Jsay1jb3JlLmMgYW5kIHRoZQ0KY29kZSBpbiB0aGF0IGZpbGUgdGhhdCBoYW5kbGVzIHRoZSBy
ZXF1ZXN0IGZsYWcgUlFGX0RPTlRQUkVQLg0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0KDQo=
