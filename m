From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Tue, 5 Dec 2017 16:41:46 +0000
Message-ID: <1512492105.2660.22.camel@wdc.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
         <1512490099.2660.6.camel@sandisk.com> <20171205162825.GA23788@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205162825.GA23788@ming.t460p>
Content-Language: en-US
Content-ID: <6991D4D553E0F44091E36367F38849FA@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTEyLTA2IGF0IDAwOjI4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gVGhp
cyBpcyBzdGlsbCBhIHdvcmthcm91bmQgZm9yIFJFU1RBUlQsIHNlZSBteSBjb21tZW50IGJlZm9y
ZToNCj4gDQo+IAlodHRwczovL21hcmMuaW5mby8/bD1saW51eC1ibG9jayZtPTE1MTIxNzUwMDky
OTM0MSZ3PTINCg0KQSBxdW90ZSBmcm9tIHRoYXQgZS1tYWlsOiAiVGhlIHRoZW9yeSBhYm91dCB1
c2luZyBCTEtfTVFfU19TQ0hFRF9SRVNUQVJUIGluDQpjdXJyZW50IHdheSBpcyB0aGF0IHdlIG1h
cmsgaXQgYWZ0ZXIgcmVxdWVzdHMgYXJlIGFkZGVkIHRvIGhjdHgtPmRpc3BhdGNoIi4NClJlYWRp
bmcgdGhhdCBtYWtlcyBtZSB3b25kZXIgd2hldGhlciB5b3UgdW5kZXJzdGFuZCB0aGUgcHVycG9z
ZSBvZiB0aGUNCkJMS19NUV9TX1NDSEVEX1JFU1RBUlQgZmxhZz8gVGhhdCBmbGFnIGlzIG5vdCBz
ZXQgYWZ0ZXIgcmVxdWVzdHMgYXJlIGFkZGVkDQp0byB0aGUgZGlzcGF0Y2ggbGlzdCBidXQgYWZ0
ZXIgcmVxdWVzdHMgaGF2ZSBiZWVuICpyZW1vdmVkKi4gVGhlIHB1cnBvc2Ugb2YNCnRoYXQgZmxh
ZyBpcyB0byBkZXRlY3Qgd2hldGhlciBhbm90aGVyIHRocmVhZCBoYXMgcnVuIHRoZSBxdWV1ZSBh
ZnRlcg0KcmVxdWVzdHMgd2VyZSByZW1vdmVkIGZyb20gdGhlIGRpc3BhdGNoIGxpc3QgYW5kIGJl
Zm9yZSB0aGVzZSB3ZXJlIHJlYWRkZWQuDQpJZiBzbywgdGhlIHF1ZXVlIG5lZWRzIHRvIGJlIHJl
cnVuLg0KDQpCYXJ0Lg==
