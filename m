From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
 4.17.0-x64-08428-g7d3bf613e99a
Date: Wed, 13 Jun 2018 14:08:12 +0000
Message-ID: <09e8bd7605febd091679172d68ca1e9ca3990c91.camel@wdc.com>
References: <201806091606.51078.randrianasulu@gmail.com>
         <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org>
         <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com>
         <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
         <20180613140411.GA32701@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613140411.GA32701@lst.de>
Content-Language: en-US
Content-ID: <EB4F3E66E50E8E4B81BCAD42760E67F7@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>
Cc: "randrianasulu@gmail.com" <randrianasulu@gmail.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTA2LTEzIGF0IDE2OjA0ICswMjAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiA+
IEkgc3VzcGVjdCB0aGlzIGlzIGR1ZSB0byB3ZSBjb3VsZCBleHBpcmUgYSBzYW1lIHJlcXVlc3Qg
dHdpY2Ugb3IgZXZlbiBtb3JlLg0KPiA+IEZvciBzY3NpIG1pZC1sYXllciwgaXQgcmV0dXJuIEJM
S19FSF9ET05FIGZyb20gLnRpbWVvdXQsIGluIGZhY3QsIHRoZSByZXF1ZXN0IGlzIG5vdA0KPiA+
IGNvbXBsZXRlZCB0aGVyZSwgYnV0IGp1c3QgcXVldWUgYSBkZWxheWVkIGFib3J0X3dvcmsgKEha
LzEwMCkuIElmIHRoZSBibGtfbXFfdGltZW91dF93b3JrDQo+ID4gcnVucyBhZ2FpbiBiZWZvcmUg
dGhlIGFib3J0X3dvcmssIHRoZSByZXF1ZXN0IHdpbGwgYmUgdGltZWQgb3V0IGFnYWluLCBiZWNh
dXNlIHRoZXJlIGlzIG5vdA0KPiA+IGFueSBtYXJrIG9uIGl0IHRvIGlkZW50aWZ5IHRoaXMgcmVx
dWVzdCBoYXMgYmVlbiB0aW1lZCBvdXQuDQo+ID4gDQo+ID4gV291bGQgcGxlYXNlIHRyeSB0aGUg
cGF0Y2ggYXR0YWNoZWQgb24gdG8gc2VlIHdoZXRoZXIgdGhpcyBpc3N1ZSBjb3VsZCBiZSBmaXhl
ZCA/DQo+ID4gKHRoaXMgcGF0Y2ggb25seSB3b3JrcyBmb3Igc2NzaSBkZXZpY2UgY3VycmVudGx5
KQ0KPiANCj4gVGhlIHBhdGNoIGlzbid0IHJlYWxseSBnb2luZyB0byB3b3JrIHdpdGhvdXQgYSBj
YWxsZXIgb2YgeW91ciBuZXcNCj4gX19ibGtfbXFfY29tcGxldGVfcmVxdWVzdCBoZWxwZXIsIGlz
IGl0Pw0KDQpfX2Jsa19tcV9jb21wbGV0ZV9yZXF1ZXN0KCkgaXMgYWxyZWFkeSBjYWxsZWQgdG9k
YXkgYnkgYmxrX21xX2NvbXBsZXRlX3JlcXVlc3QoKS4NCkhvd2V2ZXIsIGl0J3Mgbm90IGNsZWFy
IHRvIG1lIHdoeSB0aGF0IGZ1bmN0aW9uIGlzIGV4cG9ydGVkIGJ5IEppYW5jaGFvJ3MgcGF0Y2gu
DQoNCj4gRWl0aGVyIHdheSB0aGUgY29uY2VwdCBvZiBkb2luZyBlcnJvciBoYW5kbGluZyB3aXRo
b3V0IHF1aWVzY2luZyB0aGUNCj4gcXVldWUganVzdCBsb29rcyBib2d1cyB0byBtZSBhbmQgd2ls
bCBlbmQgdXAgd2l0aCBzb21lIHNvcnQgb2YgcmFjZQ0KPiBoZXJlIG9yIHRoZXJlLg0KDQpUaGUg
U0NTSSBlcnJvciBoYW5kbGVyIGFscmVhZHkgd2FpdHMgdW50aWwgYWxsIHBlbmRpbmcgcmVxdWVz
dHMgaGF2ZSBmaW5pc2hlZA0KYmVmb3JlIGl0IHN0YXJ0cyBoYW5kbGluZyB0aW1lZCBvdXQgY29t
bWFuZHMuIFRoaXMgZS1tYWlsIHRocmVhZCBzdGFydGVkIHdpdGggYQ0KcmVwb3J0IG9mIGEgY3Jh
c2ggaW4gdGhlIFNDU0kgZXJyb3IgaGFuZGxlciwgd2hpY2ggaXMgYSByZWdyZXNzaW9uIGludHJv
ZHVjZWQgaW4NCnRoZSB2NC4xOCBtZXJnZSB3aW5kb3cuDQoNCkJhcnQuDQoNCg0K
