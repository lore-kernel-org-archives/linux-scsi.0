From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Mon, 29 Jan 2018 16:48:31 +0000
Message-ID: <1517244510.2687.10.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
         <1516726653.3339.20.camel@wdc.com> <20180124033109.GA15945@ming.t460p>
         <20180127190920.GA24759@redhat.com> <1517091161.3055.7.camel@wdc.com>
         <20180127234151.GA21710@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180127234151.GA21710@ming.t460p>
Content-Language: en-US
Content-ID: <66A0D95C41D46E4F9596D6D0D6244574@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDE4LTAxLTI4IGF0IDA3OjQxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gTm90
IG1lbnRpb24sIHRoZSByZXF1ZXN0IGlzbid0IGFkZGVkIHRvIGRpc3BhdGNoIGxpc3QgeWV0IGlu
IC5xdWV1ZV9ycSgpLA0KPiBzdHJpY3RseSBzcGVha2luZywgaXQgaXMgbm90IGNvcnJlY3QgdG8g
Y2FsbCBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkgaW4NCj4gLnF1ZXVlX3JxKCksIHNvIHRo
ZSBjdXJyZW50IGJsb2NrIGxheWVyIEFQSSBjYW4ndCBoYW5kbGUgaXQgd2VsbCBlbm91Z2guDQoN
CkkgZGlzYWdyZWUgdGhhdCBpdCBpcyBub3QgY29ycmVjdCB0byBjYWxsIGJsa19tcV9kZWxheV9y
dW5faHdfcXVldWUoKSBmcm9tDQppbnNpZGUgLnF1ZXVlX3JxKCkuIEFkZGl0aW9uYWxseSwgSSBo
YXZlIGFscmVhZHkgZXhwbGFpbmVkIHRvIHlvdSBpbg0KcHJldmlvdXMgZS1tYWlscyB3aHkgaXQn
cyBmaW5lIHRvIGNhbGwgdGhhdCBmdW5jdGlvbiBmcm9tIGluc2lkZSAucXVldWVfcnEoKToNCi0g
Tm9ib2R5IGhhcyBldmVyIG9ic2VydmVkIHRoZSByYWNlIHlvdSBkZXNjcmliZWQgYmVjYXVzZSB0
aGUgdGltZSBhZnRlcg0KICB3aGljaCBhIHF1ZXVlIGlzIHJlcnVuIGJ5IGJsa19tcV9kZWxheV9y
dW5faHdfcXVldWUoKSBpcyBtdWNoIGxhcmdlciB0aGFuDQogIHRoZSB0aW1lIGR1cmluZyB3aGlj
aCB0aGF0IHJhY2UgZXhpc3RzLg0KLSBJdCBpcyBlYXN5IHRvIGZpeCB0aGlzIHJhY2UgaW5zaWRl
IHRoZSBibG9jayBsYXllciwgbmFtZWx5IGJ5IHVzaW5nDQogIGNhbGxfcmN1KCkgaW5zaWRlIHRo
ZSBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkgaW1wbGVtZW50YXRpb24gdG8NCiAgcG9zdHBv
bmUgdGhlIHF1ZXVlIHJlcnVubmluZyB1bnRpbCBhZnRlciB0aGUgcmVxdWVzdCBoYXMgYmVlbiBh
ZGRlZCBiYWNrIHRvDQogIHRoZSBkaXNwYXRjaCBsaXN0Lg0KDQo+ID4gLSBUaGUgcGF0Y2ggYXQg
dGhlIHN0YXJ0IG9mIHRoaXMgdGhyZWFkIGludHJvZHVjZXMgYSByZWdyZXNzaW9uIGluIHRoZQ0K
PiA+ICAgU0NTSSBjb3JlLCBuYW1lbHkgYSBxdWV1ZSBzdGFsbCBpZiBhIHJlcXVlc3QgY29tcGxl
dGlvbiBvY2N1cnMgY29uY3VycmVudGx5DQo+ID4gICB3aXRoIHRoZSBuZXdseSBhZGRlZCBCTEtf
TVFfU19TQ0hFRF9SRVNUQVJUIHRlc3QgaW4gdGhlIGJsay1tcSBjb3JlLg0KPiANCj4gVGhpcyBw
YXRjaCBvbmx5IG1vdmVzIHRoZSBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkgZnJvbSBzY3Np
X3F1ZXVlX3JxKCkNCj4gdG8gYmxrLW1xLCBhZ2FpbiwgcGxlYXNlIGV4cGxhaW4gaXQgaW4gZGV0
YWlsIGhvdyB0aGlzIHBhdGNoIFYzIGludHJvZHVjZXMgdGhpcw0KPiByZWdyZXNzaW9uIG9uIFND
U0kuDQoNClBsZWFzZSByZXJlYWQgdGhlIGZvbGxvd2luZyBtZXNzYWdlOiBodHRwczovL21hcmMu
aW5mby8/bD1kbS1kZXZlbCZtPTE1MTY3MjQ4MDEwNzU2MC4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
