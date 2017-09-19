From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 15:36:35 +0000
Message-ID: <1505835394.2671.18.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-2-ming.lei@redhat.com>
         <1505498249.3420.15.camel@wdc.com> <20170917124000.GB6289@ming.t460p>
         <1505747894.2685.6.camel@wdc.com> <20170919054308.GA2517@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919054308.GA2517@ming.t460p>
Content-Language: en-US
Content-ID: <5462BC681FD65D4DB6D925A413648C94@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTA5LTE5IGF0IDEzOjQzICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
TW9uLCBTZXAgMTgsIDIwMTcgYXQgMDM6MTg6MTZQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IElmIHlvdSBhcmUgc3RpbGwgbG9va2luZyBhdCByZW1vdmluZyB0aGUgYmxrX21x
X2RlbGF5X3J1bl9od19xdWV1ZSgpIGNhbGxzDQo+ID4gdGhlbiBJIHRoaW5rIHlvdSBhcmUgbG9v
a2luZyBpbiB0aGUgd3JvbmcgZGlyZWN0aW9uLiBXaGF0IGtpbmQgb2YgcHJvYmxlbQ0KPiA+IGFy
ZSB5b3UgdHJ5aW5nIHRvIHNvbHZlPyBJcyBpdCBwZXJoYXBzIHRoYXQgdGhlcmUgY2FuIGJlIGEg
ZGVsYXkgYmV0d2Vlbg0KPiANCj4gQWN0dWFsbHkgdGhlIGltcHJvdmVtZW50IG9uIGRtLXJxIElP
IHNjaGVkdWxlKHRoZSBwYXRjaCAyIH4gNSkgZG9lc24ndA0KPiBuZWVkIHRoaXMgcGF0Y2guDQoN
ClRoZSBhcHByb2FjaCBvZiB0aGlzIHBhdGNoIHNlcmllcyBsb29rcyB3cm9uZyB0byBtZSBhbmQg
cGF0Y2ggNS81IGlzIGFuIHVnbHkNCmhhY2sgaW4gbXkgb3Bpbmlvbi4gVGhhdCdzIHdoeSBJIGFz
a2VkIHlvdSB0byBkcm9wIHRoZSBlbnRpcmUgcGF0Y2ggc2VyaWVzIGFuZA0KdG8gdGVzdCB3aGV0
aGVyIGluc2VydGluZyBhIHF1ZXVlIHJ1biBjYWxsIGludG8gdGhlIGRtLW1wYXRoIGVuZF9pbyBj
YWxsYmFjaw0KeWllbGRzIGEgc2ltaWxhciBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCB0byB0aGUg
cGF0Y2hlcyB5b3UgcG9zdGVkLiBQbGVhc2UgZG8NCm5vdCBleHBlY3QgbWUgdG8gc3BlbmQgbW9y
ZSB0aW1lIG9uIHRoaXMgcGF0Y2ggc2VyaWVzIGlmIHlvdSBkbyBub3QgY29tZSB1cA0Kd2l0aCBt
ZWFzdXJlbWVudCByZXN1bHRzIGZvciB0aGUgcHJvcG9zZWQgYWx0ZXJuYXRpdmUuDQoNCkJhcnQu
