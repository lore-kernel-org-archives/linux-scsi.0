From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Wed, 13 Sep 2017 19:07:53 +0000
Message-ID: <1505329670.2404.10.camel@wdc.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
         <20170911111021.25810-9-ming.lei@redhat.com>
         <1505145834.2802.17.camel@wdc.com> <20170912034057.GC31533@ming.t460p>
         <20170913164803.GB10407@ming.t460p> <1505323703.2654.3.camel@wdc.com>
         <20170913174759.GB24862@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170913174759.GB24862@ming.t460p>
Content-Language: en-US
Content-ID: <38BE3A4C0957F942A0450896A7ECCDEF@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "cavery@redhat.com" <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTA5LTE0IGF0IDAxOjQ4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gTm8s
IHRoYXQgcGF0Y2ggb25seSBjaGFuZ2VzIGJsa19pbnNlcnRfY2xvbmVkX3JlcXVlc3QoKSB3aGlj
aCBpcyB1c2VkDQo+IGJ5IGRtLXJxKG1wYXRoKSBvbmx5LCBub3RoaW5nIHRvIGRvIHdpdGggdGhl
IHJlcG9ydGVkIGlzc3VlIGR1cmluZw0KPiBzdXNwZW5kIGFuZCBzZW5kaW5nIFNDU0kgRG9tYWlu
IHZhbGlkYXRpb24uDQoNClRoZXJlIG1heSBiZSBvdGhlciB3YXlzIHRvIGZpeCB0aGUgU0NTSSBk
b21haW4gdmFsaWRhdGlvbiBjb2RlLg0KDQpSZWdhcmRpbmcgdGhlIGhhbmcgZHVyaW5nIHJlc3Vt
ZTogSSBoYXZlIG5vdCBiZWVuIGFibGUgdG8gcmVwcm9kdWNlIHRoYXQNCmhhbmcgd2l0aCBKZW5z
JyBsYXRlc3QgZm9yLW5leHQgYnJhbmNoLiBJZiB0aGF0IGhhbmcgd291bGQgdHVybiBvdXQgbm90
IHRvDQpiZSByZXByb2R1Y2libGUgd2l0aCB2NC4xMy1yYzEsIHdoeSB0byBjaGFuZ2UgdGhlIGJl
aGF2aW9yIG9mIHRoZSBibG9jaw0KbGF5ZXIgd2l0aCByZWdhcmQgdG8gUFJFRU1QVCByZXF1ZXN0
cz8NCg0KQmFydC4=
