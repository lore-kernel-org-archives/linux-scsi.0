From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Fri, 8 Sep 2017 17:28:16 +0000
Message-ID: <1504891695.1665.5.camel@wdc.com>
References: <20170902130840.24609-1-ming.lei@redhat.com>
         <20170902130840.24609-8-ming.lei@redhat.com>
         <20170902131208.GA10940@ming.t460p> <1504498405.10804.10.camel@wdc.com>
         <20170904071653.GD7959@ming.t460p> <1504539634.3189.15.camel@wdc.com>
         <20170904160813.GA21757@ming.t460p> <1504575610.3360.7.camel@wdc.com>
         <20170905022325.GC24787@ming.t460p> <20170908030753.GA5627@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170908030753.GA5627@ming.t460p>
Content-Language: en-US
Content-ID: <BB4196743B8582478E20B767E9E5D2A0@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA5LTA4IGF0IDExOjA4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gTG9v
a3MgSSByZXBsaWVkIG9yIGNsYXJpZmllZCBhbGwgeW91ciBxdWVzdGlvbnMvY29tbWVudHMgb24g
dGhpcw0KPiBwYXRjaHNldC4NCg0KTm8sIHlvdSBoYXZlIG5vdCBhZGRyZXNzZWQgYWxsIG15IGNv
bW1lbnRzLCB5b3Uga25vdyB0aGF0IHlvdSBoYXZlIG5vdA0KYWRkcmVzc2VkIGFsbCBteSBjb21t
ZW50cyBzbyB5b3Ugc2hvdWxkIG5vdCBoYXZlIHdyaXR0ZW4gdGhhdCB5b3UgaGF2ZQ0KYWRkcmVz
c2VkIGFsbCBteSBjb21tZW50cy4gVGhpcyBwYXRjaCBzZXJpZXMgbm90IG9ubHkgaW50cm9kdWNl
cyB1Z2x5DQpjaGFuZ2VzIGluIHRoZSByZXF1ZXN0IHF1ZXVlIGZyZWV6ZSBtZWNoYW5pc20gYnV0
IGl0IGFsc28gaW50cm9kdWNlcyBhbg0KdW5hY2NlcHRhYmxlIHJhY2UgY29uZGl0aW9uIGJldHdl
ZW4gYmxrX2dldF9yZXF1ZXN0KCkgYW5kIHJlcXVlc3QgcXVldWUNCmNsZWFudXAuDQoNCkJUVywg
eW91IGRvbid0IGhhdmUgdG8gc3BlbmQgbW9yZSB0aW1lIG9uIHRoaXMgcGF0Y2ggc2VyaWVzLiBJ
IGhhdmUNCmltcGxlbWVudGVkIGFuIGFsdGVybmF0aXZlIGFuZCBtdWNoIGNsZWFuZXIgYXBwcm9h
Y2ggdG8gZml4IFNDU0kgZGV2aWNlDQpzdXNwZW5kLiBJJ20gY3VycmVudGx5IHRlc3RpbmcgdGhh
dCBwYXRjaCBzZXJpZXMuDQoNCkJhcnQu
