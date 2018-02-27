From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Tue, 27 Feb 2018 17:18:35 +0000
Message-ID: <1519751913.23791.6.camel@wdc.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
         <1519700898.3120.3.camel@wdc.com>
         <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
         <1519702875.3120.7.camel@wdc.com>
         <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
         <1519708355.3120.9.camel@wdc.com>
         <478f40f1-d86c-ee5f-daaf-6332b67fe721@oracle.com>
         <1519751213.23791.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519751213.23791.3.camel@wdc.com>
Content-Language: en-US
Content-ID: <047FDE75BF2B9547912CBFBD57963C48@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTAyLTI3IGF0IDE3OjA2ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIFR1ZSwgMjAxOC0wMi0yNyBhdCAxMzoxNSArMDgwMCwgamlhbmNoYW8ud2FuZyB3cm90
ZToNCj4gPiBDYW4geW91IHNoYXJlIG1vcmUgZGV0YWlscyBhYm91dCB0aGlzID8gDQo+IA0KPiBB
ZnRlciBoYXZpbmcgaGFkIGFub3RoZXIgbG9vaywgSSB0aGluayB5b3VyIHBhdGNoIGlzIGZpbmUu
DQoNCihyZXBseWluZyB0byBteSBvd24gZS1tYWlsKQ0KDQpXaGF0IEkgdGhpbmsgaXMgZmluZSBp
biB5b3VyIHBhdGNoIGlzIHRoYXQgaXQgc2tpcHMgdGhlIHVucHJlcCBhbmQgcmVwcmVwDQp3aGVu
IHJlcXVldWVpbmcuIEhvd2V2ZXIsIHRoZXJlIGlzIGEgcHV0X2RldmljZSgmc2Rldi0+c2Rldl9n
ZW5kZXYpIGNhbGwNCmluIHNjc2lfbXFfcmVxdWV1ZV9jbWQoKSBhbmQgeW91ciBwYXRjaCBjYXVz
ZXMgdGhhdCBwdXRfZGV2aWNlKCkgY2FsbCB0bw0KYmUgc2tpcHBlZCB3aGVuIHJlcXVldWVpbmcu
IEFuIGV4cGxhbmF0aW9uIGlzIG5lZWRlZCBpbiB0aGUgY29tbWl0IG1lc3NhZ2UNCndoeSB5b3Ug
dGhpbmsgdGhhdCByZW1vdmluZyB0aGF0IHB1dF9kZXZpY2UoKSBjYWxsIGlzIGZpbmUuDQoNCkJh
cnQu
