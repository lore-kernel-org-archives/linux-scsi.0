From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 6/8] scsi/ipr: Use sgl_alloc_order() and
 sgl_free_order()
Date: Mon, 30 Oct 2017 20:37:09 +0000
Message-ID: <1509395828.27259.21.camel@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
         <20171016224940.1332-7-bart.vanassche@wdc.com>
         <c804098f-5543-395c-1395-5778ef74a61b@suse.de>
         <ce6f2f5b-b4bc-380f-8ac1-1e91e4d6bf24@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <ce6f2f5b-b4bc-380f-8ac1-1e91e4d6bf24@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <ED4209D96B128A4C801E1AEE7DCAD4CD@namprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTEwLTE4IGF0IDE1OjU3IC0wNTAwLCBCcmlhbiBLaW5nIHdyb3RlOg0KPiBP
biAxMC8xNy8yMDE3IDAxOjE5IEFNLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6DQo+ID4gT24gMTAv
MTcvMjAxNyAxMjo0OSBBTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+ID4gWyAuLi4gXQ0K
PiA+IA0KPiA+IE5vdCBzdXJlIGlmIHRoaXMgaXMgYSB2YWxpZCBjb252ZXJzaW9uLg0KPiA+IE9y
aWdpbmFsbHkgdGhlIGRyaXZlciB3b3VsZCBhbGxvY2F0ZSBhIHNpbmdsZSBidWZmZXI7IHdpdGgg
dGhpcyBidWZmZXINCj4gPiB3ZSBoYXZlIHR3byBkaXN0aW5jdCBidWZmZXJzLg0KPiA+IEdpdmVu
IHRoYXQgdGhpcyBpcyB1c2VkIHRvIGRvd25sb2FkIHRoZSBtaWNyb2NvZGUgSSdtIG5vdCBzdXJl
IGlmIHRoaXMNCj4gPiBpc24ndCBhIGhhcmR3YXJlLWRlcGVuZGVudCBzdHJ1Y3R1cmUgd2hpY2gg
cmVxdWlyZXMgYSBzaW5nbGUgYnVmZmVyDQo+ID4gaW5jbHVkaW5nIHRoZSBzZ2xpc3QuDQo+ID4g
QnJpYW4sIGNhbiB5b3Ugc2hlZCBzb21lIGxpZ2h0IGhlcmU/DQo+IA0KPiBUaGUgc3RydWN0IGlw
cl9zZ2xpc3QgaXMgbm90IGEgaGFyZHdhcmUgZGVmaW5lZCBkYXRhIHN0cnVjdHVyZSwgc28gb24g
aW5pdGlhbA0KPiBnbGFuY2UsIHRoaXMgc2hvdWxkIGJlIE9LLiBJJ2xsIGxvYWQgaXQgdXAgYW5k
IGdpdmUgaXQgYSB0cnkgdG8gbWFrZSBzdXJlDQo+IGl0IGRvZXNuJ3QgYnJlYWsgY29kZSBkb3du
bG9hZC4NCg0KSGVsbG8gQnJpYW4sDQoNCkhhdmUgeW91IGFscmVhZHkgb2J0YWluZWQgYW55IHRl
c3QgcmVzdWx0cz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
