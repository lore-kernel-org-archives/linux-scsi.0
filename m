From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Thu, 7 Dec 2017 21:11:54 +0000
Message-ID: <1512681113.2624.33.camel@wdc.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
         <1512490099.2660.6.camel@sandisk.com> <20171205162825.GA23788@ming.t460p>
         <20171206015212.GB26512@ming.t460p> <1512576435.3297.3.camel@wdc.com>
         <20171207013122.GA10214@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171207013122.GA10214@ming.t460p>
Content-Language: en-US
Content-ID: <107468BAFD96F149B5DD9B0B8FF05ECB@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTEyLTA3IGF0IDA5OjMxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQnV0
IGlmIHlvdSBhbHdheXMgY2FsbCBibGtfbXFfc2NoZWRfbWFya19yZXN0YXJ0X2hjdHgoKSBiZWZv
cmUgYSBuZXcNCj4gZGlzcGF0Y2gsIHRoYXQgbWF5IGFmZmVjdCBwZXJmb3JtYW5jZSBvbiBOVk1l
IHdoaWNoIG1heSBuZXZlciB0cmlnZ2VyDQo+IEJMS19TVFNfUkVTT1VSQ0UuDQoNCkhtbSAuLi4g
b25seSB0aGUgU0NTSSBjb3JlIGltcGxlbWVudHMgLmdldF9idWRnZXQoKSBhbmQgLnB1dF9idWRn
ZXQoKSBhbmQNCkkgcHJvcG9zZWQgdG8gaW5zZXJ0IGEgYmxrX21xX3NjaGVkX21hcmtfcmVzdGFy
dF9oY3R4KCkgY2FsbCB1bmRlciAiaWYNCihxLT5tcV9vcHMtPmdldF9idWRnZXQpIi4gSW4gb3Ro
ZXIgd29yZHMsIEkgcHJvcG9zZWQgdG8gaW5zZXJ0IGENCmJsa19tcV9zY2hlZF9tYXJrX3Jlc3Rh
cnRfaGN0eCgpIGNhbGwgaW4gYSBjb2RlIHBhdGggdGhhdCBpcyBuZXZlciB0cmlnZ2VyZWQNCmJ5
IHRoZSBOVk1lIGRyaXZlci4gU28gSSBkb24ndCBzZWUgaG93IHRoZSBjaGFuZ2UgSSBwcm9wb3Nl
ZCBjb3VsZCBhZmZlY3QNCnRoZSBwZXJmb3JtYW5jZSBvZiB0aGUgTlZNZSBkcml2ZXI/DQoNCkJh
cnQu
